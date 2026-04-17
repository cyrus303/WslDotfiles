local opt = vim.opt

-- Line numbers & cursor
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "number"
opt.scrolloff = 4
opt.sidescrolloff = 8

-- Indent & wrap
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true
opt.wrap = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmode = false
opt.cmdheight = 0
opt.laststatus = 3
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.pumheight = 10
opt.pumblend = 10
opt.winminwidth = 5
opt.conceallevel = 2
opt.fillchars:append({ diff = " ", eob = " " })

-- Files & buffers
opt.autoread = true
opt.autowrite = true
opt.undofile = true
opt.undolevels = 10000
opt.confirm = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Swap: isolate per NVIM_APPNAME
opt.directory = vim.fn.stdpath("state") .. "/swap//"

-- Session
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Folds (treesitter-driven, but default closed is annoying)
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""

-- Misc
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Disable snacks animations (user preference)
vim.g.snacks_animate = false

-- Disable unused language providers (no perl/python/ruby/node plugins)
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

