local opt = vim.opt

-- Line numbers & cursor
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "number" -- only highlight the line number, not the full line
opt.scrolloff = 4
opt.sidescrolloff = 8

-- Indent & wrap
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true
opt.wrap = false -- prose filetypes enable wrap via autocmds
opt.breakindent = true -- wrapped lines visually indent to match

-- Search
opt.ignorecase = true
opt.smartcase = true -- case-sensitive when query has uppercase
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.inccommand = "split" -- live preview of :s///, with off-screen hits in a split

-- UI
opt.termguicolors = true
opt.signcolumn = "auto:1" -- show when needed, max 1 cell wide
opt.showmode = false -- mode shown by lualine instead
opt.cmdheight = 0 -- hide cmdline when not in use
opt.laststatus = 3 -- single global statusline
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen" -- keep text stable when opening splits
opt.pumheight = 10 -- max completion menu items
opt.pumblend = 10 -- slight transparency on popup menu
opt.winminwidth = 5
opt.conceallevel = 2 -- hide concealed chars (e.g. markdown syntax)
opt.fillchars:append({ diff = " ", eob = " " }) -- cleaner diff and end-of-buffer display

-- Files & buffers
opt.autoread = true
-- Writes stay explicit (<C-s>). Buffer and window switching never wrote anyway
-- -- 'hidden' is on, so an abandoned buffer is hidden rather than written -- but
-- autowrite still fired on :!, :make, :suspend, :next and CTRL-], silently
-- writing unsaved work and triggering conform's format-after-save with it.
opt.autowrite = false
opt.undofile = true
opt.undolevels = 10000
opt.confirm = true -- prompt instead of erroring on unsaved changes
opt.updatetime = 200 -- faster CursorHold and swap writes
opt.timeoutlen = 300 -- ms to wait for mapped key sequence
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- sync with system clipboard

-- Isolate swap files per NVIM_APPNAME so configs don't share state
opt.directory = vim.fn.stdpath("state") .. "/swap//"

-- Session
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }

-- Treesitter-driven folds, open by default. C# folds come from the local
-- queries/c_sharp/folds.scm override, which folds declarations rather than the
-- upstream body nodes -- see the comment at the top of that file.
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "" -- render the fold's first line with its real highlighting

-- Fold markers in the gutter. snacks' statuscolumn draws the icon, but it gates
-- the whole fold component on `foldcolumn ~= "0"` (snacks/statuscolumn.lua), so
-- leaving foldcolumn at its "0" default meant no fold indicator ever appeared --
-- neither a chevron on foldable lines nor a marker on folded ones. This costs
-- one gutter column. Pair with folds.open in the snacks statuscolumn opts,
-- otherwise only *closed* folds get an icon and there is still nothing showing
-- what is foldable in the first place.
opt.foldcolumn = "1"
-- fold = "·" keeps the dotted tail this config showed before: with foldtext = ""
-- a folded line renders as its own source text, so without the tail a collapsed
-- method is indistinguishable from a normal signature row apart from the gutter.
-- ("·" is also the fillchars default -- set explicitly so the trio reads as one
-- deliberate choice.)
--
-- The chevrons are U+F47C and U+F460, the Nerd Font octicon pair this config
-- used to render before LazyVim was dropped -- recovered from LazyVim's own
-- fillchars in ~/.cache/nvim/luac. Written as escapes rather than literal glyphs
-- so the codepoints survive editors and fonts that cannot show them.
opt.fillchars:append({ foldopen = "\u{f47c}", foldclose = "\u{f460}", fold = "·" })

-- Show trailing whitespace and non-breaking spaces
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- Suppress noisy messages (written, ins-completion, search wrap)
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Disable snacks animations
vim.g.snacks_animate = false

-- Disable unused language providers to skip slow startup checks
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
