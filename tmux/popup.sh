#!/usr/bin/env bash
SESSION="popup"
DIR="${1:-$HOME}"

tmux has-session -t "$SESSION" 2>/dev/null || tmux new-session -d -s "$SESSION" -c "$DIR"

tmux set-option -t "$SESSION" detach-on-destroy on
tmux set-option -t "$SESSION" window-style "bg=#0e0e16"
tmux set-option -t "$SESSION" window-active-style "bg=#0e0e16"
tmux set-hook -t "$SESSION" after-new-window "set-option -w window-style 'bg=#0e0e16'; set-option -w window-active-style 'bg=#0e0e16'"
tmux set-option -t "$SESSION" status on
tmux set-option -t "$SESSION" status-position top
tmux set-option -t "$SESSION" status-style "bg=#0e0e16"
tmux set-option -t "$SESSION" 'status-format[0]' '#[align=right]#{W:#{?window_active,#[fg=#eb6f92]●,#[fg=#6b3858]●}  }'

tmux display-popup -d "$DIR" -w 90% -h 90% \
  -T "#[fg=#eb6f92,bold] $SESSION " \
  -E "tmux attach-session -t $SESSION"
