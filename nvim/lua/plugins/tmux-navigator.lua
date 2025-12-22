return {
  "christoomey/vim-tmux-navigator",
  keys = {
    { "<M-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to the previous pane" },
    { "<M-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to the left pane" },
    { "<M-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to the down pane" },
    { "<M-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to the up pane" },
    { "<M-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to the right pane" },
  },
}
