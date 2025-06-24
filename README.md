# aserdev-arch
my post install script for arch-linux


## instructions

### download the iso

first download the latest arch iso

from here

https://archlinux.org/download/

### installation

install arch linux like you would normally 

https://wiki.archlinux.org/title/Installation_guide

or use an automated script like "archinstall"

```zsh
sudo pacman -Sy archinstall
```
```zsh
archinstall
```


## after you finish installation 

### reboot
```zsh
reboot
```
### after rebooting install curl

```zsh
sudo pacman -Syu curl --noconfirm
```

### run the installer

```zsh
 https://raw.githubusercontent.com/aserdev-yt/aserdev-arch/refs/heads/main/install.sh
```
