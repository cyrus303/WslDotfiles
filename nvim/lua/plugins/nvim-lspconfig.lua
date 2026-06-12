return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      -- Global capabilities (blink augments these per-server automatically
      -- via its own integration, but also expose here for any manual setup)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- Disable inlay hints (user preference)
      if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
        vim.lsp.inlay_hint.enable(false)
      end

      -- Store for other modules (Roslyn handles its own setup)
      vim.g.lsp_capabilities = capabilities

      local ss = require("schemastore")

      -- JSON
      vim.lsp.config("jsonls", {
        filetypes = { "json", "jsonc" },
        capabilities = capabilities,
        settings = {
          json = {
            schemas = ss.json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.enable("jsonls")

      -- YAML
      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = ss.yaml.schemas(),
          },
        },
      })
      vim.lsp.enable("yamlls")

      -- TypeScript / JavaScript (Next.js, React, Node)
      -- Formatting is delegated to conform (prettierd); vtsls provides
      -- completion, diagnostics, code actions, go-to-definition, etc.
      vim.lsp.config("vtsls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("vtsls")
    end,
  },
}
