#!/bin/sh

#set -x



## Running User Check
if [ $(id -u) -ne 0 ] ;then
  echo "==> Please Using : sudo bash $(pwd)/$0"
  exit 1
fi


## Public Key
[ -d /root/.ssh ] || mkdir /root/.ssh

if [ -f /root/.ssh/authorized_keys ] ;then
  echo "==> Already Setting /root/.ssh/authorized_keys. Now Setting is......."
  echo --------------------------------------------------------------------------
  cat /root/.ssh/authorized_keys
  echo --------------------------------------------------------------------------
fi

cat << EOF >> /root/.ssh/authorized_keys
ssh-rsa 
EOF

chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

## SSH setting (root login)
SSH_PATH="/etc/ssh/sshd_config"
PERMIT_ROOT=$(grep ^PermitRootLogin $SSH_PATH | awk '{print $2}')
if [ "$PERMIT_ROOT" = "no" ] ;then
  echo "==> [$SSH_PATH]  s/PermitRootLogin no/PermitRootLogin without-password/g"
  sed -i -e 's/PermitRootLogin no/PermitRootLogin without-password/g' $SSH_PATH
elif [ "$PERMIT_ROOT" = "yes" -o  "$PERMIT_ROOT" = "prohibit-password" -o "$PERMIT_ROOT" = "without-password" ]  ;then
  echo "==> [$SSH_PATH]  Now Setting is Good"
else
  echo "==> [$SSH_PATH]  WARNIG!!!! Plase Check!"
fi
