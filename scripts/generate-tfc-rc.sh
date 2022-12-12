#!/bin/sh
set -e

cat << EOF > ~/.terraformrc
credentials "app.terraform.io" {
    token = "${TERRAFORM_CLOUD_TOKEN}"
}
EOF