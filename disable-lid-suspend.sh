#!/bin/bash

# Define the logind.conf file path
LOGIND_CONF="/etc/systemd/logind.conf"

# Check if logind.conf exists
if [ ! -f "$LOGIND_CONF" ]; then
    echo "Error: $LOGIND_CONF does not exist."
    exit 1
fi

# Make a backup of the original file
cp "$LOGIND_CONF" "${LOGIND_CONF}.bak"

# Uncomment HandleLidSwitch if it's commented out and set it to ignore, or add it if it's missing
if grep -q "^#HandleLidSwitch=suspend" "$LOGIND_CONF"; then
    # Uncomment and set to ignore
    sed -i 's/^#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' "$LOGIND_CONF"
elif grep -q "^HandleLidSwitch" "$LOGIND_CONF"; then
    # Change existing line to ignore
    sed -i 's/^HandleLidSwitch=.*/HandleLidSwitch=ignore/' "$LOGIND_CONF"
else
    # Add HandleLidSwitch at the end of the file
    echo "HandleLidSwitch=ignore" >> "$LOGIND_CONF"
fi

# Restart systemd-logind to apply changes
systemctl restart systemd-logind

echo "Configuration updated. Laptop lid closure will now be ignored."
