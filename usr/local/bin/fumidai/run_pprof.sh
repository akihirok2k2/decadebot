#!/bin/bash

## info
# this shell is blocking intaractive shell until 30sec

## require
# apt install graphviz

GOBIN_PATH=/home/isucon/isubata/webapp/go/isubata
OUT_PATH=/tmp/pprof_profile.png
YOMI_PATH=`dirname "${0}"`/./postimg4slack_tmi8
go tool pprof -png -output ${OUT_PATH} ${GOBIN_PATH} http://localhost:6060/debug/pprof/profile
go tool pprof -list main `ls -1t /root/pprof/* | head -1`
${YOMI_PATH} ${OUT_PATH}