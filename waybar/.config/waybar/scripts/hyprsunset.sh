#!/bin/bash

STATE_FILE="$HOME/.cache/hyprsunset_state"

# default state if file doesn't exist
if [ ! -f "$STATE_FILE" ]; then
  echo "identity" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

if [ "$STATE" = "identity" ]; then
  hyprctl hyprsunset temperature 5000
  echo "temperature" > "$STATE_FILE"
else
  hyprctl hyprsunset identity
  echo "identity" > "$STATE_FILE"
fi
