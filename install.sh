#!/bin/bash

dir=$(dirname $0 | xargs -I{} realpath {})

check_pkgs()
{
    pkgs=$@
    for pkg in $pkgs
    do
        if [[ $(dpkg -l | grep $pkg | grep -v ^rc | wc -l) -eq 0 ]]; then
            echo "$pkg is unavailable. Install it with:"
            echo "  sudo apt install $pkg"
            exit 1
        fi
    done
}

# Pre-dependency check
pkgs="curl wget git fonts-powerline libsecret-tools"
#sudo apt install -y $pkgs
#check_pkgs $pkgs

################################## VIM ##########################################

# Link vimrc
ln -sf ${dir}/vimrc ~/.vimrc

# Download PlugInstall
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Plugins
vim -E -c PlugInstall -c q -c w -c q

################################## BASH ##########################################

# Ref: https://www.ditig.com/256-colors-cheat-sheet for colors
# Ref: https://unix.stackexchange.com/a/124409
# Link termrc
if [[ $SHELL == *zsh*  ]]; then
    TERMRC=~/.zshrc
else
    TERMRC=~/.bashrc
fi

sed -i"" -e "s|. ${dir}/termrc||g" ${TERMRC}
echo ". ${dir}/termrc" >> ${TERMRC}

############################### LEET CODE ########################################
if [[ $1 == "-l" ]]; then
    check_pkgs node
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
    . ${TERMRC}
    nvm install --lts
    npm install -g leetcode-cli
    leetcode plugin -i cookie.chrome
fi

############################### TMUX CONF ########################################
mkdir -p  ~/.tmux/plugins/
rm -rf ~/.tmux/plugins/tpm
ln -sf ${dir}/tpm ~/.tmux/plugins/tpm
ln -sf ${dir}/tmux.conf.local ~/.tmux.conf
#~/.tmux/plugins/tpm/tpm
