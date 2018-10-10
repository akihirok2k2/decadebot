#!/bin/bash

VM=$1
ACT=$2
if [ "$ACT" == "start" ] ;then
  usacloud server boot -y $VM
  echo "$VM start"
elif  [ "$ACT" == "stop" ] ;then
  usacloud server stop -y $VM
  echo "$VM stop"
elif  [ "$ACT" == "restart" ] ;then
  usacloud server stop -y $VM
  usacloud server boot -y $VM
  echo "$VM restart"
fi
