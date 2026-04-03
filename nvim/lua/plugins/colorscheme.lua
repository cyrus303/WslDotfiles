-- return {
--   {
--     "rose-pine/neovim",
--     name = "rose-pine",
--     lazy = false,
--     priority = 1000,
--     opts = {
--       variant = "main",
--       dark_variant = "main",
--       dim_inactive_windows = false,
--       extend_background_behind_borders = true,
--
--       enable = {
--         terminal = true,
--         legacy_highlights = true,
--         migrations = true,
--       },
--
--       styles = {
--         bold = false,
--         italic = true,
--         transparency = true,
--       },
--
--       groups = {
--         border = "muted",
--         link = "iris",
--         panel = "surface",
--
--         error = "love",
--         hint = "iris",
--         info = "foam",
--         note = "pine",
--         todo = "rose",
--         warn = "gold",
--
--         git_add = "foam",
--         git_change = "rose",
--         git_delete = "love",
--         git_dirty = "rose",
--         git_ignore = "muted",
--         git_merge = "iris",
--         git_rename = "pine",
--         git_stage = "iris",
--         git_text = "rose",
--         git_untracked = "subtle",
--
--         h1 = "iris",
--         h2 = "foam",
--         h3 = "rose",
--         h4 = "gold",
--         h5 = "pine",
--         h6 = "foam",
--       },
--
--       palette = {
--         main = {
--           base = "#111019",
--         },
--       },
--
--       highlight_groups = {
--         CursorLineNr = { fg = "#eb6f92", bold = true },
--         LineNr = { fg = "#524f67" },
--         Comment = { italic = true },
--       },
--     },
--     config = function(_, opts)
--       require("rose-pine").setup(opts)
--       vim.cmd("colorscheme rose-pine")
--     end,
--   },
-- }

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
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
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
        cmp = true,
        gitsigns = true,
        which_key = true,
        mini = { enabled = true },
        dap = true,
        dap_ui = true,
        indent_blankline = { enabled = true },
        neotree = true,
        fidget = true,
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
          Visual = { bg = "#2a2740" },
          CursorLine = { bg = "#1c1a28" },
          ColorColumn = { bg = panel },
          EndOfBuffer = { fg = bg, bg = bg },
          WinSeparator = { fg = colors.surface2 },
          VertSplit = { fg = colors.surface2 },

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
          ["@lsp.type.method"] = { fg = colors.blue },
          ["@lsp.type.property"] = { fg = colors.lavender },
          ["@lsp.type.parameter"] = { fg = colors.maroon, italic = true },
          ["@lsp.type.event"] = { fg = colors.flamingo },

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

          -- Neo-tree
          NeoTreeNormal = { bg = bg },
          NeoTreeNormalNC = { bg = bg },
          NeoTreeEndOfBuffer = { bg = bg },

          -- Diffview / Git diff (bold red/green style)
          DiffAdd = { bg = "#1a3a1a" },
          DiffChange = { bg = "#181620" },
          DiffDelete = { bg = "#4a1518" },
          DiffText = { bg = "#3d3520" },
          DiffviewDiffAdd = { bg = "#1a3a1a" },
          DiffviewDiffAddAsDelete = { bg = "#4a1518" },
          DiffviewDiffDelete = { fg = colors.surface2, bg = "#3a1215" },
          DiffviewDiffChange = { bg = "#181620" },
          DiffviewDiffText = { bg = "#3d3520" },
          DiffviewDiffDeleteDim = { bg = "#351015" },
          DiffAddAsDelete = { bg = "#4a1518" },
          DiffviewFiller = { bg = "#1a1828" },
          DiffRemoved = { bg = "#4a1518", fg = colors.red },
          DiffviewNormal = { bg = bg },
          DiffviewCursorLine = { bg = "#1c1a28" },
          DiffviewFilePanelTitle = { fg = colors.blue, bold = true },
          DiffviewFilePanelCounter = { fg = colors.mauve },
          DiffviewFilePanelFileName = { fg = colors.text },
          DiffviewStatusAdded = { fg = colors.green },
          DiffviewStatusModified = { fg = colors.yellow },
          DiffviewStatusDeleted = { fg = colors.red },
          DiffviewStatusRenamed = { fg = colors.blue },
        }
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
