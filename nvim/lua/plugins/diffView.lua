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
      { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (diffview)" },
      { "<leader>gU", "<cmd>DiffviewRefresh<cr>", desc = "Update/Refresh Diffview" },
      { "<leader>ge", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle File DiffView" },
    },
    opts = {
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
        },
        merge_tool = {
          layout = "diff4_mixed",
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
          { "n", "gf",       "<nop>",                        { desc = "" } },
          { "n", "q",        "<cmd>DiffviewClose<cr>",        { desc = "Close Diffview" } },
          { "n", "<leader>e","<cmd>DiffviewToggleFiles<cr>",  { desc = "Toggle File Panel" } },
        },
        file_panel = {
          { "n", "gf",        "<nop>",                       { desc = "" } },
          { "n", "<Space>",   "<nop>",                       { desc = "" } },
          { "n", "q",         "<cmd>DiffviewClose<cr>",       { desc = "Close Diffview" } },
          { "n", "<leader>e", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle File Panel" } },
        },
        file_history_panel = {
          { "n", "gf", "<nop>", { desc = "" } },
          { "n", "q",  "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
      },
    },
  },
}
