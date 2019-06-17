#!/bin/bash

sudo xcodebuild -license

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install wget git htop tmux zsh vim
brew cask install p4v

git config --global user.name "Darrell Mozingo"
git config --global user.email "darrell@mozingo.net"

git config --global merge.tool p4merge
git config --global mergetool.p4merge.cmd 'p4merge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
git config --global mergetool.p4mergetool.trustExitCode false
git config --global mergetool.keepBackup false

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -Fsv ~/.dotfiles/.vimrc ~
vim +PluginInstall

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f ~/.zshrc
ln -sv ~/.dotfiles/.zshrc ~
ln -sv ~/.dotfiles/.work-commands.zshrc ~
git update-index --assume-unchanged ~/.dotfiles/.work-commands.zshrc # don't track future changes

ln -sv ~/.dotfiles/.tmux.conf ~
