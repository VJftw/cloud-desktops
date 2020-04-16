#!/bin/bash -e

github_api_version="application/vnd.github.v3+json"
github_owner="VJftw"
github_repo="cloud-desktops"


export GOOGLE_APPLICATION_CREDENTIALS="${GITHUB_WORKSPACE}.google-application-credentials"
gcp_project="vjftw-images"

version=$(git describe --always)

echo "-> finding built images for this version..."
gcloud auth activate-service-account --key-file "${GOOGLE_APPLICATION_CREDENTIALS}"
released_images=$(gcloud compute images list --project="${gcp_project}" \
    --format="value(NAME)" \
    --filter="name=${version}" | awk '{printf "%s\\n", $0}')

post_release_json=$(cat <<EOF
{
  "tag_name": "${version}",
  "target_commitish": "master",
  "name": "${version}",
  "body": "${released_images}",
  "draft": false,
  "prerelease": false
}
EOF
)

release_resp=$(curl \
  --header "Accept: ${github_api_version}" \
  --header "Authorization: token ${GITHUB_TOKEN}" \
  --silent \
  --request POST \
  --data "${post_release_json}" \
  "https://api.github.com/repos/${github_owner}/${github_repo}/releases")

release_id=$(echo "${release_resp}" | jq '.id')
if [ -z "${release_id}" ] || [ "${release_id}" == "null" ]; then
  echo "!> could not find release id in response"
  echo "${release_resp}"
  exit 1
fi
echo "-> created release ${release_id}"
