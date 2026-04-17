return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    presets = {
      lsp_doc_border = true,
    },
    cmdline = {
      view = "cmdline_popup",
    },
    views = {
      cmdline_popup = {
        position = { row = 2, col = "50%" },
        size = { width = 60, min_width = 60 },
      },
    },
    routes = {
      {
        filter = { find = "%[nuget%]" },
        opts = { skip = true },
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
      hover = {
        enabled = true,
        silent = true,
        view = nil,
        opts = {
          border = "rounded",
          -- you can tweak size/position if needed
          -- max_width = 80,
          -- max_height = 20,
        },
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
        },
        opts = {
          border = "rounded",
        },
      },
    },
  },
}
