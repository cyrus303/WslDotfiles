return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	event = "BufWritePre",
	opts = {
		formatters_by_ft = {
			cs = { "csharpier" },
			json = { "biome" },
			lua = { "stylua" },
		},
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
	},
}
