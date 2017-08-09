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
  unset aws_access_key_id aws_secret_access_key aws_session_token AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}

refresh_sts_creds () {
  if [ "$MFA_SERIAL" = "" ] ; then
    echo "MFA_SERIAL not set"
    return 2
  fi

  clear_sts_creds # You can't use tokens to get tokens, so start clean
  echo -n "MFA Code: "
  read MFA_TOKEN

  CREDS=$(aws sts get-session-token --duration-seconds 3600 --serial-number $MFA_SERIAL --token-code $MFA_TOKEN)

  unset MFA_TOKEN
  if [ $? -eq 0 ] ; then
    AWS_ACCESS_KEY_ID=$(echo "$CREDS" | jq -r .Credentials.AccessKeyId)
    AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | jq -r .Credentials.SecretAccessKey)
    AWS_SESSION_TOKEN=$(echo "$CREDS" | jq -r .Credentials.SessionToken)
    aws_access_key_id=$AWS_ACCESS_KEY_ID
    aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
    aws_session_token=$AWS_SESSION_TOKEN
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  fi
  unset CREDS

  return 0
}

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
