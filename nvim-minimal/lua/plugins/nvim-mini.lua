return {
  {
    "nvim-mini/mini.splitjoin",
    keys = {
      { "gS", mode = { "n", "x" }, desc = "Split/join arguments" },
    },
    opts = {},
  },
  {
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = {
      n_lines = 500,
    },
  },
}
