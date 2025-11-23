#!/bin/bash

# Configuration
STATE_FILE="/tmp/hypr_immersive_mode_state"

# --- Helper function to get Hyprland option values ---
get_hypr_option() {
    hyprctl getoption "$1" -j | jq -r '.custom // .int // .str // .float'
}

if [ -f "$STATE_FILE" ]; then
    # RESTORE MODE: immersive mode is active, restore previous settings

    # Read saved state
    ORIGINAL_GAPS_IN=$(head -n 1 "$STATE_FILE")
    ORIGINAL_GAPS_OUT=$(sed -n '2p' "$STATE_FILE")
    ORIGINAL_ACTIVE_BORDER=$(sed -n '3p' "$STATE_FILE")
    ORIGINAL_INACTIVE_BORDER=$(sed -n '4p' "$STATE_FILE")

    # Restore Hyprland settings
    hyprctl keyword general:gaps_in "$ORIGINAL_GAPS_IN"
    hyprctl keyword general:gaps_out "$ORIGINAL_GAPS_OUT"
    hyprctl keyword general:col.active_border "$ORIGINAL_ACTIVE_BORDER"
    hyprctl keyword general:col.inactive_border "$ORIGINAL_INACTIVE_BORDER"

    # Show Waybar
    waybar & disown

    # Clean up state file
    rm "$STATE_FILE"
else
    # ACTIVATE MODE: immersive mode is off, activate it

    CURRENT_GAPS_IN=$(get_hypr_option "general:gaps_in")
    CURRENT_GAPS_OUT=$(get_hypr_option "general:gaps_out")

    # Hardcoded border colors for restore
    CURRENT_ACTIVE_BORDER="rgb(ffffff)"
    CURRENT_INACTIVE_BORDER="rgba(595959aa)"

    # Save current state
    {
        echo "$CURRENT_GAPS_IN"
        echo "$CURRENT_GAPS_OUT"
        echo "$CURRENT_ACTIVE_BORDER"
        echo "$CURRENT_INACTIVE_BORDER"
    } > "$STATE_FILE"

    # Set immersive mode settings
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    hyprctl keyword general:col.active_border 0x000000FF
    hyprctl keyword general:col.inactive_border 0x000000FF

    # Hide Waybar
    pkill -x waybar
fi

exit 0

