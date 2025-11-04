#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR%/scripts}"

DB_URL=${DB_URL:-"jdbc:oracle:thin:@localhost:1521/XEPDB1"}
DB_ADMIN_USER=${DB_ADMIN_USER:-"system"}
DB_ADMIN_PASSWORD=${DB_ADMIN_PASSWORD:-"oracle"}

if [ ! -f "$PROJECT_DIR/vendor/ojdbc8-21.11.0.0.jar" ]; then
  echo "[bootstrap] Fetching ojdbc8 21.11.0.0..."
  curl -fsSL -o "$PROJECT_DIR/vendor/ojdbc8-21.11.0.0.jar" \
    https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc8/21.11.0.0/ojdbc8-21.11.0.0.jar
fi

cat > "$PROJECT_DIR/scripts/.db_bootstrap.java" << 'JAVA'
import java.sql.*;
class db_bootstrap {
  public static void main(String[] args) throws Exception {
    String url = System.getenv().getOrDefault("DB_URL", "jdbc:oracle:thin:@localhost:1521/XEPDB1");
    String adminUser = System.getenv().getOrDefault("DB_ADMIN_USER", "system");
    String adminPass = System.getenv().getOrDefault("DB_ADMIN_PASSWORD", "oracle");
    try { Class.forName("oracle.jdbc.OracleDriver"); } catch (Throwable t) { Class.forName("oracle.jdbc.driver.OracleDriver"); }
    try (Connection c = DriverManager.getConnection(url, adminUser, adminPass)) {
      c.setAutoCommit(false);
      try (Statement s = c.createStatement()) {
        try { s.execute("CREATE USER SCOTT IDENTIFIED BY 1231"); } catch (SQLException ignored) {}
        try { s.execute("ALTER USER SCOTT IDENTIFIED BY 1231"); } catch (SQLException ignored) {}
        try { s.execute("GRANT CONNECT, RESOURCE TO SCOTT"); } catch (SQLException ignored) {}
        try { s.execute("ALTER USER SCOTT QUOTA UNLIMITED ON USERS"); } catch (SQLException ignored) {}
      }
      try (Statement s = c.createStatement()) {
        s.execute("ALTER SESSION SET CURRENT_SCHEMA = SCOTT");
        try { s.execute("CREATE TABLE account (no NUMBER PRIMARY KEY, id VARCHAR2(20) NOT NULL, password VARCHAR2(20) NOT NULL, realname VARCHAR2(50) NOT NULL, nickname VARCHAR2(10) NOT NULL, email VARCHAR2(50) NOT NULL)"); } catch (SQLException ignored) {}
        try { s.execute("CREATE SEQUENCE account_seq START WITH 1 INCREMENT BY 1 NOCACHE"); } catch (SQLException ignored) {}
        try { s.execute("CREATE TABLE chat (no NUMBER PRIMARY KEY, id VARCHAR2(20) NOT NULL, nickname VARCHAR2(10) NOT NULL, chat_time VARCHAR2(40) NOT NULL, chat_text VARCHAR2(4000) NOT NULL)"); } catch (SQLException ignored) {}
        try { s.execute("CREATE SEQUENCE chat_seq START WITH 1 INCREMENT BY 1 NOCACHE"); } catch (SQLException ignored) {}
      }
      c.commit();
      System.out.println("Bootstrap completed");
    }
  }
}
JAVA

javac -cp "$PROJECT_DIR/vendor/ojdbc8-21.11.0.0.jar" "$PROJECT_DIR/scripts/.db_bootstrap.java"
DB_URL="$DB_URL" DB_ADMIN_USER="$DB_ADMIN_USER" DB_ADMIN_PASSWORD="$DB_ADMIN_PASSWORD" \
  java -cp "$PROJECT_DIR/scripts:$PROJECT_DIR/vendor/ojdbc8-21.11.0.0.jar" db_bootstrap
rm -f "$PROJECT_DIR/scripts/.db_bootstrap.java" "$PROJECT_DIR/scripts/db_bootstrap.class"
echo "[bootstrap] Done. User SCOTT/1231 and tables ready."
