return {
  {
    "dlyongemallo/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
      "DiffviewRefresh",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diff Working Tree" },
      { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>",  desc = "Diff vs HEAD~1" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>",  desc = "Branch File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>",                 desc = "Current File History" },
      { "<leader>gr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh Diffview" },
    },
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
        listing_style = "list",
        win_config = {
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
      keymaps = {
        disable_defaults = false, -- [x/]x and <leader>co/ct/cb/ca already covered by defaults
        view = {
          { "n", "gf", "<nop>", { desc = "" } },
          { "n", "q",  "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_panel = {
          { "n", "gf",    "<nop>", { desc = "" } },
          { "n", "<Space>","<nop>", { desc = "" } },
          { "n", "q",     "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_history_panel = {
          { "n", "gf", "<nop>", { desc = "" } },
          { "n", "q",  "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
      },
    },
  },
}
