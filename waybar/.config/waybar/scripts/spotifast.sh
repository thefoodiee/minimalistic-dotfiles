#!/usr/bin/env bash

# Check if spotifast is running and get its status
status=$(playerctl -p spotifast status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    artist=$(playerctl -p spotifast metadata artist)
    title=$(playerctl -p spotifast metadata title)
    echo "{\"text\": \"$artist - $title\", \"class\": \"playing\", \"tooltip\": \"$artist - $title\"}"
elif [ "$status" = "Paused" ]; then
    artist=$(playerctl -p spotifast metadata artist)
    title=$(playerctl -p spotifast metadata title)
    echo "{\"text\": \"$artist - $title\", \"class\": \"paused\", \"tooltip\": \"$artist - $title (Paused)\"}"
else
    # Output empty JSON if spotifast is not playing/paused, so the module hides/shows nothing
    echo "{}"
fi
