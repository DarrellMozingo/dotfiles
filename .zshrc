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

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

work_specific_commands=~/.work-commands.zshrc
[ -s $work_specific_commands ] && source $work_specific_commands

aws_completer=/usr/local/bin/aws_zsh_completer.sh
[ -s $aws_completer ] && source $aws_completer

alias http-here='echo http://$(hostname):1337 && python -m http.server 1337'

# `--no-run-if-empty` needed on xargs for Linux (defaults to that on Mac?)
alias git-clean='git fetch && git branch --merged | grep -v master | xargs git branch -d && git remote prune origin'

# Tag prompt with various activated tools
original_prompt=$PS1
precmd() { # equivalent of bash PROMPT_COMMAND
  tags=""

  if [ "$AWS_PROFILE" ]; then
    tags="(aws) $tags"
  fi

  if [ "$VIRTUAL_ENV" ]; then
    tags="(venv) $tags"
  fi

  PS1=${tags}${original_prompt}
}

#### mac shite:
  # Export gmake (from `brew install make`) as make on mac (so it's newer than 3.8.1, supporting .ONESHELL)
  PATH="/usr/local/opt/make/libexec/gnubin:$PATH"

  # For compilers to find zlib (for eg `pyenv install`):
  export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
  export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"

  # For pkg-config to find zlib (for eg `pyenv install`):
  export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"
####

# Ruby version manager
export PATH="$HOME/.rbenv/bin:$PATH"
[ -d "$HOME/.rbenv" ] && eval "$(command rbenv init -)"

# Python version manager
export PATH="$HOME/.pyenv/bin:$PATH"
[ -d "$HOME/.pyenv" ] && eval "$(command pyenv init -)"
[ -d "$HOME/.pyenv" ] && eval "$(command pyenv virtualenv-init -)"

# Java version management
if [ -s "$HOME/.jabba/jabba.sh" ]; then
  source "$HOME/.jabba/jabba.sh"

  function __jabba_on_cd() {
    [[ -f "./.jabbarc" ]] && echo "\n☕️⚡️ Setting Jabba JDK from .jabbarc in $PWD: $(cat .jabbarc | tr -d "\n")" && jabba use
  }
  chpwd_functions=(${chpwd_functions[@]} "__jabba_on_cd")

  # If the shell loads in a .jabbarc folder
  [[ -f "./.jabbarc" ]] && __jabba_on_cd
fi

# Node version manager
export NVM_DIR="$HOME/.nvm"

NVM_SCRIPT="$(brew --prefix nvm)/nvm.sh"  # Linux: NVM_SCRIPT="$NVM_DIR/nvm.sh"

if [ -s $NVM_SCRIPT ]; then
  source $NVM_SCRIPT

  function __nvmrc_on_cd() {
    [[ -f "./.nvmrc" ]] && nvm use
  }
  chpwd_functions=(${chpwd_functions[@]} "__nvmrc_on_cd")

  # If the shell loads in an .nvmrc folder
  [[ -f "./.nvmrc" ]] && __nvmrc_on_cd
fi

# NVM is pretty slow to load. This defers it until needed, but ran into problems integrating w/above cd change
# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .zshrc gets sourced multiple times
# by checking whether __init_nvm is a function. Original init code that's slow:
#    export NVM_DIR="$HOME/.nvm"
#    source "$NVM_DIR/nvm.sh"
#if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(whence -w __init_nvm)" = function ]; then
#  export NVM_DIR="$HOME/.nvm"
#  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
#  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
#  function __init_nvm() {
#    for i in "${__node_commands[@]}"; do unalias $i; done
#    . "$NVM_DIR"/nvm.sh
#    unset __node_commands
#    unset -f __init_nvm
#  }
#  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
#fi

