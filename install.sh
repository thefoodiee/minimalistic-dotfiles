#!/usr/bin/env bash
set -euo pipefail

# ===================================
#   Arch Hyprland + Matugen Setup Script
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
sudo pacman -S --needed --noconfirm git base-devel curl wget stow

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
# 3. Install packages
# -----------------------------------
yay_pkgs=(
  # Hyprland
  hyprland
  xdg-desktop-portal-hyprland
  hypridle
  hyprlock
  hyprpicker
  hyprshot
  hyprsunset

  # Core apps
  kitty
  waybar
  rofi-wayland
  rofi-emoji
  swww
  wl-clipboard
  cliphist
  swayosd
  wlogout
  sox

  # Utilities
  wifitui
  blueman
  pavucontrol
  playerctl
  udiskie
  gnome-keyring
  polkit-kde-agent
  fastfetch
  clipse
  alacritty
  bluetui

  # NWG
  nwg-displays
  nwg-look

  # Theming
  qt5ct
  qt6ct-kde
  kvantum-qt5
  kvantum
  breeze-icons
  breeze
  papirus-icon-theme
  ttf-cascadia-code-nerd
  ttf-cascadia-mono-nerd
  minecraft-ttf-git

  # System apps
  dolphin
  gwenview
  gnome-system-monitor
  baobab
  mpv
  obs-studio
  brave-bin

  # Matugen
  matugen
  apple-sf-fonts
  ttf-space-mono-nerd
  swaync
  neovim
)

echo ">>> Installing packages..."
yay -S --needed "${yay_pkgs[@]}"

# -----------------------------------
# 4. Clone dotfiles repo
# -----------------------------------
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
    "$HOME/.config/matugen"
    "$HOME/.config/mimeapps.list"
    "$HOME/.local/share/applications/mimeapps.list"
    "$HOME/.zshrc"
    "$HOME/.config/kdeglobals"
)

echo ">>> Backing up configs..."
for target in "${backup_list[@]}"; do
    backup "$target"
done

# -----------------------------------
# 5. Stow dotfiles
# -----------------------------------
echo ">>> Stowing dotfiles..."
cd "$REPO_DIR"

for pkg in */; do
    pkg=${pkg%/}
    echo "Stowing $pkg..."
    stow -vSt "$HOME" "$pkg" || echo "Warning: conflict in $pkg"
done

# -----------------------------------
# 6. Hyprland monitor config
# -----------------------------------
HYPR_DIR="$HOME/.config/hypr"
MON_EXAMPLE="$REPO_DIR/hypr/.config/hypr/monitors.conf.example"
MON_REAL="$HYPR_DIR/monitors.conf"

mkdir -p "$HYPR_DIR"

if [ ! -f "$MON_REAL" ] && [ -f "$MON_EXAMPLE" ]; then
    echo ">>> Creating default monitors.conf"
    cp "$MON_EXAMPLE" "$MON_REAL"
fi

# -----------------------------------
# 7. Wallpaper setup
# -----------------------------------
echo ">>> Installing wallpaper..."

WALL_SRC="$REPO_DIR/wallpapers/wallpaper.png"
WALL_DST="$HOME/Pictures/wallpapers/wallpaper.png"

mkdir -p "$HOME/Pictures/wallpapers"
cp "$WALL_SRC" "$WALL_DST"

if command -v swww >/dev/null 2>&1; then
    swww-daemon & disown
    sleep 1
    swww img "$WALL_DST" --transition-type grow --transition-fps 60
fi

# -----------------------------------
# 8. Generate Matugen theme
# -----------------------------------
echo ">>> Generating Matugen colors..."

if command -v matugen >/dev/null 2>&1; then
    matugen image "$WALL_DST"
fi

# -----------------------------------
# 9. Install adw-gtk3-dark theme
# -----------------------------------
echo ">>> Installing adw-gtk3-dark theme..."

mkdir -p "$HOME/.themes"
TMPDIR="$(mktemp -d)"
cd "$TMPDIR"

wget -q https://github.com/lassekongo83/adw-gtk3/releases/download/v6.4/adw-gtk3v6.4.tar.xz
tar -xJf adw-gtk3v6.4.tar.xz

cp -r adw-gtk3-dark "$HOME/.themes/"
cp -r adw-gtk3 "$HOME/.themes/" 2>/dev/null || true

cd ~
rm -rf "$TMPDIR"

# -----------------------------------
# 10. Apply GTK settings
# -----------------------------------
echo ">>> Applying GTK settings..."

mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

cat <<EOF > "$HOME/.config/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=adw-gtk3-dark
gtk-icon-theme-name=Papirus-Dark
gtk-application-prefer-dark-theme=1
EOF

cat <<EOF > "$HOME/.config/gtk-4.0/settings.ini"
[Settings]
gtk-theme-name=adw-gtk3-dark
gtk-icon-theme-name=Papirus-Dark
gtk-application-prefer-dark-theme=1
EOF

# -----------------------------------
# 11. Apply Qt settings
# -----------------------------------
mkdir -p "$HOME/.config/qt5ct"
cat <<EOF > "$HOME/.config/qt5ct/qt5ct.conf"
[Appearance]
style=kvantum
EOF

mkdir -p "$HOME/.config/qt6ct"
cat <<EOF > "$HOME/.config/qt6ct/qt6ct.conf"
[Appearance]
style=kvantum
EOF

echo ">>> Add to hyprland.conf:"
echo "env = QT_QPA_PLATFORMTHEME,qt6ct"
echo "env = QT_STYLE_OVERRIDE,Kvantum"

# -----------------------------------
# 12. Configure Zsh
# -----------------------------------
echo ">>> Configuring Zsh..."

if ! command -v zsh >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm zsh
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

git clone https://github.com/zsh-users/zsh-autosuggestions \
"$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
"$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
"$ZSH_CUSTOM/themes/powerlevel10k" 2>/dev/null || true

# -----------------------------------
# 13. Install BreezeX Black Cursor
# -----------------------------------
echo ">>> Installing BreezeX Black cursor..."

CURSOR_URL="https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Black.tar.xz"
TMPDIR="$(mktemp -d)"
ICON_DST="$HOME/.local/share/icons/BreezeX-Black"

mkdir -p "$HOME/.local/share/icons"

cd "$TMPDIR"
wget -q "$CURSOR_URL" -O breezeX.tar.xz
tar -xJf breezeX.tar.xz
mv BreezeX-Black "$ICON_DST"

cd ~
rm -rf "$TMPDIR"

chmod -R 755 "$ICON_DST"

# -----------------------------------
# Done
# -----------------------------------
echo ""
echo ">>> INSTALLATION COMPLETE!"
echo ">>> Reboot recommended."