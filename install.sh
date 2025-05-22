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

echo "installing yay"

echo "do you have yay airady installed? (y/n) (important)"
read yay_installed

if [ "$yay_installed" = "y" ]; then
    echo "yay is already installed!"
else
    echo "yay is not installed, installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
    echo "yay installed successfully!"
fi


echo "installing fastfetch"
yay -S --needed --noconfirm fastfetch
echo "fastfetch installed successfully!"

echo "making a custom config file for fastfetch"

figlet ASER >> ~/ad
figlet Dev >> ~/ad

fastfetch -l ~/ad --gen-config-force

figlet "real installation"

echo "installing alot of packages"
echo "make sure you have internet connection (a good one)"

sudo pacman -S --needed --noconfirm base-devel git wget curl vim bash-completion 

sudo pacman -S --needed --noconfirm xorg-server xorg-xinit xorg-xsetroot xorg-xrandr xorg-xsetroot xorg-xkill xorg-xmodmap xorg-xinput xorg-xbacklight xorg-xdriinfo xorg-xev xorg-xprop xorg-xrandr xorg-xsetroot xorg-xkill xorg-xmodmap xorg-xinput xorg-xbacklight xorg-xdriinfo xorg-xev xorg-xprop

figlet "display manager"
echo "what display manager do you want to install?"
echo "1. gnome"
echo "2. kde"
echo "3. xfce4"
echo "4. hyprland (uses ml4w)"
read dm_choice

if [ "$dm_choice" = "1" ]; then
    sudo pacman -S --needed --noconfirm gdm gnome-shell gnome-tweaks gnome-terminal gnome-control-center gnome-software gnome-system-monitor gnome-disk-utility gnome-calculator gnome-screenshot gnome-sound-properties gnome-backgrounds gnome-font-viewer gnome-characters gnome-logs gnome-music gnome-photos gnome-weather
    sudo systemctl enable gdm.service --force
    echo "gnome display manager installed successfully!"
elif [ "$dm_choice" = "2" ]; then
    sudo pacman -S --needed --noconfirm sddm plasma-desktop plasma-wayland-session plasma-nm plasma-pa plasma-disks plasma-disks plasma-firewall plasma-systemmonitor plasma-thunderbolt plasma-vault plasma-workspace plasma-workspace-wallpapers
    sudo systemctl enable sddm.service --force
    echo "kde display manager installed successfully!"
elif [ "$dm_choice" = "3" ]; then
    sudo pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter xfce4-session xfce4-settings xfce4-panel xfce4-appfinder xfce4-terminal xfce4-diskperf-plugin xfce4-sensors-plugin xfce4-cpufreq-plugin xfce4-netload-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin
    sudo systemctl enable lightdm.service --force
    echo "xfce4 display manager installed successfully!"
elif [ "$dm_choice" = "4" ]; then
    bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/hyprland-starter/main/setup.sh)
    echo "hyprland display manager installed successfully!"
else
    echo "Invalid choice. Please run the script again."
fi

figlet "extra packages"

echo "do you want to install microsoft edge? (y/n)"
read edge_choice

if [ "$edge_choice" = "y" ]; then
    yay -S --needed --noconfirm microsoft-edge-stable-bin
    echo "microsoft edge installed successfully!"
else
    echo "skipping microsoft edge installation."
fi
echo "do you want to install vscode? (y/n)"
read vscode_choice
if [ "$vscode_choice" = "y" ]; then
    yay -S --needed --noconfirm visual-studio-code-bin
    echo "vscode installed successfully!"
else
    echo "skipping vscode installation."
fi
echo "do you want to install preload? (y/n)"
read preload_choice

if [ "$preload_choice" = "y" ]; then
    yay --needed --noconfirm preload
    echo "preload installed successfully!"
else
    echo "skipping preload installation."
fi

echo "do you want to install plymouth? (you will configure it by yourself) (y/n)"
read plymouth_choice
if [ "$plymouth_choice" = "y" ]; then
    sudo pacman -S --needed --noconfirm plymouth
    echo "plymouth installed successfully!"
else
    echo "skipping plymouth installation."
fi

echo "reboot? (y/n)"
read reboot_choice
if [ "$reboot_choice" = "y" ]; then
    sudo reboot
else
    echo "you can reboot later."
fi

