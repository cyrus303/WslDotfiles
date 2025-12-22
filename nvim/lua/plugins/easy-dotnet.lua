return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("easy-dotnet").setup({
      picker = "snacks",
      lsp = { enabled = false },
      diagnostics = { enabled = false },
      debugger = {
        enabled = true,
        path = "netcoredbg", -- uses the one you just tested
      },
    })

    -- <leader>dd -> kill dotnet, then EasyDotnet picker
    vim.keymap.set("n", "<leader>dd", function()
      -- kill any running dotnet processes (dev-only)
      vim.fn.system("pkill dotnet || true")
      -- then open the EasyDotnet picker
      vim.cmd("Dotnet")
    end, { desc = "kill + EasyDotnet" })
  end,
}
