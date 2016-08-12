#!/bin/bash

sudo apt-get update \
  && sudo apt-get install -y git curl vim tmux zsh
  
git config --global user.name "Darrell Mozingo"
git config --global user.email "darrell@mozingo.net"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -sv ~/.dotfiles/.vimrc ~
ln -sv ~/.dotfiles/.zshrc ~
ln -sv ~/.dotfiles/.tmux.conf ~
vim +PluginInstall

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
