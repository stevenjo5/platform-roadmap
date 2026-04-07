#!/bin/bash 

SERVICE="sleep"

echo "--- Watchdog Check: $(date) ---"

if pgrep -x "$SERVICE" > /dev/null 
then 
    echo "$Service is running. No action required."
else 
    echo "$SERVICE is NOT running! Initiating recovery..." 
    sleep 1000 & 
    echo "$SERVICE has been restarted successfully."
fi
