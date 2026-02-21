#!/bin/bash

STATE_FILE="/tmp/keepawake"

case "$1" in
    toggle)
        if [ -f "$STATE_FILE" ]; then
            rm "$STATE_FILE"
            hypridle &
        else
            touch "$STATE_FILE"
            pkill hypridle
        fi
        ;;
    status)
        if [ -f "$STATE_FILE" ]; then
            echo '{"text":"󰅶 ","class":"active"}'
        else
            echo '{"text":"󰾪 ","class":"inactive"}'
        fi
        ;;
esac
