return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- keep your inlay-hints setting
      opts.inlay_hints = opts.inlay_hints or {}
      opts.inlay_hints.enabled = false

      -- diagnostics: let tiny-inline handle inline text
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = false, -- important: no builtin inline text
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
        },
      })
    end,
  },
}
