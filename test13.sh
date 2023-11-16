#!/bin/bash

LOG_PATH="./mainlog"
NEW_LOG_PATH="./result"
CURRENT_DATE=""
LAST_LOG_CONTENT=""
# 시도결과 Terminated
# 에러발생, 사용 불가능

monitor_logs() {
    local prev_content=""
    while true; do
        if [ -f "$NEW_LOG_FILE" ]; then
            local new_content=$(grep -B 1 -A 1 "hello" "$NEW_LOG_FILE")
            if [ "$prev_content" != "$new_content" ]; then
                echo "$new_content"
                prev_content="$new_content"
            fi
        fi
        sleep 2
    done
}

while true; do
    DATE_FORMAT=$(date +"%Y%m%d")

    if [ "$DATE_FORMAT" != "$CURRENT_DATE" ]; then
        CURRENT_DATE="$DATE_FORMAT"
        LOG_FILE="$LOG_PATH/$CURRENT_DATE.log"
        NEW_LOG_FILE="$NEW_LOG_PATH/$CURRENT_DATE.log"
        > "$NEW_LOG_FILE" # 이전 내용 초기화

        # 이전 모니터링 프로세스 종료
        if [ ! -z $MONITOR_PID ]; then
            kill $MONITOR_PID 2>/dev/null
        fi

        monitor_logs &
        MONITOR_PID=$!
    fi

    if [ -f "$LOG_FILE" ]; then
        ...
    fi

    sleep 2
done
