#!/bin/bash

LOG_FILE_PATH="/Users/sri/Downloads/logs"
ERROR_PATTERN=(ERROR FATAL CRITICAL) 
REPORT_FILE="$LOG_FILE_PATH/log_analysis_report.txt"

echo "Analyzing log files" > "$REPORT_FILE"
echo "############################################################" >> "$REPORT_FILE"

echo "List of log files updated in last 24 hours" >> "$REPORT_FILE"

LOG_FILE_NAMES_OF_24HRS=$(find $LOG_FILE_PATH -name "*.log" -mtime -1) 

echo "$LOG_FILE_NAMES_OF_24HRS">> "$REPORT_FILE"  >> "$REPORT_FILE"

echo " ##########################################" >> "$REPORT_FILE" 

for LOG_FILE in $LOG_FILE_NAMES_OF_24HRS; do
    echo "###########################################" >> "$REPORT_FILE"
    echo -e "\nAnalyzing $LOG_FILE file" >> "$REPORT_FILE" >> "$REPORT_FILE"
    echo "##########################################" >> "$REPORT_FILE"

    for PATTERN in "${ERROR_PATTERN[@]}"; do
        echo -e "\nSearching $PATTERN logs in $LOG_FILE file" >> "$REPORT_FILE"
        grep -i $PATTERN "$LOG_FILE"   >> "$REPORT_FILE"
        
        echo -e "\nSearching $PATTERN logs in $LOG_FILE file"  >> "$REPORT_FILE"
        
        ERROR_COUNT=$(grep -ic "$PATTERN" "$LOG_FILE")
        echo $ERROR_COUNT  >> "$REPORT_FILE"

        if [ "$ERROR_COUNT" -gt 10 ]; then
            echo -e "\n ⚠️ Found $ERROR_COUNT occurrences of $PATTERN in $LOG_FILE"
        fi
    done

done

echo -e "\n Log analysis completed. Report saved to $REPORT_FILE\n"


