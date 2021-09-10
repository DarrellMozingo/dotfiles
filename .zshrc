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

source $ZSH/oh-my-zsh.sh

extra_includes=(
  "$HOME/.work-commands.zshrc"
  "/usr/local/bin/aws_zsh_completer.sh"
  "$HOME/.google-cloud-sdk/path.zsh.inc"
  "$HOME/.google-cloud-sdk/completion.zsh.inc"
)

for include in "${extra_includes[@]}"; do
  [ -s $include ] && source $include
done

alias http-here='echo http://$(hostname):1337 && python -m http.server 1337'

# `--no-run-if-empty` needed on xargs for Linux (defaults to that on Mac?)
alias git-clean='git fetch && git branch --merged | grep -Ev "master|main|develop|stable" | xargs git branch -d && git remote prune origin'

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

# dotnet tooling
export PATH="$PATH:$HOME/.dotnet/tools:/usr/local/share/dotnet"

# golang tooling
export PATH="$PATH:/usr/local/go/bin"

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
if which fnm > /dev/null; then
  eval "$(fnm env)"

  function __fnm_on_cd() {
    [[ -f "./.nvmrc" ]] && fnm use
  }
  chpwd_functions=(${chpwd_functions[@]} "__fnm_on_cd")
  __fnm_on_cd
fi

# Kubectl autocomplete
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

