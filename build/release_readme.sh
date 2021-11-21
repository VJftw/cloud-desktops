#!/usr/bin/env bash
set -Eeuo pipefail


JQ="$(dirname $0)/third_party/binary/jq"

packer_manifests=($(find ./plz-out -name 'packer-manifest.json'))

debian_image=""
for packer_manifest in "${packer_manifests[@]}"; do
    printf "inspecting packer manifest '%s'\n" "${packer_manifest}"
    artifact_id=$($JQ -r '.builds[].artifact_id' "${packer_manifest}")
    if [[ "${artifact_id}" == *"debian-xfce4"* ]]; then
        debian_image="${artifact_id}"
        break
    fi
done

if [ -z "${debian_image}" ]; then
    printf "no image found for debian-xfce4, exiting."
    exit 0
fi

# debian_image="debian-xfce4-2021-11-20-58e5e53"

# update the debian example in the README.
sed -i "s/debian-xfce4-.*/${debian_image}/" README.md

git add README.md
git commit -m "update README to ${debian_image}"
git push origin master
