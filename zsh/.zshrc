if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git 
  zsh-autosuggestions
  zsh-syntax-highlighting
  vscode
  docker-compose
  docker
  autojump
)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

export PATH="$PATH:$HOME/.local/bin"

# (cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
# cat ~/.cache/wal/sequences
# custom functions

mkcode(){
  if [ -z "$1" ]; then
    echo "Usage: mkcode <directory>"
    return 1
  fi
  mkdir -p "$1" && code "$1"
}

# change vscode folder
chcode() {
  if [[ -z "$1" ]]; then
    echo "Usage: chcode <foldername>"
    return 1
  fi

  cd .. || return
  mkdir -p "$1"
  code -r "$1"
}

# aliases

# paru shortcuts
alias s='paru'
alias i='paru -S'
alias r='paru -Rns'

alias nv='nvim'
alias nrd='npm run dev'

alias ls='lsd'
alias l='lsd -l -a'

# Don't save duplicate commands
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# Ignore commands that start with a space
setopt HIST_IGNORE_SPACE

# Large history
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# Commands/patterns to ignore
# zshaddhistory() {
#     emulate -L zsh
#
#     local cmd="${1%%$'\n'}"
#
#     # common navigation/listing commands
#     case "$cmd" in
#         cd*|pushd*|popd*|dirs*|pwd|ls*|ll*|la*|l*|lsd*|j*)
#             return 1
#             ;;
#     esac
#
#     # ignore commands that are just paths
#     if [[ "$cmd" =~ '^(\.?\.?/|~/|/)' ]]; then
#         return 1
#     fi
#
#     # ignore single-word path-like commands
#     if [[ "$cmd" != *" "* && ( -d "$cmd" || "$cmd" == .* || "$cmd" == */* ) ]]; then
#         return 1
#     fi
#
#     return 0
# }
