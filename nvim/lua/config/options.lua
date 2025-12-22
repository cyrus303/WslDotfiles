-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.termguicolors = true

-- Enable cursorline for the line number only
vim.opt.cursorline = true -- Enable cursorline
vim.opt.cursorlineopt = "number" -- Only highlight the line number
vim.opt.showmode = false
vim.opt.cmdheight = 2

vim.opt.autoread = true
vim.opt.autowrite = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Notification after file change
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.api.nvim_echo({ { "File changed on disk. Buffer reloaded.", "WarningMsg" } }, false, {})
  end,
})

-- Disable all animations
vim.g.snacks_animate = false
