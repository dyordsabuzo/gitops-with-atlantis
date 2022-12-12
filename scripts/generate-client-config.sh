#!/bin/sh
set -e

cat <<EOF > atlantis.yaml
version: 3
projects:
- name: poc
  dir: .
  workspace: poc
  workflow: terraform
  autoplan:
    enabled: true  
EOF