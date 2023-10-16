#!/usr/bin/env bash
set -Eeuo pipefail

JQ="$(dirname $0)/third_party/binary/jq"

gcp_project="${GCP_PROJECT_ID:=}"

packer_manifests=($(find ./plz-out -name 'packer-manifest.json'))

artifact_ids=()
for packer_manifest in "${packer_manifests[@]}"; do
    printf "inspecting packer manifest '%s'\n" "${packer_manifest}"
    artifact_ids+=($($JQ -r '.builds[].artifact_id' "${packer_manifest}"))
done

if (( ${#artifact_ids[@]} )); then
    printf "deleting ${#artifact_ids[@]} images.\n"
    gcloud --quiet --project "${gcp_project}" compute images delete "${artifact_ids[@]}"
else
    printf "no images to delete.\n"
fi

## terminate instances older than 6 hours
all_csv_instances=($(gcloud --project "${gcp_project}" compute instances list --format="csv(name, creationTimestamp, zone)" | tail -n+2))

for csv_instance in "${all_csv_instances[@]}"; do
    instance_name="$(echo "${csv_instance}" | cut -f1 -d,)"
    instance_created="$(echo "${csv_instance}" | cut -f2 -d,)"
    zone="$(echo "${csv_instance}" | cut -f3 -d,)"

    instance_created_normalised="$(date --date="${instance_created}" '+%s')"
    oldest_accepted_timestamp="$(date --date="-6 hours" '+%s')"

    if [ "${oldest_accepted_timestamp}" -ge "${instance_created_normalised}" ]; then
        # delete this instance
        printf "deleting '%s' as '%s' is older than '%s'.\n" "${instance_name}" "${instance_created_normalised}" "${oldest_accepted_timestamp}"
        gcloud --quiet --project "${gcp_project}" compute instances delete --zone "${zone}" --delete-disks=all "${instance_name}"
    fi

done
