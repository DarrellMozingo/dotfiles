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
# Plugins disabled for faster startup - git aliases defined manually below
plugins=()

TRAPINT() { # display character when canceling commands, like bash does
  print -n "^C"
  return $(( 128 + $1 ))
}

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
export EDITOR=vim

source $ZSH/oh-my-zsh.sh

# Load work commands immediately (assumed to be lightweight)
[ -s "$HOME/.work-commands.zshrc" ] && source "$HOME/.work-commands.zshrc"

# Google Cloud SDK - load paths immediately, defer completions
[ -s "$HOME/.google-cloud-sdk/path.zsh.inc" ] && source "$HOME/.google-cloud-sdk/path.zsh.inc"

# Lazy load expensive completions
if [ -s "/usr/local/bin/aws_zsh_completer.sh" ]; then
  aws() {
    unfunction aws
    source "/usr/local/bin/aws_zsh_completer.sh"
    aws "$@"
  }
fi

if [ -s "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then
  gcloud() {
    unfunction gcloud
    source "$HOME/.google-cloud-sdk/completion.zsh.inc"
    gcloud "$@"
  }
fi

alias http-here='echo http://$(hostname):1337 && python -m http.server 1337'

# https://aria2.github.io
alias torrent='aria2c'

# `--no-run-if-empty` needed on xargs for Linux (defaults to that on Mac?)
alias git-clean='git fetch && git branch --merged | grep -Ev "master|main|develop|stable" | xargs git branch -d && git remote prune origin'

# Tag prompt with various activated tools
original_prompt=$PS1
precmd() { # equivalent of bash PROMPT_COMMAND
  tags=""

  if [ "$AWS_SESSION_TOKEN" ]; then
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

# rust tooling
export PATH="$PATH:$HOME/.cargo/bin"

#### mac shite:
  # Homebrew paths - set manually to avoid expensive 'brew shellenv' on every startup
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

  # Export gmake (from `brew install make`) as make on mac (so it's newer than 3.8.1, supporting .ONESHELL)
  PATH="/usr/local/opt/make/libexec/gnubin:$PATH"

  # For compilers to find zlib (for eg `pyenv install`):
  export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
  export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"

  # For pkg-config to find zlib (for eg `pyenv install`):
  export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"
####

# Python version manager - lazy loaded
export PATH="$HOME/.pyenv/bin:$PATH"
if [ -d "$HOME/.pyenv" ]; then
  pyenv() {
    unfunction pyenv
    eval "$(command pyenv init --path)"
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    pyenv "$@"
  }
fi

# Java version management
if [ -s "$HOME/.jabba/jabba.sh" ]; then
  source "$HOME/.jabba/jabba.sh"

  function __jabba_on_cd() {
    if [[ -f "./.jabbarc" ]]; then
      echo "\n☕️⚡️ Setting Jabba JDK from .jabbarc in $PWD: $(cat .jabbarc)"
      jabba use
    fi
  }
  chpwd_functions+=(__jabba_on_cd)

  # If the shell loads in a .jabbarc folder
  [[ -f "./.jabbarc" ]] && __jabba_on_cd
fi

# Node version manager - lazy loaded
export PATH="$HOME/.local/share/fnm:$PATH"
if command -v fnm > /dev/null 2>&1; then
  fnm() {
    unfunction fnm
    eval "$(command fnm env --use-on-cd)"
    fnm "$@"
  }

  node() {
    unfunction fnm node npm npx
    eval "$(command fnm env --use-on-cd)"
    node "$@"
  }

  npm() {
    unfunction fnm node npm npx
    eval "$(command fnm env --use-on-cd)"
    npm "$@"
  }

  npx() {
    unfunction fnm node npm npx
    eval "$(command fnm env --use-on-cd)"
    npx "$@"
  }
fi

# Kubectl autocomplete - lazy loaded for faster startup
if [[ $commands[kubectl] ]]; then
  kubectl() {
    unfunction kubectl
    source <(command kubectl completion zsh)
    kubectl "$@"
  }
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Google Cloud SDK already loaded via extra_includes array above (lines 34-35)

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/darrell/.docker/completions $fpath)

# Optimized compinit - only regenerate dump once per day
autoload -Uz compinit
setopt EXTENDEDGLOB
for dump in ${HOME}/.zcompdump(#qN.mh+24); do
  compinit
  if [[ -s "$dump" && (! -s "${dump}.zwc" || "$dump" -nt "${dump}.zwc") ]]; then
    zcompile "$dump"
  fi
done
unsetopt EXTENDEDGLOB
compinit -C
# End of Docker CLI completions

# Added by Antigravity
export PATH="/Users/darrell/.antigravity/antigravity/bin:$PATH"
