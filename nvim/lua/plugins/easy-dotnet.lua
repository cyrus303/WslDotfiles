return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Dotnet",
  ft = "cs",
  keys = {
    { "<leader>dd", "<cmd>Dotnet<cr>", desc = "EasyDotnet picker" },
  },
  config = function()
    require("easy-dotnet").setup({
      picker = "snacks",
      lsp = { enabled = false },
      -- projx_lsp is a language server for *.csproj that completes
      -- Include="/Version=" as you type. Defaults to on, but packages here are
      -- added through nuget.nvim (<leader>dpi/dpr) or the dotnet CLI rather than
      -- by hand-editing csproj, so it would only spawn a
      -- `dotnet-easydotnet projx-language-server` process for nothing.
      -- :checkhealth easy-dotnet reports "ProjX LSP not enabled" -- expected.
      projx_lsp = { enabled = false },
      diagnostics = { enabled = false },
      debugger = {
        enabled = true,
        path = "netcoredbg",
      },
    })
  end,
}
