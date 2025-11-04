#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR%/scripts}"
cd "$PROJECT_DIR"

echo "[build] Packaging Maven project..."
mvn -q -DskipTests package
JAR_PATH=$(ls -1 target/*.jar | head -n1)
echo "[build] Built: $JAR_PATH"

