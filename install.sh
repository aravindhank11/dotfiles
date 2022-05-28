#!/bin/bash

check_pkgs()
{
    pkgs=$@
    for pkg in $pkgs
    do
        if [[ $(dpkg -l | grep $pkg | wc -l) -eq 0 ]]; then
            echo "$pkg is unavailable. Install it with:"
            echo "  sudo apt install $pkg"
            exit 1
        fi
    done
}

# Pre-dependency check
check_pkgs curl wget git fonts-powerline taskwarrior

################################## VIM ##########################################

# Link vimrc
ln -sf $(pwd)/vimrc ~/.vimrc

# Download PlugInstall
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Plugins
vim -E -c PlugInstall -c q -c w -c q

################################## BASH ##########################################

# Ref: https://www.ditig.com/256-colors-cheat-sheet for colors
# Ref: https://unix.stackexchange.com/a/124409
# Link bashrc
sed -i "s|. $(pwd)/bashrc||g" ~/.bashrc
echo ". $(pwd)/bashrc" >> ~/.bashrc
