export ZSH=~/.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

TRAPINT() { # display character when canceling commands, like bash does
  print -n "^C"
    return $(( 128 + $1 ))
}

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/packer"

source $ZSH/oh-my-zsh.sh

alias rdesktop='rdesktop -g 1024x768 -5 -K -r clipboard:CLIPBOARD'
alias http-here='echo http://$(hostname -I | cut -d" " -f 1):1337 && python -m SimpleHTTPServer 1337'
alias kp='kpcli --kdb ~/Dropbox/Finances/Passwords.kdbx'
. ~/.work-commands.zshrc  # Work specific commands

export EDITOR=vim

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

