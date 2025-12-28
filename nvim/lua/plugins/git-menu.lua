return {
  "LazyVim/LazyVim",
  init = function()
    -- run after LazyVim sets its keymaps and which-key defaults
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimKeymaps",
      once = true,
      callback = function()
        local del = vim.keymap.del

        -- remove unwanted <leader>g* mappings
        for _, lhs in ipairs({
          "<leader>gB", -- Git Browse (open)
          "<leader>gf", -- Git Current File History
          "<leader>gi", -- GitHub Issues (open)
          "<leader>gI", -- GitHub Issues (all)
          "<leader>gl", -- Git Log
          "<leader>gh",
          "<leader>gL", -- Git Log (cwd)
          "<leader>gp", -- GitHub PRs (open)
          "<leader>gP", -- GitHub PRs (all)
          "<leader>gs", -- Git Status
          "<leader>gS", -- Git Stash
          "<leader>gY", -- Git Browse (copy)
        }) do
          pcall(del, "n", lhs)
        end
      end,
    })
  end,
}
