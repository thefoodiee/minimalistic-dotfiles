if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting vscode)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

export PATH="$PATH:$HOME/.local/bin"

# (cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
# cat ~/.cache/wal/sequences

export QT_QPA_PLATFORMTHEME=qt5ct
export LANG=en_IN.UTF-8
export LC_ALL=en_IN.UTF-8

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

# yay shortcuts
alias s='yay'
alias i='yay -S'
alias r='yay -Rns'

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
