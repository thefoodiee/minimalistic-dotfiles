#!/usr/bin/env bash
set -euo pipefail

# ===================================
#   Arch-Based Hyprland Setup Script
#   with AUR packages (Spotify, VSCode, Discord)
# ===================================

REPO_URL="https://github.com/thefoodiee/minimalistic-dotfiles.git"
REPO_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%s)"

echo ">>> Starting Arch-based Hyprland installer..."

# -----------------------------------
# OFFICIAL REPO PACKAGES
# -----------------------------------
pacman_pkgs=(
  hyprland
  xdg-desktop-portal-hyprland
  kitty
  waybar
  rofi-wayland
  swww
  hypridle
  hyprlock
  hyprpicker
  hyprshot
  wl-clipboard
  swayosd
  cliphist
  wlogout
  wifitui
  blueman
  pavucontrol
  playerctl
  udiskie
  nwg-displays
  nwg-looks
  gnome-keyring
  polkit-kde-agent
  qt5ct
  qt6ct
  kvantum
  breeze-icons
  breeze-cursors
  firefox
  dolphin
  gwenview
  gnome-system-monitor
  baobab
  mpv
  obs-studio
  python-pywal16
  fastfetch
)

# -----------------------------------
# AUR PACKAGES (install via yay)
# -----------------------------------
aur_pkgs=(
  spotify
  discord
  visual-studio-code-bin
)

# -----------------------------------
# Install yay if missing
# -----------------------------------
install_yay() {
    if ! command -v yay >/dev/null 2>&1; then
        echo ">>> yay not found. Installing yay (AUR helper)..."
        sudo pacman -S --needed --noconfirm git base-devel

        cd /tmp
        rm -rf yay
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
    else
        echo ">>> yay is already installed"
    fi
}

# -----------------------------------
# Install pacman packages
# -----------------------------------
install_pacman() {
    echo ">>> Updating system..."
    sudo pacman -Syu --noconfirm

    echo ">>> Installing official repo packages..."
    sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"
}

# -----------------------------------
# Install AUR packages
# -----------------------------------
install_aur() {
    echo ">>> Installing AUR packages..."
    yay -S --needed --noconfirm "${aur_pkgs[@]}"
}

# -----------------------------------
# Enable GNOME keyring (secrets only)
# -----------------------------------
enable_keyring() {
    echo ">>> Enabling GNOME Keyring user services"
    systemctl --user enable --now gnome-keyring-daemon.service || true
    systemctl --user enable --now gcr-ssh-agent.service || true

    echo ">>> IMPORTANT: Add this to Hyprland config:"
    echo "exec-once = gnome-keyring-daemon --start --components=secrets"
}

# -----------------------------------
# Clone + Stow dotfiles
# -----------------------------------
setup_dotfiles() {
    echo ">>> Installing stow + git"
    sudo pacman -S --needed --noconfirm stow git

    if [ ! -d "$REPO_DIR" ]; then
        echo ">>> Cloning dotfiles repo"
        git clone "$REPO_URL" "$REPO_DIR"
    fi

    mkdir -p "$BACKUP_DIR"
    echo ">>> Backing up existing configs to: $BACKUP_DIR"

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
      "$HOME/.config/fastfetch"
      "$HOME/.config/mimeapps.list"
      "$HOME/.local/share/applications/mimeapps.list"
      "$HOME/.cache/wal"
      "$HOME/.zshrc"
    )

    for path in "${backup_list[@]}"; do
        backup "$path"
    done

    echo ">>> Stowing dotfiles packages"
    cd "$REPO_DIR"
    for pkg in */; do
        pkg=${pkg%/}
        echo "Stowing $pkg..."
        stow -vSt "$HOME" "$pkg" || echo "Warning: stow conflict in $pkg"
    done

    # Apply pywal colors
    if command -v wal >/dev/null 2>&1; then
        echo ">>> Applying pywal theme (wal -R)"
        wal -R || true
    fi
}

# -----------------------------------
# MAIN EXECUTION
# -----------------------------------
echo ">>> Installing pacman packages..."
install_pacman

echo ">>> Installing yay..."
install_yay

echo ">>> Installing AUR packages..."
install_aur

echo ">>> Enabling GNOME Keyring..."
enable_keyring

echo ">>> Setting up dotfiles..."
setup_dotfiles

# -----------------------------------
# Copy and apply default wallpaper
# -----------------------------------
echo ">>> Installing default wallpaper..."

WALL_SRC="$REPO_DIR/wallpapers/moonv1.png"
WALL_DST="$HOME/Pictures/wallpapers/moonv1.png"

# Create wallpapers directory if needed
mkdir -p "$HOME/Pictures/wallpapers"

# Copy wallpaper from repo to Pictures directory
cp "$WALL_SRC" "$WALL_DST"

echo ">>> Wallpaper copied to $WALL_DST"

# Apply wallpaper immediately (no need to relaunch Hyprland)
if command -v swww >/dev/null 2>&1; then
    echo ">>> Applying wallpaper now..."
    pkill swww || true
    swww init
    swww img "$WALL_DST" --transition-type grow --transition-fps 60
fi


echo ""
echo ">>> Installation complete!"
echo ">>> Reboot recommended."
