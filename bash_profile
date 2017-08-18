# Rebuilds the ssh auth socket info file
rebuild_sockinfo () {
  env | grep SSH_AUTH_SOCK | sed 's,$,; export SSH_AUTH_SOCK,' > ~/.sock_info
}

# Setup the auth sock, for later user
ssh-add -l > /dev/null 2>&1
if [ $? -eq 0 ] ; then
  rebuild_sockinfo
fi

# Setup our X11 forwarding variables
env | egrep '(DISPLAY|XDG_SESSION_COOKIE)' > ~/.x11-env
echo "export DISPLAY XDG_SESSION_COOKIE" >> ~/.x11-env

# AWS MFA / Temp credential helpers
clear_sts_creds () {
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}

refresh_sts_creds () {
  if [ "$MFA_SERIAL" = "" ] ; then
    echo "MFA_SERIAL not set"
    return 2
  fi

  clear_sts_creds # You can't use tokens to get tokens, so start clean

  if [ "$MFA_SERIAL" != "none" ] ; then
    echo -n "MFA Code: "
    read MFA_TOKEN

    CREDS=$(aws sts get-session-token --duration-seconds ${MFA_TTL:-3600} --serial-number $MFA_SERIAL --token-code $MFA_TOKEN \
              --output text --query 'Credentials.[AccessKeyId, SecretAccessKey, SessionToken]')
  else
    CREDS=$(aws sts get-session-token --duration-seconds ${MFA_TTL:-3600} \
              --output text --query 'Credentials.[AccessKeyId, SecretAccessKey, SessionToken]')
  fi

  unset MFA_TOKEN
  if [ $? -eq 0 ] ; then
    AWS_ACCESS_KEY_ID=$(echo "$CREDS" | awk '{print $1}')
    AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | awk '{print $2}')
    AWS_SESSION_TOKEN=$(echo "$CREDS" | awk '{print $3}')
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  fi
  unset CREDS

  return 0
}

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
