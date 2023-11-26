#!/bin/bash

find_files() {
    local current_dir="$1"
    local target_timestamp="$2"
    for file in "$current_dir"/*; do
        if [ -f "$file" ]; then
            local creation_time=$(stat -c %Y "$file")
            if [ "$creation_time" -lt "$target_timestamp" ]; then
                echo "$file"
            fi
        elif [ -d "$file" ]; then
            find_files "$file" "$target_timestamp"
        fi
    done
}

if [ "$#" -ne 2 ]; then
    echo "Using: $0 <directory> <data>"
    exit 1
fi

directory="$1"
target_date="$2"

if [ ! -d "$directory" ]; then
    echo "Invalid directory: '$directory'"
    exit 1
fi

if ! [[ "$target_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Invalid date"
    exit 1
fi

target_timestamp=$(date -d "$target_date" +%s 2>/dev/null)

find_files "$directory" "$target_timestamp"
