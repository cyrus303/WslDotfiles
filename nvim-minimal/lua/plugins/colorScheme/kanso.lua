return {
	"webhooked/kanso.nvim",
	lazy = false,
	enabled = false,
	priority = 1000,
	config = function()
		require("kanso").setup({
			bold = true,
			italics = true,
			compile = false,
			undercurl = true,
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = {},
			typeStyle = {},
			transparent = false,
			dimInactive = false,
			terminalColors = true,
			colors = {
				palette = {},
				theme = { zen = {}, pearl = {}, ink = {}, all = {} },
			},
			overrides = function(_)
				return {}
			end,
			background = {
				dark = "zen",
				light = "pearl",
			},
			foreground = "default",
			minimal = false,
		})
		vim.cmd("colorscheme kanso")
	end,
}
