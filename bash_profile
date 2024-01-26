# Rebuilds the ssh auth socket info file
rebuild_sockinfo () {
  env | grep SSH_AUTH_SOCK | sed 's,$,; export SSH_AUTH_SOCK,' > ~/.sock_info
}

# Setup the auth sock, for later user
timeout 2 ssh-add -l > /dev/null 2>&1
if [ $? -eq 0 ] ; then
  rebuild_sockinfo
fi

# Setup our X11 forwarding variables
env | egrep '(DISPLAY|XDG_SESSION_COOKIE)' > ~/.x11-env
echo "export DISPLAY XDG_SESSION_COOKIE" >> ~/.x11-env

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
