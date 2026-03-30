return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Configure explorer picker source to show hidden files by default
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = vim.tbl_deep_extend("force", opts.picker.sources.explorer or {}, {
        hidden = true, -- show hidden files immediately
        ignored = true, -- show gitignored files
      })

      -- Optional: also set for regular files picker
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.files = vim.tbl_deep_extend("force", opts.picker.sources.files or {}, {
        hidden = true,
      })

      -- your window / key mappings (keep these)
      opts.explorer = opts.explorer or {}
      opts.explorer.win = opts.explorer.win or {}
      opts.explorer.win.list = opts.explorer.win.list or {}
      opts.explorer.win.list.keys = vim.tbl_deep_extend("force", opts.explorer.win.list.keys or {}, {
        ["<CR>"] = { "edit", mode = "n" },
        ["s"] = { "edit_split", mode = "n" },
        ["v"] = { "edit_vsplit", mode = "n" },
      })
    end,
  },
}
