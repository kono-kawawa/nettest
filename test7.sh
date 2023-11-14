#!/bin/bash
#파이널 아님. 이 코드 수정이 필요함 

LOG_PATH="./mainlog"
NEW_LOG_PATH="./result"
CURRENT_DATE=""
LAST_LOG_FILE=""
TAIL_PID=0

# Tail 
start_tail() {
    tail -F "$NEW_LOG_FILE" &
    TAIL_PID=$!
}

# Tail stop
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
        LAST_LOG_FILE="$LOG_PATH/$CURRENT_DATE.log.old"

        cp "$LOG_FILE" "$LAST_LOG_FILE" 2>/dev/null || :
        start_tail
    fi

    if [ -f "$LOG_FILE" ]; then
        if [ -f "$LAST_LOG_FILE" ]; then
            # diff를 사용하여 변경 사항 추출해야하는...데....왜안되농..
            DIFF_CONTENT=$(diff "$LAST_LOG_FILE" "$LOG_FILE" | grep '^>' | sed 's/^> //')
            if [ ! -z "$DIFF_CONTENT" ]; then
                echo "$DIFF_CONTENT" >> "$NEW_LOG_FILE"
            fi
        fi
        cp "$LOG_FILE" "$LAST_LOG_FILE"
    else
        echo "NOT exist $LOG_FILE"
    fi

    sleep 2
done

