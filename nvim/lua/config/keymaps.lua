local map = vim.keymap.set

-- gc toggles comment on current line (disabled keymaps live in config/disabled.lua)
map("n", "gc", function()
	return require("vim._comment").operator() .. "_"
end, { expr = true, desc = "Toggle comment line" })

-- Space as leader, backslash as local leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Save and quit
map({ "n", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save buffer" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save buffer" })
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
map("n", "<leader>\\", function()
	local cur = vim.api.nvim_get_current_buf()
	local alt = vim.fn.bufnr("#")
	local target = (alt ~= -1 and alt ~= cur and vim.fn.buflisted(alt) == 1) and alt or nil
	if not target then
		for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
			if buf.bufnr ~= cur then
				target = buf.bufnr
				break
			end
		end
	end
	vim.cmd("vsplit")
	if target then
		vim.cmd("wincmd h")
		vim.api.nvim_set_current_buf(target)
		vim.cmd("wincmd l")
	end
end, { desc = "Split Window Right (alt buf left)" })

-- Resize splits with arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Cycle through open buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<leader>bo", function()
  local cur = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= cur and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, { desc = "Close other buffers" })

-- Folds: `za` (default) toggles the fold under cursor (method/block).
-- `<leader>z` toggles VS-style method folding: collapses methods only,
-- keeps class/namespace structure visible.
-- If folding isn't at the right depth, change the `1` below:
--   0 = fold everything including class
--   1 = fold methods, keep class + namespace open (C# default)
--   2 = fold nested blocks inside methods, keep methods visible
map("n", "<leader>z", function()
  if vim.wo.foldlevel > 1 then
    vim.wo.foldlevel = 1
  else
    vim.wo.foldlevel = 99
  end
end, { desc = "Toggle method folds (VS-style)" })

-- On a folded line, `l` opens the fold; otherwise normal right-motion.
map("n", "l", function()
  return vim.fn.foldclosed(vim.fn.line(".")) ~= -1 and "zo" or "l"
end, { expr = true, silent = true, desc = "Open fold or move right" })

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

-- File info: replicates <C-g> output and also yanks it to the system clipboard
map("n", "<C-g>", function()
  local path = vim.fn.expand("%:~:.")
  if path == "" then path = "[No Name]" end
  local flags = (vim.bo.modified and " [Modified]" or "")
    .. (vim.bo.readonly and " [readonly]" or "")
  local line  = vim.fn.line(".")
  local total = vim.fn.line("$")
  local col   = vim.fn.col(".")
  local pct   = total > 0 and math.floor(line * 100 / total) or 0
  local msg   = string.format('"%s"%s  line %d of %d --%d%%-- col %d',
    path, flags, line, total, pct, col)
  vim.fn.setreg("+", msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "File Info" })
end, { desc = "File info (copied to clipboard)" })

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
map("n", "<leader>lr", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local lenses = vim.lsp.codelens.get({ bufnr = bufnr })
	local found
	for _, item in ipairs(lenses) do
		if item.lens.range.start.line == row then
			found = item
			break
		end
	end
	if not found then
		vim.notify("No codelens on current line", vim.log.levels.WARN)
		return
	end
	local pos = found.lens.range.start
	local saved = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_win_set_cursor(0, { pos.line + 1, pos.character })
	vim.lsp.buf.references()
	vim.api.nvim_win_set_cursor(0, saved)
end, { desc = "Line references (codelens)" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "Implementation" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "K", function()
	vim.lsp.buf.hover({ border = "rounded", max_width = 80 })
end, { desc = "Hover" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	vim.notify("Autoformat " .. (vim.g.disable_autoformat and "disabled" or "enabled"), vim.log.levels.INFO)
end, { desc = "Toggle autoformat" })

-- Toggle inlay hints
map("n", "<leader>ci", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- Toggle line wrap across all windows
map("n", "<leader>cw", function()
	local new_wrap = not vim.wo.wrap
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		vim.wo[win].wrap = new_wrap
	end
	vim.notify("Wrap " .. (new_wrap and "enabled" or "disabled"))
end, { desc = "Toggle wrap" })

-- Toggle codelens — refreshes on every BufEnter while enabled
map("n", "<leader>cl", function()
	local enabled = not vim.g.codelens_enabled
	vim.g.codelens_enabled = enabled
	if enabled then
		vim.lsp.codelens.enable(true)
	else
		vim.lsp.codelens.enable(false)
		vim.api.nvim_create_augroup("codelens_refresh", { clear = true })
	end
	vim.notify("Codelens " .. (enabled and "enabled" or "disabled"))
end, { desc = "Toggle codelens" })
