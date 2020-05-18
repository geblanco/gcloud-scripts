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
  proxy_data=""
  if [[ ! -z "${HOP_SERVER}" ]]; then
    proxy_data="-e \"ssh -p 22 -A ${HOP_SERVER} ssh\""
  fi
  # This is a good moment to backup important stuff... i.e.: train log, results...
  # ToDo := Add files from filelist
  rsync "${proxy_data}" -avrzP "${TO_BACKUP_DIR}" "${BACKUP_SERVER}:/${REMOTE_BACKUP_DIR}"
fi

sudo shutdown -h now
