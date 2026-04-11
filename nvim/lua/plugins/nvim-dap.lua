return {
  {
    "mfussenegger/nvim-dap",
    config = function()
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

      local map = vim.keymap.set
      map("n", "<F5>", function()
        dap.continue()
      end, { desc = "DAP Continue" })
      map("n", "<F10>", function()
        dap.step_over()
      end, { desc = "DAP Step Over" })
      map("n", "<F11>", function()
        dap.step_into()
      end, { desc = "DAP Step Into" })
      map("n", "<F12>", function()
        dap.step_out()
      end, { desc = "DAP Step Out" })
      map("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, { desc = "DAP Toggle Breakpoint" })
      map("n", "<leader>dx", function()
        dap.terminate()
      end, { desc = "DAP Terminate" })
      map("n", "<leader>dX", function()
        dap.clear_breakpoints()
      end, { desc = "DAP Clear Breakpoints" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, { desc = "DAP Conditional Breakpoint" })
      map("n", "<leader>dr", function()
        dap.restart()
      end, { desc = "DAP Restart" })
      map("n", "<leader>dR", function()
        dap.run_to_cursor()
      end, { desc = "DAP Run to Cursor" })
    end,
  },

  {
    "igorlfs/nvim-dap-view",
    version = "1.*",
    dependencies = { "mfussenegger/nvim-dap" },
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      auto_toggle = true,
      windows = {
        position = "right",
        size = 0.45,
        terminal = {
          position = "below",
          size = 0.45,
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
