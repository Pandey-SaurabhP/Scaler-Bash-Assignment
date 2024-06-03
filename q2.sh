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
