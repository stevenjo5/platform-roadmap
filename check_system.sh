#!/bin/bash

DATE=$(date +%Y-%m-%d)

echo "--- System Health Check: $DATE ---"

USAGE=$(df / | grep / | awk ' {print $5}'| sed 's/%//g' )

if [ "$USAGE" -gt 60 ]; then 
    echo "⚠️  CRITICAL: Disk usage is at $USAGE%!"
    echo "Cleaning up files older than 7 days..."
    find . -name "*.txt" -mtime +7 -delete
    echo "Cleanup complete. Re-checking space..."
    NEW_USAGE=$(df / | grep / | awk ' {print $5}'| sed 's/%//g' )
    echo "New Disk Usage: $NEW_USAGE%"
else 
    echo "✅ SUCCESS: Disk usage is safe at $USAGE%."
fi 
    echo "--- Check Finished ---" 