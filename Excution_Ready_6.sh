#!/bin/bash

LOG_PATH="./mainlog"
NEW_LOG_PATH="./result"
CURRENT_DATE=""
LAST_LOG_CONTENT=""
DISPLAYED_CONTENT=""

# result main
print_updated_content() {
    local new_content=$(awk 'BEGIN {buffer=""; count=0; found=0} 
                               {if (/hello/) found=1; buffer=buffer (count>0 ? " | " : "") $0; count++} 
                               count==3 {if (found) {print buffer "--"}; buffer=""; count=0; found=0} 
                               END {if(buffer != "" && found) print buffer "--"}' "$NEW_LOG_FILE")
    if [ "$DISPLAYED_CONTENT" != "$new_content" ]; then
        clear
        echo "-------------------------------------"
        echo "$new_content"
        echo "-------------------------------------"
        DISPLAYED_CONTENT="$new_content"
    fi
}

while true; do
    DATE_FORMAT=$(date +"%Y%m%d")

    if [ "$DATE_FORMAT" != "$CURRENT_DATE" ]; then
        CURRENT_DATE="$DATE_FORMAT"
        LOG_FILE="$LOG_PATH/$CURRENT_DATE.log"
        NEW_LOG_FILE="$NEW_LOG_PATH/$CURRENT_DATE.log"

        if [ -f "$NEW_LOG_FILE" ]; then
            mv "$NEW_LOG_FILE" "${NEW_LOG_FILE}.old"
        fi

        > "$NEW_LOG_FILE" # Clear previous content
        DISPLAYED_CONTENT=""
    fi

    if [ -f "$LOG_FILE" ]; then
        grep -B 1 -A 1 "hello" "$LOG_FILE" | awk '{printf "| %-10s \n", $0} END {print "|"}' > "$NEW_LOG_FILE"
        LAST_LOG_CONTENT=$(cat "$NEW_LOG_FILE")
    else
        echo "Log file $LOG_FILE does not exist"
    fi

    print_updated_content
    sleep 2
done
