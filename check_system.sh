#!/bin/bash

# 1. Create a variable for today's date
DATE=$(date +%Y-%m-%d)

echo "--- System Report for $DATE ---"

# 2. Check Disk Space and save only the 'Percentage used' line
echo "Checking Disk Space..."
df -h | grep "/$"

# 3. Create a backup folder if it doesn't exist
mkdir -p ~/backups

echo "--- Report Complete ---"
