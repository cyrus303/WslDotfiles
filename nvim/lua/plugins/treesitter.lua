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
				"css",
				"diff",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"tsx",
				"typescript",
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

					-- C# parser is loaded but treesitter module isn't started (Roslyn handles highlighting),
					-- so the treesitter indentexpr returns nothing useful — let smartindent handle it.
					if ev.match ~= "cs" then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end

					-- foldexpr is evaluated before TS attaches; recompute once parser is ready.
					-- Skip in insert mode — `normal! zx` would disrupt the cursor and scramble typing.
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(ev.buf)
							and vim.api.nvim_get_mode().mode:sub(1, 1) ~= "i"
						then
							pcall(vim.cmd, "normal! zx")
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
