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
        lualine_b = { project_root, "branch" },
        lualine_c = {
          {
            "filename",
            path = 0,
            newfile_status = false,
          },
        },
        lualine_x = {
          job_indicator_fn,
          {
            "diagnostics",
            symbols = {
              error = "\u{F057} ",
              warn  = "\u{F071} ",
              info  = "\u{F05A} ",
              hint  = "\u{F0EB} ",
            },
          },
        },
        lualine_y = {
          {
            "diff",
            symbols = {
              added    = "\u{F067} ",
              modified = "\u{F040} ",
              removed  = "\u{F068} ",
            },
          },
          "progress",
          "location",
        },
        lualine_z = {
          function() return " " .. os.date("%H:%M") end,
        },
      },
      extensions = { "lazy", "trouble", "mason", "quickfix" },
    }
  end,
}
