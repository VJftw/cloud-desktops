#!/usr/bin/env bash
set -Eeuo pipefail

gcp_project="${GCP_PROJECT_ID:=}"
version=$(./scripts/version.sh)

target="$1"

target_dir=$(dirname "${target}")
target_file=$(basename "${target}")

cd "flavours/${target_dir}"

export PATH="${HOME}/.local/bin/:${PATH}"

image_name=$(packer -machine-readable build -var "gcp_project_id=${gcp_project}" -var "version_suffix=${version}" "${target_file}.json" | tee >(cat 1>&2) | awk -F, '$0 ~/artifact,0,id/ {print $6}')


if [ -v CI ] && [ "${CI}" == "true" ]; then
    echo "-> making ${image_name} public"
    gcloud compute images add-iam-policy-binding "${image_name}" \
        --project="${gcp_project}" \
        --member='allAuthenticatedUsers' \
        --role='roles/compute.imageUser'
fi
