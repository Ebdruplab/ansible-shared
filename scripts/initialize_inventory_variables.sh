#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <inventory_file_path> <target_directory>"
    exit 1
fi

# Assign command line arguments to variables
INVENTORY_FILE="$1"
TARGET_DIRECTORY="$2"

# Check if the inventory file exists
if [ ! -f "$INVENTORY_FILE" ]; then
    echo "Inventory file not found: $INVENTORY_FILE"
    exit 1
fi

# Function to create directories and files
create_dirs_and_files() {
    local type=$1
    local name=$2
    local dir_path="$TARGET_DIRECTORY/${type}_vars/${name}"

    mkdir -p "$dir_path"
    touch "$dir_path/vars.yml"
    touch "$dir_path/vault.yml"
}

# Read the inventory file
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    if [[ -z "$line" || $line == \#* ]]; then
        continue
    fi

    # Check for group names
    if [[ $line == \[*\] ]]; then
        group_name=$(echo $line | tr -d '[]')
        create_dirs_and_files "group" "$group_name"
    else
        # Assume it's a hostname
        host_name=$line
        create_dirs_and_files "host" "$host_name"
    fi
done < "$INVENTORY_FILE"

echo "Directories and files created successfully at $TARGET_DIRECTORY."
