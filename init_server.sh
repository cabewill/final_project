#!/bin/bash

set -euo pipefail

  
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

  # Run the server setup playbook
  echo "Running server setup playbook..."
  ansible-playbook -i localhost, playbooks/server_setup.yml
  if [ $? -ne 0 ]; then
    echo "Error: Server setup playbook failed."
    exit 1
  fi
fi

# Run the webapp deployment playbook
echo "Running webapp deployment playbook..."
ansible-playbook -i localhost, playbooks/webapp_deploy.yml
if [ $? -ne 0 ]; then
  echo "Error: Webapp deployment playbook failed."
  exit 1
fi

# Run the task deployment playbook
echo "Running task deployment playbook..."
ansible-playbook -i localhost, playbooks/task_deploy.yml
if [ $? -ne 0 ]; then
  echo "Error: Task deployment playbook failed."
  exit 1
fi

echo "Setup complete."
