#!/bin/bash

set -euo pipefail

  REPO_DIR="/tmp/final_project"

  # Run the server setup playbook
  echo "Running server setup playbook..."
  ansible-playbook -i localhost -c local, $REPO_DIR/playbooks/server_setup.yml
  if [ $? -ne 0 ]; then
    echo "Error: Server setup playbook failed."
    exit 1
  fi