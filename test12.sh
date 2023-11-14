#!/bin/bash

LOG_PATH="./mainlog"
NEW_LOG_PATH="./result"
CURRENT_DATE=""
LAST_LOG_CONTENT=""

# 클리어 삭제. 다른 방법 시도중/ 확인결과pkill은 사용불가능 판정
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
        pkill -f "monitor_logs" # 이전 모니터링 프로세스 종료
        monitor_logs &
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

    sleep 2
done

