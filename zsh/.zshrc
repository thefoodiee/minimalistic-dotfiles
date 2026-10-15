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

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/develop/flutter/bin"

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

# >>> railway initialize >>>
source "$HOME/.railway/env"
# <<< railway initialize <<<
