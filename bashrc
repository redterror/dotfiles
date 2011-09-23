source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/prompt
#source ~/.bash/paths
#source ~/.bash/config

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

if [ -f ~/.sock_info ]; then
  source ~/.sock_info
fi

if [ -d "$HOME/.rbenv" ] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
else
  # RVM junk - this should be the last line of the file
  [[ -s "/usr/local/lib/rvm" ]] && . "/usr/local/lib/rvm"
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

