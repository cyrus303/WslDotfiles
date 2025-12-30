return {
  "gbprod/yanky.nvim",
  dependencies = { "kkharji/sqlite.lua" },
  opts = {
    ring = {
      history_length = 100,
      storage = "sqlite",
      storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db",
      sync_with_ringbuffer = true,
      cancel_event = "update",
      ignore_registers = { "_", "c", "C", "/", "-" }, -- Ignore blackhole + others
      permanent_wrapper = require("yanky.wrappers").remove_carriage_return,
    },
  },
  keys = {
    { "<c-p>", "<Plug>(YankyCycleForward)", mode = { "n", "x" } },
    { "<c-n>", "<Plug>(YankyCycleBackward)", mode = { "n", "x" } },
  },
}
