# Setup the auth sock, for later user
ssh-add -l > /dev/null 2>&1
if [ $? -eq 0 ] ; then
  env | grep SSH_AUTH_SOCK | sed 's,$,; export SSH_AUTH_SOCK,' > ~/.sock_info
fi

export EDITOR=vim
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
