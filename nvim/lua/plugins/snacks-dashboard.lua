return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.dashboard = opts.dashboard or {}
    opts.dashboard.enabled = true

    opts.dashboard.preset = {
      header = opts.dashboard.preset and opts.dashboard.preset.header,
      keys = {
        { icon = "󰈞", key = "f", desc = "Find file", action = "<leader>ff" },
        { icon = "󰊄", key = "g", desc = "Live grep", action = "<leader>fg" },
        { icon = "", key = "l", desc = "Plugins", action = "<cmd>Lazy<CR>" },
        { icon = "󰅚", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
      },
    }

    opts.dashboard.sections = {
      -- header centered (Snacks will center it)
      {
        section = "header",
        position = "center",
        padding = 2,
      },

      -- keys list on the left
      { section = "keys", gap = 1, padding = 1 },

      -- recent files under keys
      {
        icon = " ",
        title = "Recent Files",
        section = "recent_files",
        padding = 1,
      },

      -- git status under recent files
      {
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function()
          return require("snacks.git").get_root() ~= nil
        end,
        cmd = "git status --short --branch --renames",
        height = 5,
        padding = 1,
        ttl = 5 * 60,
      },

      -- plugins load time centered at bottom
      function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        local text = string.format("⚡ Neovim loaded %d/%d plugins in %.2fms", stats.loaded, stats.count, ms)
        return { align = "center", text = text, padding = 1, pane = 2 }
      end,

      -- Git Graph on the right side (pane 2)
      function()
        local in_git = require("snacks.git").get_root() ~= nil
        local cmds = {
          {
            title = "Git Graph",
            icon = " ",
            cmd = [[echo -e "$(/usr/sbin/git-graph --style round --color always --wrap 50 0 8 -f 'oneline')" ]],
            indent = 2,
            height = 25,
          },
        }
        return vim.tbl_map(function(cmd)
          return vim.tbl_extend("force", {
            pane = 2,
            section = "terminal",
            enabled = function()
              return in_git and vim.o.columns > 130
            end,
            padding = 1,
          }, cmd)
        end, cmds)
      end,

      -- version centered below
      -- function()
      --   local v = vim.version()
      --   return {
      --     align = "center",
      --     text = "   v" .. v.major .. "." .. v.minor .. "." .. v.patch,
      --     padding = 1,
      --     pane = 2,
      --   }
      -- end,
    }

    return opts
  end,
}
