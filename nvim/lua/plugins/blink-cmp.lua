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
    -- No easy-dotnet source here on purpose. It completed Include="/Version="
    -- in csproj/fsproj/xml, which easy-dotnet's projx_lsp (an XML language
    -- server gated to *.csproj) now does through the LSP source instead --
    -- running both duplicated NuGet completions, and :checkhealth easy-dotnet
    -- warns "cmp source configured, use projx_lsp instead". Only .fsproj loses
    -- coverage, since projx_lsp is .csproj-only.
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    signature = {
      enabled = true,
      window = { border = "rounded" },
    },
  },
  opts_extend = { "sources.default" },
}
