#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: ./builder.sh <github-repo> <docker-image>"
  exit 1
fi

set -e

GITHUB_REPO="$1"
DOCKER_IMAGE="$2"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

git clone "https://github.com/$GITHUB_REPO" "$WORKDIR"
docker build -t "$DOCKER_IMAGE" "$WORKDIR"
docker push "$DOCKER_IMAGE"
