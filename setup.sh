#!/bin/bash

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -sv ~/.dotfiles/.vimrc ~
ln -sv ~/.dotfiles/.zshrc ~
vim +PluginInstall
