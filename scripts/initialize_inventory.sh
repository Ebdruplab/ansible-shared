#!/bin/bash

# README
# This script initializes a new Ansible inventory with a specific directory structure.
# The structure includes an inventory.ini file, and directories for host_vars and group_vars.
# For the example host and group, it also creates vault.yml and vars.yml files.
#
# Usage:
#   ./initialize_inventory.sh <inventory_name> <creation_path>
# Example:
#   ./initialize_inventory.sh my_inventory ~/ansible-repo/inventories
#

# Ensure correct number of arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <inventory_name> <creation_path>"
  exit 1
fi

# Get input arguments
INVENTORY_NAME="$1"
CREATION_PATH=$(realpath "$2")

# Validate input
if [ -z "${INVENTORY_NAME}" ] || [ -z "${CREATION_PATH}" ]; then
  echo "Error: Inventory name and creation path must be provided."
  echo "Are you sure that is the correct spot?"
  exit 1
fi

# Define directories to be created
DIRECTORIES=(
  "${INVENTORY_NAME}/host_vars/example_host"
  "${INVENTORY_NAME}/group_vars/example_group"
)

# Create directories
for dir in "${DIRECTORIES[@]}"; do
  FULL_PATH="${CREATION_PATH}/${dir}"
  mkdir -p "${FULL_PATH}"
  echo "Directory created: ${FULL_PATH}"
done

# Create inventory.ini file
INVENTORY_FILE="${CREATION_PATH}/${INVENTORY_NAME}/inventory.ini"
cat <<EOL > "$INVENTORY_FILE"
# Sample inventory.ini file
[example_group]
example_host
EOL
echo "File created: ${INVENTORY_FILE}"

# Create vault.yml and vars.yml for example_host and example_group
for dir in "host_vars/example_host" "group_vars/example_group"; do
  for file in "vault.yml" "vars.yml"; do
    FULL_PATH="${CREATION_PATH}/${INVENTORY_NAME}/${dir}/${file}"
    touch "${FULL_PATH}"
    echo "File created: ${FULL_PATH}"
  done
done

echo "Inventory setup created at ${CREATION_PATH}/${INVENTORY_NAME}"
