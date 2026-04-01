return {
  "rmagatti/goto-preview",
  event = "LspAttach",
  opts = {
    width = 120,
    height = 25,
    border = "rounded",
    default_mappings = false,
    post_open_hook = function(buf, win)
      -- Esc inside peek = close just this window (step back one level)
      vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_win_close(0, true)
      end, { buffer = buf, silent = true })
    end,
  },
  keys = {
    {
      "gp",
      function()
        local src_buf = vim.api.nvim_get_current_buf()
        require("goto-preview").goto_preview_definition()
        vim.schedule(function()
          vim.keymap.set("n", "<Esc>", function()
            require("goto-preview").close_all_win()
            pcall(vim.keymap.del, "n", "<Esc>", { buffer = src_buf })
          end, { buffer = src_buf, silent = true })
        end)
      end,
      desc = "Peek definition",
    },
    { "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close peek windows" },
  },
}
