#!/bin/bash

set -euo pipefail

  REPO_DIR="/tmp/final_project"

  
  # Check if Ansible is installed
  if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    sudo apt update
    sudo apt install -y ansible
    if [ $? -ne 0 ]; then
      echo "Error: Ansible installation failed."
      exit 1
    fi
  else
    echo "Ansible is already installed."
  fi

  # cp -r ./playbooks $REPO_DIR/playbooks
  # cp -r ./webapp $REPO_DIR/webapp

  # Check if the repository is already cloned

  if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning repository..."
    git clone https://github.com/cabewill/final_project.git "$REPO_DIR"
    if [ $? -ne 0 ]; then
      echo "Error: Git clone failed."
      exit 1
    fi
  else
    echo "Repository is already cloned. Pulling last updates"
    cd "$REPO_DIR"
    sudo git pull
  fi



  export VAULT_PASSWORD=duckduck # This shouldn't be here, and in a production environment I'd get the value from an Azure Vault

  # Run the server setup playbook
  echo "Running server setup playbook..."
  ansible-playbook -i localhost -c local, $REPO_DIR/playbooks/server_setup.yml
  if [ $? -ne 0 ]; then
    echo "Error: Server setup playbook failed."
    exit 1
  fi

# Run the webapp deployment playbook
echo "Running webapp deployment playbook..."
ansible-playbook -i localhost -c local, $REPO_DIR/playbooks/webapp_deploy.yml
if [ $? -ne 0 ]; then
  echo "Error: Webapp deployment playbook failed."
  exit 1
fi

# Run the task deployment playbook
echo "Running task deployment playbook..."
ansible-playbook -i localhost -c local --vault-password-file vault.pass playbooks/task_deploy.yml
if [ $? -ne 0 ]; then
  echo "Error: Task deployment playbook failed."
  exit 1
fi

echo "Setup complete."
