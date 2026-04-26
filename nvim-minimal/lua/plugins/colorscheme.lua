return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = false,
			color_overrides = {
				mocha = {
					base = "#111019",
					mantle = "#0d0c14",
					crust = "#09080f",
				},
			},
			styles = {
				comments = { "italic" },
			},
			lsp_styles = {
				virtual_text = {
					errors = { "italic" },
					warnings = { "italic" },
					hints = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "undercurl" },
					warnings = { "undercurl" },
					hints = { "underline" },
					information = { "underline" },
				},
			},
			integrations = {
				treesitter = true,
				blink_cmp = true,
				gitsigns = true,
				which_key = true,
				mini = { enabled = true },
				dap = true,
				mason = true,
			},
			custom_highlights = function(colors)
				local bg = "#111019"
				local panel = "#0d0c14"
				return {
					-- Base UI
					Normal = { bg = bg },
					NormalNC = { bg = bg },
					SignColumn = { bg = bg },
					LineNr = { fg = "#6c7086", bg = bg },
					CursorLineNr = { fg = colors.peach, bold = true, bg = panel },
					Visual = { bg = "#393552" },
					CursorLine = { bg = "#252338" },
					ColorColumn = { bg = panel },
					EndOfBuffer = { fg = bg, bg = bg },
					WinSeparator = { fg = colors.surface2 },
					VertSplit = { fg = colors.surface2 },
					Folded = { bg = bg, fg = colors.overlay0 },

					-- Statusline
					StatusLine = { bg = panel },
					StatusLineNC = { bg = panel },

					-- Floats
					NormalFloat = { bg = bg },
					FloatBorder = { fg = colors.surface2, bg = bg },
					FloatTitle = { fg = colors.blue, bg = bg },

					-- Completion menu
					Pmenu = { bg = panel },
					PmenuSel = { bg = colors.surface1, bold = true },
					PmenuThumb = { bg = colors.overlay0 },
					PmenuSbar = { bg = panel },
					QuickFixLine = { bg = "#302040", fg = colors.peach, bold = true },
					QfCursorLine = { bg = "#252236" },

					-- LSP
					LspInlayHint = { fg = colors.overlay1, italic = true },

					-- C# / .NET semantic token highlights
					["@lsp.type.namespace"] = { fg = colors.yellow },
					["@lsp.type.class"] = { fg = colors.blue },
					["@lsp.type.interface"] = { fg = colors.green, italic = true },
					["@lsp.type.struct"] = { fg = colors.peach },
					["@lsp.type.record"] = { fg = colors.sapphire },
					["@lsp.type.enum"] = { fg = colors.teal },
					["@lsp.type.enumMember"] = { fg = colors.teal, bold = true },
					["@lsp.type.delegate"] = { fg = colors.mauve, italic = true },
					["@lsp.type.typeParameter"] = { fg = colors.pink },
					["@lsp.type.method"] = { fg = colors.sky },
					["@lsp.type.property"] = { fg = colors.lavender },
					["@lsp.type.field"] = { fg = colors.flamingo },
					["@lsp.type.parameter"] = { fg = colors.maroon, italic = true },
					["@lsp.type.variable"] = { fg = colors.text },
					["@lsp.type.event"] = { fg = colors.red, bold = true },

					-- C# / .NET semantic modifiers
					["@lsp.mod.deprecated"] = { strikethrough = true }, -- [Obsolete] members get a strikethrough at every reference
					["@lsp.typemod.method.static"] = { italic = true }, -- static method calls — italic on top of the sky hue
					["@lsp.typemod.property.static"] = { italic = true },
					["@lsp.typemod.variable.static"] = { italic = true }, -- catches static fields too
					["@lsp.typemod.method.async"] = { underline = true }, -- async method calls — underline; stacks with static-italic
					["@lsp.typemod.variable.readonly"] = { italic = true }, -- private readonly _foo dependencies stand out

					-- XML doc comments (`///`) distinct from regular comments
					["@lsp.typemod.comment.documentation"] = { fg = colors.lavender, italic = true },

					-- Attributes / decorators ([HttpGet], [Authorize], [Obsolete], …)
					["@lsp.type.decorator"] = { fg = colors.yellow },
					["@attribute"] = { fg = colors.yellow },

					-- Matching parens / brackets — lifted so they're obvious on the dark base
					MatchParen = { bg = colors.surface1, bold = true },

					-- Search highlights — warm hues, distinct from the cool Visual bg
					Search = { bg = colors.peach, fg = colors.base, bold = true },
					IncSearch = { bg = colors.yellow, fg = colors.base, bold = true },
					CurSearch = { bg = colors.red, fg = colors.base, bold = true },

					-- Snacks indent
					SnacksIndent = { fg = "#2a2840" },
					SnacksIndentScope = { fg = colors.overlay1 },

					-- Snacks
					SnacksNormal = { bg = bg },
					SnacksBorder = { fg = colors.surface2, bg = bg },
					SnacksTitle = { fg = colors.blue, bg = bg },
					SnacksWinBar = { bg = bg },
					SnacksWinBarNC = { bg = bg },
					SnacksPicker = { bg = bg },
					SnacksPickerBorder = { fg = colors.surface2, bg = bg },
					SnacksPickerTitle = { fg = colors.blue, bg = bg },
					SnacksPickerInput = { bg = bg },
					SnacksPickerInputBorder = { fg = colors.surface2, bg = bg },
					SnacksPickerBox = { bg = bg },
					SnacksPickerPreview = { bg = bg },
					SnacksPickerPreviewBorder = { fg = colors.surface2, bg = bg },
					SnacksPickerList = { bg = bg },
					SnacksPickerListBorder = { fg = colors.surface2, bg = bg },
					SnacksPickerMatch = { fg = colors.peach, bold = true },
					SnacksPickerCursorLine = { bg = colors.surface1, bold = true },

					-- Diffview / Git diff (bold red/green style)
					DiffAdd = { bg = "#1a3a1a" },
					DiffChange = { bg = "#1d2438" },
					DiffDelete = { bg = "#4a1518" },
					DiffText = { bg = "#3d3520" },
					DiffviewDiffAdd = { bg = "#1a3a1a" },
					DiffviewDiffAddAsDelete = { bg = "#4a1518" },
					DiffviewDiffDelete = { fg = colors.surface2, bg = "#3a1215" },
					DiffviewDiffChange = { bg = "#1d2438" },
					DiffviewDiffText = { bg = "#3d3520" },
					DiffviewDiffDeleteDim = { bg = "#351015" },
					DiffAddAsDelete = { bg = "#4a1518" },
					DiffviewFiller = { bg = "#1a1828" },

					-- Flash
					FlashBackdrop = { fg = colors.overlay0 },
					FlashLabel = { fg = colors.base, bg = colors.red, bold = true },
					FlashMatch = { link = "Search" },
					FlashCurrent = { link = "Search" },
					DiffRemoved = { bg = "#4a1518", fg = colors.red },
					DiffviewNormal = { bg = bg },
					DiffviewCursorLine = { bg = "#252338" },
					DiffviewFilePanelTitle = { fg = colors.blue, bold = true },
					DiffviewFilePanelCounter = { fg = colors.mauve },
					DiffviewFilePanelFileName = { fg = colors.text },
					DiffviewStatusAdded = { fg = colors.green },
					DiffviewStatusModified = { fg = colors.yellow },
					DiffviewStatusDeleted = { fg = colors.red },
					DiffviewStatusRenamed = { fg = colors.blue },

					-- Blink completion menu — kind icons mirror the buffer LSP token rules
					-- so the menu speaks the same color language as the editor: type the
					-- dot operator and methods/properties/fields are scannable by hue.
					BlinkCmpMenu = { bg = bg },
					BlinkCmpMenuBorder = { fg = colors.surface2, bg = bg },
					BlinkCmpMenuSelection = { bg = colors.surface1, bold = true },
					BlinkCmpScrollBarThumb = { bg = colors.overlay0 },
					BlinkCmpScrollBarGutter = { bg = panel },
					BlinkCmpDoc = { bg = bg },
					BlinkCmpDocBorder = { fg = colors.surface2, bg = bg },
					BlinkCmpDocCursorLine = { bg = "#252338" }, -- matches CursorLine
					BlinkCmpSignatureHelp = { bg = bg },
					BlinkCmpSignatureHelpBorder = { fg = colors.surface2, bg = bg },
					BlinkCmpSignatureHelpActiveParameter = { fg = colors.peach, bold = true },

					-- Label parts
					BlinkCmpLabel = { fg = colors.text },
					BlinkCmpLabelMatch = { fg = colors.peach, bold = true }, -- fuzzy match chars
					BlinkCmpLabelDeprecated = { strikethrough = true, fg = colors.overlay1 }, -- deprecated entries match buffer rule
					BlinkCmpLabelDescription = { fg = colors.overlay1, italic = true },
					BlinkCmpLabelDetail = { fg = colors.overlay1 },
					BlinkCmpSource = { fg = colors.overlay0, italic = true },
					BlinkCmpGhostText = { fg = colors.surface2, italic = true },

					-- Kind icons — paired with the @lsp.type.* hues from above
					BlinkCmpKind = { fg = colors.overlay1 },
					BlinkCmpKindMethod = { fg = colors.sky }, -- matches @lsp.type.method
					BlinkCmpKindFunction = { fg = colors.sky },
					BlinkCmpKindConstructor = { fg = colors.sky },
					BlinkCmpKindProperty = { fg = colors.lavender }, -- matches @lsp.type.property
					BlinkCmpKindField = { fg = colors.flamingo }, -- matches @lsp.type.field
					BlinkCmpKindVariable = { fg = colors.text },
					BlinkCmpKindClass = { fg = colors.blue }, -- matches @lsp.type.class
					BlinkCmpKindInterface = { fg = colors.green }, -- matches @lsp.type.interface
					BlinkCmpKindStruct = { fg = colors.peach }, -- matches @lsp.type.struct
					BlinkCmpKindEnum = { fg = colors.teal }, -- matches @lsp.type.enum
					BlinkCmpKindEnumMember = { fg = colors.teal, bold = true },
					BlinkCmpKindModule = { fg = colors.yellow }, -- namespace family
					BlinkCmpKindConstant = { fg = colors.flamingo },
					BlinkCmpKindKeyword = { fg = colors.mauve },
					BlinkCmpKindSnippet = { fg = colors.green },
					BlinkCmpKindEvent = { fg = colors.red, bold = true }, -- matches @lsp.type.event
					BlinkCmpKindOperator = { fg = colors.overlay2 },
					BlinkCmpKindReference = { fg = colors.flamingo },
					BlinkCmpKindFile = { fg = colors.blue },
					BlinkCmpKindFolder = { fg = colors.blue },
					BlinkCmpKindText = { fg = colors.text },
					BlinkCmpKindUnit = { fg = colors.text },
					BlinkCmpKindValue = { fg = colors.peach },
					BlinkCmpKindColor = { fg = colors.text },
					BlinkCmpKindTypeParameter = { fg = colors.pink }, -- matches @lsp.type.typeParameter
				}
			end,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		priority = 900, -- carbonfox stays available via :colorscheme carbonfox; catppuccin is now the default (set in colorscheme.lua)
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
						CursorLineNr = { fg = "palette.yellow.bright", bg = "#161616", style = "bold" }, -- bright IBM teal, fully on-palette
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
						SnacksIndent = { fg = "#1c1c1c" },
						SnacksIndentChunk = { fg = "#1c1c1c" },
						SnacksIndentScope = { fg = "#e8c5a0" }, -- warm cream, matches active buffer in lualine — unified "current focus" cue

						-- Vim marks in the statuscolumn (m{a-z}) — cream to match active buffer + scope line
						SnacksStatusColumnMark = { fg = "#e8c5a0", style = "bold" },

						-- C# / .NET semantic token highlights
						-- Type-level kinds: each in its own hue family so class/struct/record/interface never collide
						["@lsp.type.namespace"] = { fg = "fg2" }, -- structural qualifier, dim
						["@lsp.type.class"] = { fg = "palette.blue.base" }, -- primary reference type
						["@lsp.type.struct"] = { fg = "palette.magenta.base" }, -- value type (was teal, clashed with namespace)
						["@lsp.type.record"] = { fg = "palette.cyan.base" }, -- data type, sky blue
						["@lsp.type.interface"] = { fg = "palette.green.base", style = "italic" }, -- contract; italic reinforces I-prefix
						["@lsp.type.enum"] = { fg = "palette.yellow.base" }, -- finite set, deep teal
						["@lsp.type.enumMember"] = { fg = "palette.yellow.base", style = "bold" }, -- same hue as enum, bold weight signals the member relationship
						["@lsp.type.delegate"] = { fg = "palette.orange.base", style = "italic" }, -- function-like, lighter teal
						["@lsp.type.typeParameter"] = { fg = "palette.pink.base", style = "italic" }, -- generic placeholder, distinct from red event/param

						-- Member-level kinds: brights pair with their owning type's hue, but stay distinct from each other
						["@lsp.type.method"] = { fg = "palette.orange.bright" }, -- bright teal, distinct from class/record blues; chained calls now read with clear method/type separation
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
