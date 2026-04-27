return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false,
	priority = 1000,
	opts = {
		variant = "moon",
		styles = {
			bold = true,
			italic = true,
			transparency = false,
		},
		palette = {
			moon = { base = "#111019", surface = "#161320", overlay = "#1e1b2e" },
		},
		highlight_groups = {
			["@lsp.type.class"]     = { fg = "foam" },
			["@lsp.type.interface"] = { fg = "foam", italic = true },
			["@lsp.type.struct"]    = { fg = "foam" },
			["@lsp.type.enum"]      = { fg = "foam" },
			["@lsp.mod.deprecated"] = { strikethrough = true },
		},
	},
	config = function(_, opts)
		require("rose-pine").setup(opts)
		vim.cmd("colorscheme rose-pine")
	end,
}
