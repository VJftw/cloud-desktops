#!/usr/bin/env bash
set -Eeuo pipefail

JQ="$(dirname $0)/third_party/binary/jq"

gcp_project="${GCP_PROJECT_ID:=}"

packer_manifests=($(find ./plz-out -name 'packer-manifest.json'))
if [ ${#packer_manifests[@]} -eq 0 ]; then
    >&2 printf "unexpectedly no packer manifests found\n"
    exit 1
fi

artifact_ids=()
for packer_manifest in "${packer_manifests[@]}"; do
    printf "inspecting packer manifest '%s'\n" "${packer_manifest}"
    artifact_ids+=($($JQ -r '.builds[].artifact_id' "${packer_manifest}"))
done

if [ ${#artifact_ids[@]} -eq 0 ]; then
    >&2 printf "unexpectedly no artifacts found\n"
    exit 1
fi

for artifact_id in "${artifact_ids[@]}"; do
    printf "making %s publicly accessible\n" "${artifact_id}"
    gcloud compute images add-iam-policy-binding "${artifact_id}" \
        --project="${gcp_project}" \
        --member='allAuthenticatedUsers' \
        --role='roles/compute.imageUser'
done

printf "finished making artifacts publicly accessible\n"
exit 0
