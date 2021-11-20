#!/usr/bin/env bash
set -Eeuo pipefail

JQ="$(dirname $0)/third_party/binary/jq"

gcp_project="${GCP_PROJECT_ID:=}"

packer_manifests=($(find ./plz-out -name 'packer-manifest.json'))
artifact_ids=()
for packer_manifest in "${packer_manifests[@]}"; do
    printf "inspecting packer manifest '%s'\n" "${packer_manifest}"
    artifact_ids+=($($JQ -r '.builds[] | select(.name == "googlecompute") | .artifact_id' "${packer_manifest}"))
done

for artifact_id in "${artifact_ids[@]}"; do
    printf "making %s publicly accessible\n" "${artifact_id}"
    gcloud compute images add-iam-policy-binding "${artifact_id}" \
        --project="${gcp_project}" \
        --member='allAuthenticatedUsers' \
        --role='roles/compute.imageUser'
done
