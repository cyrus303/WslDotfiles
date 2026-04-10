-- lua/plugins/snacks-picker.lua
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}

      -- Global input key overrides
      opts.picker.win = opts.picker.win or {}
      opts.picker.win.input = opts.picker.win.input or {}
      opts.picker.win.input.keys = vim.tbl_deep_extend("force", opts.picker.win.input.keys or {}, {
        -- confirm current selection with Ctrl-l
        ["<C-l>"] = { "confirm", mode = { "i", "n" } },
      })

      -- Show hidden files in the regular files picker
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.files = vim.tbl_deep_extend("force", opts.picker.sources.files or {}, {
        hidden = true,
      })
    end,
  },
}
