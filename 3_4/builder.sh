#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: builder.sh <github-repo> <docker-image>"
  exit 1
fi

set -e

: "${DOCKER_USER:?DOCKER_USER is not set}"
: "${DOCKER_PWD:?DOCKER_PWD is not set}"

GITHUB_REPO="$1"
DOCKER_IMAGE="$2"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

git clone "https://github.com/$GITHUB_REPO" "$WORKDIR"
docker build -t "$DOCKER_IMAGE" "$WORKDIR"
echo "$DOCKER_PWD" | docker login -u "$DOCKER_USER" --password-stdin
docker push "$DOCKER_IMAGE"
