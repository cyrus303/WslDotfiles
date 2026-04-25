return {
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 900, -- loads after catppuccin (priority 1000) so it wins as the active colorscheme; catppuccin remains available via :colorscheme catppuccin
		config = function()
			require("nightfox").setup({
				options = {
					styles = {
						comments = "italic",
					},
				},
				groups = {
					carbonfox = {
						-- Background unification — match the explorer's darker float bg everywhere
						Normal = { bg = "#0f0f0f" },
						NormalNC = { bg = "#0f0f0f" },
						NormalFloat = { bg = "#0f0f0f" },
						SignColumn = { bg = "#0f0f0f" },
						LineNr = { bg = "#0f0f0f" },
						FoldColumn = { bg = "#0f0f0f" },
						Folded = { bg = "#0f0f0f" },
						EndOfBuffer = { fg = "#0f0f0f", bg = "#0f0f0f" },
						CursorLine = { bg = "#161616" },
						CursorLineNr = { fg = "#ff8a3d", bg = "#161616", style = "bold" }, -- IBM Carbon orange-40, off-palette but on-brand
						ColorColumn = { bg = "#0c0c0c" },
						FloatBorder = { bg = "#0f0f0f" },
						FloatTitle = { bg = "#0f0f0f" },
						WinSeparator = { fg = "#3a3a3a", bg = "#0f0f0f" },
						StatusLine = { bg = "#0c0c0c" },
						StatusLineNC = { bg = "#0c0c0c" },
						Pmenu = { bg = "#0c0c0c" },
						PmenuSbar = { bg = "#0c0c0c" },

						-- Snacks
						SnacksNormal = { bg = "#0f0f0f" },
						SnacksBorder = { bg = "#0f0f0f" },
						SnacksWinBar = { bg = "#0f0f0f" },
						SnacksWinBarNC = { bg = "#0f0f0f" },
						SnacksPicker = { bg = "#0f0f0f" },
						SnacksPickerBorder = { bg = "#0f0f0f" },
						SnacksPickerTitle = { bg = "#0f0f0f" },
						SnacksPickerInput = { bg = "#0f0f0f" },
						SnacksPickerInputBorder = { bg = "#0f0f0f" },
						SnacksPickerBox = { bg = "#0f0f0f" },
						SnacksPickerList = { bg = "#0f0f0f" },
						SnacksPickerListBorder = { bg = "#0f0f0f" },
						SnacksPickerPreview = { bg = "#0f0f0f" },
						SnacksPickerPreviewBorder = { bg = "#0f0f0f" },

						-- Indent guides — passive lines barely above bg, active scope line stays as carbonfox default
						SnacksIndent      = { fg = "#1c1c1c" },
						SnacksIndentChunk = { fg = "#1c1c1c" },
						SnacksIndentScope = { fg = "palette.pink.dim" },

						-- C# / .NET semantic token highlights
						-- Type-level kinds: each in its own hue family so class/struct/record/interface never collide
						["@lsp.type.namespace"] = { fg = "fg2" }, -- structural qualifier, dim
						["@lsp.type.class"] = { fg = "palette.blue.base" }, -- primary reference type
						["@lsp.type.struct"] = { fg = "palette.magenta.base" }, -- value type (was teal, clashed with namespace)
						["@lsp.type.record"] = { fg = "palette.cyan.base" }, -- data type, sky blue
						["@lsp.type.interface"] = { fg = "palette.green.base", style = "italic" }, -- contract; italic reinforces I-prefix
						["@lsp.type.enum"] = { fg = "palette.yellow.base" }, -- finite set, deep teal
						["@lsp.type.enumMember"] = { fg = "palette.yellow.bright", style = "bold" }, -- same family as enum, brighter+bold
						["@lsp.type.delegate"] = { fg = "palette.orange.base", style = "italic" }, -- function-like, lighter teal
						["@lsp.type.typeParameter"] = { fg = "palette.pink.base", style = "italic" }, -- generic placeholder, distinct from red event/param

						-- Member-level kinds: brights pair with their owning type's hue, but stay distinct from each other
						["@lsp.type.method"] = { fg = "palette.blue.bright" }, -- methods read as bright variant of class
						["@lsp.type.property"] = { fg = "palette.cyan.bright" }, -- properties bright variant of record/cyan
						["@lsp.type.field"] = { fg = "palette.magenta.dim" }, -- instance state, ties to struct family
						["@lsp.type.parameter"] = { fg = "palette.red.dim", style = "italic" }, -- input, dim red + italic
						["@lsp.type.event"] = { fg = "palette.red.bright" }, -- events stand out
						["@lsp.type.variable"] = { fg = "palette.white.base" }, -- locals, plain

						-- LSP
						LspInlayHint = { fg = "palette.black.bright", style = "italic" },

						-- Completion menu
						QuickFixLine = { fg = "palette.orange.base", style = "bold" },

						-- Snacks picker
						SnacksPickerMatch = { fg = "palette.orange.base", style = "bold" },
						SnacksPickerCursorLine = { style = "bold" },

						-- Git diff
						DiffAdd = { bg = "#1a3a1a" },
						DiffChange = { bg = "#202030" },
						DiffDelete = { bg = "#4a1518" },
						DiffText = { bg = "#3d3520" },

						DiffviewDiffAdd = { bg = "#1a3a1a" },
						DiffviewDiffAddAsDelete = { bg = "#4a1518" },
						DiffviewDiffDelete = { bg = "#3a1215" },
						DiffviewDiffChange = { bg = "#202030" },
						DiffviewDiffText = { bg = "#3d3520" },
						DiffviewFiller = { bg = "#181818" },
					},
				},
			})
			vim.cmd.colorscheme("carbonfox")
		end,
	},
}
