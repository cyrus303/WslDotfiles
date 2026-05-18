return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  opts = {
    keymaps = {
      accept_suggestion = "<Tab>",
    },
    ignore_filetypes = { gitcommit = true, markdown = true, TelescopePrompt = true, snacks_input = true },
    log_level = "off",
    disable_inline_completion = false,
    disable_keymaps = false,
  },
}
