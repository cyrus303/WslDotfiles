-- lua/plugins/cutlass.lua
return {
  "gbprod/cutlass.nvim",
  event = "VeryLazy",
  opts = {
    override_del = true, -- x → silent delete
    cut_key = "cx", -- cx = real cut (to "+ clipboard)
    exclude = { "c", "C" }, -- don't override c/C so gc (comment) works
  },
  config = function(_, opts)
    require("cutlass").setup(opts)
    -- cxx = cut whole line (cutlass uses cxcx internally for multi-char keys)
    vim.keymap.set("n", "cxx", '"+dd', { desc = "Cut line" })
  end,
}
