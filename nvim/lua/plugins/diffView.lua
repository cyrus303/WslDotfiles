return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
      },
      use_icons = true,
      file_panel = {
        listing_style = "list", -- One of 'list' or 'tree'
      },
    },
    cmd = { "DiffviewOpen", "DiffviewClose" }, -- ✅ Autoloads on command
    keys = {
      -- Diff current working tree vs HEAD
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff (Diffview)" },
      -- Close diffview
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
  },
}
