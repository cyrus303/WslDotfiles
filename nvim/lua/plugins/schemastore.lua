return {
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local ss = require("schemastore")
      local capabilities = vim.g.lsp_capabilities or vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, "blink.cmp")
      if ok then capabilities = blink.get_lsp_capabilities(capabilities) end

      vim.lsp.config("jsonls", {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = ss.json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.enable("jsonls")

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
    end,
  },
}
