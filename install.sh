#!/bin/sh
set -e

# ...existing code...

# Use a file for figlet output
FIGLET_FILE="$HOME/ad.txt"
figlet ASER > "$FIGLET_FILE"
figlet Dev >> "$FIGLET_FILE"

# Check fastfetch options
fastfetch --logo "$FIGLET_FILE" --gen-config-force

# Fix yay install command for preload
if [ "$preload_choice" = "y" ]; then
    yay -S --needed --noconfirm preload
    echo "preload installed successfully!"
else
    echo "skipping preload installation."
fi

# Remove duplicate packages in pacman commands
sudo pacman -S --needed --noconfirm xorg-server xorg-xinit xorg-xsetroot xorg-xrandr xorg-xkill xorg-xmodmap xorg-xinput xorg-xbacklight xorg-xdriinfo xorg-xev xorg-xprop

# ...existing code...