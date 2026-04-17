local roslyn_opts = {
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
}

return {
  "seblyng/roslyn.nvim",
  ft = { "cs" },
  -- init runs at startup so broad_search is active when the first buffer's
  -- root_dir is evaluated, preventing a second instance at the project dir.
  init = function()
    require("roslyn.config").setup(roslyn_opts)
  end,
  opts = roslyn_opts,
  config = function(_, opts)
    require("roslyn").setup(opts)
  end,
}
