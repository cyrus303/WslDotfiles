return {
	{
		"slugbyte/lackluster.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		config = function()
			local lackluster = require("lackluster")
			local c = lackluster.color
			local warn_fg = "#b8933a"
			local hint_fg = "#5a8a9f"
			local diag_err_bg = "#1e1418"
			lackluster.setup({
				tweak_color = {
					orange = "#8a5f3c",
					red = "#9e3d3f",
				},
				tweak_syntax = {
					string = c.yellow,
					string_escape = c.blue,
					comment = c.gray6,
					builtin = c.blue,
					type = c.green,
					keyword = "default",
					keyword_return = c.green,
					keyword_exception = c.blue,
				},
				tweak_background = {
					normal = "default",
					telescope = "default",
					menu = "default",
					popup = "default",
				},
				tweak_highlight = {
					-- C# Types
					["@lsp.type.class"] = { overwrite = true, fg = c.green, bold = true },
					["@lsp.type.interface"] = { overwrite = true, fg = c.green, italic = true },
					["@lsp.type.struct"] = { overwrite = true, fg = c.green },
					["@lsp.type.enum"] = { overwrite = true, fg = c.green },
					-- C# Methods: LSP semantic tokens + Treesitter fallback
					["@lsp.type.method"] = { overwrite = true, fg = c.lack },
					["@lsp.typemod.method.async"] = { overwrite = true, fg = c.lack, underline = true },
					["@lsp.typemod.method.static"] = { overwrite = true, fg = c.lack, italic = true },
					["@function.call"] = { overwrite = true, fg = c.lack },
					["@method.call"] = { overwrite = true, fg = c.lack },
					-- C# Parameters / data flow
					["@lsp.type.parameter"] = { overwrite = true, fg = c.orange, italic = true },
					["@lsp.type.typeParameter"] = { overwrite = true, fg = c.orange, bold = true },
					-- C# Value types & readonly
					["@lsp.type.enumMember"] = { overwrite = true, fg = c.yellow, bold = true },
					["@lsp.typemod.variable.readonly"] = { overwrite = true, fg = c.gray8, italic = true },
					-- C# Deprecated
					["@lsp.mod.deprecated"] = { overwrite = true, strikethrough = true },
					-- Diagnostics
					["DiagnosticError"] = { overwrite = true, fg = c.red },
					["DiagnosticVirtualTextError"] = { overwrite = true, fg = c.red, bg = diag_err_bg, italic = true },
					["DiagnosticUnderlineError"] = { overwrite = true, sp = c.red, undercurl = true },
					["DiagnosticSignError"] = { overwrite = true, fg = c.red },
					["DiagnosticDeprecated"] = { overwrite = true, sp = c.red, strikethrough = true },
					["DiagnosticWarn"] = { overwrite = true, fg = warn_fg },
					["DiagnosticVirtualTextWarn"] = { overwrite = true, fg = warn_fg, italic = true },
					["DiagnosticUnderlineWarn"] = { overwrite = true, sp = warn_fg, undercurl = true },
					["DiagnosticHint"] = { overwrite = true, fg = hint_fg },
					["DiagnosticVirtualTextHint"] = { overwrite = true, fg = hint_fg, italic = true },
					-- LSP references
					["LspReferenceRead"] = { overwrite = true, bg = c.gray3 },
					["LspReferenceWrite"] = { overwrite = true, bg = c.gray3 },
					["LspReferenceText"] = { overwrite = true, bg = c.gray3 },
					["LspInlayHint"] = { overwrite = true, fg = c.gray5, italic = true },
					-- UI
					["CursorLineNr"] = { overwrite = true, fg = c.orange, bold = true },
					["Visual"] = { overwrite = true, bg = "#2a2a35" },
					["VisualNOS"] = { overwrite = true, bg = "#2a2a35" },
					["FloatBorder"] = { overwrite = true, fg = c.gray5 },
					-- Diff
					["DiffAdd"] = { overwrite = true, bg = "#1a3a1a" },
					["DiffChange"] = { overwrite = true, bg = "#1d2438" },
					["DiffDelete"] = { overwrite = true, bg = "#2e1315" },
					["DiffText"] = { overwrite = true, bg = "#3d3520" },
				},
			})
			vim.cmd.colorscheme("lackluster")
		end,
	},
}
