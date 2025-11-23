#!/bin/bash

VIDEO_DIR="/home/urmum/Videos/wpe"
WALLPAPER_FILE="$HOME/.cache/hypr-power-wallpaper"

video=$(find "$VIDEO_DIR" -type f | shuf -n 1)
echo "$video" > "$WALLPAPER_FILE"

echo "[change-wall] New wallpaper set: $video"

# Restart mpvpaper if it's running
pkill -x mpvpaper
