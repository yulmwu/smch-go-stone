#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${SCRIPT_DIR%/scripts}"
cd "${PROJECT_ROOT}"

ensure_java11() {
  local v
  if v=$(java -XshowSettings:properties -version 2>&1 | rg 'java\.specification\.version\s*=\s*(\S+)' -or '$1' || true); then
    :
  else
    v=$(java -version 2>&1 | head -n1 | sed -E 's/.*version "([0-9]+).*/\1/' || true)
  fi
  case "${v}" in
    1.8|8|9|10|"" )
      local CAND
      CAND=$(ls -d /usr/lib/jvm/java-17-openjdk* /usr/lib/jvm/java-11-openjdk* 2>/dev/null | head -n1 || true)
      if [[ -n "${CAND}" ]]; then
        export JAVA_HOME="${CAND}"
        export PATH="${JAVA_HOME}/bin:${PATH}"
        echo "[BUILD] Using JAVA_HOME=${JAVA_HOME}"
      else
        echo "[ERROR] JDK 11+ required. Run scripts/install-deps-rocky.sh first." >&2
        exit 1
      fi
      ;;
    *)
      # OK
      ;;
  esac
}

ensure_java11

echo "[BUILD] Cleaning and packaging (skip tests)"
mvn -q -DskipTests clean package

JAR_FILE=$(ls -1 target/go-stone-*.jar | head -n 1 || true)
if [[ -n "${JAR_FILE}" ]]; then
  echo "[BUILD] Built: ${JAR_FILE}"
else
  echo "[WARN] JAR not found under target/"
fi
