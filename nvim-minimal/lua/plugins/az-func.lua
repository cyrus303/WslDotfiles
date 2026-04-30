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
		vim.keymap.set("n", "<leader>df", function()
			local azfunc = require("azfunc")
			local state = require("azfunc.terminal").get_state()
			if state.channel then
				azfunc.stop()
			else
				azfunc.start()
			end
		end, { desc = "Toggle AzFunc Debug" })
	end,
}
