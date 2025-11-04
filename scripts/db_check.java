import java.sql.*;
import java.util.Properties;
public class db_check {
  public static void main(String[] args) throws Exception {
    String url = System.getenv().getOrDefault("DB_URL","jdbc:oracle:thin:@localhost:1521/XEPDB1");
    String user = System.getenv().getOrDefault("DB_USER","scott");
    String pass = System.getenv().getOrDefault("DB_PASSWORD","1231");
    try { Class.forName("oracle.jdbc.OracleDriver"); } catch (Throwable t) { Class.forName("oracle.jdbc.driver.OracleDriver"); }
    Properties p=new Properties(); p.setProperty("user",user); p.setProperty("password",pass);
    try (Connection c=DriverManager.getConnection(url,p)){
      System.out.println("Connected ok: "+url+" as "+user);
      try (Statement s=c.createStatement()){
        try(ResultSet rs=s.executeQuery("select count(*) from account")){
          if(rs.next()) System.out.println("account rows="+rs.getInt(1));
        }
        try(ResultSet rs=s.executeQuery("select count(*) from chat")){
          if(rs.next()) System.out.println("chat rows="+rs.getInt(1));
        }
      }
    }
  }
}
