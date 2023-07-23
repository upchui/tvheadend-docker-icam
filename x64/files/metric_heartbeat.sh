#!/bin/bash

API_KEY=619269e542c207099e02a64106697e4c
EVENT_TYPE="heartbeat"
URL=https://api2.amplitude.com/2/httpapi

while true
do
  # Get the hostname
  HOSTNAME=$(cat /proc/sys/kernel/random/uuid)

  # Create the JSON data
  JSON_DATA=$(printf '{"api_key": "%s", "events": [{"device_id": "%s", "event_type": "%s"}]}' "$API_KEY" "$HOSTNAME" "$EVENT_TYPE")

  # Make the POST request
  curl -X POST $URL -H 'Content-Type: application/json' -H 'Accept: */*' --data "$JSON_DATA" > /dev/null 2>&1

  # Wait for 24 hours before next execution
  sleep 3600
  done