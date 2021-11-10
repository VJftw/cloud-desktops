#!/usr/bin/env bash
set -Eeuo pipefail

output_file="$1"

gcp_project="${GCP_PROJECT_ID:=}"
version="$(./scripts/version.sh)"

released_images=$(gcloud compute images list --project="${gcp_project}" \
    --format="value(NAME)" \
    --filter="name=${version}" | awk '{printf "%s\\n", $0}')

echo "${released_images}" > "${output_file}"

echo "wrote $output_file"
