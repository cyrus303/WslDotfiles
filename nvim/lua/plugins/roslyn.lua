return {
  "seblyng/roslyn.nvim",
  ft = "cs",
  opts = {
    filewatching = "roslyn",
    broad_search = true,
  },
  config = function(_, opts)
    require("roslyn").setup(opts)
    vim.lsp.config("roslyn", {})
  end,
}
