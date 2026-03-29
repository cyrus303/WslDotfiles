# ----- Powerlevel10k instant prompt (must be first) -----
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Clear screen on shell start
if [[ $- == *i* ]]; then
  clear
fi

# --- fastfetch first, no conditions ---
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
  echo
fi

# Always start in $HOME for the first shell, but not inside tmux
if [[ -z "$TMUX" ]] && [[ $PWD != $HOME ]]; then
  builtin cd "$HOME"
fi

# ----- Oh My Zsh -----
export ZSH="$HOME/.oh-my-zsh"
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


# ----- Environment -----
export EDITOR='nvim'
export PATH="$HOME/.dotnet/tools:$HOME/.local/netcoredbg:$PATH"

# ----- onefetch repo-aware hook -----
_last_onefetch_repo=""

_onefetch_maybe() {
  local current_repo
  current_repo=$(git rev-parse --show-toplevel 2>/dev/null) || return

  if [[ "$current_repo" != "$_last_onefetch_repo" ]]; then
    _last_onefetch_repo="$current_repo"
    onefetch
  fi
}

add-zsh-hook chpwd _onefetch_maybe

# ----- fzf history (unique, bound to Ctrl-P) -----
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
bindkey '^P' fzf_hist_unique

# ----- Aliases -----
alias ls='eza'
alias ll='eza -alh'
alias tree='eza --tree'

alias tn='tmux new -s "$(basename "$PWD")"'

alias cat='bat --paging=never'

# fzf shell integration (Arch installs these)
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ]   && source /usr/share/fzf/completion.zsh

# --- Custom fzf keybindings ---

# Unbind built-ins you don't want
bindkey -r '^R'   # remove Ctrl-R history search
bindkey -r '^T'   # remove Ctrl-T file search
bindkey -r '^[C'  # remove Alt-C cd (optional)

# Ctrl-F: fzf file search (was Ctrl-T)
bindkey '^F' fzf-file-widget

export ZSH_COMPDUMP="${ZSH_CACHE_DIR:-$HOME/.cache}/zcompdump"

# ----- zoxide (must be last) -----
export _ZO_DOCTOR=0
eval "$(zoxide init --cmd cd zsh)"
