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

    -- <leader>dk -> kill dotnet
    vim.keymap.set("n", "<leader>dk", function()
      -- kill any running dotnet processes (dev-only)
      vim.fn.system("pkill dotnet || true")
    end, { desc = "Kill dotnet processes" })

    -- <leader>dd -> EasyDotnet picker
    vim.keymap.set("n", "<leader>dd", function()
      vim.cmd("Dotnet")
    end, { desc = "EasyDotnet picker" })
  end,
}
