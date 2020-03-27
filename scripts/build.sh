#!/bin/bash -e

export GOOGLE_APPLICATION_CREDENTIALS="${GITHUB_WORKSPACE}.google-application-credentials"

gcp_project="vjftw-images"

target="$1"

target_dir=$(dirname "${target}")
target_file=$(basename "${target}")

cd "flavours/${target_dir}"

export PATH="${HOME}/.local/bin/:${PATH}"

version=$(git describe --always)

image_name=$(packer -machine-readable build -var "gcp_project_id=${gcp_project}" -var "version_suffix=-${version}" "${target_file}.json" | tee >(cat 1>&2) | awk -F, '$0 ~/artifact,0,id/ {print $6}')

echo "-> making ${image_name} public"
gcloud auth activate-service-account --key-file "${GOOGLE_APPLICATION_CREDENTIALS}"
gcloud compute images add-iam-policy-binding "${image_name}" \
    --project="${gcp_project}" \
    --member='allAuthenticatedUsers' \
    --role='roles/compute.imageUser'


