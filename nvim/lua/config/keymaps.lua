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
  vim.diagnostic.open_float(nil, {
    scope = "line",
    close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
    border = "rounded",
  })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" }, {
    once = true,
    callback = function()
      require("tiny-inline-diagnostic").enable()
    end,
  })
end

map("n", "<leader>cd", show_line_diag_without_inline, { desc = "Line diagnostics (no inline)" })
