#!/bin/bash

LOG_PATH="./mainlog"
DATE_FORMAT=$(date +"%Y%m%d")

NEW_LOG_PATH="./result"
NEW_LOG_FILE="$NEW_LOG_PATH/$DATE_FORMAT.log"
touch "$NEW_LOG_FILE"

while true; do
    LOG_FILE="$LOG_PATH/$DATE_FORMAT.log"

    if [ -f "$LOG_FILE" ]; then
        grep -B 1 -A 1 "hello" "$LOG_FILE" >> "$NEW_LOG_FILE"
    else
        echo "NOT exist $LOG_FILE"
    fi

    DATE_FORMAT=$(date -d "tomorrow" +"%Y%m%d")
    sleep 2
done
