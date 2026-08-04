FOLDER=$1

mkdir -p ~/minimalistic-dotfiles/$1/.config

mv ~/.config/$1 ~/minimalistic-dotfiles/$1/.config/$1

stow $1
