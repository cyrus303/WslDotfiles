return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      json = { "biome" },
      lua = { "stylua" },
    },
    format_on_save = false,
  },
}
