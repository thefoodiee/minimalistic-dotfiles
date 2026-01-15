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
sudo pacman -S --needed --noconfirm git base-devel curl wget

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
  rofi-emoji
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
  clipse
  alacritty

  # NWG tools
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

  # Pywal + misc
  python-pywal16
  apple-fonts
  ttf-space-mono-nerd
  swaync
  neovim
)

echo ">>> Installing all packages via yay..."
yay -S --needed "${yay_pkgs[@]}" || {
    echo ""
    echo ">>> Conflicting packages detected!"
    echo "Do you want yay to remove conflicting packages automatically? (y/N)"
    read -r ans

    if [[ "$ans" =~ ^[Yy]$ ]]; then
        yay -S --needed --removemake --noconfirm "${yay_pkgs[@]}"
    else
        echo ">>> Skipping conflicting package removal. Resolve conflicts manually."
        exit 1
    fi
}

# -----------------------------------
# 4. GNOME keyring hint
# -----------------------------------
echo ">>> Add this to your hyprland.conf:"
echo "exec-once = gnome-keyring-daemon --start --components=secrets,ssh"

# -----------------------------------
# 5. Backup + stow dotfiles
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
    "$HOME/.config/kdeglobals"
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

# -----------------------------------
# Create default Hyprland monitors.conf
# -----------------------------------
HYPR_DIR="$HOME/.config/hypr"
MON_EXAMPLE="$REPO_DIR/hypr/.config/hypr/monitors.conf.example"
MON_REAL="$HYPR_DIR/monitors.conf"

mkdir -p "$HYPR_DIR"

if [ ! -f "$MON_REAL" ]; then
    if [ -f "$MON_EXAMPLE" ]; then
        echo ">>> Creating default monitors.conf from template"
        cp "$MON_EXAMPLE" "$MON_REAL"
    else
        echo ">>> Warning: monitors.conf.example not found in repo"
    fi
else
    echo ">>> monitors.conf already exists, leaving it untouched"
fi

# -----------------------------------
# 6. Copy and apply default wallpaper
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

# -----------------------------------
# 7. Apply Pywal theme from wallpaper
# -----------------------------------
if command -v wal >/dev/null 2>&1; then
    echo ">>> Generating Pywal theme..."
    wal -i "$WALL_DST" -n
fi

# -----------------------------------
# 8. Install Celestial GTK Theme
# -----------------------------------
echo ">>> Installing Celestial GTK theme..."

mkdir -p "$HOME/.themes"

if [ ! -d "$HOME/celestial-gtk-theme" ]; then
    git clone https://github.com/zquestz/celestial-gtk-theme.git "$HOME/celestial-gtk-theme"
    cd "$HOME/celestial-gtk-theme"
    chmod +x install.sh
    ./install.sh -t azul
else
    echo ">>> Celestial theme already installed."
fi

# -----------------------------------
# 9. Apply GTK & Qt theme settings
# -----------------------------------
echo ">>> Applying GTK and Qt theme..."

mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cat <<EOF > "$HOME/.config/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=Celestial-Dark-Azul
gtk-icon-theme-name=Papirus-Dark
gtk-application-prefer-dark-theme=1
EOF

cat <<EOF > "$HOME/.config/gtk-4.0/settings.ini"
[Settings]
gtk-theme-name=Celestial-Dark-Azul
gtk-icon-theme-name=Papirus-Dark
gtk-application-prefer-dark-theme=1
EOF

mkdir -p "$HOME/.config/Kvantum"
cat <<EOF > "$HOME/.config/Kvantum/kvantum.kvconfig"
[General]
theme=Celestial-Dark-Azul
EOF

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

echo ">>> Add these to your hyprland.conf for Qt apps:"
echo "env = QT_QPA_PLATFORMTHEME,qt6ct"
echo "env = QT_STYLE_OVERRIDE,Kvantum"

# -----------------------------------
# 10. ZSH + OH-MY-ZSH INSTALL & SETUP
# -----------------------------------
echo ">>> Configuring Zsh environment..."

if ! command -v zsh >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm zsh
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
    sed -i 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC"
    grep -q "p10k.zsh" "$ZSHRC" || echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> "$ZSHRC"
else
    cat <<EOF > "$ZSHRC"
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source \$ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
fi

if [ "$(basename "$SHELL")" != "zsh" ]; then
    chsh -s /bin/zsh "$USER"
    echo ">>> Logout and login again to enable Zsh."
fi

echo ">>> Zsh configured successfully!"

# -----------------------------------
# Install BreezeX Black cursor theme
# -----------------------------------
echo ">>> Installing BreezeX Black cursor theme..."
CURSOR_URL="https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Black.tar.xz"
TMPDIR="$(mktemp -d)"
ICON_DST="$HOME/.local/share/icons/BreezeX-Black"

mkdir -p "$HOME/.local/share/icons"

cd "$TMPDIR"
wget -q "$CURSOR_URL" -O breezeX.tar.xz
tar -xJf breezeX.tar.xz
# The tar might extract a folder. Move/rename it properly:
# Assuming archive extracts 'BreezeX-Black'
mv BreezeX-Black "$ICON_DST"
cd ~
rm -rf "$TMPDIR"

# Set permissions
chmod -R 755 "$ICON_DST"

echo ">>> BreezeX Black installed to $ICON_DST"
echo ">>> To use it, set your cursor theme to 'BreezeX-Black' in your DE/WM settings (or export XCURSOR_THEME='BreezeX-Black')."

echo ""
echo ">>> INSTALLATION COMPLETE!"
echo ">>> Reboot recommended."
