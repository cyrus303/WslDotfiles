-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set


-- Keep cursor centered on half-page jumps
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, center" })

-- Clear highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlight" })

-- Shared styled diagnostic float
local function show_styled_diag_float()
  require("tiny-inline-diagnostic").disable()

  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(0, { lnum = lnum })
  local severity = vim.diagnostic.severity.HINT
  for _, d in ipairs(diags) do
    if d.severity < severity then severity = d.severity end
  end

  local border_hl = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticError",
    [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
    [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
    [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
  }

  local screen_row = vim.fn.winline()
  local lines_below = vim.api.nvim_win_get_height(0) - screen_row
  local anchor = lines_below < 5 and "above" or "below"

  local _, winid = vim.diagnostic.open_float(nil, {
    scope = "line",
    close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
    border = "rounded",
    max_width = 60,
    wrap = true,
    anchor_bias = anchor,
  })

  if winid then
    vim.wo[winid].winhighlight = "FloatBorder:" .. (border_hl[severity] or "DiagnosticHint")
  end

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" }, {
    once = true,
    callback = function()
      require("tiny-inline-diagnostic").enable()
    end,
  })
end

map("n", "<leader>cd", show_styled_diag_float, { desc = "Line diagnostics (no inline)" })

-- New .NET item in current file's directory
map("n", "<leader>dn", function()
  local path = vim.fn.expand("%:p:h")
  coroutine.wrap(function()
    require("easy-dotnet.actions.new").create_new_item(path, function(file_path)
      vim.schedule(function()
        vim.cmd("edit " .. vim.fn.fnameescape(file_path))
      end)
    end)
  end)()
end, { desc = "New .NET item" })

-- gc = comment current line, remove unused gco/gcO
vim.keymap.del("n", "gco")
vim.keymap.del("n", "gcO")
map("n", "gc", function()
  vim.api.nvim_feedkeys("gcc", "m", false)
end, { desc = "Comment line" })

-- Go to next/prev diagnostic with styled float
map("n", "]d", function()
  vim.diagnostic.goto_next({ float = false })
  vim.defer_fn(show_styled_diag_float, 50)
end, { desc = "Next diagnostic" })

map("n", "[d", function()
  vim.diagnostic.goto_prev({ float = false })
  vim.defer_fn(show_styled_diag_float, 50)
end, { desc = "Prev diagnostic" })

-- Jump between errors only (severity = ERROR)
map("n", "]e", function()
  vim.diagnostic.goto_next({ float = false, severity = vim.diagnostic.severity.ERROR })
  vim.defer_fn(show_styled_diag_float, 50)
end, { desc = "Next error" })

map("n", "[e", function()
  vim.diagnostic.goto_prev({ float = false, severity = vim.diagnostic.severity.ERROR })
  vim.defer_fn(show_styled_diag_float, 50)
end, { desc = "Prev error" })

-- Trouble diagnostics
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics (Trouble)" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
