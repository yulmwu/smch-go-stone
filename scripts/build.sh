#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${SCRIPT_DIR%/scripts}"
cd "${PROJECT_ROOT}"

echo "[BUILD] Cleaning and packaging (skip tests)"
mvn -q -DskipTests clean package

JAR_FILE=$(ls -1 target/go-stone-*.jar | head -n 1 || true)
if [[ -n "${JAR_FILE}" ]]; then
  echo "[BUILD] Built: ${JAR_FILE}"
else
  echo "[WARN] JAR not found under target/"
fi

