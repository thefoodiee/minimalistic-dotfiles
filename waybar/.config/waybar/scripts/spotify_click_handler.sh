#!/bin/bash

STATE_FILE="/tmp/waybar_spotify_click_state"
PID_FILE="/tmp/waybar_spotify_click_handler.pid"
TIMEOUT_MS=400 # INCREASED: Try 400ms or even 450ms if 400 doesn't work

# Kill any previous pending click handler to prevent race conditions
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    kill -9 "$OLD_PID" 2>/dev/null
    rm "$PID_FILE" 2>/dev/null
fi

# Read last click timestamp and count
if [ -f "$STATE_FILE" ]; then
    LAST_CLICK_TIME=$(head -n 1 "$STATE_FILE")
    CLICK_COUNT=$(tail -n 1 "$STATE_FILE")
else
    LAST_CLICK_TIME=0
    CLICK_COUNT=0
fi

CURRENT_TIME_MS=$(($(date +%s%N) / 1000000)) # Current time in milliseconds

# Calculate time difference
TIME_DIFF_MS=$((CURRENT_TIME_MS - LAST_CLICK_TIME))

if [ "$TIME_DIFF_MS" -lt "$TIMEOUT_MS" ]; then
    CLICK_COUNT=$((CLICK_COUNT + 1))
else
    # If too much time has passed since the last click, reset count
    CLICK_COUNT=1
fi

# Store current click info (timestamp and current count)
echo "$CURRENT_TIME_MS" > "$STATE_FILE"
echo "$CLICK_COUNT" >> "$STATE_FILE"

# Start a background process to wait for the timeout and then process the clicks
(
    # Store PID of this background process
    echo $$ > "$PID_FILE"

    # Wait for the timeout duration
    sleep $((TIMEOUT_MS / 1000)).$((TIMEOUT_MS % 1000))

    # Re-read the state file. This ensures we get the *final* click count
    # if multiple clicks happened very quickly.
    if [ -f "$STATE_FILE" ]; then
        FINAL_CLICK_COUNT=$(tail -n 1 "$STATE_FILE")
    else
        FINAL_CLICK_COUNT=0
    fi

    # Execute action based on final click count
    case "$FINAL_CLICK_COUNT" in
        1) playerctl -p spotify play-pause ;; # Single Click: Play/Pause
        2) playerctl -p spotify next ;;      # Double Click: Next Track
        3) playerctl -p spotify previous ;;  # Triple Click: Previous Track
    esac

    # Reset the state file and remove the PID file to be ready for the next click sequence
    echo 0 > "$STATE_FILE"
    echo 0 >> "$STATE_FILE"
    rm "$PID_FILE" 2>/dev/null
) & disown