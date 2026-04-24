local is_git_item = function(item, git_nodes)
	return vim.iter(git_nodes):any(function(node)
		if node.dir_status then
			return vim.fs.relpath(node.path, item.file) ~= nil
		end
		return vim.fs.relpath(item.file, node.path) ~= nil
	end)
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>E",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status (sidebar)",
		},
		{
			"<leader>gb",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Blame Line",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "File Log (picker)",
		},
		{
			"<leader><leader>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lines()
			end,
			desc = "Search Buffer Lines",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep({ live = false, need_search = false })
			end,
			desc = "Fuzzy Grep",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep({ live = true })
			end,
			desc = "Live Grep (ripgrep)",
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Explorer",
		},
	},
	opts = {
		lazygit = { enabled = true },
		bigfile = { enabled = true },
		indent = {
			enabled = true,
			char = "│",
			hl = "SnacksIndent",
		},
		input = { enabled = true },
		notifier = { enabled = true, timeout = 3000 },
		quickfile = { enabled = true },
		scope = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		scroll = { enabled = false },
		animate = { enabled = false },

		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{ icon = "󰈞", key = "f", desc = "Find file", action = "<leader>sf" },
					{ icon = "󰊄", key = "g", desc = "Live grep", action = "<leader>sg" },
					{ icon = "󰁯", key = "s", desc = "Restore Session", action = function() require("persistence").load() end },
					{ icon = "󰒲", key = "l", desc = "Plugins", action = "<cmd>Lazy<CR>" },
					{ icon = "󰅚", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
				},
			},
			sections = {
				-- pane 1
				function()
					local header_width = 62
					local indent = math.max(0, math.floor((vim.o.columns - header_width) / 2))
					return { section = "header", indent = indent, padding = { 2, 0, 2, 0 } }
				end,
				{ section = "keys", gap = 1, padding = 1 },
				{
					text = { { "󰈞  Recent Files", hl = "SnacksDashboardTitle" } },
					padding = { 1, 0, 1, 0 },
				},
				{
					section = "recent_files",
					cwd = true,
					limit = 5,
					indent = 2,
					padding = { 0, 0, 1, 0 },
				},

				-- pane 2
				{ pane = 2, text = "", padding = 6 },
				{
					pane = 2,
					text = { { "󰊢  Recent Commits", hl = "SnacksDashboardTitle" } },
					padding = { 1, 0, 1, 0 },
				},
				{
					pane = 2,
					section = "terminal",
					enabled = function()
						return require("snacks.git").get_root() ~= nil
					end,
					cmd = "git --no-pager log --color=always -15 --format='%C(yellow)%h%C(reset) %<(35,trunc)%s %C(240)%<(12,trunc)%cr'",
					height = 17,
					padding = 1,
					ttl = 5 * 60,
					indent = 2,
				},
			},
		},

		picker = {
			win = {
				input = {
					keys = {
						["<C-l>"] = { "confirm", mode = { "i", "n" } },
					},
				},
			},
			sources = {
				files = { hidden = true },
				grep = { live = false, need_search = false },
				git_status = { layout = { preset = "default" } },
				buffers = {
					win = {
						input = {
							keys = {
								["<C-h>"] = { "bufdelete", mode = { "i", "n" } },
							},
						},
						list = {
							keys = {
								["<C-h>"] = "bufdelete",
							},
						},
					},
				},
				explorer = {
					hidden = true,
					ignored = true,
					finder = function(o, ctx)
						local Tree = require("snacks.explorer.tree")
						local git_nodes = {}
						Tree:walk(Tree:find(ctx.picker:cwd()), function(node)
							if node.status then
								table.insert(git_nodes, node)
							end
						end)
						ctx.picker.git_nodes = git_nodes
						return require("snacks.picker.source.explorer").explorer(o, ctx)
					end,
					transform = function(item, ctx)
						if ctx.picker.opts.only_git then
							return is_git_item(item, ctx.picker.git_nodes)
						end
					end,
					only_git = false,
					toggles = { only_git = "S" },
					win = {
						list = {
							keys = {
								["<CR>"] = { "edit", mode = "n" },
								["s"] = { "edit_split", mode = "n" },
								["v"] = { "edit_vsplit", mode = "n" },
								["S"] = "toggle_only_git",
								["W"] = function(self)
									local win_id = self.win
									if not win_id or not vim.api.nvim_win_is_valid(win_id) then return end
									if self._fit_width then
										vim.api.nvim_win_set_width(win_id, self._fit_width)
										self._fit_width = nil
									else
										local buf = vim.api.nvim_win_get_buf(win_id)
										local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
										local max_w = 0
										for _, line in ipairs(lines) do
											max_w = math.max(max_w, vim.fn.strdisplaywidth(line))
										end
										self._fit_width = vim.api.nvim_win_get_width(win_id)
										vim.api.nvim_win_set_width(win_id, max_w + 2)
									end
								end,
							},
						},
					},
				},
			},
		},

		explorer = {},
	},
}
