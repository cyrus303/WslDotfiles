return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("easy-dotnet").setup({
      picker = "snacks", -- optional; or omit to let it auto-detect
      lsp = { enabled = false }, -- disable its LSP client
      diagnostics = { enabled = false }, -- optional: let roslyn handle diags
    })

    -- <leader>dd -> EasyDotnet picker
    vim.keymap.set("n", "<leader>dd", "<cmd>Dotnet<cr>", {
      desc = "EasyDotnet menu",
    })
  end,
}
