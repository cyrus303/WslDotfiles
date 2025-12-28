return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts.on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- remove LazyVim's default <leader>gh* maps
        local del = vim.keymap.del
        for _, mode in ipairs({ "n", "x" }) do
          for _, lhs in ipairs({
            "<leader>ghs",
            "<leader>ghS",
            "<leader>ghu",
            "<leader>ghr",
            "<leader>ghR",
            "<leader>ghp",
            "<leader>ghd",
            "<leader>ghD",
          }) do
            pcall(del, mode, lhs, { buffer = bufnr })
          end
        end

        -- hunk navigation only
        vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
        vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Prev hunk" })
      end

      -- Disable all extra UI/features except gutter signs
      opts.current_line_blame = false
      opts.word_diff = false
      opts.numhl = false
      opts.linehl = false
      opts.culhl = false
      opts.signs_staged_enable = false -- No staged signs
      opts.attach_to_untracked = false -- No untracked signs
      opts.signcolumn = true -- Keep gutter signs visible

      return opts
    end,
  },
}
