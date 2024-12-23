#!/bin/bash

message_sent=false

send_message () {
  message=$1
  wget -q -O - --header "Content-Type: application/json" --post-data "{\"token\": \"$PUSHOVER_API_TOKEN\", \"user\": \"$PUSHOVER_USER_KEY\", \"message\": \"$message\"}"  https://api.pushover.net/1/messages.json
  echo
}




while true; do
  available=$(df -PB 1M | grep -e "^$FILESYSTEM" | awk '{ print $4 }')
  echo "Available: ${available}MB"

  if (( $available > $MIN_FREE_SPACE)); then
    message_sent=false
  elif ! $message_sent; then
    echo "Sending message to Pushover"
    send_message "The free disk space on lenders.dev has dropped below ${MIN_FREE_SPACE}MB"
    message_sent=true
  fi

  sleep $INTERVAL
done
