-- Keymaps explicitly disabled to avoid conflicts or unwanted defaults.
-- Add new entries here rather than scattering nop mappings across other files.

local nop = function(keys)
  for _, k in ipairs(keys) do
    vim.keymap.set("n", k, "<nop>", { silent = true })
  end
end

-- Neovim 0.10+ built-in diagnostic jumps (first/last in file).
-- We use ]d/[d with a styled float instead; these would be inconsistent.
nop({ "[D", "]D" })
