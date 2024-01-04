#!/bin/bash

sudo apt-get update \
  && sudo apt-get install -y curl vim tmux zsh

git config --global user.name "Darrell Mozingo"
git config --global user.email "darrell@mozingo.net"
git config --global commit.gpgsign true

git config --global merge.tool p4merge
git config --global mergetool.p4merge.cmd 'p4merge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
git config --global mergetool.p4mergetool.trustExitCode false
git config --global mergetool.keepBackup false

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -sv ~/.dotfiles/.vimrc ~
vim +PluginInstall

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f ~/.zshrc
ln -sv ~/.dotfiles/.zshrc ~
ln -sv ~/.dotfiles/.work-commands.zshrc ~
git update-index --assume-unchanged ~/.dotfiles/.work-commands.zshrc # don't track future changes

ln -sv ~/.dotfiles/.tmux.conf ~

echo "Get p4merge from http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools"
