#!/bin/bash

FILE="/tmp/bench_$(date +%Y%m%d_%H%M%S)"
TOKEN="xoxp-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
CHANNEL="#share_env"

sudo ssh ansible.kanakomi.com "bash /usr/local/bin/bench-wrapper.sh $1" > $FILE
curl -F file=@$FILE -F content="text" -F channels=$CHANNEL  -F token=${TOKEN} https://slack.com/api/files.upload
