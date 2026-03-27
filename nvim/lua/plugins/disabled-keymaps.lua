return {
  "LazyVim/LazyVim",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimKeymaps",
      once = true,
      callback = function()
        local del = vim.keymap.del

        -- remove unwanted <leader>g* mappings from LazyVim + Snacks
        for _, lhs in ipairs({
          "<leader>gB", -- Git Browse (open)
          "<leader>gf", -- Git Current File History / Snacks file history
          "<leader>gi", -- GitHub Issues (open)
          "<leader>gI", -- GitHub Issues (all)
          "<leader>gl", -- Git Log
          "<leader>gh", -- hunks / history
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

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy", -- LATER event
      callback = function()
        vim.schedule(function() -- DELAYED
          pcall(vim.keymap.del, "n", "<leader>gd") -- Delete Snacks gd
          pcall(vim.keymap.set, "n", "<leader>gd", "<cmd>DiffviewOpen<cr>") -- Re-add yours
        end)
      end,
    })
  end,
}
