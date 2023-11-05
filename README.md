# ansible-shared
Scripts for sharing to the public.

## Scripts explained
### Ansible Repository Initialization Scripts

This repository contains two Bash scripts designed to streamline the setup and initialization of Ansible repositories and inventory structures:

1. **initialize_ansible_repo.sh**
2. **create_inventory_setup.sh**

#### 1. initialize_ansible_repo.sh

##### Description

This script automates the process of setting up a new Ansible repository with a standardized directory structure. It creates directories for roles, inventories, collections, and variables. Additionally, it generates example `requirements.yml` files for roles and collections sourced from Ansible Galaxy and GitHub. An `ansible.cfg` configuration file is also created, and a unique vault password file is generated and stored securely.

##### Directory Structure

The script sets up the following directory structure:

```
ansible-repo/
│   ansible.cfg
│   README.md
├── roles/
│   └── requirements.yml
├── inventories/
├── collections/
│   └── requirements.yml
└── vars/
```

##### Usage

To use the script, provide the desired path for the new Ansible repository:

```bash
sudo ./initialize_ansible_repo.sh ~/ansible-repo
```

#### 2. create_inventory_setup.sh

##### Description

This script automates the creation of an inventory structure within an existing Ansible repository. Given an inventory name and a path, it generates the required directories (`host_vars` and `group_vars`) and sample files (e.g., `inventory.ini`, `vault.yml`, `vars.yml`).

##### Inventory Structure

The script sets up the following inventory structure:

```
inventories/
└── <inventory_name>/
    ├── inventory.ini
    ├── host_vars/
    │   └── example_host/
    │       ├── vault.yml
    │       └── vars.yml
    └── group_vars/
        └── example_group/
            ├── vault.yml
            └── vars.yml
```

##### Usage

To use the script, provide the inventory name and the creation path:

```bash
./create_inventory_setup.sh <inventory_name> <creation_path>
```

##### Validation

The script also includes validation checks to ensure that the input is valid and prompts the user to confirm the correctness of the input.

#### Conclusion

These scripts serve as utility tools to quickly set up and standardize Ansible repositories and inventory structures. They aim to save time and ensure consistency across different setups.
