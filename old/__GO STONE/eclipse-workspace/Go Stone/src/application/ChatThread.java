package application;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ChatThread extends Thread {
	private Connection conn;
	private String driver = "oracle.jdbc.driver.OracleDriver";
	private String url = "jdbc:oracle:thin:@219.241.55.188:1521:xe";
	private String user = "scott";
	private String password = "1231";
	
	public ChatThread() throws IOException {
		try {
			Class.forName(driver);
		} catch (ClassNotFoundException e) {
//			showError("DB에 접속할 수 없습니다");
		}
	}
	
	
	
	public void run(){
		try {
			conn = DriverManager.getConnection(url, user, password);
			
			String quary = "select * from chat";
			
			PreparedStatement pstm = conn.prepareStatement(quary);
			
//			FXMLLoader loader = new FXMLLoader(getClass().getResource("../fxml/main.fxml"));
			
			while(true) {
				try {
					ResultSet rs = pstm.executeQuery();
					
					@SuppressWarnings("unused")
					String result = "";
					
					while(rs.next()) {
						String rs_nickname = rs.getString(3);
						String rs_chat_time = rs.getString(4);
						String rs_chat_text = rs.getString(5);
						
						result += "[ " + rs_nickname + " ]  |  " + rs_chat_time + ":\n" + rs_chat_text + "\n\n";
					}
					
//					((Controller) application.Controller.getController()).mainChat.setText(result);
//					application.Controller.mainChat.setText(result);
//					Controller.this.mainChat.setText(result);
//					노답 나중에 다시 생각
					
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		} catch (SQLException e) {
//			showError("DB 서버에 연결할 수 없습니다.");
		}
	}
}



