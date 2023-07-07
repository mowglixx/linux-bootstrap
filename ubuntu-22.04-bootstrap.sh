#!/bin/bash

pauseForReboot() {
  read -p 'Press [Enter] to reboot'
}

echo 'Please enter password for admin'
sudo echo 'OK!'

echo 'generate a new ssh key'
ssh-keygen

sudo apt update
sudo apt upgrade -y

echo ' '
echo ' '
echo '###################################'
echo '         Installing Basics'
echo '###################################'
echo ' '
echo ' '

sudo apt install -y vlc curl wget build-essential zsh git \
  vanilla-gnome-desktop vanilla-gnome-default-settings \
  zip apt-transport-https software-properties-common \
  gpg ca-certificates gnupg2 ubuntu-keyring

echo ' '
echo ' '
echo '###################################'
echo '         Installing Utils'
echo '###################################'
echo ' '
echo ' '

# install mainline
sudo add-apt-repository -y ppa:cappelikan/ppa

# Install VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Install Googe Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo rm google-chrome-stable_current_amd64.deb

# Install Node JS
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Install Insomnia
echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" | sudo tee -a /etc/apt/sources.list.d/insomnia.list

# Actual installers
sudo apt update && sudo apt upgrade -y
sudo apt install -y mainline code nodejs insomnia flatpak gnome-tweaks

# Flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.mattjakeman.ExtensionManager
flatpak install flathub com.github.tchx84.Flatseal

#  Snaps
sudo snap install discord

# update to latest kernel
export VERBOSE=0
sudo mainline --install-latest --yes && sudo mainline --uninstall-old --yes

echo '###################################'
echo '         Install Complete!'
echo '###################################'

pauseForReboot

sudo reboot
return 0
