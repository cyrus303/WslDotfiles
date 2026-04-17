return {
  "mason-org/mason.nvim",
  lazy = false,
  priority = 100,
  build = ":MasonUpdate",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
  opts = {
    registries = {
      "github:Crashdummyy/mason-registry",
      "github:mason-org/mason-registry",
    },
  },
}
