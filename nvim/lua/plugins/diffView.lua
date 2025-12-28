return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      use_icons = true,
    },
    keys = {
      -- Diff current working tree vs HEAD
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff (Diffview)" },
      -- Diff against a specific commit
      { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff HEAD~1" },
      -- Close diffview
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
  },
}
