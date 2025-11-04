#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${SCRIPT_DIR%/scripts}"
cd "${PROJECT_ROOT}"

echo "[RUN] Launching via javafx-maven-plugin"
mvn -q javafx:run

