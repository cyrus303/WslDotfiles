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

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					if ev.match == "cs" then
						-- Parser only — Roslyn handles C# highlighting via semantic tokens.
						-- Needed so foldexpr() and textobjects have a live parse tree.
						pcall(vim.treesitter.get_parser, ev.buf)
					elseif ev.match == "jsonc" then
						-- jsonc.so lives in site/parser but nvim-treesitter main doesn't
						-- register the language; pass it explicitly so Neovim finds it.
						pcall(vim.treesitter.start, ev.buf, "jsonc")
					else
						pcall(vim.treesitter.start, ev.buf)
					end

					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

					-- foldexpr is evaluated before TS attaches; recompute once parser is ready.
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(ev.buf) then
							vim.cmd("normal! zx")
						end
					end)
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
