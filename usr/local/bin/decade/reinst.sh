#!/bin/bash

set -x 
echo "CMD: $@ " >> /var/log/reinst.log

VM=$1
DIST=$2
PASSWD="XXXXXXXXX"
#KEY_ID="113000925445"
KEY_ID="113000943569"

#ARCHIVE_ID="113000423772"  # ubuntu16.04
if [ "$DIST" == "centos6" ] ;then
  ARCHIVE_ID="113000813348"
elif [ "$DIST" == "centos7" ] ;then
  ARCHIVE_ID="113000629234"
else
  ARCHIVE_ID="113000423772" #ubuntu16.04
fi

SERVER_ID=$(usacloud server list --name $VM | awk '/'"$VM"'/{print $2}')
DISK_ID=$(usacloud disk list --name $VM | awk '/'"$VM"'/{print $2}')
usacloud server stop -y $VM

## old disk remove
usacloud disk server-disconnect -y $DISK_ID
usacloud disk rm -y $DISK_ID

## add new disk
usacloud disk create --source-archive-id $ARCHIVE_ID --name $VM --plan ssd --connection virtio --size 20 -y
NEW_DISK_ID=$(usacloud disk list --name $VM | awk '/'"$VM"'/{print $2}')
usacloud disk server-connect --server-id $SERVER_ID -y $NEW_DISK_ID
## STARTUPスクリプトでSSH認証の設定を入れるように仕込む
usacloud disk config --hostname $VM --password $PASSWD  --ssh-key-ids $KEY_ID --disable-password-auth --note-ids 113000944001 -y $VM

# VM起動
usacloud server boot -y $VM


# rootログイン許可
#ssh ubuntu@$VM "sudo cp -Rfp /home/ubuntu/.ssh/ /root"
