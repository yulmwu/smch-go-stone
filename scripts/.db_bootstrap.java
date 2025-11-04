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
