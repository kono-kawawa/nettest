#!/bin/bash

LOG_PATH="./mainlog"
NEW_LOG_PATH="./result"
CURRENT_DATE=""
LAST_LOG_CONTENT=""
DISPLAYED_CONTENT=""

curl -o webpage.html 'http://www.naver.com'
# result Monitoring function()
print_updated_content() {
    local new_content=$(grep -B 1 -A 1 "hello" "$NEW_LOG_FILE")

    if [ "$DISPLAYED_CONTENT" != "$new_content" ]; then
        clear
        echo "$new_content"
        DISPLAYED_CONTENT="$new_content"
    fi
}

while true; do
    DATE_FORMAT=$(date +"%Y%m%d")

    if [ "$DATE_FORMAT" != "$CURRENT_DATE" ]; then
        CURRENT_DATE="$DATE_FORMAT"
        LOG_FILE="$LOG_PATH/$CURRENT_DATE.log"
        NEW_LOG_FILE="$NEW_LOG_PATH/$CURRENT_DATE.log"

        # 기존 Log File    BackUp to .old File 
        if [ -f "$NEW_LOG_FILE" ]; then
            mv "$NEW_LOG_FILE" "${NEW_LOG_FILE}.old"
        fi

        > "$NEW_LOG_FILE" # current text reset
        DISPLAYED_CONTENT=""
    fi

    if [ -f "$LOG_FILE" ]; then
        CURRENT_LOG_CONTENT=$(grep -B 1 -A 1 "hello" "$LOG_FILE")

        if [ "$LAST_LOG_CONTENT" != "$CURRENT_LOG_CONTENT" ]; then
            echo "$CURRENT_LOG_CONTENT" > "$NEW_LOG_FILE"
            LAST_LOG_CONTENT="$CURRENT_LOG_CONTENT"
        fi
    else
        echo "NOT exist $LOG_FILE"
    fi

    print_updated_content

    sleep 2
done
