#!/bin/bash

# Hyprland power management + video wallpaper + Matugen Fruit Salad accents
# Requires: acpi (or upower), powerprofilesctl, mpvpaper, ffmpeg, matugen, jq, hyprctl

FRAME_FILE="/tmp/wallframe.png"
WALLPAPER_FILE="$HOME/.cache/hypr-power-wallpaper"

usage() {
    echo "Usage:"
    echo "  $0 <video_file>     # start script with wallpaper"
    echo "  $0 --change <file>  # change wallpaper while script is running"
    exit 1
}

# Handle arguments
if [[ "$1" == "--change" ]]; then
    if [[ -z "$2" ]]; then
        echo "Error: no video file provided"
        usage
    fi
    if [[ ! -f "$2" ]]; then
        echo "Error: file '$2' not found"
        exit 1
    fi
    echo "$2" > "$WALLPAPER_FILE"

    # If mpvpaper is running, reload wallpaper immediately
    if pgrep -x mpvpaper >/dev/null; then
        pkill -9 -x mpvpaper
    fi
    echo "[hypr-power] Wallpaper changed to $2"
    exit 0
elif [[ -n "$1" ]]; then
    if [[ ! -f "$1" ]]; then
        echo "Error: file '$1' not found"
        exit 1
    fi
    echo "$1" > "$WALLPAPER_FILE"
elif [[ ! -f "$WALLPAPER_FILE" ]]; then
    usage
fi

VIDEO=$(cat "$WALLPAPER_FILE")

check_power() {
    if command -v acpi >/dev/null 2>&1; then
        acpi -a | grep -q "on-line" && echo "AC" || echo "Battery"
    elif command -v upower >/dev/null 2>&1; then
        status=$(upower -i $(upower -e | grep BAT) | grep state | awk '{print $2}')
        [[ "$status" == "discharging" ]] && echo "Battery" || echo "AC"
    else
        echo "Unknown"
    fi
}

generate_colors() {
    local video="$1"
    ffmpeg -y -i "$video" -vf "select=eq(n\,30)" -vframes 1 "$FRAME_FILE" >/dev/null 2>&1
    primary=$(matugen image "$FRAME_FILE" --type scheme-fruit-salad --json hex \
              | jq -r '.colors.dark.primary // empty' | sed 's/^#//')
    if [[ -n "$primary" ]]; then
        updatecolors "$primary"
        echo "[hypr-power] Updated colors with primary: $primary"
    else
        echo "[hypr-power] Failed to extract primary color (got null/empty)"
    fi
}

check_windows() {
    if hyprctl activewindow | grep -q "Invalid"; then
        return 1   # no focused window
    else
        return 0   # some window focused
    fi
}

while true; do
    power_state=$(check_power)

    if [[ "$power_state" == "Battery" ]]; then
        echo "[hypr-power] On battery: enabling power saving and disabling mpvpaper"
        powerprofilesctl set power-saver 2>/dev/null
        pkill -9 -x mpvpaper 2>/dev/null
    elif [[ "$power_state" == "AC" ]]; then
        echo "[hypr-power] On AC: enabling performance mode and starting mpvpaper"
        powerprofilesctl set balanced 2>/dev/null

        # reload video in case --change was called
        VIDEO=$(cat "$WALLPAPER_FILE")

        if ! pgrep -x mpvpaper >/dev/null; then
            mpvpaper -o "no-audio --loop-file --panscan=1 --no-keepaspect --vf=fps=30" ALL "$VIDEO" &
            generate_colors "$VIDEO"
        fi

        if check_windows; then
            echo "[hypr-power] Window focused → pause wallpaper"
            pkill -STOP mpvpaper 2>/dev/null
        else
            echo "[hypr-power] No focused window → resume wallpaper"
            pkill -CONT mpvpaper 2>/dev/null
        fi
    fi

    sleep 1
done

