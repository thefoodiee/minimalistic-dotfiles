#!/bin/bash

if playerctl -p spotify status &>/dev/null; then
    song_info=$(playerctl -p spotify metadata --format "{{title}} - {{artist}}")
    echo "<span weight='heavy'>  $song_info</span>"
else
    echo "<span weight='heavy'>no media</span>"
fi
