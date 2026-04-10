local is_git_item = function(item, git_nodes)
  return vim.iter(git_nodes):any(function(node)
    if node.dir_status then
      return vim.fs.relpath(node.path, item.file) ~= nil
    end
    return vim.fs.relpath(item.file, node.path) ~= nil
  end)
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>E",
        function() Snacks.picker.git_status() end,
        desc = "Git Status (sidebar)",
      },
    },
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = vim.tbl_deep_extend("force", opts.picker.sources.explorer or {}, {
        hidden = true,
        ignored = true,
        finder = function(o, ctx)
          local Tree = require("snacks.explorer.tree")
          local git_nodes = {}
          Tree:walk(Tree:find(ctx.picker:cwd()), function(node)
            if node.status then
              table.insert(git_nodes, node)
            end
          end)
          ctx.picker.git_nodes = git_nodes
          return require("snacks.picker.source.explorer").explorer(o, ctx)
        end,
        transform = function(item, ctx)
          if ctx.picker.opts.only_git then
            return is_git_item(item, ctx.picker.git_nodes)
          end
        end,
        only_git = false,
        toggles = {
          only_git = "S",
        },
        win = {
          list = {
            keys = {
              ["<CR>"] = { "edit", mode = "n" },
              ["s"] = { "edit_split", mode = "n" },
              ["v"] = { "edit_vsplit", mode = "n" },
              ["S"] = "toggle_only_git",
            },
          },
        },
      })

      opts.explorer = opts.explorer or {}
    end,
  },
}
