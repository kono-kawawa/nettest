#!/bin/bash

LOG_PATH="./mainlog"
NEW_LOG_PATH="./result"
CURRENT_DATE=""

while true; do
    DATE_FORMAT=$(date +"%Y%m%d")

    if [ "$DATE_FORMAT" != "$CURRENT_DATE" ]; then
        CURRENT_DATE="$DATE_FORMAT"
        LOG_FILE="$LOG_PATH/$CURRENT_DATE.log"
        NEW_LOG_FILE="$NEW_LOG_PATH/$CURRENT_DATE.log"
    fi

    if [ -f "$LOG_FILE" ]; then
        grep -B 1 -A 1 "hello" "$LOG_FILE" >> "$NEW_LOG_FILE"
    else
        echo "NOT exist $LOG_FILE"
    fi

    sleep 2
done
