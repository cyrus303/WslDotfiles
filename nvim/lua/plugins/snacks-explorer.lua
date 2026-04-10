return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>E",
        function()
          Snacks.picker.pick("explorer", {
            title = "Git Changes",
            finder = function(opts, ctx)
              local Tree = require("snacks.explorer.tree")
              local nodes = {}
              Tree:walk(Tree:find(ctx.filter.cwd), function(node)
                if node.status then
                  table.insert(nodes, node)
                end
              end)
              ctx.picker.git_nodes = nodes
              return require("snacks.picker.source.explorer").explorer(opts, ctx)
            end,
            transform = function(item, ctx)
              return vim.iter(ctx.picker.git_nodes):any(function(node)
                if node.dir_status then
                  return vim.fs.relpath(node.path, item.file) ~= nil
                end
                return vim.fs.relpath(item.file, node.path) ~= nil
              end)
            end,
            layout = { preset = "sidebar" },
          })
        end,
        desc = "Explorer (git changes)",
      },
    },
    opts = function(_, opts)
      -- Configure explorer picker source to show hidden files by default
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = vim.tbl_deep_extend("force", opts.picker.sources.explorer or {}, {
        hidden = true,
        ignored = true,
      })

      -- your window / key mappings (keep these)
      opts.explorer = opts.explorer or {}
      opts.explorer.win = opts.explorer.win or {}
      opts.explorer.win.list = opts.explorer.win.list or {}
      opts.explorer.win.list.keys = vim.tbl_deep_extend("force", opts.explorer.win.list.keys or {}, {
        ["<CR>"] = { "edit", mode = "n" },
        ["s"] = { "edit_split", mode = "n" },
        ["v"] = { "edit_vsplit", mode = "n" },
      })
    end,
  },
}
