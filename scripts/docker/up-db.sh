#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR%/scripts/docker}"
cd "$PROJECT_DIR"

echo "[compose] Starting Oracle XE (gvenzl/oracle-xe) in background..."
docker compose up -d oracle


