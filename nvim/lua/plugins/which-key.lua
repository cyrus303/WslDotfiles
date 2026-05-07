return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		spec = {
			{ "<leader>c", group = "code" },
			{ "<leader>cf", desc = "Toggle autoformat", icon = function()
				if vim.g.disable_autoformat then
					return { icon = "\u{F204}", color = "grey" }
				end
				return { icon = "\u{F205}", color = "yellow" }
			end },
			{ "<leader>ci", desc = "Toggle inlay hints", icon = function()
				if vim.lsp.inlay_hint.is_enabled() then
					return { icon = "\u{F205}", color = "yellow" }
				end
				return { icon = "\u{F204}", color = "grey" }
			end },
			{ "<leader>cw", desc = "Toggle wrap", icon = function()
				if vim.wo.wrap then
					return { icon = "\u{F205}", color = "yellow" }
				end
				return { icon = "\u{F204}", color = "grey" }
			end },
			{ "<leader>cl", desc = "Toggle codelens", icon = function()
				if vim.g.codelens_enabled then
					return { icon = "\u{F205}", color = "yellow" }
				end
				return { icon = "\u{F204}", color = "grey" }
			end },
			{ "<leader>d", group = "dotnet/debug" },
			{ "<leader>df", desc = "Toggle AzFunc Debug", icon = function()
				local ok, terminal = pcall(require, "azfunc.terminal")
				if ok and terminal.get_state().channel then
					return { icon = "\u{F205}", color = "yellow" }
				end
				return { icon = "\u{F204}", color = "grey" }
			end },
			{ "<leader>dp", group = "packages" },
			{ "<leader>lr", desc = "Line references (codelens)" },
			{ "<leader>f", group = "find" },
			{ "<leader>s", group = "search" },
			{ "<leader>g", group = "git" },
			{ "<leader>gg", desc = "Lazygit" },
			{ "<leader>q", group = "quit" },
			{ "<leader>x", group = "diagnostics/symbols" },
			{ "<leader>E", desc = "Git Status" },
			{ "<leader>e", desc = "Explorer" },
			{ "<leader>H", desc = "Harpoon Add File" },
			{ "<leader>h", desc = "Harpoon Picker" },
			{ "s", desc = "Flash jump" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Harpoon numeric shortcuts: registered but hidden to keep UI tidy.
		wk.add({
			{ "<leader>1", "<cmd>lua require('harpoon'):list():select(1)<cr>", hidden = true },
			{ "<leader>2", "<cmd>lua require('harpoon'):list():select(2)<cr>", hidden = true },
			{ "<leader>3", "<cmd>lua require('harpoon'):list():select(3)<cr>", hidden = true },
			{ "<leader>4", "<cmd>lua require('harpoon'):list():select(4)<cr>", hidden = true },
			{ "<leader>5", "<cmd>lua require('harpoon'):list():select(5)<cr>", hidden = true },
			{ "<leader>6", "<cmd>lua require('harpoon'):list():select(6)<cr>", hidden = true },
			{ "<leader>7", "<cmd>lua require('harpoon'):list():select(7)<cr>", hidden = true },
			{ "<leader>8", "<cmd>lua require('harpoon'):list():select(8)<cr>", hidden = true },
			{ "<leader>9", "<cmd>lua require('harpoon'):list():select(9)<cr>", hidden = true },
			{ "ge", hidden = true },
			{ "gE", hidden = true },
			{ "gn", hidden = true },
			{ "gN", hidden = true },
			{ "gt", hidden = true },
			{ "gT", hidden = true },
			{ "gu", hidden = true },
			{ "gU", hidden = true },
			{ "gv", hidden = true },
			{ "gx", hidden = true },
			{ "g,", hidden = true },
			{ "g;", hidden = true },
			{ "g%", hidden = true },
			{ "gb", hidden = true },
			{ "gc", hidden = true },
			{ "g'", hidden = true },
			{ "g`", hidden = true },
			{ "gcc", hidden = true },
			{ "[D", hidden = true },
			{ "]D", hidden = true },
		})
	end,
}
