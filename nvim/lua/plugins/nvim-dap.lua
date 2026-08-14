-- Shared by <leader>dx and the terminal-mode <C-c> below.
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
					-- so intercept here: while stopped, terminate through DAP; while
					-- running, forward a literal 0x03 so the normal graceful shutdown
					-- ("Press Ctrl+C to shut down") still works as before.
					vim.keymap.set("t", "<C-c>", function()
						local session = require("dap").session()
						if session and session.stopped_thread_id then
							vim.schedule(stop_session)
						else
							local chan = vim.bo[args.buf].channel
							if chan and chan > 0 then
								vim.api.nvim_chan_send(chan, "\3")
							end
						end
					end, { buffer = args.buf, desc = "Stop debug session / send SIGINT" })
				end,
			})
		end,
	},
}
