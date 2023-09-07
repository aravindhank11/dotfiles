# VIM AND BASHRC

## Clone the repo
```
[SSH]
git clone --recursive git@github.com:aravindhank11/dotfiles.git

(or)

[HTTPS]
git clone --recursive https://github.com/aravindhank11/dotfiles.git


cd dotfiles
```

## Install Pre-requisites
```
sudo apt install -y wget git curl fonts-powerline
```

## Setting up a pretty Terminal
* Ref: https://mayccoll.github.io/Gogh/ and install "Argonaut" theme

Press `8` to install Argonaut theme when prompted
```
bash -c  "$(wget -qO- https://git.io/vQgMr)"
```

### Install vimrc and termrc
```
./install.sh
```

### Make it take effect
```
if [[ $SHELL = *zsh* ]]; then source ~/.zshrc; else source ~/.bashrc; fi
```
