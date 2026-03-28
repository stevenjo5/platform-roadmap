#!/bin/bash
cleanup_logs() {
    echo "Running Janitor: Deleting old logs..."
    find . -name "*.log" -type f -delete
}


USAGE=$(df -P / | grep / | awk ' {print $5}'| sed 's/%//g' )

if [ "$USAGE" -gt 60 ]; then 
    echo "⚠️  CRITICAL: Disk usage is at $USAGE%!"
    
  cleanup_logs
else 
    echo "✅ SUCCESS: Disk usage is safe at $USAGE%."
fi 
    echo "--- Check Finished ---" 