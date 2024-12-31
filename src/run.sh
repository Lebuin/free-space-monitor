#!/bin/bash

# Status 0: sufficient disk space
# Status 1: disk space is low
send_status () {
  status=$1
  wget -q -O - $HEALTHCHECK_URL/$status
  echo
}




while true; do
  available=$(df -PB 1M | grep -e "^$FILESYSTEM" | awk '{ print $4 }')
  echo "Available: ${available} MB"

  if (( $available > $MIN_FREE_SPACE)); then
    status=0
  else
    status=1
  fi

  send_status $status;

  sleep $INTERVAL
done
