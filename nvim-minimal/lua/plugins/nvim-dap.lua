return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "DAP Terminate" },
      { "<leader>dX", function() require("dap").clear_breakpoints() end, desc = "DAP Clear Breakpoints" },
      { "<leader>dr", function() require("dap").restart() end, desc = "DAP Restart" },
      { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "DAP Continue to Cursor" },
      { "<leader>dw", function() require("dap-view").add_expr() end, desc = "DAP Add Watch Expression" },
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
    },
    config = function(_, opts)
      local dapview = require("dap-view")
      dapview.setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-view",
        callback = function(args)
          vim.keymap.set("n", "<C-l>", "<CR>", { buffer = args.buf, remap = true, desc = "DAP View Expand" })
          -- Defer so our overrides land after the plugin's own set_keymaps() call
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(args.buf) then return end
            -- Add missing descriptions
            vim.keymap.set("n", "[v", function() dapview.navigate({ count = -vim.v.count1, wrap = true }) end, { buffer = args.buf, desc = "DAP View Prev Tab" })
            vim.keymap.set("n", "]v", function() dapview.navigate({ count = vim.v.count1, wrap = true }) end, { buffer = args.buf, desc = "DAP View Next Tab" })
            -- Delete broken/undescribed keymaps ([V/]V use vim._maxint which no longer exists)
            pcall(vim.keymap.del, "n", "[[", { buffer = args.buf })
            pcall(vim.keymap.del, "n", "[V", { buffer = args.buf })
            pcall(vim.keymap.del, "n", "]V", { buffer = args.buf })
          end)
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "dap-view-term", "dap-repl" },
        callback = function()
          vim.wo.wrap = true
        end,
      })
    end,
  },
}
