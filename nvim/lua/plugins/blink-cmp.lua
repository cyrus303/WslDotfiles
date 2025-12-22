return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.cmdline = opts.cmdline or {}
      opts.cmdline.keymap = opts.cmdline.keymap or {}

      -- Insert mode
      opts.keymap["<C-j>"] = { "select_next" }
      opts.keymap["<C-k>"] = { "select_prev" }
      opts.keymap["<C-l>"] = { "select_and_accept" }

      -- Cmdline
      opts.cmdline.keymap["<C-j>"] = { "select_next" }
      opts.cmdline.keymap["<C-k>"] = { "select_prev" }
      opts.cmdline.keymap["<C-l>"] = { "select_and_accept" }

      -- Ghost text off (both insert and cmdline)
      opts.completion = opts.completion or {}
      opts.completion.ghost_text = opts.completion.ghost_text or {}
      opts.completion.ghost_text.enabled = false

      opts.cmdline.completion = opts.cmdline.completion or {}
      opts.cmdline.completion.ghost_text = { enabled = false }
    end,
  },
}
