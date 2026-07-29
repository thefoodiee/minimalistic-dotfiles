#!/usr/bin/env bash

while true; do
    notify-send \
        --app-name="Water Reminder" \
        --urgency=critical \
        --expire-time=0 \
        --hint=boolean:resident:true \
        "💧 Drink Water" \
        "Time to drink a glass of water."

    sleep 1800
done
