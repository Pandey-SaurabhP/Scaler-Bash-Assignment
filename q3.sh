# Check if extra string is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <extra_string>"
    exit 1
fi

extra_string="$1"

# Set the Output file
output_file="running_services.txt"

# To display all services
ps_output=$(ps -eo pid,tty,time,comm,stat)

# Filter the output to only include lines with status R or R+ and put it into the output file
echo "$ps_output" | grep -E ' [R][+]? ' | grep -v grep | awk '{print $1"   "$2"   "$3"   "$4"    "$5}' > "$output_file"

# Saved it to output
# Display matching lines
status=false

while read -r line; do
    command_name=$(echo "$line" | awk -F/ '{print $NF}')
    if [[ "$command_name" == "$extra_string" ]]; then
        echo "$line"
        status=true
    fi
done < "$output_file"

if $status; then
    echo "Service is running"
else
    echo "Service is not running"
fi