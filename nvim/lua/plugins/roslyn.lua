return {
  "seblyng/roslyn.nvim",
  ft = "cs",
  opts = {
    filewatching = "roslyn",
    broad_search = true, -- you can keep this
  },
  config = function(_, opts)
    require("roslyn").setup(opts)

    local util = require("lspconfig.util")

    vim.lsp.config("roslyn", {
      -- choose ONE root for the Roslyn client
      root_dir = function(fname)
        -- monorepo root: AssessmentAPI
        return util.root_pattern("Solutions")(fname)
          or util.root_pattern(".git")(fname)
          or vim.fn.expand("~/work/AssessmentAPI")
      end,
    })
  end,
}
