return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		enabled = false,
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
					-- ─── Base UI ────────────────────────────────────────────────
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

					-- ─── Statusline ─────────────────────────────────────────────
					StatusLine = { bg = panel },
					StatusLineNC = { bg = panel },

					-- ─── Floats ─────────────────────────────────────────────────
					NormalFloat = { bg = bg },
					FloatBorder = { fg = colors.surface2, bg = bg },
					FloatTitle = { fg = colors.overlay2, bg = bg }, -- dimmed; was blue

					-- ─── Completion menu ────────────────────────────────────────
					Pmenu = { bg = panel },
					PmenuSel = { bg = colors.surface1, bold = true },
					PmenuThumb = { bg = colors.overlay0 },
					PmenuSbar = { bg = panel },
					QuickFixLine = { bg = "#302040", fg = colors.peach, bold = true },
					QfCursorLine = { bg = "#252236" },

					-- ─── LSP diagnostics ────────────────────────────────────────
					LspInlayHint = { fg = colors.overlay0, italic = true }, -- dimmed; was overlay1

					-- ─── C# semantic tokens — MINIMAL 3-hue system ──────────────
					-- TYPE FAMILY → blue  ("gd-navigable symbols get one shared hue")
					["@lsp.type.class"] = { fg = colors.blue },
					["@lsp.type.interface"] = { fg = colors.blue, italic = true }, -- italic distinguishes interface from class
					["@lsp.type.struct"] = { fg = colors.blue },
					["@lsp.type.record"] = { fg = colors.blue },
					["@lsp.type.enum"] = { fg = colors.blue },
					["@lsp.type.enumMember"] = { fg = colors.blue, bold = true },
					["@lsp.type.delegate"] = { fg = colors.blue, italic = true },
					["@lsp.type.typeParameter"] = { fg = colors.blue, italic = true }, -- T, TKey, TValue etc

					-- METHOD FAMILY → sky  ("invocable symbols")
					["@lsp.type.method"] = { fg = colors.sky },

					-- NAMESPACE → dim overlay  ("context, not navigation")
					["@lsp.type.namespace"] = { fg = colors.overlay2 },

					-- EVERYTHING ELSE → default text colour, style-only distinction
					["@lsp.type.property"] = { fg = colors.text },
					["@lsp.type.field"] = { fg = colors.text },
					["@lsp.type.variable"] = { fg = colors.text },
					["@lsp.type.event"] = { fg = colors.text, bold = true }, -- bold = "subscribe here"

					-- MODIFIERS — style only, no new hue introduced
					["@lsp.type.parameter"] = { fg = colors.maroon, italic = true },
					["@lsp.mod.deprecated"] = { strikethrough = true },
					["@lsp.typemod.method.static"] = { fg = colors.sky, italic = true },
					["@lsp.typemod.property.static"] = { fg = colors.text, italic = true },
					["@lsp.typemod.variable.static"] = { fg = colors.text, italic = true },
					["@lsp.typemod.method.async"] = { fg = colors.sky, underline = true },
					["@lsp.typemod.variable.readonly"] = { fg = colors.text, italic = true },

					-- XML doc comments (`///`) — slightly lifted but still calm
					["@lsp.typemod.comment.documentation"] = { fg = colors.overlay2, italic = true },

					-- Attributes ([HttpGet], [Authorize], …) — no hue, just dim
					["@lsp.type.decorator"] = { fg = colors.overlay2 },
					["@attribute"] = { fg = colors.overlay2 },

					-- ─── Search & MatchParen ─────────────────────────────────────
					MatchParen = { bg = colors.surface1, bold = true },
					Search = { bg = colors.peach, fg = colors.base, bold = true },
					IncSearch = { bg = colors.yellow, fg = colors.base, bold = true },
					CurSearch = { bg = colors.red, fg = colors.base, bold = true },

					-- ─── Snacks ─────────────────────────────────────────────────
					SnacksIndent = { fg = "#2a2840" },
					SnacksIndentScope = { fg = colors.overlay1 },
					SnacksNormal = { bg = bg },
					SnacksBorder = { fg = colors.surface2, bg = bg },
					SnacksTitle = { fg = colors.overlay2, bg = bg }, -- dimmed
					SnacksWinBar = { bg = bg },
					SnacksWinBarNC = { bg = bg },
					SnacksPicker = { bg = bg },
					SnacksPickerBorder = { fg = colors.surface2, bg = bg },
					SnacksPickerTitle = { fg = colors.overlay2, bg = bg }, -- dimmed
					SnacksPickerInput = { bg = bg },
					SnacksPickerInputBorder = { fg = colors.surface2, bg = bg },
					SnacksPickerBox = { bg = bg },
					SnacksPickerPreview = { bg = bg },
					SnacksPickerPreviewBorder = { fg = colors.surface2, bg = bg },
					SnacksPickerList = { bg = bg },
					SnacksPickerListBorder = { fg = colors.surface2, bg = bg },
					SnacksPickerMatch = { fg = colors.peach, bold = true },
					SnacksPickerCursorLine = { bg = colors.surface1, bold = true },

					-- ─── Git diff ───────────────────────────────────────────────
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
					DiffRemoved = { bg = "#4a1518", fg = colors.red },
					DiffviewNormal = { bg = bg },
					DiffviewCursorLine = { bg = "#252338" },
					DiffviewFilePanelTitle = { fg = colors.overlay2, bold = true }, -- dimmed
					DiffviewFilePanelCounter = { fg = colors.overlay1 },
					DiffviewFilePanelFileName = { fg = colors.text },
					DiffviewStatusAdded = { fg = colors.green },
					DiffviewStatusModified = { fg = colors.yellow },
					DiffviewStatusDeleted = { fg = colors.red },
					DiffviewStatusRenamed = { fg = colors.blue },

					-- ─── Flash ──────────────────────────────────────────────────
					FlashBackdrop = { fg = colors.overlay0 },
					FlashLabel = { fg = colors.base, bg = colors.red, bold = true },
					FlashMatch = { link = "Search" },
					FlashCurrent = { link = "Search" },

					-- ─── Blink CMP ──────────────────────────────────────────────
					BlinkCmpMenu = { bg = bg },
					BlinkCmpMenuBorder = { fg = colors.surface2, bg = bg },
					BlinkCmpMenuSelection = { bg = colors.surface1, bold = true },
					BlinkCmpScrollBarThumb = { bg = colors.overlay0 },
					BlinkCmpScrollBarGutter = { bg = panel },
					BlinkCmpDoc = { bg = bg },
					BlinkCmpDocBorder = { fg = colors.surface2, bg = bg },
					BlinkCmpDocCursorLine = { bg = "#252338" },
					BlinkCmpSignatureHelp = { bg = bg },
					BlinkCmpSignatureHelpBorder = { fg = colors.surface2, bg = bg },
					BlinkCmpSignatureHelpActiveParameter = { fg = colors.peach, bold = true },
					BlinkCmpLabel = { fg = colors.text },
					BlinkCmpLabelMatch = { fg = colors.peach, bold = true },
					BlinkCmpLabelDeprecated = { strikethrough = true, fg = colors.overlay1 },
					BlinkCmpLabelDescription = { fg = colors.overlay1, italic = true },
					BlinkCmpLabelDetail = { fg = colors.overlay1 },
					BlinkCmpSource = { fg = colors.overlay0, italic = true },
					BlinkCmpGhostText = { fg = colors.surface2, italic = true },

					-- Kind icons — mirrors the 3-hue system above
					BlinkCmpKind = { fg = colors.overlay1 },
					BlinkCmpKindMethod = { fg = colors.sky },
					BlinkCmpKindFunction = { fg = colors.sky },
					BlinkCmpKindConstructor = { fg = colors.sky },
					BlinkCmpKindProperty = { fg = colors.text },
					BlinkCmpKindField = { fg = colors.text },
					BlinkCmpKindVariable = { fg = colors.text },
					BlinkCmpKindClass = { fg = colors.blue },
					BlinkCmpKindInterface = { fg = colors.blue },
					BlinkCmpKindStruct = { fg = colors.blue },
					BlinkCmpKindEnum = { fg = colors.blue },
					BlinkCmpKindEnumMember = { fg = colors.blue, bold = true },
					BlinkCmpKindModule = { fg = colors.overlay2 }, -- namespace family, dim
					BlinkCmpKindConstant = { fg = colors.text },
					BlinkCmpKindKeyword = { fg = colors.mauve }, -- keywords stay mauve (catppuccin default, well-established)
					BlinkCmpKindSnippet = { fg = colors.overlay1 },
					BlinkCmpKindEvent = { fg = colors.text, bold = true },
					BlinkCmpKindOperator = { fg = colors.overlay2 },
					BlinkCmpKindReference = { fg = colors.text },
					BlinkCmpKindFile = { fg = colors.overlay2 },
					BlinkCmpKindFolder = { fg = colors.overlay2 },
					BlinkCmpKindText = { fg = colors.text },
					BlinkCmpKindUnit = { fg = colors.text },
					BlinkCmpKindValue = { fg = colors.text },
					BlinkCmpKindColor = { fg = colors.text },
					BlinkCmpKindTypeParameter = { fg = colors.blue, italic = true },
				}
			end,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
