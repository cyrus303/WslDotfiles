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
				local term_au
				term_au = vim.api.nvim_create_autocmd("TermOpen", {
					callback = function(ev)
						vim.api.nvim_del_autocmd(term_au)
						local term_buf = ev.buf
						vim.schedule(function()
							-- Hide the auto-opened split; keep the buffer alive
							local win = get_azfunc_win(term_buf)
							if win then
								vim.api.nvim_win_close(win, false)
							end
						end)

						-- Inject our terminal as session.term_buf before dap-view's
						-- configurationDone listener runs so setup_term_buf() picks it up.
						-- Then schedule open_term_buf_win() after all configurationDone
						-- listeners finish — at that point state.term_winnr is still nil
						-- (attach sessions skip it), so we create the window ourselves.
						require("dap").listeners.before.configurationDone["azfunc_term"] = function(session)
							require("dap").listeners.before.configurationDone["azfunc_term"] = nil
							if not session.term_buf and vim.api.nvim_buf_is_valid(term_buf) then
								session.term_buf = term_buf
								vim.schedule(function()
									require("dap-view.console.view").open_term_buf_win()
								end)
							end
						end
					end,
				})
				azfunc.start()
			end
		end, { desc = "Toggle AzFunc Debug" })

	end,
}
