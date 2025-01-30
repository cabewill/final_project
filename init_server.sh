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

  chmod +x *.sh

  source $REPO_DIR/server_setup.sh

  source $REPO_DIR/webapp_deploy.sh

  source $REPO_DIR/task_deploy.sh

  echo "Setup complete."