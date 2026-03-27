-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Move lines up/down (normal + visual)
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on half-page jumps
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, center" })

-- Clear highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlight" })

-- Line diagnostics helper
local function show_line_diag_without_inline()
  require("tiny-inline-diagnostic").disable()

  -- Find highest severity on current line
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

  local _, winid = vim.diagnostic.open_float(nil, {
    scope = "line",
    close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
    border = "rounded",
    max_width = 60,
    wrap = true,
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

map("n", "<leader>cd", show_line_diag_without_inline, { desc = "Line diagnostics (no inline)" })
