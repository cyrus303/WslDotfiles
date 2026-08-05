return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function()
		local bg = "#0e0e16" -- main background
		local panel = "#252540" -- lifted accent for folder / branch
		local mid_bg = "#0e0e16" -- middle stretch stays seamless
		local dim_text = "#858d95"

		local lake_theme = {
			normal = {
				a = { bg = "#70a8a8", fg = bg, gui = "bold" }, -- cyan pill
				b = { bg = panel, fg = "#d8d8d8" }, -- folder panel (raised)
				c = { bg = mid_bg, fg = dim_text }, -- seamless middle
			},
			insert = {
				a = { bg = "#8ac490", fg = bg, gui = "bold" },
				b = { bg = panel, fg = "#d8d8d8" },
				c = { bg = mid_bg, fg = dim_text },
			},
			visual = {
				a = { bg = "#b0c0e0", fg = bg, gui = "bold" },
				b = { bg = panel, fg = "#d8d8d8" },
				c = { bg = mid_bg, fg = dim_text },
			},
			replace = {
				a = { bg = "#ef8a90", fg = bg, gui = "bold" },
				b = { bg = panel, fg = "#d8d8d8" },
				c = { bg = mid_bg, fg = dim_text },
			},
			command = {
				a = { bg = "#d58ca6", fg = bg, gui = "bold" },
				b = { bg = panel, fg = "#d8d8d8" },
				c = { bg = mid_bg, fg = dim_text },
			},
			terminal = {
				a = { bg = "#70a8a8", fg = bg, gui = "bold" },
				b = { bg = panel, fg = "#d8d8d8" },
				c = { bg = mid_bg, fg = dim_text },
			},
			inactive = {
				a = { bg = "#151520", fg = "#4a4a5e", gui = "bold" },
				b = { bg = "#151520", fg = "#4a4a5e" },
				c = { bg = mid_bg, fg = "#4a4a5e" },
			},
		}

		-- Right side mirrors the left: accent pill → panel → seamless
		-- lualine handles x/y/z automatically through the same theme table
		-- x uses c theme, y uses b theme, z uses a theme

		local function job_indicator_fn()
			if not package.loaded["easy-dotnet.ui-modules.jobs"] then
				return ""
			end
			local ok, ui = pcall(require, "easy-dotnet.ui-modules.jobs")
			if not ok or type(ui.lualine) ~= "function" then
				return ""
			end
			local v = ui.lualine()
			return type(v) == "string" and v or ""
		end

		local function project_root()
			local ok, root = pcall(function()
				return require("snacks.git").get_root()
			end)
			if ok and root then
				return " " .. vim.fn.fnamemodify(root, ":t")
			end
			return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
		end

		return {
			options = {
				theme = lake_theme,
				globalstatus = true,
				component_separators = { left = "\u{E0B1}", right = "\u{E0B3}" },
				section_separators = { left = "\u{E0B0}", right = "\u{E0B2}" },
				disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { project_root },
				lualine_c = {
					{
						"buffers",
						show_filename_only = true,
						show_modified_status = true,
						mode = 0,
						symbols = { modified = " ●", alternate_file = "", directory = "" },
						filetype_names = { snacks_dashboard = false },
						buffers_color = {
							active = { fg = "#f07098", gui = "bold" },
							inactive = { fg = "#6a7080" },
						},
					},
				},
				lualine_x = {
					job_indicator_fn,
					{
						function()
							return require("noice").api.status.mode.get()
						end,
						cond = function()
							return package.loaded["noice"] and require("noice").api.status.mode.has()
						end,
						color = { fg = "#d58ca6" },
					},
					{
						"diagnostics",
						sections = { "error", "warn" },
						symbols = {
							error = "\u{F057} ",
							warn = "\u{F071} ",
						},
					},
				},
				lualine_y = {
					{
						"diff",
						source = function()
							local gs = vim.b.gitsigns_status_dict
							if not gs then
								return nil
							end
							return { added = gs.added, modified = gs.changed, removed = gs.removed }
						end,
						symbols = {
							added = "\u{F067} ",
							modified = "\u{F040} ",
							removed = "\u{F068} ",
						},
					},
					"branch",
				},
				lualine_z = {
					function()
						return " " .. os.date("%H:%M")
					end,
				},
			},
			extensions = { "lazy", "trouble", "mason", "quickfix" },
		}
	end,
}
