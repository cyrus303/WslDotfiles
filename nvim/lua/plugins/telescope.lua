return {
  "nvim-telescope/telescope.nvim",
  optional = true,
  -- Telescope is only here as nuget.nvim's dependency (nothing else requires it;
  -- snacks.picker is the picker everywhere else). nuget.nvim is lazy on its cmds
  -- and <leader>dp* keys, but this spec had no trigger of its own, so
  -- defaults.lazy = false in config/lazy.lua made telescope load at every
  -- startup to serve a plugin that had not loaded yet. lazy.nvim loads
  -- dependencies before their parent, so telescope now comes up with nuget.nvim
  -- instead -- opts still merge at that point, so the mappings below apply.
  lazy = true,
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-l>"] = actions.select_default,
          },
          n = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-l>"] = actions.select_default,
          },
        },
      },
    }
  end,
}
