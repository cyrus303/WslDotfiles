-- lua/plugins/cutlass.lua
return {
  "gbprod/cutlass.nvim",
  opts = {
    override_del = true, -- x → silent delete
    cut_key = "m", -- m = real cut (to "+ clipboard)
  },
}
