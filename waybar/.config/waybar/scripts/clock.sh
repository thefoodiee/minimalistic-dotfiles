#!/usr/bin/env bash

time_text=$(date +"%I:%M • %a, %d %b" | tr '[:upper:]' '[:lower:]')

# Output in JSON format for Waybar
echo "{\"text\": \"$time_text\"}"
