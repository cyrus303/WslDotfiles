return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "*",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = {
      preset = "default",
      ["<C-j>"] = { "select_next" },
      ["<C-k>"] = { "select_prev" },
      ["<C-l>"] = { "select_and_accept" },
      ["<CR>"] = { "select_and_accept", "fallback" },
    },
    -- Command-line completion is owned by noice (cmdline_popup view). blink and
    -- noice can't both drive ':' — with both enabled blink's menu flickers and
    -- closes instantly. Disable blink for cmdline so noice's popup handles it.
    cmdline = {
      enabled = false,
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      menu = {
        border = "rounded",
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
      ghost_text = { enabled = false },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "easy-dotnet" },
      providers = {
        ["easy-dotnet"] = {
          name = "easy-dotnet",
          module = "easy-dotnet.completion.blink",
          score_offset = 10,
          async = true,
        },
      },
    },
    signature = {
      enabled = true,
      window = { border = "rounded" },
    },
  },
  opts_extend = { "sources.default" },
}
