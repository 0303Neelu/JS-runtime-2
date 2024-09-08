#!/bin/bash

# Set the threshold for sudo attempts
THRESHOLD=3

# Log file to monitor sudo commands
LOG_FILE="/var/log/sudo-access.log"

# Email address to which you want to send notifications
ADMIN_EMAIL="sneelulatha2005@gmail.com"

# Extract low privilege users from /etc/passwd
LOW_PRIV_USERS=$(awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd)

echo $LOW_PRIV_USERS

# Loop through the users
for USER in $LOW_PRIV_USERS; do
    # Count sudo command attempts
    SUDO_COUNT=$(grep -c "$USER : user NOT in sudoers" "$LOG_FILE")

    # Check if attempts exceed threshold
    if [ $SUDO_COUNT -gt $THRESHOLD ]; then
        # Send email notification
        echo "Threshold reached. Mailing about - $USER"
        SUBJECT="Excessive sudo attempts by $USER"
        BODY="The user $USER has attempted to use sudo commands $SUDO_COUNT times."
        echo "$BODY" | mail -s "$SUBJECT" "$ADMIN_EMAIL"
    fi
done
