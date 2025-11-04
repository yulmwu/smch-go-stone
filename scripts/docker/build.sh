#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR%/scripts/docker}"
cd "$PROJECT_DIR"

# Ensure local jar is built
"$PROJECT_DIR/scripts/build.sh"

echo "[docker] Building image (platform=${DOCKER_PLATFORM:-native})..."
docker build ${DOCKER_PLATFORM:+--platform "$DOCKER_PLATFORM"} -t go-stone:latest .

