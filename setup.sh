#!/bin/bash

sudo apt-get update \
  && sudo apt-get install -y vim tmux zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -sv ~/.dotfiles/.vimrc ~
ln -sv ~/.dotfiles/.zshrc ~
ln -sv ~/.dotfiles/.tmux.conf ~
vim +PluginInstall
