source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/prompt
source ~/.bash/aws_functions
source ~/.bash/python
source ~/.bash/putty
source ~/.bash/ssh
#source ~/.bash/paths
#source ~/.bash/config

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=50000

# LANG is the default, with overrides allowed via other LC_* env vars.  See:
# https://superuser.com/a/392466
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_TIME=C.UTF-8 # UTC 24-hour clock

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

if [ -f ~/.sock_info ]; then
  source ~/.sock_info
fi

# Python local stuff
if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.rbenv" ] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
else
  # RVM junk - this should be the last line of the file
  [[ -s "/usr/local/lib/rvm" ]] && . "/usr/local/lib/rvm"
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -d "$HOME/.yarn/bin" ] && export PATH="$HOME/.yarn/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
