return {
	"yonatanperel/lake-dweller.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("lake-dweller").setup({
			variant = "lake-dweller",
		})

		vim.cmd.colorscheme("lake-dweller")

		local dim_border = "#2a2a3a"
		local indent_line = "#1a1a24" -- ghost guides
		local active_scope = "#5e5e7a" -- bumped up, clearly visible

		-- Core UI borders
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = dim_border })
		vim.api.nvim_set_hl(0, "VertSplit", { fg = dim_border })

		-- LSP / diagnostics
		vim.api.nvim_set_hl(0, "LspInfoBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "DiagnosticFloatBorder", { fg = dim_border })

		-- Snacks
		vim.api.nvim_set_hl(0, "SnacksBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "SnacksInputBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "SnacksPreviewBorder", { fg = dim_border })

		-- Snacks indent / scope lines
		vim.api.nvim_set_hl(0, "SnacksIndent", { fg = indent_line })
		vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = active_scope })

		-- Blink completion
		vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = dim_border })

		-- Telescope
		vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = dim_border })
		vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = dim_border })

		-- Mason / WhichKey
		vim.api.nvim_set_hl(0, "MasonNormal", { fg = dim_border })
		vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = dim_border })

		-- indent-blankline.nvim
		vim.api.nvim_set_hl(0, "IblIndent", { fg = indent_line })
		vim.api.nvim_set_hl(0, "IblScope", { fg = active_scope })

		-- mini.indentscope
		vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = active_scope })
		vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = indent_line })

		-- Data flow: only parameters
		vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#c0a0c8", italic = true })
		vim.api.nvim_set_hl(0, "@lsp.type.parameter.cs", { link = "@variable.parameter" })
		vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "#d8d8d8" })

		-- After lake-dweller colorscheme loads
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#8ac490" }) -- no bg, just green bar
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#70a8a8" }) -- no bg, just cyan bar
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ef8a90" }) -- no bg, just red bar

		-- Ensure sign column is exactly 1 cell wide
		vim.opt.signcolumn = "auto:1"
	end,
}
