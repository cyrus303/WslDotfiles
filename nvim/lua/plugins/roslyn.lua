return {
  "seblyng/roslyn.nvim",
  ft = { "cs", "razor" },
  opts = {
    filewatching = "roslyn",
    broad_search = true,
    -- let roslyn.nvim handle root + attach
  },
  config = function(_, opts)
    require("roslyn").setup(opts)
  end,
}
