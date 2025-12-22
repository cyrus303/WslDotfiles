-- lua/plugins/snacks-explorer.lua
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.explorer = opts.explorer or {}
      opts.explorer.win = opts.explorer.win or {}
      opts.explorer.win.list = opts.explorer.win.list or {}
      opts.explorer.win.list.keys = vim.tbl_deep_extend("force", opts.explorer.win.list.keys or {}, {
        -- normal‑mode mappings inside explorer list
        ["<CR>"] = { "edit", mode = "n" },

        -- horizontal split on `s`
        ["s"] = { "edit_split", mode = "n" },

        -- vertical split on `v`
        ["v"] = { "edit_vsplit", mode = "n" },
      })
    end,
  },
}
