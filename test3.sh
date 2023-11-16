#!/bin/bash

LOG_PATH="./mainlog"
NEW_LOG_PATH="./result"
CURRENT_DATE=""
LAST_LOG_CONTENT=""

while true; do
    DATE_FORMAT=$(date +"%Y%m%d")


    if [ "$DATE_FORMAT" != "$CURRENT_DATE" ]; then
        CURRENT_DATE="$DATE_FORMAT"
        LOG_FILE="$LOG_PATH/$CURRENT_DATE.log"
        NEW_LOG_FILE="$NEW_LOG_PATH/$CURRENT_DATE.log"
    fi

    if [ -f "$LOG_FILE" ]; then
        CURRENT_LOG_CONTENT=$(grep -B 1 -A 1 "hello" "$LOG_FILE")
        
        if [ "$LAST_LOG_CONTENT" != "$CURRENT_LOG_CONTENT" ]; then
            echo "$CURRENT_LOG_CONTENT" >> "$NEW_LOG_FILE"
            LAST_LOG_CONTENT="$CURRENT_LOG_CONTENT"
        fi
    else
        echo "NOT exist $LOG_FILE"
    fi

    sleep 2
done
