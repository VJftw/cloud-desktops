#!/usr/bin/env bash
set -Eeuo pipefail

PACKER_VERSION=1.5.4

curl -L "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" \
    -o /tmp/packer.zip

unzip /tmp/packer.zip

mkdir -p ~/.local/bin
mv packer ~/.local/bin/packer
