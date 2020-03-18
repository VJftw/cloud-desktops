#!/bin/bash -e

curl -L https://releases.hashicorp.com/packer/1.5.4/packer_1.5.4_linux_amd64.zip \
    -o /tmp/packer.zip

unzip /tmp/packer.zip

mkdir -p ~/.local/bin
mv packer ~/.local/bin/packer
