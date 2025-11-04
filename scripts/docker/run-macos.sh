#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR%/scripts/docker}"
cd "$PROJECT_DIR"

export DOCKER_PLATFORM="linux/arm64"
export DOCKER_DB_PLATFORM="linux/amd64"

# Ensure Oracle DB is up (brings up and waits if needed)
"$PROJECT_DIR/scripts/docker/up-db.sh"

# XQuartz: ensure it allows connections
DISPLAY_VALUE=${DISPLAY:-host.docker.internal:0}
echo "[docker] Using DISPLAY=$DISPLAY_VALUE"

"$PROJECT_DIR/scripts/docker/build.sh"

docker compose run --rm \
  -e DISPLAY="$DISPLAY_VALUE" \
  go-stone
