#!/bin/bash

while true; do
    DATE_FORMAT=$(date +"%Y%m%d")
    CURRENT_DATE="$DATE_FORMAT"
    LOG_FILE="./mainlog/$CURRENT_DATE.log"

    if [ -f "$LOG_FILE" ]; then
        CURRENT_LOG_CONTENT=$(grep -B 1 -A 1 "hello" "$LOG_FILE")

        if [ "$LAST_LOG_CONTENT" != "$CURRENT_LOG_CONTENT" ]; then
            echo "$CURRENT_LOG_CONTENT"
            LAST_LOG_CONTENT="$CURRENT_LOG_CONTENT"
        fi
    else
        echo "NOT exist $LOG_FILE"
    fi

    sleep 2
done

