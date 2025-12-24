-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 1. Visual paste without overwriting yank
map("x", "p", '"_dP', { desc = "Paste without overwriting yank" })

-- 2. Delete / change without yanking
map("n", "<leader>d", '"_d', { desc = "Delete without yank" })
map("v", "<leader>d", '"_d', { desc = "Delete without yank" })
map("n", "<leader>D", '"_D', { desc = "Delete line without yank" })
map("n", "<leader>c", '"_c', { desc = "Change without yank" })
map("n", "<leader>C", '"_C', { desc = "Change line without yank" })

-- 3. Make x a real delete (not cut)
map("n", "x", '"_x', { desc = "Delete char without yank" })

-- Move lines up/down (normal + visual)
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on half-page jumps and
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, center" })
-- map("n", "n", "nzzzv", { desc = "Next match, center" })
-- map("n", "N", "Nzzzv", { desc = "Prev match, center" })

-- Clear  highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear  highlight" })

-- Paste from system clipboard and strip CRs from EOlocal map = vim.keymap.set
map("n", "<leader>p", function()
  -- paste from system clipboard
  vim.cmd('normal! "+p')
  -- strip CR at end of lines
  vim.cmd([[%s/\r$//e]])
end, { desc = "Paste from clipboard (strip CRLF)" })

-- helper: show line diagnostics without tiny-inline
local function show_line_diag_without_inline()
  -- disable tiny-inline
  require("tiny-inline-diagnostic").disable()

  -- open float and close it on movement / leave
  vim.diagnostic.open_float(nil, {
    scope = "line",
    close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
    border = "rounded",
  })

  -- re-enable tiny-inline after those events
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" }, {
    once = true,
    callback = function()
      require("tiny-inline-diagnostic").enable()
    end,
  })
end

vim.keymap.set("n", "<leader>cd", show_line_diag_without_inline, { desc = "Line diagnostics (no inline)" })
