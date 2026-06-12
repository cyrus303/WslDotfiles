local function augroup(name)
  return vim.api.nvim_create_augroup("nvim_min_" .. name, { clear = true })
end

-- Flash highlight on yank (disabled — yanky.nvim handles this via highlight.timer)
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   group = augroup("yank_highlight"),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

-- Press <q> to close transient buffers (help, lspinfo, etc.)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, { buffer = event.buf, silent = true, desc = "Quit buffer" })
    end)
  end,
})

-- Keep splits equal when the terminal window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Restore cursor to last known position when reopening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Create missing parent directories automatically on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Quickfix enhancements: cursorline highlight + <l> to jump to entry
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("qf_enhance"),
  pattern = "qf",
  callback = function(ev)
    vim.opt_local.cursorline = true
    vim.opt_local.cursorlineopt = "both"
    vim.opt_local.winhighlight = "CursorLine:QfCursorLine"
    vim.keymap.set("n", "l", "<CR>", { buffer = ev.buf, silent = true })
    vim.api.nvim_set_hl(0, "QfError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "QfWarning", { link = "DiagnosticWarn" })
    vim.fn.matchadd("QfWarning", "\\c^.*warning.*$", 10)
    vim.fn.matchadd("QfError", "\\c^.*error.*$", 11)
  end,
})

-- Remove nvim 0.11 default LSP keymaps that overlap with user's custom
-- `gr` → References and `<leader>c*` code actions. Deleting them avoids
-- timeout delays when typing `gr` / `gra`.
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp_default_keymaps"),
  callback = function(ev)
    for _, lhs in ipairs({ "grr", "gri", "grn", "gra", "grt" }) do
      pcall(vim.keymap.del, "n", lhs, { buffer = ev.buf })
    end
  end,
})

-- Override codelens rendering: show inline at EOL instead of virtual lines above.
-- Neovim 0.12 renders codelens via an internal decoration provider (Provider:on_win).
-- We replace it by extracting the private Provider table via debug.getupvalue.
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("codelens_inline"),
  once = true,
  callback = function()
    vim.schedule(function()
      local ok, cm = pcall(require, "vim.lsp.codelens")
      if not ok then return end

      local Provider
      for i = 1, 50 do
        local name, val = debug.getupvalue(cm.on_refresh, i)
        if not name then break end
        if name == "Provider" then Provider = val; break end
      end
      if not Provider then return end

      local api = vim.api
      local ns = api.nvim_create_namespace("nvim.lsp.codelens")

      api.nvim_set_decoration_provider(ns, {
        on_win = function(_, _, bufnr, toprow, botrow)
          local p = Provider.active[bufnr]
          if not p then return end

          for row = toprow, botrow do
            if p.row_version[row] ~= p.version then
              for client_id, state in pairs(p.client_state) do
                api.nvim_buf_clear_namespace(bufnr, state.namespace, row, row + 1)
                local lenses = state.row_lenses[row]
                if lenses then
                  local client = vim.lsp.get_client_by_id(client_id)
                  if client then
                    table.sort(lenses, function(a, b)
                      return a.range.start.character < b.range.start.character
                    end)
                    local chunks = {}
                    for idx, lens in ipairs(lenses) do
                      if not lens.command then
                        p:resolve(client, lens)
                      else
                        if idx > 1 then
                          table.insert(chunks, { " | ", "LspCodeLensSeparator" })
                        end
                        table.insert(chunks, { lens.command.title, "LspCodeLens" })
                      end
                    end
                    if #chunks > 0 then
                      api.nvim_buf_set_extmark(bufnr, state.namespace, row, 0, {
                        virt_text = chunks,
                        virt_text_pos = "eol",
                        hl_mode = "combine",
                      })
                    end
                  end
                end
                p.row_version[row] = p.version
              end
            end
          end

          if botrow == api.nvim_buf_line_count(bufnr) - 1 then
            for _, state in pairs(p.client_state) do
              api.nvim_buf_clear_namespace(bufnr, state.namespace, botrow + 1, -1)
            end
          end
        end,
      })
    end)
  end,
})

-- Reload buffer when file changes on disk (e.g. git checkout, external edit)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup("checktime"),
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Notify when a buffer is reloaded due to external file change
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = augroup("file_changed"),
  pattern = "*",
  callback = function()
    vim.api.nvim_echo({ { "File changed on disk. Buffer reloaded.", "WarningMsg" } }, false, {})
  end,
})

-- Return to normal mode when saving from insert mode
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("insert_leave_on_save"),
  callback = function()
    if vim.fn.mode() == "i" then
      vim.cmd("stopinsert")
    end
  end,
})

-- Treat comment-bearing JSON files as jsonc so // isn't flagged as a parse error
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("jsonc_filetype"),
  pattern = {
    "*.jsonc",
    "local.settings.json",
    "tsconfig*.json",
    "jsconfig.json",
    ".eslintrc.json",
  },
  callback = function()
    vim.bo.filetype = "jsonc"
  end,
})

-- Enable line wrap and spellcheck for prose filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= "" then return end
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
