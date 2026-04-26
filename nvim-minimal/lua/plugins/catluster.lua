-- Catluster — catppuccin on lackluster's palette, 3-tier hierarchy.
-- Combines hues from all 4 lackluster variants (default/hack/mint/night/dark)
-- so we get richer differentiation while staying entirely in-palette.
--
-- TIER 3  Ambient — fades into bg
--   #3A3A3A  comments
--   #666666  keywords
--   #7a7a7a  punctuation, operators, namespaces, function calls
--
-- TIER 2  Operational — greys, brightness = importance
--   #cccccc  variables, properties, enumMembers              (data)
--   #aaaaaa  methods                                         (call site)
--   #8E8E8E  parameters
--
-- TIER 1  Primary — typed, colored. Each kind gets its own hue:
--   luster  #deeeed   class, interface (italic), function def
--   blue    #88a0c8   record, delegate (italic)              ← DTO / data type
--   lack    #90a0b8   struct, type.builtin, this/null (italic)
--   green   #8aaa88   enum, enumMember (bold), string.escape
--   rose    #c07878   typeParameter (italic), field
--
-- Pop accents:
--   yellow  #abab77   strings (lackluster original)
--   orange  #ffaa88   attributes, events, warnings
--   red     #D70000   errors

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
					-- Backgrounds (lackluster main_background / popup / menu / statusline)
					base = "#101010",
					mantle = "#1A1A1A",
					crust = "#080808",

					-- Surface stack — gray2/3, statusline
					surface0 = "#191919",
					surface1 = "#242424",
					surface2 = "#2a2a2a",

					-- Overlay stack — gray4/5/6
					overlay0 = "#444444",
					overlay1 = "#555555",
					overlay2 = "#7a7a7a",

					-- Foreground stack — param / gray7 / gray8
					subtext0 = "#8E8E8E",
					subtext1 = "#aaaaaa",
					text = "#cccccc",

					-- Lackluster accents — bumped for contrast on #101010
					yellow = "#abab77", -- strings              (lackluster original — good)
					peach = "#ffaa88", -- orange                (lackluster original — good)
					sky = "#88a0c8", -- blue                    (bumped from #7788AA)
					sapphire = "#88a0c8",
					blue = "#88a0c8",
					teal = "#8aaa88", -- green                  (bumped from #789978)
					lavender = "#90a0b8", -- lack slate          (bumped from #708090)
					mauve = "#90a0b8",
					pink = "#deeeed", -- luster                 (lackluster original — good)
					rosewater = "#deeeed",
					flamingo = "#deeeed",
					maroon = "#ffaa88",
					red = "#D70000", --                         (lackluster original — good)
					green = "#8aaa88",
				},
			},
			styles = {
				comments = {},
				keywords = {},
				functions = {},
				types = {},
				operators = {},
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
			custom_highlights = function(c)
				-- Lackluster constants
				local bg = "#101010"
				local panel = "#1A1A1A"
				local statusline = "#242424"
				local cursorline = "#191919"
				local comment = "#3A3A3A"
				local keyword = "#666666" -- lackluster's `keyword` special; freed `lack` for types
				local exception_kw = "#7788AA" -- blue (lackluster-night)
				local param = "#8E8E8E"
				local luster = "#deeeed"  -- lackluster original, ~18:1 contrast — good
				local yellow = "#abab77"  -- lackluster original — good
				local blue = "#88a0c8"    -- bumped from #7788AA for contrast
				local orange = "#ffaa88"  -- lackluster original — good
				local green = "#8aaa88"   -- bumped from #789978
				local lack = "#90a0b8"    -- bumped from #708090 (slate)
				local rose = "#c07878"    -- bumped from #aa6666

				return {
					-- ── Core UI ───────────────────────────────────────────
					Normal = { fg = c.text, bg = bg },
					NormalNC = { fg = c.text, bg = bg },
					SignColumn = { bg = bg },
					EndOfBuffer = { fg = bg, bg = bg },
					LineNr = { fg = c.overlay0, bg = bg },
					CursorLineNr = { fg = c.subtext1, bold = true, bg = cursorline },
					CursorLine = { bg = cursorline },
					ColorColumn = { bg = c.crust },
					Visual = { fg = "#000000", bg = c.text },
					Folded = { fg = c.overlay0, bg = bg },
					WinSeparator = { fg = c.overlay0 },
					VertSplit = { fg = c.overlay0 },
					MatchParen = { fg = luster, bold = true, underline = true },
					Whitespace = { fg = "#202020" },
					NonText = { fg = "#202020" },
					SpecialKey = { fg = "#202020" },

					-- ── Statusline / float / popup ───────────────────────
					-- Floats share main bg so goto-preview / decompiled views
					-- don't feel like a separate panel layer.
					StatusLine = { fg = c.subtext1, bg = statusline },
					StatusLineNC = { fg = c.overlay0, bg = c.crust },
					NormalFloat = { bg = bg },
					FloatBorder = { fg = c.overlay0, bg = bg },
					FloatTitle = { fg = c.overlay1, bg = bg },
					Pmenu = { fg = c.overlay2, bg = bg },
					PmenuSel = { fg = c.text, bg = c.surface1, bold = true },
					PmenuThumb = { bg = c.overlay1 },
					PmenuSbar = { bg = c.surface0 },
					QuickFixLine = { bg = c.surface1, bold = true },
					QfCursorLine = { bg = cursorline },

					-- ── Search ────────────────────────────────────────────
					Search = { fg = "#000000", bg = lack },
					IncSearch = { fg = "#000000", bg = c.text },
					CurSearch = { fg = "#000000", bg = c.text },

					-- ── Treesitter / syntax (lackluster-night) ───────────
					["@comment"] = { fg = comment },
					Comment = { fg = comment },

					["@variable"] = { fg = c.text },
					["@variable.member"] = { fg = c.text },
					["@variable.parameter"] = { fg = param },
					["@variable.builtin"] = { fg = lack, italic = true },

					["@constant"] = { fg = yellow },
					["@constant.builtin"] = { fg = lack, italic = true },

					["@string"] = { fg = yellow },
					["@string.escape"] = { fg = green },
					["@string.special"] = { fg = green },
					["@number"] = { fg = c.subtext1 },
					["@number.float"] = { fg = c.subtext1 },
					["@boolean"] = { fg = c.subtext1 },
					["@character"] = { fg = yellow },

					["@keyword"] = { fg = keyword },
					["@keyword.modifier"] = { fg = keyword },
					["@keyword.operator"] = { fg = keyword },
					["@keyword.coroutine"] = { fg = keyword },
					["@keyword.import"] = { fg = keyword },
					["@keyword.type"] = { fg = keyword },
					["@keyword.conditional"] = { fg = keyword },
					["@keyword.repeat"] = { fg = keyword },
					["@keyword.return"] = { fg = exception_kw },
					["@keyword.exception"] = { fg = exception_kw },

					["@operator"] = { fg = c.overlay2 },
					["@punctuation"] = { fg = c.overlay2 },
					["@punctuation.bracket"] = { fg = c.overlay2 },
					["@punctuation.delimiter"] = { fg = c.overlay2 },
					["@punctuation.special"] = { fg = c.overlay2 },

					["@function"] = { fg = luster },
					["@function.method"] = { fg = luster },
					["@function.call"] = { fg = c.overlay2 },
					["@function.method.call"] = { fg = c.overlay2 },
					["@function.builtin"] = { fg = blue },
					["@constructor"] = { fg = c.overlay2 },

					["@type"] = { fg = luster },
					["@type.builtin"] = { fg = lack },
					["@type.definition"] = { fg = luster, bold = true },

					["@tag"] = { fg = c.overlay1 },
					["@attribute"] = { fg = orange },

					-- ── LSP semantic tokens (Roslyn / C#) ────────────────
					-- TIER 1: types are colored by kind (luster / blue / lack / green).
					-- TIER 2: data is bright grey, methods sit one notch dimmer.
					-- TIER 3: namespaces fade.
					["@lsp.type.namespace"] = { fg = c.overlay2 },
					["@lsp.type.namespace.cs"] = { fg = c.overlay2 },

					-- Reference types — luster (the "main" types)
					["@lsp.type.class"] = { fg = luster },
					["@lsp.type.class.cs"] = { fg = luster },
					["@lsp.type.interface"] = { fg = luster, italic = true },
					["@lsp.type.interface.cs"] = { fg = luster, italic = true },

					-- Data / DTO types — blue (records, delegates)
					["@lsp.type.record"] = { fg = blue },
					["@lsp.type.record.cs"] = { fg = blue },
					["@lsp.type.delegate"] = { fg = blue, italic = true },
					["@lsp.type.delegate.cs"] = { fg = blue, italic = true },

					-- Value types — lack (slate)
					["@lsp.type.struct"] = { fg = lack },
					["@lsp.type.struct.cs"] = { fg = lack },

					-- Generics — rose (warm, distinct from struct)
					["@lsp.type.typeParameter"] = { fg = rose, italic = true },
					["@lsp.type.typeParameter.cs"] = { fg = rose, italic = true },

					-- Enums — green (finite sets)
					["@lsp.type.enum"] = { fg = green },
					["@lsp.type.enum.cs"] = { fg = green },
					["@lsp.type.enumMember"] = { fg = green, bold = true },
					["@lsp.type.enumMember.cs"] = { fg = green, bold = true },

					-- Callables — calls sit dim, definitions pop with luster
					["@lsp.type.method"] = { fg = c.subtext1 },
					["@lsp.type.method.cs"] = { fg = c.subtext1 },
					["@lsp.typemod.method.definition"] = { fg = luster },
					["@lsp.typemod.method.definition.cs"] = { fg = luster },

					-- Properties (public accessors) — bright neutral
					["@lsp.type.property"] = { fg = c.text },
					["@lsp.type.property.cs"] = { fg = c.text },

					-- Fields (instance state) — rose, distinct from properties
					["@lsp.type.field"] = { fg = rose },
					["@lsp.type.field.cs"] = { fg = rose },

					-- Variables — bright neutral
					["@lsp.type.variable"] = { fg = c.text },
					["@lsp.type.variable.cs"] = { fg = c.text },

					-- Locals
					["@lsp.type.parameter"] = { fg = param },
					["@lsp.type.parameter.cs"] = { fg = param },

					-- Pop — orange umph
					["@lsp.type.event"] = { fg = orange, bold = true },
					["@lsp.type.event.cs"] = { fg = orange, bold = true },
					["@lsp.type.decorator"] = { fg = orange },
					["@lsp.type.decorator.cs"] = { fg = orange },

					-- C# Roslyn idioms: this/base, deprecated, async, static
					["@lsp.typemod.variable.self"] = { fg = lack, italic = true },
					["@lsp.mod.deprecated"] = { strikethrough = true },
					["@lsp.typemod.method.static"] = { italic = true },
					["@lsp.typemod.property.static"] = { italic = true },
					["@lsp.typemod.method.async"] = { underline = true },

					-- Constants — `const` / `static readonly` get yellow.
					-- Catches both module-level (variable) and class-level (field).
					["@lsp.typemod.variable.readonly"] = { fg = yellow, italic = true },
					["@lsp.typemod.variable.static"] = { fg = yellow, italic = true },
					["@lsp.typemod.field.readonly"] = { fg = yellow, italic = true },
					["@lsp.typemod.field.static"] = { fg = yellow, italic = true },

					["@lsp.typemod.comment.documentation"] = { fg = lack },

					-- ── Diagnostics (lackluster keeps them quiet) ────────
					-- tiny-inline-diagnostic auto-blends bg from these fg colors,
					-- so we drive both inline and gutter signs from one place.
					DiagnosticError = { fg = c.red },
					DiagnosticWarn = { fg = orange },
					DiagnosticInfo = { fg = c.overlay2 },
					DiagnosticHint = { fg = c.overlay2 },
					DiagnosticOk = { fg = green },
					DiagnosticUnnecessary = { fg = c.overlay0 },
					DiagnosticDeprecated = { fg = orange, strikethrough = true },

					-- Virtual text fallback (when tiny-inline isn't active on a line)
					-- — subtle matching bg so messages are scannable but not loud
					DiagnosticVirtualTextError = { fg = c.red, bg = "#1c1212" },
					DiagnosticVirtualTextWarn = { fg = orange, bg = "#1c1810" },
					DiagnosticVirtualTextInfo = { fg = c.overlay2, bg = "#141618" },
					DiagnosticVirtualTextHint = { fg = c.overlay2, bg = bg },
					DiagnosticVirtualTextOk = { fg = green, bg = "#141a14" },

					-- Underlines (sp colors drive the squiggle)
					DiagnosticUnderlineError = { sp = c.red, undercurl = true },
					DiagnosticUnderlineWarn = { sp = orange, undercurl = true },
					DiagnosticUnderlineInfo = { sp = c.overlay2, underline = true },
					DiagnosticUnderlineHint = { sp = c.overlay2, underline = true },

					LspInlayHint = { fg = c.overlay0, italic = true, bg = bg },
					LspReferenceText = { bg = c.surface1 },
					LspReferenceRead = { bg = c.surface1 },
					LspReferenceWrite = { bg = c.surface1, bold = true },

					-- ── Snacks ────────────────────────────────────────────
					SnacksIndent = { fg = c.surface0 },
					SnacksIndentScope = { fg = c.overlay0 },
					SnacksNormal = { bg = bg },
					SnacksBorder = { fg = c.overlay0, bg = bg },
					SnacksTitle = { fg = c.overlay1, bg = bg },
					SnacksWinBar = { bg = bg },
					SnacksWinBarNC = { bg = bg },
					SnacksPicker = { bg = bg },
					SnacksPickerBorder = { fg = c.overlay0, bg = bg },
					SnacksPickerTitle = { fg = c.overlay1, bg = bg },
					SnacksPickerInput = { bg = bg },
					SnacksPickerInputBorder = { fg = c.overlay0, bg = bg },
					SnacksPickerBox = { bg = bg },
					SnacksPickerPreview = { bg = bg },
					SnacksPickerPreviewBorder = { fg = c.overlay0, bg = bg },
					SnacksPickerList = { bg = bg },
					SnacksPickerListBorder = { fg = c.overlay0, bg = bg },
					SnacksPickerMatch = { fg = luster, bold = true },
					SnacksPickerCursorLine = { bg = c.surface1, bold = true },
					-- File path components — defaults link Dir→NonText (#202020)
					-- which is invisible against bg. Override explicitly.
					SnacksPickerFile = { fg = c.text },
					SnacksPickerDir = { fg = c.overlay2 }, -- dirname prefix, readable but dim
					SnacksPickerDirectory = { fg = c.subtext1 }, -- when item itself is a dir
					SnacksPickerDimmed = { fg = c.overlay1 },
					SnacksPickerComment = { fg = c.overlay1 },

					-- ── Diff (lackluster: green/orange/gray) ─────────────
					DiffAdd = { bg = "#16241a" },
					DiffChange = { bg = "#1c1c1c" },
					DiffDelete = { bg = "#2a1a16" },
					DiffText = { bg = "#22221a" },
					DiffviewDiffAdd = { bg = "#16241a" },
					DiffviewDiffAddAsDelete = { bg = "#2a1a16" },
					DiffviewDiffDelete = { fg = c.surface2, bg = "#1f1412" },
					DiffviewDiffChange = { bg = "#1c1c1c" },
					DiffviewDiffText = { bg = "#22221a" },
					DiffviewDiffDeleteDim = { bg = "#190f0d" },
					DiffAddAsDelete = { bg = "#2a1a16" },
					DiffviewFiller = { bg = bg },
					DiffRemoved = { bg = "#2a1a16", fg = orange },
					DiffviewNormal = { bg = bg },
					DiffviewCursorLine = { bg = cursorline },
					DiffviewFilePanelTitle = { fg = luster, bold = true },
					DiffviewFilePanelCounter = { fg = c.overlay2 },
					DiffviewFilePanelFileName = { fg = c.subtext1 },
					DiffviewStatusAdded = { fg = green },
					DiffviewStatusModified = { fg = c.overlay2 },
					DiffviewStatusDeleted = { fg = orange },
					DiffviewStatusRenamed = { fg = lack },

					-- ── Gitsigns (lackluster diff palette) ───────────────
					GitSignsAdd = { fg = green },
					GitSignsChange = { fg = c.overlay2 },
					GitSignsDelete = { fg = orange },

					-- ── Flash (lackluster's flash uses blue label) ───────
					FlashBackdrop = { fg = c.overlay0 },
					FlashLabel = { fg = panel, bg = blue, bold = true },
					FlashMatch = { fg = c.overlay2, bg = bg },
					FlashCurrent = { fg = "#000000", bg = c.text, bold = true },

					-- ── Blink completion ─────────────────────────────────
					BlinkCmpMenu = { bg = bg },
					BlinkCmpMenuBorder = { fg = c.overlay0, bg = bg },
					BlinkCmpMenuSelection = { bg = c.surface1, bold = true },
					BlinkCmpScrollBarThumb = { bg = c.overlay1 },
					BlinkCmpScrollBarGutter = { bg = c.surface0 },
					BlinkCmpDoc = { bg = bg },
					BlinkCmpDocBorder = { fg = c.overlay0, bg = bg },
					BlinkCmpDocCursorLine = { bg = cursorline },
					BlinkCmpSignatureHelp = { bg = bg },
					BlinkCmpSignatureHelpBorder = { fg = c.overlay0, bg = bg },
					BlinkCmpSignatureHelpActiveParameter = { fg = luster, bold = true },

					BlinkCmpLabel = { fg = c.subtext1 },
					BlinkCmpLabelMatch = { fg = luster, bold = true },
					BlinkCmpLabelDeprecated = { strikethrough = true, fg = c.overlay0 },
					BlinkCmpLabelDescription = { fg = c.overlay1 },
					BlinkCmpLabelDetail = { fg = c.overlay1 },
					BlinkCmpSource = { fg = c.overlay0 },
					BlinkCmpGhostText = { fg = c.overlay0 },

					-- Kind icons mirror the buffer hierarchy:
					--   luster → class/interface/function   blue → record/delegate
					--   lack   → struct/typeParameter        green → enum/enumMember
					BlinkCmpKind = { fg = c.subtext1 },
					BlinkCmpKindMethod = { fg = c.subtext1 },
					BlinkCmpKindFunction = { fg = luster },
					BlinkCmpKindConstructor = { fg = luster },
					BlinkCmpKindProperty = { fg = c.text },
					BlinkCmpKindField = { fg = rose },
					BlinkCmpKindVariable = { fg = c.text },
					BlinkCmpKindClass = { fg = luster },
					BlinkCmpKindInterface = { fg = luster, italic = true },
					BlinkCmpKindStruct = { fg = lack },
					BlinkCmpKindEnum = { fg = green },
					BlinkCmpKindEnumMember = { fg = green, bold = true },
					BlinkCmpKindModule = { fg = c.overlay2 },
					BlinkCmpKindConstant = { fg = yellow },
					BlinkCmpKindKeyword = { fg = keyword },
					BlinkCmpKindSnippet = { fg = lack },
					BlinkCmpKindEvent = { fg = orange, bold = true },
					BlinkCmpKindOperator = { fg = c.overlay2 },
					BlinkCmpKindReference = { fg = blue },
					BlinkCmpKindFile = { fg = luster },
					BlinkCmpKindFolder = { fg = c.subtext1 },
					BlinkCmpKindText = { fg = c.text },
					BlinkCmpKindUnit = { fg = c.text },
					BlinkCmpKindValue = { fg = c.text },
					BlinkCmpKindColor = { fg = c.text },
					BlinkCmpKindTypeParameter = { fg = rose, italic = true },

					-- ── Trouble ──────────────────────────────────────────
					TroubleNormal = { bg = bg },
					TroubleNormalNC = { bg = bg },
					TroubleText = { fg = c.text, bg = bg },
					TroubleSource = { fg = c.overlay1 },
					TroubleCount = { fg = orange, bold = true },
					TroubleCode = { fg = c.overlay2 },
					TroubleFoldIcon = { fg = c.overlay0 },
					TroubleIndent = { fg = c.surface1 },
					TroublePos = { fg = c.overlay1 },
					TroubleLocation = { fg = c.overlay2 },
					TroubleFile = { fg = luster, bold = true },
					TroubleFilename = { fg = luster, bold = true },
					TroubleDir = { fg = c.subtext1 },
					TroublePreview = { bg = bg },
					TroubleHelp = { fg = c.overlay1 },
					TroublePromptTitle = { fg = luster, bg = bg, bold = true },
					-- Diagnostic kind indicators in trouble panes
					TroubleSignError = { fg = c.red, bg = bg },
					TroubleSignWarning = { fg = orange, bg = bg },
					TroubleSignInformation = { fg = c.overlay2, bg = bg },
					TroubleSignHint = { fg = c.overlay2, bg = bg },
					TroubleSignOther = { fg = c.subtext1, bg = bg },
					-- Symbol kinds in :Trouble symbols — mirror the buffer hierarchy
					TroubleIconClass = { fg = luster },
					TroubleIconInterface = { fg = luster, italic = true },
					TroubleIconFunction = { fg = luster },
					TroubleIconMethod = { fg = c.subtext1 },
					TroubleIconConstructor = { fg = luster },
					TroubleIconStruct = { fg = lack },
					TroubleIconRecord = { fg = blue },
					TroubleIconEnum = { fg = green },
					TroubleIconEnumMember = { fg = green, bold = true },
					TroubleIconField = { fg = rose },
					TroubleIconProperty = { fg = c.text },
					TroubleIconVariable = { fg = c.text },
					TroubleIconConstant = { fg = yellow },
					TroubleIconNamespace = { fg = c.overlay2 },
					TroubleIconModule = { fg = c.overlay2 },
					TroubleIconEvent = { fg = orange, bold = true },
					TroubleIconTypeParameter = { fg = rose, italic = true },

					-- ── Aerial ───────────────────────────────────────────
					AerialNormal = { bg = bg },
					AerialLine = { bg = c.surface1, bold = true },
					AerialLineNC = { bg = cursorline },
					AerialGuide = { fg = c.surface2 },
					-- Symbol kind highlights mirror buffer + completion menu
					AerialClass = { fg = luster },
					AerialClassIcon = { fg = luster },
					AerialInterface = { fg = luster, italic = true },
					AerialInterfaceIcon = { fg = luster, italic = true },
					AerialFunction = { fg = luster },
					AerialFunctionIcon = { fg = luster },
					AerialMethod = { fg = c.subtext1 },
					AerialMethodIcon = { fg = c.subtext1 },
					AerialConstructor = { fg = luster },
					AerialConstructorIcon = { fg = luster },
					AerialStruct = { fg = lack },
					AerialStructIcon = { fg = lack },
					AerialEnum = { fg = green },
					AerialEnumIcon = { fg = green },
					AerialEnumMember = { fg = green, bold = true },
					AerialEnumMemberIcon = { fg = green, bold = true },
					AerialField = { fg = rose },
					AerialFieldIcon = { fg = rose },
					AerialProperty = { fg = c.text },
					AerialPropertyIcon = { fg = c.text },
					AerialVariable = { fg = c.text },
					AerialVariableIcon = { fg = c.text },
					AerialConstant = { fg = yellow },
					AerialConstantIcon = { fg = yellow },
					AerialNamespace = { fg = c.overlay2 },
					AerialNamespaceIcon = { fg = c.overlay2 },
					AerialModule = { fg = c.overlay2 },
					AerialModuleIcon = { fg = c.overlay2 },
					AerialEvent = { fg = orange, bold = true },
					AerialEventIcon = { fg = orange, bold = true },
					AerialTypeParameter = { fg = rose, italic = true },
					AerialTypeParameterIcon = { fg = rose, italic = true },

					-- ── Yanky ────────────────────────────────────────────
					YankyPut = { link = "IncSearch" },
					YankyYanked = { link = "IncSearch" },

					-- ── Markdown / @markup.* ─────────────────────────────
					-- READMEs, lua docstrings, help files, prompt files.
					-- Heading hierarchy: luster → blue → green → subtext.
					["@markup.heading"] = { fg = luster, bold = true },
					["@markup.heading.1"] = { fg = luster, bold = true },
					["@markup.heading.2"] = { fg = blue, bold = true },
					["@markup.heading.3"] = { fg = green, bold = true },
					["@markup.heading.4"] = { fg = c.subtext1, bold = true },
					["@markup.heading.5"] = { fg = c.subtext1, bold = true, italic = true },
					["@markup.heading.6"] = { fg = c.overlay2, bold = true },
					["@markup.heading.1.markdown"] = { fg = luster, bold = true },
					["@markup.heading.2.markdown"] = { fg = blue, bold = true },
					["@markup.heading.3.markdown"] = { fg = green, bold = true },
					["@markup.heading.4.markdown"] = { fg = c.subtext1, bold = true },
					["@markup.heading.5.markdown"] = { fg = c.subtext1, bold = true, italic = true },
					["@markup.heading.6.markdown"] = { fg = c.overlay2, bold = true },

					["@markup.strong"] = { fg = c.text, bold = true },
					["@markup.italic"] = { fg = c.text, italic = true },
					["@markup.strikethrough"] = { strikethrough = true },
					["@markup.underline"] = { underline = true },

					-- Inline / block code — yellow like strings, blocks get surface bg
					["@markup.raw"] = { fg = yellow },
					["@markup.raw.markdown_inline"] = { fg = yellow },
					["@markup.raw.block"] = { bg = c.surface0 },
					["@markup.raw.block.markdown"] = { bg = c.surface0 },

					-- Links — blue (matches our DTO/data hue), URLs dimmer
					["@markup.link"] = { fg = blue },
					["@markup.link.label"] = { fg = blue, underline = true },
					["@markup.link.url"] = { fg = c.overlay1, underline = true },

					-- Lists & quotes
					["@markup.list"] = { fg = orange },
					["@markup.list.checked"] = { fg = green },
					["@markup.list.unchecked"] = { fg = c.overlay1 },
					["@markup.quote"] = { fg = c.overlay1, italic = true },
					["@markup.math"] = { fg = yellow },
					["@markup.environment"] = { fg = orange },

					-- Legacy @text.* fallback (older tree-sitter parsers)
					["@text.title"] = { fg = luster, bold = true },
					["@text.literal"] = { fg = yellow },
					["@text.uri"] = { fg = blue, underline = true },
					["@text.reference"] = { fg = blue },
					["@text.note"] = { fg = blue },
					["@text.warning"] = { fg = orange },
					["@text.danger"] = { fg = c.red, bold = true },
					["@text.todo"] = { fg = orange },
					["@text.emphasis"] = { italic = true },
					["@text.strong"] = { bold = true },

					-- Markdown rule (---) and headings prefix marks
					["@punctuation.special.markdown"] = { fg = orange },

					-- ── todo-comments.nvim ───────────────────────────────
					-- Map keywords to lackluster palette so TODO/FIXME/etc.
					-- stand out without going neon. Bg variants invert fg/bg
					-- when the keyword renders as a colored block.
					-- TODO — orange (action needed)
					TodoFgTODO = { fg = orange, bold = true },
					TodoBgTODO = { fg = bg, bg = orange, bold = true },
					TodoSignTODO = { fg = orange },
					-- FIXME / FIX / BUG / ISSUE — red (urgent)
					TodoFgFIX = { fg = c.red, bold = true },
					TodoBgFIX = { fg = bg, bg = c.red, bold = true },
					TodoSignFIX = { fg = c.red },
					-- HACK — yellow (workaround)
					TodoFgHACK = { fg = yellow, bold = true },
					TodoBgHACK = { fg = bg, bg = yellow, bold = true },
					TodoSignHACK = { fg = yellow },
					-- WARN / WARNING / XXX — orange italic
					TodoFgWARN = { fg = orange, bold = true, italic = true },
					TodoBgWARN = { fg = bg, bg = orange, bold = true, italic = true },
					TodoSignWARN = { fg = orange },
					-- NOTE / INFO — blue (informational)
					TodoFgNOTE = { fg = blue, bold = true },
					TodoBgNOTE = { fg = bg, bg = blue, bold = true },
					TodoSignNOTE = { fg = blue },
					-- PERF / OPTIM / OPTIMIZE / PERFORMANCE — green
					TodoFgPERF = { fg = green, bold = true },
					TodoBgPERF = { fg = bg, bg = green, bold = true },
					TodoSignPERF = { fg = green },
					-- TEST / TESTING — lack (slate, neutral)
					TodoFgTEST = { fg = lack, bold = true },
					TodoBgTEST = { fg = bg, bg = lack, bold = true },
					TodoSignTEST = { fg = lack },
				}
			end,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
			-- Terminal colors — set AFTER colorscheme so we override catppuccin's
			-- defaults. These drive lazygit (and any terminal app inside nvim).
			vim.g.terminal_color_0  = "#101010" -- black       (bg)
			vim.g.terminal_color_1  = "#D70000" -- red
			vim.g.terminal_color_2  = "#8aaa88" -- green
			vim.g.terminal_color_3  = "#abab77" -- yellow
			vim.g.terminal_color_4  = "#88a0c8" -- blue
			vim.g.terminal_color_5  = "#c07878" -- magenta     (rose)
			vim.g.terminal_color_6  = "#90a0b8" -- cyan        (lack)
			vim.g.terminal_color_7  = "#aaaaaa" -- white       (subtext1)
			vim.g.terminal_color_8  = "#444444" -- bright black (overlay0)
			vim.g.terminal_color_9  = "#D70000" -- bright red
			vim.g.terminal_color_10 = "#8aaa88" -- bright green
			vim.g.terminal_color_11 = "#abab77" -- bright yellow
			vim.g.terminal_color_12 = "#88a0c8" -- bright blue
			vim.g.terminal_color_13 = "#ffaa88" -- bright magenta (orange — for git modified)
			vim.g.terminal_color_14 = "#90a0b8" -- bright cyan
			vim.g.terminal_color_15 = "#cccccc" -- bright white (text)
		end,
	},
}
