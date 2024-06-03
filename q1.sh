
# Above program has multiple functions each performs a task
# I have used grep to match the strings for a pattern
# awk is used to keep the output in a sorted fashion 
# Simple formulaes are used to keep the program more understandable
# Finally, since the request can be either POST or GET, totalCount = cnt(POST) + cnt(GET)
# It is ultimately used in calculating the percentage of success requests

totalCount=0

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

getFailed() {
    local logFile="$1"
    failedRequests=$(grep -E -c 'HTTP/1.[01]\" [45][0-9][0-9] ' "$logFile")
    echo "Number of Failed Requests: $failedRequests"
}

getMostActive() {
    local logFile="$1"
    mostActiveUser=$(awk '{print $1}' "$logFile" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
    echo "Most Active User (IP Address): $mostActiveUser"
}

getHttpMethod() {
    local logFile="$1"
    getCount=$(grep -c '"GET ' "$logFile")
    postCount=$(grep -c '"POST ' "$logFile")
    totalCount=$((getCount + postCount))

    echo "Total Requests Count: $totalCount"
    echo "Number of GET Requests: $getCount"
    echo "Number of POST Requests: $postCount"
}

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

