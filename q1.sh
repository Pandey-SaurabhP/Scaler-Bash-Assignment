#!/bin/bash

# Global variable to store the total count of requests
totalCount=0

# Function to check if the log file exists and is readable
checkLog() {
    local logFile="$1"
    if [[ ! -f "$logFile" ]]; then
        echo "Error: Log file '$logFile' does not exist."
        exit 1
    fi

    if [[ ! -r "$logFile" ]]; then
        echo "Error: Log file '$logFile' is not readable."
        exit 1
    fi
}

# Function to calculate the percentage of successful requests
getSuccess() {
    local logFile="$1"
    successfulRequests=$(grep -c 'HTTP/1.[01]\" 2[0-9][0-9] ' "$logFile")

    if [[ $totalCount -eq 0 ]]; then
        successPercentage=0
    else
        successPercentage=$(awk "BEGIN {printf \"%.2f\", ($successfulRequests / $totalCount) * 100}")
    fi

    echo "Percentage of Successful Requests: $successPercentage%"
}

# Function to count failed requests
getFailed() {
    local logFile="$1"
    failedRequests=$(grep -E -c 'HTTP/1.[01]\" [45][0-9][0-9] ' "$logFile")
    echo "Number of Failed Requests: $failedRequests"
}

# Function to find the most active user
getMostActive() {
    local logFile="$1"
    mostActiveUser=$(awk '{print $1}' "$logFile" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
    echo "Most Active User (IP Address): $mostActiveUser"
}

# Function to count HTTP methods (GET/POST)
getHttpMethod() {
    local logFile="$1"
    getCount=$(grep -c '"GET ' "$logFile")
    postCount=$(grep -c '"POST ' "$logFile")
    totalCount=$((getCount + postCount))

    echo "Total Requests Count: $totalCount"
    echo "Number of GET Requests: $getCount"
    echo "Number of POST Requests: $postCount"
}

# Main script execution
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 path_to_log_file"
    exit 1
else
    logFile="$1"
    checkLog "$logFile"
    getHttpMethod "$logFile"
    getFailed "$logFile"
    getSuccess "$logFile"
    getMostActive "$logFile"
fi
