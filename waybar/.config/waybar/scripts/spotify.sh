#!/bin/bash

# Check if Spotify is running and get its status
status=$(playerctl -p spotify status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    artist=$(playerctl -p spotify metadata artist)
    title=$(playerctl -p spotify metadata title)
    echo "{\"text\": \"$artist - $title\", \"class\": \"playing\", \"tooltip\": \"$artist - $title\"}"
elif [ "$status" = "Paused" ]; then
    artist=$(playerctl -p spotify metadata artist)
    title=$(playerctl -p spotify metadata title)
    echo "{\"text\": \"$artist - $title\", \"class\": \"paused\", \"tooltip\": \"$artist - $title (Paused)\"}"
else
    # Output empty JSON if Spotify is not playing/paused, so the module hides/shows nothing
    echo "{}"
fi