#!/usr/bin/env bash

hour=$(date +%H)

if [ "$hour" -ge 5 ] && [ "$hour" -lt 12 ]; then
    icon="󰖨" # morning
elif [ "$hour" -ge 12 ] && [ "$hour" -lt 17 ]; then
    icon="󰖙" # afternoon
elif [ "$hour" -ge 17 ] && [ "$hour" -lt 20 ]; then
    icon="󰖛" # evening
else
    icon="󰖔" # night
fi

echo "<span weight='heavy'>$(date +'%I:%M') $icon </span>"
