#!/usr/bin/env bash
set -Eeuo pipefail

JQ="$(dirname $0)/third_party/binary/jq"

gcp_project="${GCP_PROJECT_ID:=}"
github_repository="${GITHUB_REPOSITORY:=}"

## terminate instances older than 2 hours

all_csv_instances=($(gcloud --project "${gcp_project}" compute instances list --format="csv(name, creationTimestamp, zone)" | tail -n+2))

for csv_instance in "${all_csv_instances[@]}"; do
    instance_name="$(echo "${csv_instance}" | cut -f1 -d,)"
    instance_created="$(echo "${csv_instance}" | cut -f2 -d,)"
    zone="$(echo "${csv_instance}" | cut -f3 -d,)"

    instance_created_normalised="$(date --date="${instance_created}" '+%s')"
    oldest_accepted_timestamp="$(date --date="-2 hours" '+%s')"

    if [ "${oldest_accepted_timestamp}" -ge "${instance_created_normalised}" ]; then
        # delete this instance
        printf "deleting '%s' as '%s' is older than '%s'.\n" "${instance_name}" "${instance_created_normalised}" "${oldest_accepted_timestamp}"
        gcloud --quiet --project "${gcp_project}" compute instances delete --zone "${zone}" --delete-disks=all "${instance_name}"
    fi

done

## only keep last 10 releases
mapfile -t all_github_release_ids < \
    <(curl --silent -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${github_repository}/releases" | jq -r '.[] | ( .name + "," + (.id|tostring) )')

mapfile -t releases_to_delete < \
    <(printf "%s\n" "${all_github_release_ids[@]}" | tail -n +11)

if (( ${#releases_to_delete[@]} )); then
    printf "deleting ${#releases_to_delete[@]} releases.\n"


    for release_id in "${releases_to_delete[@]}"; do
        release="$(echo "$release_id" | cut -f1 -d",")"
        id="$(echo "$release_id" | cut -f2 -d",")"
        curl --silent -L \
            -X DELETE \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $GITHUB_TOKEN" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "https://api.github.com/repos/${github_repository}/releases/$id"
    done
fi

## delete images not associated with a release

all_csv_images=($(gcloud --project "${gcp_project}" compute images list --no-standard-images --format="csv(name, creationTimestamp)" | tail -n+2))

images_to_delete=()
for csv_image in "${all_csv_images[@]}"; do
    image_name="$(echo "${csv_image}" | cut -f1 -d,)"
    image_created="$(echo "${csv_image}" | cut -f2 -d,)"

    if [[ "${all_github_releases[@]}" != *"${image_name}"* ]]; then
        images_to_delete+=("${image_name}")
    else
        printf "keeping image '%s'.\n" "${image_name}"
    fi
done

if (( ${#images_to_delete[@]} )); then
    printf "deleting ${#images_to_delete[@]} images.\n"
    gcloud --quiet --project "${gcp_project}" compute images delete "${images_to_delete[@]}"
else
    printf "no images to delete.\n"
fi

## delete tags not associated with a release
git fetch --tags --prune --prune-tags

all_git_tags=($(git tag))

for git_tag in "${all_git_tags[@]}"; do
    if [[ "${all_github_releases[@]}" != *"${git_tag}"* ]]; then
        printf "deleting tag '%s'.\n" "${git_tag}"
        git tag -d "${git_tag}"
        git push --delete origin "${git_tag}"
    else
        printf "keeping tag '%s'.\n" "${git_tag}"
    fi
done
