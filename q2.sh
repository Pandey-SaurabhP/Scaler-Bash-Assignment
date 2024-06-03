# For the below program, I have created a simple function it takes directory
# as input. *** The directory should be relative to current path ***
# Then the program goes on reading the files in the given directory
# result is a structure that keeps the count associated with the string
# then the result is printed in descending order

countFileTypes() {
    local directory="$1"
    declare -A fileCounts

    while IFS= read -r -d '' file; do
        extension="${file##*.}"
        if [[ "$file" == *.* ]]; then
            extension=".$extension"
        else
            extension="No Extension"
        fi
        ((fileCounts["$extension"]++))
    done < <(find "$directory" -type f -print0)

    results=()
    for ext in "${!fileCounts[@]}"; do
        results+=("$ext -> ${fileCounts[$ext]}")
    done

    printf "%s\n" "${results[@]}" | sort -t '>' -k2 -nr
}

# Main script execution
if [[ -d "$1" ]]; then
    absolutePath=$(realpath "$1")
    countFileTypes "$absolutePath"
else
    echo "Usage: $0 directory_path"
    echo "Please provide a valid directory path." # Please provide relative directory path, relative to current path
fi
