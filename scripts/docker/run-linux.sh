#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR%/scripts/docker}"
cd "$PROJECT_DIR"

export DOCKER_PLATFORM="linux/amd64"
export DOCKER_DB_PLATFORM="linux/amd64"

"$PROJECT_DIR/scripts/docker/up-db.sh"

DISPLAY_VALUE=${DISPLAY:-:0}
echo "[docker] Using DISPLAY=$DISPLAY_VALUE"

"$PROJECT_DIR/scripts/docker/build.sh"

docker compose run --rm \
  -e DISPLAY="$DISPLAY_VALUE" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  go-stone
