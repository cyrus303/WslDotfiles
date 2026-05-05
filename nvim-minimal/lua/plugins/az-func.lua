return {
	"fschaal/azfunc.nvim",
	dependencies = { "mfussenegger/nvim-dap" },
	keys = {
		{ "<leader>df", desc = "Toggle AzFunc Debug" },
	},
	config = function()
		require("azfunc").setup({
			mappings = {},
			debug = {
				adapter_type = "coreclr",
				attach_retry_count = 20,
				retry_interval = 2000,
				attach_timeout = 1000,
			},
			terminal = {
				split = "split",
			},
		})
		local function get_azfunc_buf()
			local state = require("azfunc.terminal").get_state()
			if not state.channel then
				return nil
			end
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
					if vim.api.nvim_buf_get_var(buf, "terminal_job_id") == state.channel then
						return buf
					end
				end
			end
		end

		local function get_azfunc_win(buf)
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_get_buf(win) == buf then
					return win
				end
			end
		end

		vim.keymap.set("n", "<leader>df", function()
			local azfunc = require("azfunc")
			local state = require("azfunc.terminal").get_state()
			if state.channel then
				azfunc.stop()
			else
				local hide_au
				hide_au = vim.api.nvim_create_autocmd("TermOpen", {
					callback = function(ev)
						vim.api.nvim_del_autocmd(hide_au)
						vim.schedule(function()
							local win = get_azfunc_win(ev.buf)
							if win then
								vim.api.nvim_win_close(win, false)
							end
						end)
					end,
				})
				azfunc.start()
			end
		end, { desc = "Toggle AzFunc Debug" })

		vim.keymap.set("n", "<leader>dt", function()
			local buf = get_azfunc_buf()
			if not buf then
				return
			end
			local win = get_azfunc_win(buf)
			if win then
				vim.api.nvim_win_close(win, false)
			else
				vim.cmd("botright split")
				vim.api.nvim_win_set_buf(0, buf)
			end
		end, { desc = "Toggle AzFunc Terminal" })
	end,
}
