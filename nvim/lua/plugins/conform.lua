return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      -- C# is deliberately absent so it falls through to lsp_format = "fallback"
      -- below, i.e. Roslyn formats it. Visual Studio formats with Roslyn too, so
      -- using the same engine is what stops every touched file churning against
      -- teammates who only use VS. csharpier is a different formatter by design
      -- (Prettier-style: it re-wraps arguments and re-breaks lines) and cannot be
      -- configured to match VS, so matching meant swapping engines, not settings.
      --
      -- Re-enable by uncommenting -- but note it will diverge from VS again unless
      -- the team adopts csharpier (dotnet-tools.json + the CSharpier VS extension).
      -- The zero-effort alternative is a committed .editorconfig, which VS reads
      -- natively and Roslyn honours, making both sides deterministic.
      -- cs = { "csharpier" },
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
