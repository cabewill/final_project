#!/bin/bash

set -euo pipefail

  REPO_DIR="/tmp/final_project"

  # Run the webapp deployment playbook
  echo "Running webapp deployment playbook..."
  ansible-playbook -i localhost -c local, $REPO_DIR/playbooks/webapp_deploy.yml
  if [ $? -ne 0 ]; then
    echo "Error: Webapp deployment playbook failed."
    exit 1
  fi