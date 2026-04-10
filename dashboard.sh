#!/bin/bash 

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== PLATFORM STATUS DASHBOARD ==${NC}"
echo "Generated: $(date)"
echo "---------------------------------"

if pgrep -x "sleep" > /dev/null; then 
   echo -e "Watchdog Status: ${GREEN}RUNNING${NC}"
else 
   echo -e "Watchdog Status: ${RED}FAILED${NC}"
fi 

MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d. -f1)
echo "Memoru Usage:      $MEM_USAGE%"

DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}')
echo "Disk Space Used: $DISK_USAGE"

echo "--------------------------------------"
echo "Latest Log Activity:" 
tail -n 1 ~/watchdog.log
echo "--------------------------------------"