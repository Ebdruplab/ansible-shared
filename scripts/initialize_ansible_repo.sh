#!/bin/bash

# README
# This script initializes a new Ansible repository with a specific directory structure.
# The structure includes directories for roles, inventories, collections, and variables,
# along with example requirements.yml files for roles and collections sourced from both
# Ansible Galaxy and GitHub.
#
# Usage:
#   ./initialize_ansible_repo.sh <ansible_repo_path>
# Example:
#   ./initialize_ansible_repo.sh ~/ansible-repo
#

# Ensure a directory path is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ansible_repo_path>"
  exit 1
fi

# Define the Ansible repository path
ANSIBLE_REPO=$(realpath "$1")

# Define directories to be created
DIRECTORIES=(
  "roles"
  "inventories"
  "collections"
  "vars"
)

# Create the Ansible repository directory and directories
for dir in "${DIRECTORIES[@]}"; do
  FULL_PATH="${ANSIBLE_REPO}/${dir}"
  mkdir -p "${FULL_PATH}"
  echo "Directory created: ${FULL_PATH}"
done

# Create roles/requirements.yml file with examples from Ansible Galaxy and GitHub
ROLES_REQ="${ANSIBLE_REPO}/roles/requirements.yml"
cat <<EOL > "$ROLES_REQ"
# Example role requirements from Ansible Galaxy
- name: example_role
  src: ansible-role-example
  version: v1.0

# Example role requirements from GitHub
- name: example_role_github
  src: https://github.com/user/ansible-role-example
  version: master
EOL
echo "File created: ${ROLES_REQ}"

# Create collections/requirements.yml file with examples from Ansible Galaxy and GitHub
COLLECTIONS_REQ="${ANSIBLE_REPO}/collections/requirements.yml"
cat <<EOL > "$COLLECTIONS_REQ"
# Example collection requirements from Ansible Galaxy
- name: ansible.builtin
  version: "1.0.0"
  source: https://galaxy.ansible.com

# Example collection requirements from GitHub
- name: example_collection_github
  src: https://github.com/user/ansible-collection-example
  version: main
EOL
echo "File created: ${COLLECTIONS_REQ}"

# Create README.md file
README="${ANSIBLE_REPO}/README.md"
cat <<EOL > "$README"
# Ansible Repository

This repository contains Ansible playbooks, roles, and configurations.

## Directory Structure

- \`roles\`: Contains Ansible roles and a \`requirements.yml\` file for external roles.
- \`inventories\`: Inventory files defining hosts and groups.
- \`collections\`: Ansible collections along with a \`requirements.yml\` file for external collections.
- \`vars\`: Variables files.

## Usage

To use this repository, clone it and run the necessary playbooks using the Ansible commands.

For example:

\`\`\`
ansible-playbook -i inventories/hosts.ini example-playbook.yml
\`\`\`
EOL
echo "File created: ${README}"

echo "Ansible repository layout created at ${ANSIBLE_REPO}"
