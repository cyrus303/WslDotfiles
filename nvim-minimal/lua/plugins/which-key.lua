return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      { "<leader>c", group = "code" },
      { "<leader>d", group = "dotnet/debug" },
      { "<leader>dp", group = "packages" },
      { "<leader>f", group = "find" },
      { "<leader>s", group = "search" },
      { "<leader>g", group = "git" },
      { "<leader>gg", desc = "Lazygit" },
      { "<leader>q", group = "quit" },
      { "<leader>x", group = "diagnostics/symbols" },
      { "<leader>E", desc = "Git Status" },
      { "<leader>e", desc = "Explorer" },
      { "<leader>H", desc = "Harpoon Add File" },
      { "<leader>h", desc = "Harpoon Picker" },
      { "<leader>l", desc = "Lazy" },
      { "<leader>cm", desc = "Mason" },
      { "s", group = "surround" },
      { "sa", desc = "Add surrounding" },
      { "sd", desc = "Delete surrounding" },
      { "sr", desc = "Replace surrounding" },
      { "sf", desc = "Find surrounding (right)" },
      { "sF", desc = "Find surrounding (left)" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Harpoon numeric shortcuts: registered but hidden to keep UI tidy.
    wk.add({
      { "<leader>1", "<cmd>lua require('harpoon'):list():select(1)<cr>", hidden = true },
      { "<leader>2", "<cmd>lua require('harpoon'):list():select(2)<cr>", hidden = true },
      { "<leader>3", "<cmd>lua require('harpoon'):list():select(3)<cr>", hidden = true },
      { "<leader>4", "<cmd>lua require('harpoon'):list():select(4)<cr>", hidden = true },
      { "<leader>5", "<cmd>lua require('harpoon'):list():select(5)<cr>", hidden = true },
      { "<leader>6", "<cmd>lua require('harpoon'):list():select(6)<cr>", hidden = true },
      { "<leader>7", "<cmd>lua require('harpoon'):list():select(7)<cr>", hidden = true },
      { "<leader>8", "<cmd>lua require('harpoon'):list():select(8)<cr>", hidden = true },
      { "<leader>9", "<cmd>lua require('harpoon'):list():select(9)<cr>", hidden = true },
      { "gcc", hidden = true },
      { "[D", hidden = true },
      { "]D", hidden = true },
    })
  end,
}
