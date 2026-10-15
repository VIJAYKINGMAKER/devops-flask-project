#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:?Usage: deploy-container.sh <image>}"

CONTAINER_NAME="devops-flask-project"
APP_PORT="${APP_PORT:-5000}"

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker is not installed." >&2
  exit 1
fi

echo "Pulling image: $IMAGE"
docker pull "$IMAGE"

if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
  echo "Removing existing container: $CONTAINER_NAME"
  docker rm -f "$CONTAINER_NAME"
fi

docker run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  -p "127.0.0.1:${APP_PORT}:5000" \
  "$IMAGE"

echo "Container started: $CONTAINER_NAME"
echo "Health endpoint: http://127.0.0.1:${APP_PORT}/health"