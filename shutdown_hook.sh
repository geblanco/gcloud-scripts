#!/bin/bash

if [[ $@ -lt 1 ]]; then
  echo "Usage ./shutdown_hook.sh <pid>"
  exit 0
fi

pid=$1
while kill -0 $pid 2>&1 1>/dev/null; do
  sleep 10m
done

if [ -f ~/.server_data ]; then
  . ~/.server_data
  backup
fi

sudo shutdown -h now
