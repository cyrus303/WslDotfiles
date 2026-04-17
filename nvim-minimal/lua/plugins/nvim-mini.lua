return {
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
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
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {},
  },
}
