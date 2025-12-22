return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local job_indicator = { require("easy-dotnet.ui-modules.jobs").lualine }

      opts.sections = opts.sections or {}

      -- center: just filename (no path)
      opts.sections.lualine_c = {
        {
          "filename",
          path = 0,
          newfile_status = false,
        },
      }

      -- left: keep mode as-is
      opts.sections.lualine_a = opts.sections.lualine_a or { "mode" }

      -- right: append easy-dotnet job indicator
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, job_indicator)
    end,
  },
}
