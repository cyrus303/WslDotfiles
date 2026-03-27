return {
  "seblyng/roslyn.nvim",
  ft = { "cs", "razor" },
  -- `init` runs at startup, before plugin/roslyn.lua calls vim.lsp.enable("roslyn").
  -- This ensures broad_search=true is active when the first buffer's root_dir is evaluated,
  -- preventing a second instance from being spawned at the project dir.
  init = function()
    require("roslyn.config").setup({
      filewatching = "off",
      broad_search = true,
      choose_target = function(targets)
        local slns = vim.tbl_filter(function(t)
          return t:match("%.sln$") or t:match("%.slnx$") or t:match("%.slnf$")
        end, targets)
        local pool = #slns > 0 and slns or targets
        table.sort(pool, function(a, b) return #a < #b end)
        return pool[1]
      end,
    })
  end,
  opts = {
    filewatching = "off",
    broad_search = true,
    choose_target = function(targets)
      local slns = vim.tbl_filter(function(t)
        return t:match("%.sln$") or t:match("%.slnx$") or t:match("%.slnf$")
      end, targets)
      local pool = #slns > 0 and slns or targets
      table.sort(pool, function(a, b) return #a < #b end)
      return pool[1]
    end,
  },
  config = function(_, opts)
    require("roslyn").setup(opts)
  end,
}
