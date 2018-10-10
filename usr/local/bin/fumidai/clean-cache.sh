#!/bin/bash
#set -x
LIST=/tmp/uri.list
SERVER=127.0.0.1

cat /var/log/nginx/access.log | grep /icons/| awk '/GET/{print $7}' | sort | uniq > $LIST

for list in $(cat $LIST) ;do
  curl http://$SERVER/$list -o /dev/null -s
done
