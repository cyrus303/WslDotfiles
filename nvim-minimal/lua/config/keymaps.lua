local map = vim.keymap.set

-- gc toggles comment on current line; all other comment keymaps disabled
map("n", "gc", function()
	return require("vim._comment").operator() .. "_"
end, { expr = true, desc = "Toggle comment line" })
map("n", "gco", "<Nop>")
map("n", "gcO", "<Nop>")
map("n", "gcA", "<Nop>")
map("n", "gb",  "<Nop>")
map("n", "gbc", "<Nop>")
map("x", "gb",  "<Nop>")

-- Space as leader, backslash as local leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Save and quit
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save buffer" })
map({ "n", "i", "v" }, "<C-S-s>", "<cmd>wa<CR>", { desc = "Save all buffers" })
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>qw", "<cmd>q<CR>", { desc = "Close window" })

-- Keep cursor centered while scrolling and searching
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, center" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Prev search result" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlight" })

-- Split windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>\\", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Resize splits with arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Cycle through open buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Move lines up/down and re-indent
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Join line without moving cursor
map("n", "J", "mzJ`z", { desc = "Join line" })

-- Stay in visual mode after indenting
map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })

-- Diagnostic float: temporarily disables tiny-inline-diagnostic while the float
-- is open, then re-enables it on cursor move so both don't fight each other.
local function show_styled_diag_float()
	pcall(function()
		require("tiny-inline-diagnostic").disable()
	end)

	local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
	local diags = vim.diagnostic.get(0, { lnum = lnum })
	local severity = vim.diagnostic.severity.HINT
	for _, d in ipairs(diags) do
		if d.severity < severity then
			severity = d.severity
		end
	end

	local border_hl = {
		[vim.diagnostic.severity.ERROR] = "DiagnosticError",
		[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
		[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
		[vim.diagnostic.severity.HINT] = "DiagnosticHint",
	}

	local screen_row = vim.fn.winline()
	local lines_below = vim.api.nvim_win_get_height(0) - screen_row
	local anchor = lines_below < 5 and "above" or "below"

	local _, winid = vim.diagnostic.open_float(nil, {
		scope = "line",
		close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
		border = "rounded",
		max_width = 60,
		wrap = true,
		anchor_bias = anchor,
	})

	if winid then
		vim.wo[winid].winhighlight = "FloatBorder:" .. (border_hl[severity] or "DiagnosticHint")
	end

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" }, {
		once = true,
		callback = function()
			pcall(function()
				require("tiny-inline-diagnostic").enable()
			end)
		end,
	})
end

-- Navigate diagnostics with styled float (all severities)
map("n", "]d", function()
	vim.diagnostic.goto_next({ float = false })
	vim.defer_fn(show_styled_diag_float, 50)
end, { desc = "Next diagnostic" })

map("n", "[d", function()
	vim.diagnostic.goto_prev({ float = false })
	vim.defer_fn(show_styled_diag_float, 50)
end, { desc = "Prev diagnostic" })

-- Navigate errors only
map("n", "]e", function()
	vim.diagnostic.goto_next({ float = false, severity = vim.diagnostic.severity.ERROR })
	vim.defer_fn(show_styled_diag_float, 50)
end, { desc = "Next error" })

map("n", "[e", function()
	vim.diagnostic.goto_prev({ float = false, severity = vim.diagnostic.severity.ERROR })
	vim.defer_fn(show_styled_diag_float, 50)
end, { desc = "Prev error" })

-- .NET helpers
map("n", "<leader>dk", function()
	vim.fn.system("pkill dotnet || true")
end, { desc = "Kill dotnet processes" })

map("n", "<leader>dn", function()
	local path = vim.fn.expand("%:p:h")
	coroutine.wrap(function()
		require("easy-dotnet.actions.new").create_new_item(path, function(file_path)
			vim.schedule(function()
				vim.cmd("edit " .. vim.fn.fnameescape(file_path))
			end)
		end)
	end)()
end, { desc = "New .NET item" })

-- LSP — set globally so they work before LspAttach fires; plugins can override per-buffer
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "Implementation" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "K", function()
	vim.lsp.buf.hover({ border = "rounded", max_width = 80 })
end, { desc = "Hover" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cf", function()
	require("conform").format({ async = true })
end, { desc = "Format" })

-- Toggle inlay hints
map("n", "<leader>ci", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- Toggle codelens — refreshes on every BufEnter while enabled
map("n", "<leader>cl", function()
	local enabled = not vim.g.codelens_enabled
	vim.g.codelens_enabled = enabled
	if enabled then
		vim.lsp.codelens.refresh()
		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			group = vim.api.nvim_create_augroup("codelens_refresh", { clear = true }),
			callback = function()
				vim.lsp.codelens.refresh()
			end,
		})
	else
		vim.lsp.codelens.clear()
		vim.api.nvim_create_augroup("codelens_refresh", { clear = true })
	end
	vim.notify("Codelens " .. (enabled and "enabled" or "disabled"))
end, { desc = "Toggle codelens" })
