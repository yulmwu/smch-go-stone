package application;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;

import com.jfoenix.controls.JFXButton;
import com.jfoenix.controls.JFXPasswordField;
import com.jfoenix.controls.JFXTextArea;
import com.jfoenix.controls.JFXTextField;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

public class Controller {
	
	// DB
	
	private Connection conn;
	private String driver = "oracle.jdbc.driver.OracleDriver";
	private String url = "jdbc:oracle:thin:@219.241.55.188:1521:xe";
	private String user = "scott";
	private String password = "1231";
	
	public Controller() throws IOException {
		try {
			Class.forName(driver);
		} catch (ClassNotFoundException e) {
			showError("DB에 연결할 수 없습니다");
		}
	}
	
	
	
	// Top bar
	
	double x, y;
	
	@FXML void dragged(MouseEvent event) {
		Stage stage = (Stage) ((Node)event.getSource()).getScene().getWindow();
		stage.setX(event.getScreenX() - x);
		stage.setY(event.getScreenY() - y);
    }

    @FXML void pressed(MouseEvent event) {
    	x = event.getSceneX();
    	y = event.getSceneY();
    }
    
    @FXML void close(MouseEvent event) {
    	Stage stage = (Stage) ((Node) event.getSource()).getScene().getWindow();
    	stage.close();
    }

    @FXML void min(MouseEvent event) {
    	Stage stage = (Stage) ((Node) event.getSource()).getScene().getWindow();
    	stage.setIconified(true);
    }

    @FXML void max(MouseEvent event) {
    	Stage stage = (Stage) ((Node) event.getSource()).getScene().getWindow();
    	stage.setFullScreenExitHint(" ");
    	stage.setFullScreen(true);
    }
    
    public String asdf = "";
    
    // Scene Switch
    
    @FXML Pane scene;
    
    public void scene_main() throws IOException {
		new FXMLLoader();
		scene.getScene().setRoot(FXMLLoader.load(getClass().getResource("../fxml/main.fxml")));
//		ChatThread thread = new ChatThread();
//		thread.start();
		new Thread() {
			 
            public void run() {
            	try {
					conn = DriverManager.getConnection(url, user, password);
					
					String quary = "select * from chat";
	    			
	    			PreparedStatement pstm = conn.prepareStatement(quary);
	    			
//	    			FXMLLoader loader = new FXMLLoader(getClass().getResource("../fxml/main.fxml"));
	    			
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
	    					
//	    					mainChat.setText(result);
	    					Thread.sleep(1000);
	    					
	    				} catch (InterruptedException e) {
	    					e.printStackTrace();
	    				}
	    			}
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
            }
        }.start();
    }
    
    @FXML public void scene_login(ActionEvent e) throws IOException {
		new FXMLLoader();
		scene.getScene().setRoot(FXMLLoader.load(getClass().getResource("../fxml/login.fxml")));
    }
    
    @FXML public void scene_createAccount(ActionEvent e) throws IOException {
		new FXMLLoader();
		scene.getScene().setRoot(FXMLLoader.load(getClass().getResource("../fxml/createAccount.fxml")));
    }
    
    public void scene_createAccountSuccess() throws IOException {
		new FXMLLoader();
		scene.getScene().setRoot(FXMLLoader.load(getClass().getResource("../fxml/createAccountSuccess.fxml")));
    }
    
    @FXML public void scene_findPwd(ActionEvent e) throws IOException {
		new FXMLLoader();
		scene.getScene().setRoot(FXMLLoader.load(getClass().getResource("../fxml/findPwd.fxml")));
    }
    
    public void scene_findPwdSuccess() throws IOException {
		new FXMLLoader();
		scene.getScene().setRoot(FXMLLoader.load(getClass().getResource("../fxml/findPwdSuccess.fxml")));
    }
    
    
    
    // Scene TextField
    
    @FXML JFXTextField login_id;
    @FXML JFXPasswordField login_password;
    
    @FXML JFXTextField createAccount_id;
    @FXML JFXPasswordField createAccount_password;
    @FXML JFXTextField createAccount_realName;
    @FXML JFXTextField createAccount_nickname;
    @FXML JFXTextField createAccount_email;
    
    @FXML JFXTextField findPwd_id;
    @FXML JFXTextField findPwd_email;
    @FXML JFXButton findPwd_find;
    @FXML JFXTextField findPwd_realName;
    @FXML JFXPasswordField findPwd_newPassword;
    @FXML JFXPasswordField findPwd_newPasswordAgain;
    @FXML JFXButton findPwd_submit;
    
    @FXML JFXTextArea mainChat;
    @FXML JFXTextArea inputChat;
    
    public void setMainChat (String mainChat) {
    	this.mainChat.setText(mainChat);
    }
    
    // Error
    
    @FXML JFXTextArea error;
    
	public void showError(String text) throws IOException {
    	FXMLLoader loader = new FXMLLoader(getClass().getResource("../fxml/error.fxml"));
    	Parent root = loader.load();
    	
    	Stage stage = new Stage();
    	stage.setScene(new Scene(root));
    	stage.initStyle(StageStyle.TRANSPARENT);
    	stage.show();
    	((Controller) loader.getController()).setError(text);
    }
	
	public void setError(String text) {
		error.setText(text);
	}
    
    
    
    // Scene Button
    
    String idPattern = "^[a-zA-Z0-9]{4,20}$";
    String passwordPattern = "^[a-zA-Z0-9`~!@#$%^&*]{4,20}$";
    String realnamePattern = "^[ a-zA-Z가-힣]{1,50}$";
    String nicknamePattern = "^[ a-zA-Z가-힣0-9]{1,10}$";
    String emailPattern = "^.{1,50}$";
    
    @FXML public void login_login() throws IOException {
    	if (!Pattern.matches(idPattern, login_id.getText())) {
    		showError("ID를 확인해주세요!");
    		return;
    	}
    	if (!Pattern.matches(passwordPattern, login_password.getText())) {
    		showError("Password를 확인해주세요!");
    		return;
    	}
    	
    	try {
			conn = DriverManager.getConnection(url, user, password);
			
			String quary = "select * from ACCOUNT where id='" + login_id.getText() + "' and password='" + login_password.getText() + "'";
			
			PreparedStatement pstm = conn.prepareStatement(quary);
			ResultSet rs = pstm.executeQuery();
			if (rs.next()) {
				myid = rs.getString(2);
				mynickname = rs.getString(5);
				scene_main();
			}
			else
				showError("로그인 실패.\n입력한 정보가 올바른지 확인해주세요!");
			
		} catch (SQLException e) {
			showError("DB 서버에 접근할 수 없습니다.");
		}
    }
    
    @FXML public void createAccount_submit() throws IOException {
    	if (!Pattern.matches(idPattern, createAccount_id.getText())) {
    		showError("ID 입력이 잘못 되었습니다.\n영문, 숫자, 4~20자리");
    		return;
    	}
    	if (!Pattern.matches(passwordPattern, createAccount_password.getText())) {
    		showError("Password 입력이 잘못 되었습니다.\n영문, 숫자, 특수문자, 4~20자리");
    		return;
    	}
    	if (!Pattern.matches(realnamePattern, createAccount_realName.getText())) {
    		showError("RealName 입력이 잘못 되었습니다.\n영문, 한글, 1~50자리");
    		return;
    	}
    	if (!Pattern.matches(nicknamePattern, createAccount_nickname.getText())) {
    		showError("NickName 입력이 잘못 되었습니다.\n영문, 한글, 숫자, 1~10자리");
    		return;
    	}
    	if (!Pattern.matches(emailPattern, createAccount_email.getText())) {
    		showError("E-mail 입력이 잘못 되었습니다.\n1~50자리");
    		return;
    	}
    	
    	try {
			conn = DriverManager.getConnection(url, user, password);
			
			String quary = "select * from account";
			
			PreparedStatement pstm = conn.prepareStatement(quary);
			ResultSet rs = pstm.executeQuery();
			
			boolean overlap_id = false;
			boolean overlap_nickname = false;
			boolean overlap_email = false;
			
			while(rs.next()) {
				String rs_id = rs.getString(2);
				String rs_nickname = rs.getString(5);
				String rs_email = rs.getString(6);
				
				if (rs_id.equals(createAccount_id.getText()))
					overlap_id = true;
				if (rs_nickname.equals(createAccount_nickname.getText()))
					overlap_nickname = true;
				if (rs_email.equals(createAccount_email.getText()))
					overlap_email = true;
			}
			if (overlap_id)
				showError("이미 존재하는 아이디입니다!");
			else if (overlap_nickname)
				showError("이미 존재하는 닉네임입니다!");
			else if (overlap_email)
				showError("이미 등록된 이메일입니다!");
			else {
				String sql = "insert into account values(account_seq.nextval, ?, ?, ?, ?, ?)";
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, createAccount_id.getText());
				pstmt.setString(2, createAccount_password.getText());
				pstmt.setString(3, createAccount_realName.getText());
				pstmt.setString(4, createAccount_nickname.getText());
				pstmt.setString(5, createAccount_email.getText());
				pstmt.executeUpdate();
				scene_createAccountSuccess();
			}
			
		} catch (SQLException e) {
			showError("DB 서버에 접근할 수 없습니다.");
		}
    }
    
    @FXML public void findPwd_find() throws IOException {
    	if (!Pattern.matches(idPattern, findPwd_id.getText())) {
    		showError("ID를 확인해주세요!");
    		return;
    	}
    	if (!Pattern.matches(emailPattern, findPwd_email.getText())) {
    		showError("E-mail을 확인해주세요!");
    		return;
    	}
    	try {
			conn = DriverManager.getConnection(url, user, password);
			
			String quary = "select * from ACCOUNT where id='" + findPwd_id.getText() + "' and email='" + findPwd_email.getText() + "'";
			
			PreparedStatement pstm = conn.prepareStatement(quary);
			ResultSet rs = pstm.executeQuery();
			
			if (rs.next()) {
				findPwd_id.setDisable(true);
				findPwd_email.setDisable(true);
				findPwd_find.setDisable(true);
				findPwd_realName.setText(rs.getString(4));
				findPwd_realName.setDisable(false);
				findPwd_newPassword.setDisable(false);
				findPwd_newPasswordAgain.setDisable(false);
				findPwd_submit.setDisable(false);
			}
			else
				showError("해당 정보와 일치 하는 계정이 존재하지 않습니다.");
			
		} catch (SQLException e) {
			showError("입력이 잘못 되었거나, DB 서버에 접근할 수 없습니다.");
		}
    }
    
    @FXML public void findPwd_submit() throws IOException {
    	if (!Pattern.matches(passwordPattern, findPwd_newPassword.getText())) {
    		showError("Password 입력이 잘못 되었습니다.\n영문, 숫자, 특수문자, 4~20자리");
    		return;
    	}
    	if (!(findPwd_newPassword.getText().equals(findPwd_newPasswordAgain.getText()))) {
    		showError("비밀번호가 일치하지 않습니다!");
    		return;
    	}
    	try {
			conn = DriverManager.getConnection(url, user, password);
			
			String quary = "update account set password='" + findPwd_newPassword.getText() + "' where id='" + findPwd_id.getText() + "'";
			
			PreparedStatement pstm = conn.prepareStatement(quary);
			pstm.executeQuery();
			
			scene_findPwdSuccess();
			
		} catch (SQLException e) {
			showError("DB 서버에 접근할 수 없습니다.");
		}
    }
    
    
    
    // 로그인 정보
    
    private String myid = "???";
    private String mynickname = "???";
    
    @FXML public void sendChat() throws IOException {
//    	 ����Ʈ + ���ʹ� ���� �ǰ� https://www.youtube.com/watch?v=saLcT5UE-JM
    	if (inputChat.getText().equals("")) {
    		try {
				conn = DriverManager.getConnection(url, user, password);
				String quary = "select * from chat";
				
				PreparedStatement pstm = conn.prepareStatement(quary);
				ResultSet rs = pstm.executeQuery();
				
				String result = "";
				
				while(rs.next()) {
					String rs_nickname = rs.getString(3);
					String rs_chat_time = rs.getString(4);
					String rs_chat_text = rs.getString(5);
					
					result += "[ " + rs_nickname + " ]  |  " + rs_chat_time + ":\n" + rs_chat_text + "\n\n";
				}
				mainChat.setText(result);
	    		
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
    		return;
    	}
    	try {
			conn = DriverManager.getConnection(url, user, password);
			Date today = new Date();
		    SimpleDateFormat time = new SimpleDateFormat("MM/dd, a hh:mm");
			String quary = "insert into CHAT values(chat_seq.nextval, '" + myid + "', '" + mynickname + "', '" + time.format(today) + "', '" + inputChat.getText() + "')";
			PreparedStatement pstm = conn.prepareStatement(quary);
			pstm.executeQuery();
			inputChat.setText("");
			
		} catch (SQLException e) {
			showError("DB 서버에 접근할 수 없습니다.");
		}
    }
}


