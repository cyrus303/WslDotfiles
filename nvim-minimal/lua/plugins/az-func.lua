return {
	"fschaal/azfunc.nvim",
	dependencies = { "mfussenegger/nvim-dap" },
	keys = {
		{ "<leader>fa", desc = "AzFunc Start Debug" },
		{ "<leader>fA", desc = "AzFunc Stop Debug" },
	},
	config = function()
		require("azfunc").setup({
			mappings = {
				start = "<leader>fa",
				stop = "<leader>fA",
			},
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
	end,
}
