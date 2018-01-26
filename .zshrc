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
eval "$(command rbenv init -)"

export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(command pyenv init -)"
eval "$(command pyenv virtualenv-init -)"

export SDKMAN_DIR="$HOME/.sdkman"
source "$HOME/.sdkman/bin/sdkman-init.sh"

