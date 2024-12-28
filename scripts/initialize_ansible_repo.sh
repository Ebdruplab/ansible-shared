#!/bin/bash
#=======================================================
# SCRIPT CREATED BY KRISTIAN
#=======================================================
# This script initializes a new Ansible repository with a specific directory structure.
# The structure includes directories for roles, inventories, collections, and variables,
# along with example requirements.yml files for roles and collections sourced from both
# Ansible Galaxy and GitHub. It also creates an ansible.cfg configuration file, a vault
# password file with a random 30-character password, and sets up an initialization script
# for development environments.
#
# Usage:
#   ./initialize_ansible_repo.sh <ansible_repo_path>
# Example:
#   ./initialize_ansible_repo.sh ~/ansible-repo
#=======================================================

#=======================================================
# Ensure a directory path is provided
#=======================================================
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ansible_repo_path>"
  exit 1
fi

#=======================================================
# Define the Ansible repository path
#=======================================================
ANSIBLE_REPO=$(realpath "$1")
REPO_NAME=$(basename "${ANSIBLE_REPO}")

#=======================================================
# Define directories to be created
#=======================================================
DIRECTORIES=(
  "roles"
  "inventories"
  "collections"
  "vars"
  "scripts"
  "playbooks"
  "templates"
  "files"
)

#=======================================================
# Create the Ansible repository directory and directories
#=======================================================
for dir in "${DIRECTORIES[@]}"; do
  FULL_PATH="${ANSIBLE_REPO}/${dir}"
  mkdir -p "${FULL_PATH}"
  echo "Directory created: ${FULL_PATH}"
done

#=======================================================
# Additional script files creation
#=======================================================

# Init development script
INIT_DEV_SCRIPT="${ANSIBLE_REPO}/scripts/init_dev.sh"
cat <<EOL > "$INIT_DEV_SCRIPT"
#!/bin/bash
# This script sets the ANSIBLE_VAULT_PASSWORD_FILE environment variable for development purposes.

export ANSIBLE_VAULT_PASSWORD_FILE="${HOME}/.vault_keys/.${REPO_NAME}"
echo "Ansible Vault password file set to: \$ANSIBLE_VAULT_PASSWORD_FILE"
EOL
chmod +x "$INIT_DEV_SCRIPT"
echo "Development init script created: ${INIT_DEV_SCRIPT}"

#=======================================================
# Create roles/requirements.yml file with examples
#=======================================================
ROLES_REQ="${ANSIBLE_REPO}/roles/requirements.yml"
cat <<EOL > "$ROLES_REQ"
roles: {}
  ## Example role requirements from Ansible Galaxy
  # - name: example_role
  #   src: ansible-role-example
  #   version: v1.0

  ## Example role requirements from GitHub
  # - name: example_role_github'
  #   src: https://github.com/user/ansible-role-example
  #   version: master
EOL
echo "File created: ${ROLES_REQ}"

#=======================================================
# Create collections/requirements.yml file with examples
#=======================================================
COLLECTIONS_REQ="${ANSIBLE_REPO}/collections/requirements.yml"
cat <<EOL > "$COLLECTIONS_REQ"
collections: {}
  ## Example collection requirements from Ansible Galaxy
  #- name: ansible.builtin
  #  version: "1.0.0"
  #  source: https://galaxy.ansible.com

  ## Example collection requirements from GitHub
  #- name: example_collection_github
  #  src: https://github.com/user/ansible-collection-example
  #  version: main
EOL
echo "File created: ${COLLECTIONS_REQ}"

#=======================================================
# Create site.yml file in root directory
#=======================================================
SITE_YML="${ANSIBLE_REPO}/site.yml"
cat <<EOL > "$SITE_YML"
---
- import_playbook: playbooks/pb_example.yml
EOL
echo "File created: ${SITE_YML}"

#=======================================================
# Create example playbook in playbooks directory
#=======================================================
EXAMPLE_PB="${ANSIBLE_REPO}/playbooks/pb_example.yml"
cat <<EOL > "$EXAMPLE_PB"
# Description: This is an example site file playbook.

# How to run: 
# ansible-playbook site.yml --limit="hostname.example.com" --check --diff
---

- name: Example Playbook
  hosts: all
  tasks:
    - name: Ensure example file exists
      ansible.builtin.copy:
        content: "This is an example file."
        dest: /tmp/example.txt
EOL
echo "File created: ${EXAMPLE_PB}"

#=======================================================
# Create README.md file
#=======================================================
README="${ANSIBLE_REPO}/README.md"
cat <<EOL > "$README"
# Ansible Repository

This repository contains Ansible playbooks, roles, and configurations.

## Directory Structure

- \`roles\`: Contains Ansible roles and a \`requirements.yml\` file for external roles.
- \`inventories\`: Inventory files defining hosts and groups.
- \`collections\`: Ansible collections along with a \`requirements.yml\` file for external collections.
- \`vars\`: Variables files.
- \`scripts\`: is holding bash scripts e.g the requerements.yml file init.

## Usage

To use this repository, clone it and run the necessary playbooks using the Ansible commands.

For example:

\`\`\`
ansible-playbook -i inventories/hosts.ini example-playbook.yml
\`\`\`
EOL
echo "File created: ${README}"

#=======================================================
# Create ansible.cfg file
#=======================================================
ANSIBLE_CFG="${ANSIBLE_REPO}/ansible.cfg"
cat <<EOL > "$ANSIBLE_CFG"
# Ansible configuration file
[defaults]
# inventory = inventories/${REPO_NAME}/inventory.ini
roles_path = ~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:./roles
filter_plugins=~/.ansible/plugins/filter:/usr/share/ansible/plugins/filter:~/plugins/filter
host_key_checking = False
# vault_password_file = ~/vault_keys/${REPO_NAME}
stdout_callback = ansible.builtin.default

[privilege_escalation]
# become = true
# become_method = sudo
# become_user = root

[colors]
highlight = white
verbose = blue
warn = bright purple
error = red
debug = dark gray
deprecate = purple
skip = cyan
unreachable = red
ok = green
changed = yellow
diff_add = green
diff_remove = red
diff_lines = cyan

# Can be enabled if in cooperate env
# [galaxy]
# server_list = automation_hub, galaxy_opensource
# 
# [galaxy_server.automation_hub]
# url=https://console.redhat.com/api/automation-hub/content/published/
# auth_url=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
# token=URKEYS
# [galaxy_server.galaxy_opensource]
# url=https://galaxy.ansible.com/
EOL
echo "File created: ${ANSIBLE_CFG}"

#=======================================================
# Generate a .gitignore file
#=======================================================
GITIGNORE_FILE="${ANSIBLE_REPO}/.gitignore"
cat <<EOL > "$GITIGNORE_FILE"
# Custom gitignore file for Ansible collections and roles
# VS CODE
.vscode/*
# ANSIBLE
collections/*
roles/*

# DO SYNC WITH GIT
!collections/requirements.yml
!roles/requirements.yml

EOL
echo "File created: ${GITIGNORE_FILE}"

#=======================================================
# Create the init_script.sh file
#=======================================================
INIT_SCRIPT="${ANSIBLE_REPO}/scripts/init_script.sh"
cat <<EOL > "$INIT_SCRIPT"
#!/bin/bash

# Check if ANSIBLE_REPO is set
if [ -z "${ANSIBLE_REPO}" ]; then
    # ANSIBLE_REPO is not set, use the current directory
    ANSIBLE_REPO=$(pwd)

    # Ask the user for confirmation
    read -p "ANISBLE_REPO is not set. Do you want to use the current directory ${ANSIBLE_REPO}? (y/n) " -n 1 -r
    echo # Move to a new line
    if [[ ! \$REPLY =~ ^[Yy]$ ]]; then
        # If the user does not confirm, exit the script
        echo "Aborted."
        exit 1
    fi
fi

echo "Installing requirements for roles..."
ansible-galaxy role install -r "\${ANSIBLE_REPO}/roles/requirements.yml" -p "\${ANSIBLE_REPO}/roles"

echo "Installing requirements for collections..."
ansible-galaxy collection install -r "\${ANSIBLE_REPO}/collections/requirements.yml" -p "\${ANSIBLE_REPO}/collections"

echo "Requirements installation complete."

EOL
echo "Init script created: ${INIT_SCRIPT}"
if [[ $EUID -eq 0 ]]; then
  chmod +x "$INIT_SCRIPT"
fi

if [[ $EUID -ne 0 ]]; then
  echo -e "\033[1;34mThis script isn't run as sudo so we can't set the correct ownership on the $INIT_SCRIPT\033[0m"
fi

#=======================================================
# Create symbolic links for templates and files in playbooks directory
#=======================================================
# Save the current directory
CURRENT_DIR=$(pwd)

# Change to playbooks directory
cd "${ANSIBLE_REPO}/playbooks"

# Create symbolic links
ln -s ../templates templates
ln -s ../files files
echo "Symbolic links created: templates and files in playbooks directory"

# Return to the original directory
cd "$CURRENT_DIR"

#=======================================================
# Create the vault password file with a random 30-character password
#=======================================================
VAULT_DIR="${HOME}/.vault_keys"
mkdir -p "${VAULT_DIR}"
VAULT_PW_FILE="${VAULT_DIR}/.${REPO_NAME}"
RANDOM_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c45; echo '')
echo "${RANDOM_PASSWORD}" > "${VAULT_PW_FILE}"
echo "File created: ${VAULT_PW_FILE}"

# Set permissions if root
if [[ $EUID -eq 0 ]]; then
  chmod 0660 "${VAULT_DIR}"
  chmod 0660 "${VAULT_PW_FILE}"
else
  # Check if sudo is available and if the user can use sudo without a password
  if sudo -n true 2>/dev/null; then
    sudo chmod 0660 "${VAULT_DIR}"
    sudo chmod 0660 "${VAULT_PW_FILE}"
    echo "Permissions set with sudo"
  else
    echo -e "\033[1;34mThis script isn't run as sudo and the user does not have passwordless sudo access, so we can't set the correct ownership on the directory\033[0m"
  fi
fi


#=======================================================
# Completion message
#=======================================================
echo "Ansible repository layout created at ${ANSIBLE_REPO}"