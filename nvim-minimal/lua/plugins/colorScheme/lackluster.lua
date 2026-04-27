return {
	-- Kept installed for fallback / palette reference. Active theme is
	-- catluster.lua (catppuccin reskinned with the lackluster palette).
	"slugbyte/lackluster.nvim",
	enabled = false,
	lazy = true,
	init = function()
		vim.cmd.colorscheme("lackluster-night")
	end,
}
