-- Directory names to hide from file/grep/recent pickers (matched anywhere in the path).
local excluded_dirs = { "Migrations" }

-- Bare names work for both `fd -E` and `rg --glob !`.
local exclude_globs = excluded_dirs

local function is_excluded(path)
  if not path then
    return false
  end
  for _, d in ipairs(excluded_dirs) do
    if path:find("/" .. d .. "/", 1, true) then
      return true
    end
  end
  return false
end

local is_git_item = function(item, git_nodes)
  return vim.iter(git_nodes):any(function(node)
    if node.dir_status then
      return vim.fs.relpath(node.path, item.file) ~= nil
    end
    return vim.fs.relpath(item.file, node.path) ~= nil
  end)
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>E",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status (sidebar)",
    },
    {
      "<leader>gb",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "File Log (picker)",
    },
    {
      "<leader><leader>",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>sl",
      function()
        Snacks.picker.lines()
      end,
      desc = "Search Buffer Lines",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep({ live = false, need_search = false })
      end,
      desc = "Fuzzy Grep",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>sf",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    -- Reopens the last picker with its query and selection intact, which is the
    -- difference between losing a long grep to a stray <Esc> and carrying on.
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume last picker",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep({ live = true })
      end,
      desc = "Live Grep (ripgrep)",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer",
    },
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Scratch Buffer",
    },
    {
      "<leader>ss",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    -- Renames the file on disk and moves the buffer with it, sending
    -- workspace/willRenameFiles first so the LSP can fix anything that depends on
    -- the path. Roslyn does advertise that method, but note what it does NOT do:
    -- tested on a throwaway class, the file was renamed and the class name was
    -- left alone. C# does not couple the two, so Roslyn returns no edit for it.
    -- To rename the type as well, use <leader>cr (rename symbol) on the class
    -- name afterwards -- this map is purely the file half.
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename file (LSP-aware)",
    },
  },
  opts = {
    lazygit = {
      enabled = true,
      config = {
        gui = {
          theme = {
            activeBorderColor = { "#f07098", "bold" },
            inactiveBorderColor = { "#5e5e7a" },
          },
        },
      },
    },
    bigfile = { enabled = true },
    indent = {
      enabled = true,
      char = "│",
      hl = "SnacksIndent",
    },
    input = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    -- quickfile calls vim.treesitter.start itself before plugins load, which
    -- bypasses the cs exclusion in the treesitter FileType handler. Excluding
    -- c_sharp keeps C# unstyled until Roslyn attaches -- that's the signal
    -- that the LSP is up. "latex" is quickfile's own default; keep it.
    quickfile = { enabled = true, exclude = { "latex", "c_sharp" } },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = false },
    animate = { enabled = false },

    dashboard = {
      enabled = true,
      formats = {
        file = function(item, ctx)
          local filename = vim.fn.fnamemodify(item.file, ":t")
          local parent = vim.fn.fnamemodify(item.file, ":h:t")
          local max = 50 -- snacks pane is 60 wide; ~10 taken by indent + icon + number
          if parent ~= "" then
            local full = parent .. "/" .. filename
            if #full > max then
              local budget = max - #filename - 2 -- 2 for "…/"
              parent = budget > 0 and ("…" .. parent:sub(-budget)) or "…"
            end
            return { { parent .. "/", hl = "dir" }, { filename, hl = "file" } }
          end
          return { { filename, hl = "file" } }
        end,
      },
      preset = {
        keys = {
          { icon = "󰈞", key = "f", desc = "Find file", action = "<leader><leader>" },
          -- <leader>/ is the actual live grep; <leader>sg is fuzzy grep
          -- (live = false), which this button used to fire despite its label.
          { icon = "󰊄", key = "g", desc = "Live grep", action = "<leader>/" },
          {
            icon = "󰁯",
            key = "s",
            desc = "Restore Session",
            action = function()
              require("persistence").load()
            end,
          },
          { icon = "󰒲", key = "l", desc = "Plugins", action = "<cmd>Lazy<CR>" },
          { icon = "󰅚", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
        },
      },
      sections = {
        -- pane 1
        function()
          local header_width = 62
          local indent = math.max(0, math.floor((vim.o.columns - header_width) / 2))
          return { section = "header", indent = indent, padding = { 2, 0, 2, 0 } }
        end,
        { section = "keys", gap = 1, padding = 1 },
        {
          text = { { "󰈞  Recent Files", hl = "SnacksDashboardTitle" } },
          padding = { 1, 0, 1, 0 },
        },
        {
          section = "recent_files",
          cwd = true,
          limit = 5,
          indent = 2,
          padding = { 0, 0, 1, 0 },
        },

        -- pane 2
        { pane = 2, text = "", padding = 6 },
        {
          pane = 2,
          text = { { "󰊢  Recent Commits", hl = "SnacksDashboardTitle" } },
          padding = { 1, 0, 1, 0 },
        },
        {
          pane = 2,
          section = "terminal",
          enabled = function()
            return require("snacks.git").get_root() ~= nil
          end,
          cmd = "git --no-pager log --color=always -15 --format='%C(yellow)%h%C(reset) %<(35,trunc)%s %C(240)%<(12,trunc)%cr'",
          height = 17,
          padding = 1,
          ttl = 5 * 60,
          indent = 2,
        },
      },
    },

    picker = {
      win = {
        input = {
          keys = {
            ["<C-l>"] = { "confirm", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<C-l>"] = "confirm",
          },
        },
      },
      sources = {
        files = {
          hidden = true,
          exclude = exclude_globs,
          transform = function(item)
            if is_excluded(item.file) then
              return false
            end
          end,
        },
        grep = {
          live = false,
          need_search = false,
          exclude = exclude_globs,
          transform = function(item)
            if is_excluded(item.file) then
              return false
            end
          end,
        },
        recent = {
          transform = function(item)
            if is_excluded(item.file) then
              return false
            end
          end,
        },
        git_status = { layout = { preset = "default" } },
        buffers = {
          formatters = { file = { filename_only = true } },
          -- The built-in sort compares only `info.lastused`, a whole-second timestamp, so
          -- buffers entered in the same second tie and Lua's unstable table.sort reshuffles
          -- them on every refresh — including the one bufdelete triggers. Sorting with bufnr
          -- as a tiebreaker makes the order total, so the list holds still while deleting.
          sort_lastused = false,
          finder = function(opts, ctx)
            local items = require("snacks.picker.source.buffers").buffers(opts, ctx)
            table.sort(items, function(a, b)
              if a.info.lastused ~= b.info.lastused then
                return a.info.lastused > b.info.lastused
              end
              return a.buf < b.buf
            end)
            return items
          end,
          transform = function(item)
            item.pos = nil
          end,
          win = {
            input = {
              keys = {
                ["<C-h>"] = { "bufdelete", mode = { "i", "n" } },
              },
            },
            list = {
              keys = {
                ["<C-h>"] = "bufdelete",
              },
            },
          },
        },
        explorer = {
          hidden = true,
          ignored = true,
          actions = {
            explorer_del = function(picker)
              local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected({ fallback = true }))
              if #paths == 0 then
                return
              end
              local what = #paths == 1 and vim.fn.fnamemodify(paths[1], ":t") or #paths .. " files"
              local ea = require("snacks.explorer.actions")
              Snacks.picker.util.confirm("Delete " .. what .. "?", function()
                for _, path in ipairs(paths) do
                  local ok, err = ea.trash(path)
                  if ok then
                    Snacks.bufdelete({ file = path, force = true })
                  else
                    Snacks.notify.error("Failed to delete `" .. path .. "`:\n" .. err)
                  end
                  require("snacks.explorer.tree"):refresh(vim.fs.dirname(path))
                end
                picker.list:set_selected()
                ea.update(picker)
              end)
            end,
            explorer_right = function(picker, item)
              if item and item.dir then
                vim.cmd("wincmd l")
              else
                picker:action("confirm")
              end
            end,
          },
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
          toggles = { only_git = "S" },
          win = {
            list = {
              keys = {
                ["<CR>"] = { "edit", mode = "n" },
                ["<C-l>"] = { "explorer_right", mode = "n" },
                ["s"] = { "edit_split", mode = "n" },
                ["v"] = { "edit_vsplit", mode = "n" },
                ["S"] = "toggle_only_git",
                ["W"] = function(self)
                  local win_id = self.win
                  if not win_id or not vim.api.nvim_win_is_valid(win_id) then
                    return
                  end
                  if self._fit_width then
                    vim.api.nvim_win_set_width(win_id, self._fit_width)
                    self._fit_width = nil
                  else
                    local buf = vim.api.nvim_win_get_buf(win_id)
                    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                    local max_w = 0
                    for _, line in ipairs(lines) do
                      max_w = math.max(max_w, vim.fn.strdisplaywidth(line))
                    end
                    self._fit_width = vim.api.nvim_win_get_width(win_id)
                    vim.api.nvim_win_set_width(win_id, max_w + 2)
                  end
                end,
              },
            },
          },
        },
      },
    },

    explorer = {},
  },
}
