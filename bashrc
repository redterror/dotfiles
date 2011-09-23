source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/prompt
#source ~/.bash/paths
#source ~/.bash/config

if [ -d "$HOME/.rbenv" ] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

if [ -f ~/.sock_info ]; then
  source ~/.sock_info
fi
