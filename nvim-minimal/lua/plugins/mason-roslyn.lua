return {
  "mason-org/mason.nvim",
  lazy = false,
  priority = 100,
  build = ":MasonUpdate",
  opts = {
    registries = {
      "github:Crashdummyy/mason-registry",
      "github:mason-org/mason-registry",
    },
  },
}
