#!/usr/bin/env bash
set -euo pipefail

# ===================================
#   Arch Hyprland + AUR Setup Script
# ===================================

REPO_URL="https://github.com/thefoodiee/minimalistic-dotfiles.git"
REPO_DIR="$HOME/minimalistic-dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%s)"

echo ">>> Starting Arch installer..."

# -----------------------------------
# 1. Install prerequisites for yay
# -----------------------------------
echo ">>> Installing pacman prerequisites (git + base-devel)"
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git base-devel

# -----------------------------------
# 2. Install yay if missing
# -----------------------------------
if ! command -v yay >/dev/null 2>&1; then
    echo ">>> yay not found — installing yay..."
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
else
    echo ">>> yay already installed."
fi

# -----------------------------------
# 3. All packages installed via yay
# -----------------------------------

yay_pkgs=(
  # Hyprland components
  hyprland
  xdg-desktop-portal-hyprland
  hypridle
  hyprlock
  hyprpicker
  hyprshot

  # Core apps
  kitty
  waybar
  rofi-wayland
  swww
  wl-clipboard
  cliphist
  swayosd
  wlogout

  # Utilities
  wifitui
  blueman
  pavucontrol
  playerctl
  udiskie
  gnome-keyring
  polkit-kde-agent
  fastfetch

  # NWG tools
  nwg-displays
  nwg-look

  # Theming
  qt5ct
  qt6ct
  kvantum-qt5
  kvantum
  breeze-icons
  breeze
  papirus-icon-theme

  # System apps
  dolphin
  gwenview
  gnome-system-monitor
  baobab
  mpv
  obs-studio

  # Pywal + misc
  python-pywal16
  apple-fonts
  ttf-space-mono-nerd
  swaync

  # ZSH + plugins
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-theme-powerlevel10k-git
)

# -----------------------------------
# 4. Install everything via yay
# -----------------------------------
echo ">>> Installing all packages via yay..."
yay -S --needed --noconfirm "${yay_pkgs[@]}"

# -----------------------------------
# 4.1. Make Zsh default shell
# -----------------------------------
echo ">>> Checking Zsh installation..."

if ! command -v zsh >/dev/null 2>&1; then
    echo ">>> Installing zsh..."
    sudo pacman -S --needed --noconfirm zsh
fi

CURRENT_SHELL="$(basename "$SHELL")"

if [ "$CURRENT_SHELL" != "zsh" ]; then
    echo ">>> Changing your shell to zsh..."
    chsh -s /bin/zsh "$USER"
    echo ">>> Default shell changed to Zsh."
    echo ">>> IMPORTANT: Log out and log back in to apply."
else
    echo ">>> Zsh already default."
fi

# -----------------------------------
# 4.2. Ensure p10k loads
# -----------------------------------
ZSHRC="$HOME/.zshrc"

if ! grep -q "p10k.zsh" "$ZSHRC" 2>/dev/null; then
    echo ">>> Adding Powerlevel10k hook to .zshrc"
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> "$ZSHRC"
fi

# -----------------------------------
# 5. GNOME keyring (manual exec in Hyprland)
# -----------------------------------
echo ">>> Add this to your hyprland.conf:"
echo "exec-once = gnome-keyring-daemon --start --components=secrets,ssh"

# -----------------------------------
# 6. Backup + stow dotfiles
# -----------------------------------
echo ">>> Setting up dotfiles and stow"

sudo pacman -S --needed --noconfirm stow

if [ ! -d "$REPO_DIR" ]; then
    echo ">>> Cloning dotfiles into $REPO_DIR"
    git clone "$REPO_URL" "$REPO_DIR"
fi

mkdir -p "$BACKUP_DIR"

backup() {
    if [ -e "$1" ] && [ ! -L "$1" ]; then
        echo "Backing up $1"
        mv "$1" "$BACKUP_DIR/"
    fi
}

backup_list=(
    "$HOME/.config/hypr"
    "$HOME/.config/waybar"
    "$HOME/.config/kitty"
    "$HOME/.config/rofi"
    "$HOME/.config/swaync"
    "$HOME/.config/wlogout"
    "$HOME/.config/Kvantum"
    "$HOME/.config/gtk-3.0"
    "$HOME/.config/gtk-4.0"
    "$HOME/.config/qt5ct"
    "$HOME/.config/qt6ct"
    "$HOME/.config/mimeapps.list"
    "$HOME/.local/share/applications/mimeapps.list"
    "$HOME/.zshrc"
)

echo ">>> Backing up existing configs..."

for target in "${backup_list[@]}"; do
    backup "$target"
done

echo ">>> Stowing dotfiles..."
cd "$REPO_DIR"

for pkg in */; do
    pkg=${pkg%/}
    echo "Stowing $pkg..."
    stow -vSt "$HOME" "$pkg" || echo "Warning: conflict in $pkg"
done

# ==================================
# 7. Apply pywal theme
# ==================================
if command -v wal >/dev/null 2>&1; then
    echo ">>> Applying pywal theme..."
    wal -R || true
fi

# -----------------------------------
# Copy and apply default wallpaper
# -----------------------------------
echo ">>> Installing default wallpaper..."

WALL_SRC="$REPO_DIR/wallpapers/moonv1.png"
WALL_DST="$HOME/Pictures/wallpapers/moonv1.png"

mkdir -p "$HOME/Pictures/wallpapers"
cp "$WALL_SRC" "$WALL_DST"

echo ">>> Wallpaper copied to $WALL_DST"

if command -v swww >/dev/null 2>&1; then
    echo ">>> Applying wallpaper now..."
    swww-daemon & disown
    swww img "$WALL_DST" --transition-type grow --transition-fps 60
fi

echo ""
echo ">>> INSTALLATION COMPLETE!"
echo ">>> Reboot recommended."
