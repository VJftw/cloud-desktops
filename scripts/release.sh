#!/bin/bash -e

gcp_project="vjftw-images"

target="$1"

target_dir=$(dirname "${target}")
target_file=$(basename "${target}")

cd "${target_dir}"

export PATH="${HOME}/.local/bin/:${PATH}"

packer build -var "gcp_project_id=${gcp_project}" "${target_file}"
