#!/bin/bash

if [[ $heartbeat_alive == "false" ]]; then
  exit 0
else
  API_KEY=619269e542c207099e02a64106697e4c
  EVENT_TYPE="heartbeat"
  URL=https://api2.amplitude.com/2/httpapi
  UUID_FILE="/config/.thealhu_amplitude_uuid"

  # Check if UUID file exists and read from it, otherwise create a new one
  if [ -f "$UUID_FILE" ]; then
    HOSTNAME=$(cat "$UUID_FILE")
  else
    HOSTNAME=$(cat /proc/sys/kernel/random/uuid)
    echo "$HOSTNAME" > "$UUID_FILE"
  fi

  # Create the JSON data
  JSON_DATA=$(printf '{"api_key": "%s", "events": [{"device_id": "%s", "event_type": "%s"}]}' "$API_KEY" "$HOSTNAME" "$EVENT_TYPE")

  while true
  do
    # Make the POST request
    curl -X POST $URL -H 'Content-Type: application/json' -H 'Accept: */*' --data "$JSON_DATA" > /dev/null 2>&1

    # Wait for 1 hour before next execution
    sleep 3600
  done
fi