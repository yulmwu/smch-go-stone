#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR%/scripts/docker}"
cd "$PROJECT_DIR"

echo "[compose] Stopping Oracle XE container..."
docker compose rm -sf oracle
echo "[compose] Done."

