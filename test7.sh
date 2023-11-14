#!/bin/bash

LOG_PATH="./mainlog"
NEW_LOG_PATH="./result"
CURRENT_DATE=""
LAST_LOG_CONTENT=""
TAIL_PID=0

# Tail process start at 11.14 pm707 test code
start_tail() {
    tail -F "$NEW_LOG_FILE" &
    TAIL_PID=$!
}

# Tail process STOP~
stop_tail() {
    if [ $TAIL_PID -ne 0 ]; then
        kill $TAIL_PID
    fi
}

trap 'stop_tail; exit' INT TERM

while true; do
    DATE_FORMAT=$(date +"%Y%m%d")

    if [ "$DATE_FORMAT" != "$CURRENT_DATE" ]; then
        stop_tail
        CURRENT_DATE="$DATE_FORMAT"
        LOG_FILE="$LOG_PATH/$CURRENT_DATE.log"
        NEW_LOG_FILE="$NEW_LOG_PATH/$CURRENT_DATE.log"

        cp "$NEW_LOG_FILE" "$NEW_LOG_FILE.old" 2>/dev/null || :
        rm -f "$NEW_LOG_FILE"
        start_tail
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
