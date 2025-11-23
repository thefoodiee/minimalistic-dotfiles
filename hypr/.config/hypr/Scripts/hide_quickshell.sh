
#!/bin/bash

CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"

# Backup the original file
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# Toggle bar.autoHide.enable
jq '.bar.autoHide.enable = (if .bar.autoHide.enable then false else true end)' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

echo "Toggled bar.autoHide.enable in $CONFIG_FILE"
