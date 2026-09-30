
#!/bin/bash
set -euo pipefail

: "${APIVERSION:?APIVERSION is required}"
: "${DOCKER_ACCOUNT:?DOCKER_ACCOUNT is required}"
: "${REMOTE_REPO_NAME:?REMOTE_REPO_NAME is required}"
: "${VERSION:?VERSION is required}"

image="${DOCKER_ACCOUNT}/${REMOTE_REPO_NAME}:cordovaAPI${APIVERSION}-V${VERSION}"
echo "Building ${image}"
docker build --platform linux/amd64 -f "Dockerfile-API${APIVERSION}" . -t "${image}"

# Preserve the existing registry authentication under the ubuntu account.
sudo -H -u ubuntu docker push "${image}"
echo "Published ${image}"
