#!/usr/bin/env bash
set -Eeuo pipefail

JQ="$(dirname $0)/third_party/binary/jq"

output_file="$1"

packer_manifests=($(find ./plz-out -name 'packer-manifest.json'))

artifact_ids=()
for packer_manifest in "${packer_manifests[@]}"; do
    printf "inspecting packer manifest '%s'\n" "${packer_manifest}"
    artifact_ids+=($($JQ -r '.builds[].artifact_id' "${packer_manifest}"))
done

printf "%s\n" "${artifact_ids[@]}" > "${output_file}"

echo "wrote $output_file"
