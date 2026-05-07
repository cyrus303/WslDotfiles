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
      diagnostics = { enabled = false },
      debugger = {
        enabled = true,
        path = "netcoredbg",
      },
    })
  end,
}
