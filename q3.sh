#!/bin/bash

# This script checks if a specified service (process) is currently running on the system.
# It takes one command-line argument: the name of the service to check.
# The script lists all running services, filters the list to include only those with a running status,
# and then checks if the specified service is in the filtered list.
# If the service is running, it prints the service details; otherwise, it indicates that the service is not running.

if [ -z "$1" ]; then
    echo "Usage: $0 <extraString>"
    exit 1
fi

extraString="$1"
outputFile="running_services.txt"
psOutput=$(ps -eo pid,tty,time,comm,stat)

echo "$psOutput" | grep -E ' [R][+]? ' | grep -v grep | awk '{print $1"   "$2"   "$3"   "$4"    "$5}' > "$outputFile"

status=false

while read -r line; do
    commandName=$(echo "$line" | awk -F/ '{print $NF}')
    if [[ "$commandName" == "$extraString" ]]; then
        echo "$line"
        status=true
    fi
done < "$outputFile"

if $status; then
    echo "Service is running"
else
    echo "Service is not running"
fi
