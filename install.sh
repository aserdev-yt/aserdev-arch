#!/bin/sh

# This script installs figlet on Arch Linux using pacman
sudo pacman -Sy figlet --needed --noconfirm

figlet "Installation!"

echo "do you want to update your system before installation? (y/n)"
read update
if [ "$update" = "y" ]; then
    sudo pacman -Syu --noconfirm
    echo "System updated successfully!"
else
    echo "Skipping system update."
fi



