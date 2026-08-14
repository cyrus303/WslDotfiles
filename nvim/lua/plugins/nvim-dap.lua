-- Graceful stop, used by <C-c> inside the dap terminal.
--
-- Only SIGINT delivered to a *running* process actually shuts the app down
-- properly and releases the listening socket -- that's the path that worked
-- before any breakpoint was hit. jobstop() cannot do it: while threads are
-- suspended the SIGTERM goes unhandled and nvim escalates to SIGKILL, so the
-- port is left behind. So if the session is stopped, resume it first and signal
-- once it's running again. Bounded retries in case the breakpoint is re-hit on
-- the way out; falls back to a DAP terminate request if it can't get clear.
local function graceful_stop(buf)
  local dap = require("dap")
  local timer = assert(vim.uv.new_timer())
  local resumes = 0

  local function finish()
    timer:stop()
    if not timer:is_closing() then
      timer:close()
    end
  end

  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      local session = dap.session()
      if not session then
        finish()
        return
      end

      if session.stopped_thread_id then
        resumes = resumes + 1
        if resumes > 5 then
          finish()
          dap.terminate()
          return
        end
        dap.continue()
        return
      end

      -- Running again: one SIGINT is all the host needs. Repeating it would
      -- read as a second Ctrl-C and force an ungraceful exit.
      finish()
      local chan = vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].channel
      if chan and chan > 0 then
        vim.api.nvim_chan_send(chan, "\3")
      end
    end)
  )
end

-- Hard stop, bound to <leader>dx: kills the job outright. Keep this for when the
-- app is wedged and you want it gone now, and use <C-c> in the terminal for the
-- graceful shutdown that clears the port.
local function stop_session()
  local terminal_ok, terminal = pcall(require, "azfunc.terminal")
  if terminal_ok and terminal.get_state().channel then
    require("azfunc").stop()
    return
  end
  local dap = require("dap")
  local session = dap.session()
  if session then
    if session.term_buf and vim.api.nvim_buf_is_valid(session.term_buf) then
      local job_id = vim.bo[session.term_buf].channel
      if job_id and job_id > 0 then
        vim.fn.jobstop(job_id)
      end
    end
    dap.terminate()
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { { "theHamsta/nvim-dap-virtual-text", opts = {} } },
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "DAP Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "DAP Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "DAP Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "DAP Step Out",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP Toggle Breakpoint",
      },
      {
        "<leader>dx",
        stop_session,
        desc = "Stop debug session",
      },
      {
        "<leader>dX",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "DAP Clear Breakpoints",
      },
      {
        "<leader>dr",
        function()
          require("dap").restart()
        end,
        desc = "DAP Restart",
      },
      {
        "<leader>dc",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "DAP Continue to Cursor",
      },
      {
        "<leader>dw",
        function()
          require("dap-view").add_expr()
        end,
        desc = "DAP Add Watch Expression",
      },
    },
    config = function()
      -- Pre-load dap-view so its auto_toggle listeners register before dap.continue() fires
      require("dap-view")

      local dap = require("dap")

      -- netcoredbg adapter; easy-dotnet will create the configs
      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      -- let easy-dotnet supply dap.configurations.cs
      dap.configurations.cs = dap.configurations.cs or {}

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "DapBreakpointRejected" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e3a2e" })
      vim.api.nvim_set_hl(0, "NvimDapVirtualText", { fg = "#c8909a", bg = "#2a1020", italic = true })
      vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { fg = "#f07098", bg = "#2a1020", italic = true })
      vim.api.nvim_set_hl(0, "NvimDapVirtualTextError", { fg = "#ef8a90", bg = "#2a1020", italic = true })

      -- When a breakpoint is hit, DAP opens the source file in the focused window.
      -- If a terminal split is focused at that moment it gets clobbered.
      -- Switch to the first normal (non-terminal, non-dap) window beforehand.
      dap.listeners.before.event_stopped["focus_editor_win"] = function()
        local skip_ft = { terminal = true, ["dap-view"] = true, ["dap-repl"] = true, ["dap-view-term"] = true }
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bt = vim.bo[buf].buftype
          local ft = vim.bo[buf].filetype
          if bt ~= "terminal" and not skip_ft[ft] then
            vim.api.nvim_set_current_win(win)
            return
          end
        end
      end
    end,
  },

  {
    "igorlfs/nvim-dap-view",
    version = "1.*",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      auto_toggle = true,
      windows = {
        position = "right",
        size = 0.42,
        terminal = {
          position = "below",
          size = 0.35,
        },
      },
      winbar = {
        controls = {
          enabled = true,
          position = "right",
          buttons = { "play", "step_into", "step_over", "step_out", "terminate" },
        },
      },
      -- dap-view 1.2 made keymaps declarative, which replaces the old FileType +
      -- vim.schedule block that raced its internal set_keymaps(). Each list here
      -- fully replaces the plugin default (tbl_deep_extend overwrites arrays), so
      -- the defaults are restated alongside <C-l>, which mirrors <CR> to match the
      -- global expand binding. [v/]v/[[/[V/]V are left to the plugin: they now
      -- ship descriptions, and vim._maxint -- which the old comment claimed was
      -- gone -- still exists in 0.12, so [V/]V were never actually broken.
      keymaps = {
        scopes = { toggle = { "<CR>", "<2-LeftMouse>", "<C-l>" } },
        watches = { toggle = { "<CR>", "<2-LeftMouse>", "<C-l>" } },
        hover = { toggle = { "<CR>", "<2-LeftMouse>", "<C-l>" } },
        threads = { jump_to_frame = { "<CR>", "<2-LeftMouse>", "<C-l>" } },
        exceptions = { toggle_filter = { "<CR>", "<2-LeftMouse>", "<C-l>" } },
        sessions = { switch_session = { "<CR>", "<2-LeftMouse>", "<C-l>" } },
        breakpoints = { jump_to_breakpoint = { "<CR>", "<2-LeftMouse>", "<C-l>" } },
      },
    },
    config = function(_, opts)
      require("dap-view").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "dap-view-term", "dap-repl" },
        callback = function(args)
          vim.wo.wrap = true

          -- Ctrl-C from inside the dap terminal. Once a breakpoint is hit,
          -- netcoredbg puts the pty in raw mode (ISIG off), so no control
          -- character generates a signal any more -- ^C/^X/^Z just echo as
          -- text and the app can't be stopped from the terminal at all.
          -- nvim handles terminal-mode mappings before bytes reach the pty,
          -- so intercept here and route to the graceful shutdown either way:
          -- running gets a plain SIGINT, stopped gets resumed first.
          vim.keymap.set("t", "<C-c>", function()
            graceful_stop(args.buf)
          end, { buffer = args.buf, desc = "Graceful stop (SIGINT, resuming first if stopped)" })
        end,
      })
    end,
  },
}
