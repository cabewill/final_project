#!/bin/bash

set -euo pipefail

  REPO_DIR="/tmp/final_project"

  # Run the task deployment playbook
  echo "Running task deployment playbook..."
  ansible-playbook -i localhost -c local --vault-password-file vault.pass $REPO_DIR/playbooks/task_deploy.yml
  if [ $? -ne 0 ]; then
    echo "Error: Task deployment playbook failed."
    exit 1
  fi
