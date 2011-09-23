# Setup the auth sock, for later user
env | grep SSH_AUTH_SOCK | sed 's,$,; export SSH_AUTH_SOCK,' > ~/.sock_info

export EDITOR=vim
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
