return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      -- Roslyn's LSP formatter was tried here instead (to match teammates who
      -- format via Visual Studio, which uses Roslyn) and is NOT good enough: on a
      -- controller with stray blank lines inside a parameter list it changed
      -- nothing at all -- 126 lines in, 126 out, 24 blank lines unchanged, and a
      -- 29-space over-indent left as-is. It only normalises already-reasonable
      -- code; it will not re-join split expressions or drop spurious blank lines.
      -- csharpier reprints from the syntax tree, which is what actually turns
      -- messy typing into tidy code, so it stays. Matching VS has to be solved by
      -- the team adopting csharpier, not by giving up formatting locally.
      cs = { "csharpier" },
      json = { "prettierd" },
      lua = { "stylua" },
      css = { "prettierd" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
    },
    format_after_save = function(bufnr)
      if vim.g.disable_autoformat then
        return
      end
      return { timeout_ms = 15000, lsp_format = "fallback" }
    end,
  },
}
