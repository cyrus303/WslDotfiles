return {
  {
    "d7omdev/nuget.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "NuGetInstall", "NuGetRemove", "NuGetClearCache" },
    keys = {
      { "<leader>dpi", "<cmd>NuGetInstall<cr>", desc = "NuGet install" },
      { "<leader>dpr", "<cmd>NuGetRemove<cr>", desc = "NuGet remove" },
      { "<leader>dpc", "<cmd>NuGetClearCache<cr>", desc = "NuGet clear cache" },
    },
    opts = {
      keys = {
        install = { "n", "<leader>dpi" },
        remove = { "n", "<leader>dpr" },
        clear_cache = { "n", "<leader>dpc" },
      },
    },
  },
}
