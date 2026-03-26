#!/bin/bash

DATE=$(date +%Y-%m-%d)

echo "--- System Health Check: $DATE ---"

USAGE=$(df / | grep / | awk ' {print $5}'| sed 's/%//g' )

if [ "$USAGE" -gt 60 ]; then 
    echo "⚠️  CRITICAL: Disk usage is at $USAGE%!"
else 
    echo "✅ SUCCESS: Disk usage is safe at $USAGE%."
fi 
    echo "--- Check Finished ---" 