#!/bin/sh
set -e

# --- Functions ---

prompt_yes_no() {
    while true; do
        read -r -p "$1 (y/n): " yn
        case "$yn" in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Please answer y or n." ;;
        esac
    done
}

install_if_missing() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Installing $1..."
        sudo pacman -S --noconfirm "$1"
    else
        echo "$1 is already installed."
    fi
}

add_fastfetch_to_shell() {
    for shellrc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$shellrc" ]; then
            if ! grep -q "fastfetch" "$shellrc"; then
                echo "" >> "$shellrc"
                echo "# Run fastfetch at shell startup" >> "$shellrc"
                echo "fastfetch" >> "$shellrc"
                echo "Added fastfetch to $shellrc"
            fi
        fi
    done
}

# --- Main Script ---

# Ensure sudo is available
if ! command -v sudo >/dev/null 2>&1; then
    echo "sudo is required. Installing sudo..."
    pacman -S --noconfirm sudo
fi

# Update package database and install figlet
echo "Updating package database and installing figlet..."
sudo pacman -Sy --noconfirm
install_if_missing figlet

figlet "AserDev Install"

# System update
if prompt_yes_no "Update your system?"; then
    sudo pacman -Syu --noconfirm
    echo "System updated."
else
    echo "Skipping system update."
fi

# Essential dependencies
echo "Installing essential dependencies..."
sudo pacman -S --needed --noconfirm python python-pip base-devel nano git wget curl bash-completion

# yay (AUR helper)
echo "Checking for yay..."
if ! command -v yay >/dev/null 2>&1; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit 1
    makepkg -si --noconfirm
    cd - >/dev/null
    rm -rf /tmp/yay
else
    echo "yay is already installed."
fi

# Desktop environment (optional)
clear
figlet "Display Manager"

if prompt_yes_no "Do you want to install a desktop environment?"; then
    echo "Choose your display manager:"
    echo "  1. KDE Plasma"
    echo "  2. GNOME"
    echo "  3. XFCE4"
    echo "  4. Hyprland"
    echo "  0. Skip"
    read -r dm_choice
    case "$dm_choice" in
        1)
            sudo pacman -S --noconfirm plasma kde-applications sddm
            sudo systemctl enable sddm.service --force
            ;;
        2)
            sudo pacman -S --noconfirm gnome gnome-extra gdm
            sudo systemctl enable gdm.service --force
            ;;
        3)
            sudo pacman -S --noconfirm xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
            sudo systemctl enable lightdm.service --force
            ;;
        4)
            sudo pacman -S --noconfirm gdm hyprland hyprpaper hyprpicker waybar wlogout grimblast grim slurp \
                xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal-kde \
                xdg-desktop-portal-gnome xdg-desktop-portal-x11 xdg-desktop-portal-wayland xdg-desktop-portal-sway \
                wlroots wayland-protocols gtk-layer-shell qt6-wayland
            sudo systemctl enable gdm.service --force
            ;;
        0)
            echo "Skipping desktop environment installation."
            ;;
        *)
            echo "Invalid choice. Skipping desktop environment installation."
            ;;
    esac
else
    echo "Skipping desktop environment installation."
fi

# Useful CLI tools
echo "Installing additional packages..."
sudo pacman -S --needed --noconfirm fastfetch htop ranger nmap openssh openssl rsync unzip zip tar gzip bzip2 xz p7zip ffmpeg imagemagick vlc 

# --- Preload (AUR) ---
echo "Installing preload from AUR..."
if ! pacman -Qi preload >/dev/null 2>&1; then
    yay -S --noconfirm preload
else
    echo "preload is already installed."
fi

echo "Enabling preload service..."
sudo systemctl enable --now preload.service

# --- Plymouth (AserDev Theme) ---
echo "Installing AserDev Plymouth theme..."
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/aserdev-yt/aserdev-plymouth-theme/main/install-arch.sh)"

# --- Optional: Set GRUB Theme ---
if [ -f /etc/default/grub ]; then
    if prompt_yes_no "Do you want to set a GRUB theme?"; then
        echo "Setting GRUB theme..."
        # Example: Place your GRUB theme setup commands here
        # sudo cp -r /path/to/theme /boot/grub/themes/
        # sudo sed -i 's|^#GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/mytheme/theme.txt"|' /etc/default/grub
        # sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo "Please add your GRUB theme setup commands in the script."
        git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes
        cd Top-5-Bootloader-Themes
        sudo ./install.sh
    fi
fi

# --- Fastfetch and Figlet Logo Section ---
echo "Installing fastfetch..."
if ! command -v fastfetch >/dev/null 2>&1; then
    if pacman -Si fastfetch >/dev/null 2>&1; then
        sudo pacman -S --noconfirm fastfetch
    else
        yay -S --noconfirm fastfetch
    fi
else
    echo "fastfetch is already installed."
fi

echo "Creating AserDev logo with figlet for fastfetch..."
LOGO_FILE="$HOME/.config/fastfetch/aserdev-logo.txt"
mkdir -p "$(dirname "$LOGO_FILE")"
figlet "AserDev" > "$LOGO_FILE"
echo "Logo saved to $LOGO_FILE"

echo "Generating fastfetch config..."
fastfetch --gen-config

# Add logo to fastfetch config
CONFIG_FILE="$HOME/.config/fastfetch/config.jsonc"
if [ -f "$CONFIG_FILE" ]; then
    if grep -q '"logo":' "$CONFIG_FILE"; then
        sed -i "s|\"logo\":.*|\"logo\": \"$LOGO_FILE\",|" "$CONFIG_FILE"
    else
        sed -i "1s|{|{\"logo\": \"$LOGO_FILE\",|" "$CONFIG_FILE"
    fi
    echo "Configured fastfetch to use your custom logo."
else
    echo "Warning: Fastfetch config not found at $CONFIG_FILE"
fi

add_fastfetch_to_shell

echo "You can use this logo in fastfetch with:"
echo "  fastfetch --logo \"$LOGO_FILE\""

echo "Installation completed successfully!"
if prompt_yes_no "Reboot your system to apply changes?"; then
    sudo reboot
else
    echo "You can reboot your system later."
fi