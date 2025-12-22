return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- disable inlay hints (your existing setting)
      opts.inlay_hints = opts.inlay_hints or {}
      opts.inlay_hints.enabled = false

      -- diagnostics display settings
      opts.diagnostics = {
        -- OPTION 1: no inline text at all (cleanest)
        virtual_text = false,

        -- OPTION 2: only show warnings+errors inline (less noisy)
        -- virtual_text = {
        --   severity = { min = vim.diagnostic.severity.WARN },
        -- },

        signs = true, -- keep gutter signs
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded", -- <- border for line diagnostics (space+cd)
          source = "if_many",
        },
      }
    end,
  },
}
