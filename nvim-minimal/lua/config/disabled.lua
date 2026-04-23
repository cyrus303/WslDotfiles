-- Keymaps explicitly disabled to avoid conflicts or unwanted defaults.
-- Add new entries here rather than scattering nop mappings across other files.

local map = vim.keymap.set

-- Neovim 0.10+ built-in diagnostic jumps (first/last in file).
-- We use ]d/[d with a styled float instead; these would be inconsistent.
map("n", "[D", "<Nop>")
map("n", "]D", "<Nop>")

-- Comment keymaps — only gc (line toggle) is kept in keymaps.lua
map("n",               "gco", "<Nop>")
map("n",               "gcO", "<Nop>")
map("n",               "gcA", "<Nop>")
map("n",               "gb",  "<Nop>")
map("n",               "gbc", "<Nop>")
map("x",               "gb",  "<Nop>")

-- g-prefix built-in motions
map({ "n", "x", "o" }, "ge",  "<Nop>")
map({ "n", "x", "o" }, "gE",  "<Nop>")
map({ "n", "x", "o" }, "gn",  "<Nop>")
map({ "n", "x", "o" }, "gN",  "<Nop>")
map("n",               "gt",  "<Nop>")
map("n",               "gT",  "<Nop>")
map({ "n", "x", "o" }, "gu",  "<Nop>")
map({ "n", "x", "o" }, "gU",  "<Nop>")
map("n",               "gv",  "<Nop>")
map("n",               "gx",  "<Nop>")
map("n",               "g,",  "<Nop>")
map("n",               "g;",  "<Nop>")
map({ "n", "x", "o" }, "g%",  "<Nop>")
map("n",               "g'",  "<Nop>")
map("n",               "g`",  "<Nop>")

-- Ex mode — never useful, easy to trigger accidentally
map("n", "Q", "<Nop>")

-- Suspend to background — easy to accidentally "lose" nvim
map({ "n", "i" }, "<C-z>", "<Nop>")

-- ZZ (save+quit) and ZQ (quit without saving) — accidental destructive exits
map("n", "ZZ", "<Nop>")
map("n", "ZQ", "<Nop>")

-- F1 help — almost always an accidental Escape miss
map({ "n", "i" }, "<F1>", "<Nop>")
