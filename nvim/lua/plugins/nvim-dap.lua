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
      map("n", "<leader>dc", function()
        dap.terminate()
        dap.clear_breakpoints()
      end, { desc = "DAP Stop and Clear Breakpoint" })
    end,
  },

  { "nvim-neotest/nvim-nio" },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
