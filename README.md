# 🛸 Minimalistic Hyprland + AUR Setup

A fully automated post-install script designed to transform a fresh Arch Linux installation into a functional, aesthetically pleasing, and performance-oriented Hyprland desktop environment.



## ✨ Features

* **Window Manager:** Hyprland (Wayland) with dynamic tiling and smooth animations.
* **AUR Helper:** Automated installation of `yay`.
* **Theming Engine:**
    * **Pywal:** Dynamic color schemes generated automatically from your wallpaper.
    * **GTK:** Integration with the **Celestial-Dark-Azul** theme.
    * **Qt:** Consistent styling via **Kvantum** and `qt6ct`.
    * **Icons:** Papirus-Dark and Breeze-Icons.
    * **Cursors:** BreezeX-Black theme.
* **Enhanced Shell:** Zsh pre-configured with **Oh My Zsh**, **Powerlevel10k**, syntax highlighting, and autosuggestions.
* **Reliability:** Automatic timestamped backups of existing `.config` files using GNU Stow.

---

## 🚀 Installation
️⚠️ The install script is AI generated. Please go through it before installation. However, the custom configs were purely written by me.
### 1. Prerequisites
Ensure you have a clean Arch Linux installation with a non-root user that has `sudo` privileges. An active internet connection is required.

### 2. Run the Script
Clone the repository and execute the installer:

```bash
git clone https://github.com/thefoodiee/minimalistic-dotfiles.git
cd minimalistic-dotfiles
./install.sh
```
---

## 📦 Included Packages

The following packages are installed automatically via `yay`. They provide the core functionality, theming, and system utilities for the Hyprland environment.

| Category | Packages |
| :--- | :--- |
| **Window Manager** | `hyprland`, `xdg-desktop-portal-hyprland`, `hypridle`, `hyprlock`, `hyprsunset` |
| **Desktop Core** | `waybar`, `rofi-wayland`, `swaync`, `swww`, `swayosd`, `wlogout` |
| **Terminal & Shell** | `kitty`, `alacritty`, `zsh`, `oh-my-zsh`, `p10k`, `neovim` |
| **Theming (Qt/GTK)** | `nwg-look`, `qt5ct`, `qt6ct-kde`, `kvantum`, `python-pywal16-git` |
| **System Utilities** | `dolphin`, `pavucontrol`, `blueman`, `wifitui`, `gnome-keyring`, `polkit-kde-agent` |
| **Multimedia** | `mpv`, `obs-studio`, `playerctl`, `sox`, `gwenview` |
| **Fonts & Icons** | `papirus-icon-theme`, `ttf-cascadia-code-nerd`, `apple-sf-fonts`, `minecraft-ttf-git` |
| **Workflow Tools** | `wl-clipboard`, `cliphist`, `hyprshot`, `hyprpicker`, `nwg-displays`, `clipse` |
| **Internet** | `brave-bin` |

---
## 🎨 Gallery
![preview](https://github.com/thefoodiee/minimalistic-dotfiles/blob/main/assets/screenshot.png?raw=true)