return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    local wk = require("which-key")

    wk.add({
      -- Override stale LazyVim descriptions
      { "<leader>E", desc = "Git Status" },
      { "<leader>h", desc = "Harpoon Picker" },
      { "<leader>d", group = "dotnet" },
      { "<leader>dp", group = "packages" },
    }, { mode = "n" })

    wk.add({
      -- Hide Snacks git SOURCES (not your gd)
      { "<leader>gB", hidden = true },
      { "<leader>gi", hidden = true },
      { "<leader>gI", hidden = true },
      { "<leader>gl", hidden = true },
      { "<leader>gL", hidden = true },
      { "<leader>gp", hidden = true },
      { "<leader>gP", hidden = true },
      { "<leader>gs", hidden = true },
      { "<leader>gS", hidden = true },
      { "<leader>gY", hidden = true },
      -- DON'T hide gd - let yours win
      -- Hide gcc since gc is the intended mapping
      { "gcc", hidden = true },
      { "[%", hidden = true }, { "]%", hidden = true },
      { "[(", hidden = true }, { "](", hidden = true },
      { "[{", hidden = true }, { "]{", hidden = true },
      { "[<", hidden = true }, { "]<", hidden = true },
      { "[)", hidden = true }, { "])", hidden = true },
      { "[}", hidden = true }, { "]}", hidden = true },
      { "[>", hidden = true }, { "]>", hidden = true },
    }, { mode = "n" })

    wk.add({
      -- hidden but still mapped
      { "<leader>1", "<cmd>Harpoon to File 1<cr>", hidden = true },
      { "<leader>2", "<cmd>Harpoon to File 2<cr>", hidden = true },
      { "<leader>3", "<cmd>Harpoon to File 3<cr>", hidden = true },
      { "<leader>4", "<cmd>Harpoon to File 4<cr>", hidden = true },
      { "<leader>5", "<cmd>Harpoon to File 5<cr>", hidden = true },
      { "<leader>6", "<cmd>Harpoon to File 6<cr>", hidden = true },
      { "<leader>7", "<cmd>Harpoon to File 7<cr>", hidden = true },
      { "<leader>8", "<cmd>Harpoon to File 8<cr>", hidden = true },
      { "<leader>9", "<cmd>Harpoon to File 9<cr>", hidden = true },
    })
  end,
}
