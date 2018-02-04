# Speed debugging tips: http://jb-blog.readthedocs.io/en/latest/posts/0032-debugging-zsh-startup-time.html

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

TRAPINT() { # display character when canceling commands, like bash does
  print -n "^C"
  return $(( 128 + $1 ))
}

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
export EDITOR=vim
export OPSCODE_USER=dmozingo

source $ZSH/oh-my-zsh.sh

work_specific_commands=~/.work-commands.zshrc
[ -s $work_specific_commands ] && source $work_specific_commands

alias rdesktop='rdesktop -g 1024x768 -5 -K -r clipboard:CLIPBOARD'
alias http-here='echo http://$(hostname -I | cut -d" " -f 1):1337 && python -m SimpleHTTPServer 1337'
alias kp='kpcli --kdb ~/Dropbox/Finances/Passwords.kdbx'

# Change prompt if AWS session is available
original_prompt=$PS1
precmd() { # equivalent of bash PROMPT_COMMAND
  if [ "$AWS_SESSION_TOKEN" ]; then
    PS1="(aws-session) $original_prompt"
  else
    PS1=$original_prompt
  fi
}

export PATH="$HOME/.rbenv/bin:$PATH"
[ -d "$HOME/.rbenv" ] && eval "$(command rbenv init -)"

export PATH="$HOME/.pyenv/bin:$PATH"
[ -d "$HOME/.pyenv" ] && eval "$(command pyenv init -)"
[ -d "$HOME/.pyenv" ] && eval "$(command pyenv virtualenv-init -)"

export SDKMAN_DIR="$HOME/.sdkman"
[ -d "$HOME/.sdkman" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .zshrc gets sourced multiple times
# by checking whether __init_nvm is a function. Original init code that's slow:
#    export NVM_DIR="$HOME/.nvm"
#    source "$NVM_DIR/nvm.sh"
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(whence -w __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi
