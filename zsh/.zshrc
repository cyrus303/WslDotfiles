# --- fastfetch on interactive shell start (before p10k instant prompt) ---
if [[ $- == *i* ]] && command -v fastfetch >/dev/null 2>&1 && [[ "$(tmux display-message -p '#S' 2>/dev/null)" != "popup" ]]; then
  fastfetch
  echo
fi
# ----- Powerlevel10k instant prompt (must be after any console output) -----
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Always start in $HOME for the first shell, but not inside tmux
if [[ -z "$TMUX" ]] && [[ $PWD != $HOME ]]; then
  builtin cd "$HOME"
fi
# ----- Oh My Zsh -----
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump"
ZSH_THEME="powerlevel10k/powerlevel10k"
# Oh My Zsh update behavior
zstyle ':omz:update' mode reminder
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source "$ZSH/oh-my-zsh.sh"
# Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Vi mode
bindkey -v
KEYTIMEOUT=1
bindkey -M viins '^I' expand-or-complete

# Cursor shape using add-zle-hook-widget to avoid overriding p10k hooks
function _vi_cursor_shape() {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[6 q'  # steady beam (normal mode)
  else
    echo -ne '\e[4 q'  # steady underline (insert mode)
  fi
}
add-zle-hook-widget zle-keymap-select _vi_cursor_shape
# Reset to steady underline on each new prompt
echo -ne '\e[4 q'
# ----- Environment -----
export TERM=wezterm
export EDITOR='nvim'
export PATH="$HOME/.dotnet/tools:$HOME/.local/netcoredbg:$PATH"
# ----- onefetch (manual) -----
alias gf='onefetch'
# ----- fzf history (unique, bound to Alt-C) -----
fzf_hist_unique() {
  local cmd
  cmd=$(
    fc -rl 1 |
    sed 's/^[[:space:]]*[0-9]\+[*[:space:]]*//' |
    awk '!seen[$0]++' |
    fzf --height 40% \
        --layout=reverse \
        --border \
        --preview 'echo {}' \
        --preview-window=down:3:hidden
  ) || return
  LBUFFER=$cmd
  zle reset-prompt
}
zle -N fzf_hist_unique
# ----- Yazi -----
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd "$cwd"
  fi
  rm -f -- "$tmp"
}
# ----- Aliases -----
alias ls='eza'
alias ll='eza -alh'
alias tree='eza --tree'
alias tn='tmux new -s "$(basename "$PWD")"'
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias cat='bat --paging=never'
alias mvim='NVIM_APPNAME=nvim-minimal nvim'
# ----- fzf preview -----
export FZF_DEFAULT_OPTS="
  --preview 'bat --color=always --style=numbers --theme=Catppuccin\ Mocha --line-range=:200 {} 2>/dev/null || ls -la {}'
  --preview-window=right:55%:wrap
  --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,ctrl-l:accept'
  --color=bg:#0e0e16,bg+:#1a1a24,fg:#d8d8d8,fg+:#d8d8d8
  --color=preview-bg:#0e0e16,border:#2a2a3a,separator:#2a2a3a
  --color=hl:#f07098,hl+:#f07098,prompt:#f07098,pointer:#f07098
  --color=info:#707c8c,header:#707c8c,marker:#8ac490,spinner:#f07098"

# fzf shell integration (Arch installs these)
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ]   && source /usr/share/fzf/completion.zsh
# --- Custom fzf keybindings ---
# Unbind built-ins you don't want
for km in main emacs viins vicmd; do
  bindkey -M $km -r '^R'  2>/dev/null
  bindkey -M $km -r '^T'  2>/dev/null
  bindkey -M $km -r '^F'  2>/dev/null
  bindkey -M $km -r '^P'  2>/dev/null
  bindkey -M $km -r '^[c' 2>/dev/null
  bindkey -M $km -r '^[d' 2>/dev/null
  bindkey -M $km -r '^[f' 2>/dev/null
done
# Alt-F: fzf file picker
bindkey '^[f' fzf-file-widget
# Alt-D: fzf directory picker
bindkey '^[d' fzf-cd-widget
# Alt-C: command history picker
bindkey '^[c' fzf_hist_unique
# ----- Windows clipboard image paste (Alt+V) -----
_wclip_paste() {
  if wl-paste --type image/bmp > /tmp/clip.bmp 2>/dev/null && convert /tmp/clip.bmp /tmp/clip.png 2>/dev/null; then
    wl-copy --type image/png < /tmp/clip.png 2>/dev/null
    LBUFFER+="/tmp/clip.png"
    zle reset-prompt
  fi
}
zle -N _wclip_paste
bindkey '^[v' _wclip_paste

export ASPNETCORE_Kestrel__Certificates__Default__Path="/mnt/c/Users/sachi/.config/https/localhost.pfx"
export ASPNETCORE_Kestrel__Certificates__Default__Password="Dev@12345!"

# ----- SSH agent -----
export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
if ! ssh-add -l &>/dev/null; then
  rm -f "$SSH_AUTH_SOCK"
  eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" > /dev/null
  ssh-add ~/.ssh/id_ed25519_personal 2>/dev/null
  ssh-add ~/.ssh/id_rsa_azure_work 2>/dev/null
fi

# ----- zoxide (must be last) -----
export _ZO_DOCTOR=0
eval "$(zoxide init --cmd cd zsh)"
