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
              active = { fg = "#89b4fa", gui = "bold" },
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
