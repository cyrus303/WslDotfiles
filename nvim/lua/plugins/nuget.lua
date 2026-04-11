return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-l>"] = "select_default",
          },
          n = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-l>"] = "select_default",
          },
        },
      },
    },
  },
  {
    "d7omdev/nuget.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      keys = {
        install = { "n", "<leader>dpi" },
        remove = { "n", "<leader>dpr" },
        clear_cache = { "n", "<leader>dpc" },
      },
    },
  },
}
