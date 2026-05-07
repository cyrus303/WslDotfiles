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
    -- Roslyn returns -30099 when a diagnostic request arrives before it has
    -- finished initialising the document's language. Swallow it silently.
    local orig = vim.lsp.handlers["textDocument/diagnostic"]
    vim.lsp.handlers["textDocument/diagnostic"] = function(err, result, ctx, config)
      if err and err.code == -30099 then
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client and client.name == "roslyn" then return end
      end
      return orig(err, result, ctx, config)
    end
  end,
}
