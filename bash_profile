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
  unset aws_access_key_id aws_secret_access_key aws_session_token
}

refresh_sts_creds () {
  if [ "$MFA_SERIAL" = "" ] ; then
    echo "MFA_SERIAL not set"
    return 2
  fi

  clear_sts_creds # You can't use tokens to get tokens, so start clean

  if [ "$MFA_SERIAL" != "none" ] ; then
    echo -n "MFA Code: "
    read -s MFA_TOKEN
    echo

    CREDS=$(aws sts get-session-token --duration-seconds ${MFA_TTL:-3600} --serial-number $MFA_SERIAL --token-code $MFA_TOKEN \
              --output text --query 'Credentials.[AccessKeyId, SecretAccessKey, SessionToken]')
  else
    CREDS=$(aws sts get-session-token --duration-seconds ${MFA_TTL:-3600} \
              --output text --query 'Credentials.[AccessKeyId, SecretAccessKey, SessionToken]')
  fi

  if [ $? -eq 0 ] ; then
    AWS_ACCESS_KEY_ID=$(echo "$CREDS" | awk '{print $1}')
    AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | awk '{print $2}')
    AWS_SESSION_TOKEN=$(echo "$CREDS" | awk '{print $3}')
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
    echo "Token refreshed."
  fi
  unset MFA_TOKEN CREDS

  return 0
}

assume_role_mfa () {
  PROFILE_NAME=$1
  if [ "$PROFILE_NAME" = "" ] ; then
    echo "Usage: assume_role_mfa profile-name"
    return 2
  fi
  if [ "$MFA_SERIAL" = "" ] ; then
    echo "MFA_SERIAL not set"
    return 2
  fi

  if [ "$MFA_SERIAL" != "none" ] ; then
    echo -n "MFA Code: "
    read -s MFA_TOKEN
    echo
	fi

  clear_sts_creds
  role_arn=$(grep -A 1 "profile $PROFILE_NAME" < ~/.aws/config | grep role_arn | awk '{print $3}')
  role_session="cli-assume-role-mfa"
  ext_id=`whoami`@`hostname`
  CREDS=$(aws sts assume-role --role-arn $role_arn --role-session-name $role_session \
            --duration-seconds ${MFA_ROLE_TTL:-3600} \
            --serial-number $MFA_SERIAL --token-code $MFA_TOKEN --external-id "$ext_id" \
            --output text --query 'Credentials.[AccessKeyId, SecretAccessKey, SessionToken]')

  if [ $? -eq 0 ] ; then
    AWS_ACCESS_KEY_ID=$(echo "$CREDS" | awk '{print $1}')
    AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | awk '{print $2}')
    AWS_SESSION_TOKEN=$(echo "$CREDS" | awk '{print $3}')
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
    echo "Token refreshed for profile ${PROFILE_NAME}."
  fi
  unset MFA_TOKEN CREDS PROFILE_NAME

  return 0
}

# Adapted from http://blog.ryanparman.com/2014/01/29/easily-ssh-into-amazon-ec2-instances-using-the-name-tag/
function hostname_from_instance() {
  name=$1 ; shift
  aws ec2 describe-instances --filters "[{\"Name\":\"tag:Name\", \"Values\":[\"$name\"]}, {\"Name\":\"instance-state-name\", \"Values\":[\"running\"]}]" --query='Reservations[].Instances[0].PublicDnsName' $@ | jq -r .[]
}

function ip_from_instance() {
  name=$1 ; shift
  aws ec2 describe-instances --filters "[{\"Name\":\"tag:Name\", \"Values\":[\"$name\"]}, {\"Name\":\"instance-state-name\", \"Values\":[\"running\"]}]" --query='Reservations[].Instances[0].PublicIpAddress' $@ | jq -r .[]
}

function ip_from_instance_id() {
  ids=$1 ; shift
  aws ec2 describe-instances --instance-ids $ids --filters "[{\"Name\":\"instance-state-name\", \"Values\":[\"running\"]}]" --query='Reservations[].Instances[0].PublicIpAddress' $@ | jq -r .[]
}

function ssh-aws() {
  ssh $(ip_from_instance $@ | head -1)
}

function ssh-aws-id() {
  ssh $(ip_from_instance_id $@ | head -1)
}

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
