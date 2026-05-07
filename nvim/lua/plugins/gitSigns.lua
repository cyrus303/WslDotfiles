return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▎" },
			topdelete = { text = "▎" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged_enable = false,
		attach_to_untracked = false,
		current_line_blame = false,
		word_diff = false,
		numhl = false,
		linehl = false,
		culhl = false,
		signcolumn = true,
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns
			vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
			vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Prev hunk" })
		end,
	},
}
