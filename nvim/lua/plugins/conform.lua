return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
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
