return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    local wk = require("which-key")

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
