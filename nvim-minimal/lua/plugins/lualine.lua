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

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filename",
            path = 0,
            newfile_status = false,
          },
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = "󰝶 " },
          },
        },
        lualine_x = {
          job_indicator_fn,
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy", "trouble", "mason", "quickfix" },
    }
  end,
}
