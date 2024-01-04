#!/bin/bash

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install:
## Common tools
brew install wget git git-gui htop tmux zsh vim editorconfig jq
## Specific tools
brew install derailed/k9s/k9s
## Language bits
brew install fnm pyenv
brew install --cask p4v

# Git config
git config --global user.name "Darrell Mozingo"
git config --global user.email "darrell@mozingo.net"
git config --global init.defaultBranch main
git config --global commit.gpgsign true

git config --global merge.tool p4merge
git config --global mergetool.p4merge.path /Applications/p4merge.app/Contents/MacOS/p4merge
git config --global mergetool.p4merge.trustExitCode false
git config --global mergetool.keepBackup false

# Vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -Fsv ~/.dotfiles/.vimrc ~
vim +PluginInstall

# Zsh setup
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f ~/.zshrc
ln -sv ~/.dotfiles/.zshrc ~
ln -sv ~/.dotfiles/.work-commands.zshrc ~
git update-index --assume-unchanged ~/.dotfiles/.work-commands.zshrc # don't track future changes

# tmux setup
ln -sv ~/.dotfiles/.tmux.conf ~

