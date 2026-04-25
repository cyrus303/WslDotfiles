return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    -- Render-time check so lualine doesn't force-load easy-dotnet at statusline init.
    -- Once easy-dotnet loads (on :Dotnet or a .cs buffer), this starts returning its output.
    local function job_indicator_fn()
      if not package.loaded["easy-dotnet.ui-modules.jobs"] then
        return ""
      end
      local ok, ui = pcall(require, "easy-dotnet.ui-modules.jobs")
      if not ok or type(ui.lualine) ~= "function" then
        return ""
      end
      local v = ui.lualine()
      return type(v) == "string" and v or ""
    end

    local function project_root()
      local ok, root = pcall(function() return require("snacks.git").get_root() end)
      if ok and root then
        return " " .. vim.fn.fnamemodify(root, ":t")
      end
      return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end

    -- Custom carbonfox-derived theme — commented out while catppuccin is the default;
    -- lualine uses theme = "auto" below so it picks up the active colorscheme.
    -- _b/_y sections lifted to give powerline arrows contrast and carry a neutral-bold secondary
    -- local bg_dim    = "#0c0c0c"             -- _c / _x — darkest, matches StatusLine
    -- local bg_mid    = "#262626"             -- _b / _y — lifted so arrows render against it
    -- local fg_dim    = "#bcb8b1"             -- carbonfox fg2 for breadcrumbs
    -- local secondary = "#e0e0e0"             -- bold neutral white — folder + branch live on brightness, not hue
    -- local accent    = "#1d995c"             -- dimmed green (palette.green.base) — calm NORMAL-mode anchor
    -- local theme = {
    --   normal = {
    --     a = { bg = accent,    fg = bg_dim, gui = "bold" },
    --     b = { bg = bg_mid,    fg = secondary, gui = "bold" },
    --     c = { bg = bg_dim,    fg = fg_dim },
    --   },
    --   insert   = { a = { bg = "#2890c8", fg = bg_dim, gui = "bold" } },
    --   visual   = { a = { bg = "#9877CC", fg = bg_dim, gui = "bold" } }, -- dimmed magenta
    --   command  = { a = { bg = "#069795", fg = bg_dim, gui = "bold" } }, -- dimmed deep teal
    --   replace  = { a = { bg = "#BE4278", fg = bg_dim, gui = "bold" } }, -- dimmed red-pink
    --   terminal = { a = { bg = "#31AFAE", fg = bg_dim, gui = "bold" } }, -- dimmed light teal
    --   inactive = {
    --     a = { bg = bg_dim, fg = "#5a5a5a" },
    --     b = { bg = bg_dim, fg = "#5a5a5a" },
    --     c = { bg = bg_dim, fg = "#5a5a5a" },
    --   },
    -- }

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "\u{E0B1}", right = "\u{E0B3}" },
        section_separators = { left = "\u{E0B0}", right = "\u{E0B2}" },
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          project_root,
        },
        lualine_c = {
          {
            "buffers",
            show_filename_only = true,
            show_modified_status = true,
            mode = 0,
            symbols = { modified = " ●", alternate_file = "", directory = "" },
            filetype_names = { snacks_dashboard = false },
            buffers_color = {
              -- active = { fg = "#e8c5a0", gui = "bold" }, -- carbonfox warm cream
              active = { fg = "#fab387", gui = "bold" }, -- catppuccin mocha peach
            },
          },
        },
        lualine_x = {
          job_indicator_fn,
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          {
            "diagnostics",
            sections = { "error", "warn" },
            symbols = {
              error = "\u{F057} ",
              warn  = "\u{F071} ",
            },
          },
        },
        lualine_y = {
          {
            "diff",
            source = function()
              local gs = vim.b.gitsigns_status_dict
              if not gs then return nil end
              return { added = gs.added, modified = gs.changed, removed = gs.removed }
            end,
            symbols = {
              added    = "\u{F067} ",
              modified = "\u{F040} ",
              removed  = "\u{F068} ",
            },
          },
          "branch",
        },
        lualine_z = {
          function() return " " .. os.date("%H:%M") end,
        },
      },
      extensions = { "lazy", "trouble", "mason", "quickfix" },
    }
  end,
}
