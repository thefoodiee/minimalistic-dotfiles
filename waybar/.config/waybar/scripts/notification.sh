#!/bin/bash

count=$(swaync-client -c)
dnd=$(swaync-client -D)

if [ "$dnd" = "true" ]; then
    echo '{"text":"󰒲","class":"dnd","tooltip":"Do Not Disturb enabled"}'
elif [ "$count" -gt 0 ]; then
    echo "{\"text\":\"\",\"class\":\"notification\",\"tooltip\":\"$count unread notification(s)\"}"
else
    echo '{"text":"","class":"none","tooltip":"No unread notifications"}'
fi
