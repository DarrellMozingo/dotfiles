#!/bin/bash

sudo apt-get update \
  && sudo apt-get install -y curl vim tmux zsh

git config --global user.name "Darrell Mozingo"
git config --global user.email "darrell@mozingo.net"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -sv ~/.dotfiles/.vimrc ~
vim +PluginInstall

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f ~/.zshrc
ln -sv ~/.dotfiles/*.zshrc ~
git update-index --assume-unchanged ~/.dotfiles/.work-commands.zshrc # don't track future changes

ln -sv ~/.dotfiles/.tmux.conf ~
