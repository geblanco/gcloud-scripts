#!/bin/bash

source "./gcloud.env"
# in minutes
POLL_INTERVAL=30
POLL_MSG_INTERVAL=10

function setup(){
  ssh-add $SSH_KEY
  gcloud beta config set compute/zone "${GCLOUD_ZONE}"
  gcloud beta config set project "${GCLOUD_PROJECT}"
}

function stop_gcloud(){
  gcloud beta compute instances stop "${GCLOUD_INSTANCE}"
}

function is_gcloud_running(){
  echo "Polling instance..." >&2
  gcloud beta compute ssh "${GCLOUD_INSTANCE}" --command 'sleep 10s; exit 0' >&2 &

  gcloud_pid=$!
  wait $gcloud_pid >/dev/null
  gcloud_exit_code=$?
  if [[ "${gcloud_exit_code}" -eq 0 ]]; then
    true
  else
    false
  fi
}

setup
while $(is_gcloud_running); do
  # poll every 30 minutes
  min_remaining=30
  echo "Gcloud instance running, polling again in ${min_remaining} minutes"
  for i in $(seq $(( $POLL_INTERVAL / $POLL_MSG_INTERVAL ))); do
    sleep "${POLL_MSG_INTERVAL}m"
    min_remaining=$(( $min_remaining - $POLL_MSG_INTERVAL ))
    echo "Polling again in ${min_remaining} minutes"
  done
done

echo "Gcloud does not seem to be active, stopping..."
stop_gcloud
