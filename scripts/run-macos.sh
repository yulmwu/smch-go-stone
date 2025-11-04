#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR%/scripts}"
cd "$PROJECT_DIR"

# Ensure platform-correct JavaFX jars (macOS/aarch64)
FX_DIR="$PROJECT_DIR/vendor/javafx-mac-aarch64-25.0.1"
if [ ! -d "$FX_DIR" ] || [ -z "$(ls -1 "$FX_DIR" 2>/dev/null)" ]; then
  echo "[run] Fetching JavaFX 25.0.1 for macos-aarch64..."
  mkdir -p "$FX_DIR"
  BASE_URL="https://repo1.maven.org/maven2/org/openjfx"
  for MOD in base graphics controls fxml; do
    URL="$BASE_URL/javafx-$MOD/25.0.1/javafx-$MOD-25.0.1-mac-aarch64.jar"
    echo "  - $URL"
    curl -fsSL "$URL" -o "$FX_DIR/javafx.$MOD.jar"
  done
fi
JAR_PATH=$(ls -1 target/*.jar | head -n1)

if [ ! -f "$JAR_PATH" ]; then
  echo "[run] Jar not found. Building first..."
  "$SCRIPT_DIR/build.sh"
  JAR_PATH=$(ls -1 target/*.jar | head -n1)
fi

# Ensure JFoenix 9.0.10 is present (compatible with modern JavaFX)
JFXN_DIR="$PROJECT_DIR/vendor"
if [ ! -f "$JFXN_DIR/jfoenix-9.0.10.jar" ]; then
  echo "[run] Fetching JFoenix 9.0.10..."
  curl -fsSL "https://repo1.maven.org/maven2/com/jfoenix/jfoenix/9.0.10/jfoenix-9.0.10.jar" \
    -o "$JFXN_DIR/jfoenix-9.0.10.jar"
fi

# Ensure modern Oracle JDBC for XE 21c
if [ ! -f "$PROJECT_DIR/vendor/ojdbc8-21.11.0.0.jar" ]; then
  echo "[run] Fetching ojdbc8 21.11.0.0..."
  curl -fsSL "https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc8/21.11.0.0/ojdbc8-21.11.0.0.jar" \
    -o "$PROJECT_DIR/vendor/ojdbc8-21.11.0.0.jar"
fi

# Provide DB env (defaults to local XE)
export DB_URL=${DB_URL:-"jdbc:oracle:thin:@localhost:1521/XEPDB1"}
export DB_USER=${DB_USER:-"scott"}
export DB_PASSWORD=${DB_PASSWORD:-"1231"}

echo "[run] Using JavaFX at: $FX_DIR"
echo "[run] Launching application..."
exec java \
  --module-path "$FX_DIR" \
  --add-modules javafx.controls,javafx.fxml \
  --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
  --add-exports=javafx.graphics/com.sun.javafx.css=ALL-UNNAMED \
  --add-exports=javafx.graphics/com.sun.javafx.scene=ALL-UNNAMED \
  --add-exports=javafx.controls/com.sun.javafx.scene.control=ALL-UNNAMED \
  -Djdbc.drivers=oracle.jdbc.OracleDriver \
  -cp "$JAR_PATH:$PROJECT_DIR/vendor/jfoenix-9.0.10.jar:$PROJECT_DIR/vendor/ojdbc8-21.11.0.0.jar" \
  application.Main
 
