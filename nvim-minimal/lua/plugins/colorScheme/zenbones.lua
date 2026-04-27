return {
	"zenbones-theme/zenbones.nvim",
	dependencies = "rktjmp/lush.nvim",
	enabled = false,
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.zenburned = { solid_bg = true }
		vim.o.background = "dark"
		vim.cmd.colorscheme("tokyobones")

		vim.api.nvim_set_hl(0, "Normal", { bg = "#111019" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "#111019" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#111019" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "#111019" })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#111019", bg = "#111019" })
	end,
}
