return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		},
		config = function()
			require("nvim-treesitter").install({
				"bash",
				"c_sharp",
				"diff",
				"json",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			})

			-- Enable treesitter highlighting for all filetypes.
			-- Skip cs: Roslyn LSP handles C# highlighting via semantic tokens.
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					if ev.match ~= "cs" then
						pcall(vim.treesitter.start)
					end
				end,
			})

			-- Treesitter-based indentation (experimental but functional for most langs)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			-- Textobjects
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
			})

			local sel = require("nvim-treesitter-textobjects.select").select_textobject
			local maps = {
				af = "@function.outer",
				["if"] = "@function.inner",
				ac = "@class.outer",
				ic = "@class.inner",
				aa = "@parameter.outer",
				ia = "@parameter.inner",
				al = "@loop.outer",
				il = "@loop.inner",
				aC = "@call.outer",
				iC = "@call.inner",
			}
			for key, obj in pairs(maps) do
				vim.keymap.set({ "x", "o" }, key, function()
					sel(obj, "textobjects")
				end, { desc = "Textobj " .. obj })
			end
		end,
	},
}
