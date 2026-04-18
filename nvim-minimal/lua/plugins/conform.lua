return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	event = "BufWritePre",
	opts = {
		formatters_by_ft = {
			json = { "biome" },
			lua = { "stylua" },
		},
		format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	},
}
