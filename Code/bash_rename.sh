#!/bin/bash

# Loop through all files in the current directory
# cd "/mnt/f/Data/CMIP6"
cd "/mnt/f/Data/analysis"

for file in *; do
    # Only process files (ignore directories)
    if [[ -f "$file" ]]; then
        # Check if the filename contains an underscore before the extension
        if [[ "$file" =~ _\.[^.]+$ ]]; then
            # Remove the last underscore before the file extension
            new_file=$(echo "$file" | sed 's/_\(\.[^.]*\)$/\1/')
            mv "$file" "$new_file"
            echo "Renamed: $file -> $new_file"
        fi
    fi
done
