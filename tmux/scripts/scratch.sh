#!/usr/bin/env bash
SESSION="scratch"
DIR="${1:-$HOME}"

tmux kill-session -t "$SESSION" 2>/dev/null
tmux new-session -d -s "$SESSION" -c "$DIR"
tmux set-option -t "$SESSION" window-style "bg=#0e0e16"
tmux set-option -t "$SESSION" window-active-style "bg=#0e0e16"
tmux set-option -t "$SESSION" detach-on-destroy on
tmux set-option -t "$SESSION" status off

tmux display-popup -d "$DIR" -w 90% -h 90% \
  -E "tmux attach-session -t $SESSION; tmux kill-session -t $SESSION 2>/dev/null"
exit 0
