return {
  "gbprod/yanky.nvim",
  opts = function()
    return {
      ring = {
        history_length = 100,
        storage = "memory",
        sync_with_ringbuffer = true,
        cancel_event = "update",
        ignore_registers = { "_", "c", "C", "/", "-" },
        permanent_wrapper = require("yanky.wrappers").remove_carriage_return,
      },
    }
  end,
  keys = {
    { "<c-p>", "<Plug>(YankyCycleForward)", mode = { "n", "x" } },
    { "<c-n>", "<Plug>(YankyCycleBackward)", mode = { "n", "x" } },
  },
}
