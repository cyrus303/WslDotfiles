return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  keys = {
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo (Picker)" },
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
  },
  opts = {
    highlight = {
      keyword = "wide_bg",
    },
    colors = {
      error   = { "#FF6E6E" },
      warning = { "#FFE66D" },
      info    = { "#4DFCFF" },
      hint    = { "#69FF94" },
      default = { "#BD93F9" },
      test    = { "#FF79C6" },
    },
  },
}
