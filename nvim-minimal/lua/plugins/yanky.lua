return {
	"gbprod/yanky.nvim",
	event = "BufReadPost",
	opts = {
		system_clipboard = {
			sync_with_ring = not vim.env.SSH_CONNECTION,
		},
		-- Let yanky handle the yank highlight instead of vim.highlight.on_yank()
		highlight = { timer = 100 },
	},
	keys = {
		{
			"<leader>y",
			function()
				Snacks.picker.yanky()
			end,
			mode = { "n", "x" },
			desc = "Yank History",
		},
		{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" },
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
		{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after selection" },
		{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before selection" },
		{ "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward in yank history" },
		{ "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward in yank history" },
		{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after (linewise)" },
		{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before (linewise)" },
		{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
		{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
		{ "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after filter" },
		{ "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before filter" },
	},
}
