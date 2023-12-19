#!/bin/bash

# Define the path to your Ansible role
ANSIBLE_ROLE_PATH="/path/to/your/ansible/role"

# Path to the var_replacement file
REPLACEMENTS_FILE="$(dirname "$0")/var_replacement"

# Check if the replacements file exists
if [ ! -f "$REPLACEMENTS_FILE" ]; then
    echo "Replacement file not found: $REPLACEMENTS_FILE"
    exit 1
fi

# Read the replacements line by line from the file
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines
    if [ -z "$line" ]; then
        continue
    fi

    # Extract the KEY and VALUE
    KEY="${line%%=*}"
    VALUE="${line#*=}"

    # Perform the replacement on files
    find "$ANSIBLE_ROLE_PATH" -type f -exec sed -i "s/${KEY}/${VALUE}/g" {} +
done < "$REPLACEMENTS_FILE"

echo "Replacement complete."
