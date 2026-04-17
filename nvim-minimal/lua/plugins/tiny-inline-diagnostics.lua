return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  opts = {
    preset = "simple",
    options = {
      -- where to start wrapping
      softwrap = 55,

      overflow = {
        mode = "wrap", -- split into multiple virtual lines
        padding = 0,
      },

      break_line = {
        enabled = true, -- actually insert virtual line breaks
        after = 55, -- characters before breaking (tune this)
      },

      add_messages = {
        messages = true,
      },
    },
  },
}
