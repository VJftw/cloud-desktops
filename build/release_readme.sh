#!/usr/bin/env bash
set -Eeuo pipefail


JQ="$(dirname $0)/third_party/binary/jq"

packer_manifests=($(find ./plz-out -name 'packer-manifest.json'))

artifact_ids=()

function replaceImageVariable {
    local variable_name
    local image_name
    variable_name="$1"
    image_name="$2"

    found_image=""
    for packer_manifest in "${packer_manifests[@]}"; do
        printf "inspecting packer manifest '%s'\n" "${packer_manifest}"
        artifact_id=$($JQ -r '.builds[].artifact_id' "${packer_manifest}")
        if [[ "${artifact_id}" == *"$image_name"* ]]; then
            found_image="${artifact_id}"
            break
        fi
    done

    if [ -z "${found_image}" ]; then
        printf "no image found for $image_name.\n"
        return
    fi

    artifact_ids+=("$artifact_id")
    sed -i "s/$variable_name=.*/$variable_name=\"$artifact_id\"/" README.md
}

replaceImageVariable "DEBIAN_IMAGE" "debian-xfce4"
replaceImageVariable "KALI_IMAGE" "kali-xfce4"
replaceImageVariable "ARCH_IMAGE" "arch-xfce4"

# git add README.md
# git commit -m "update README to ${artifact_ids[*]}"
# git push origin main
