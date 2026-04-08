#!/bin/bash
THRESHOLD=80

MEM_USAGE=$(free | grep Mem | awk ' {print $3/$2 * 100}' | cut -d. -f1)

echo "--- System Health Audit: $(date) ---"

if [ "$MEM_USAGE" -gt "$THRESHOLD" ]; then 
   echo " ALERT: High Memory Usage! Currently at $MEM_USAGE%"
else 
   echo "System stable. Memory usage at $MEM_USAGE%"
fi