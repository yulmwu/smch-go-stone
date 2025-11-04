package application;
	
import java.io.IOException;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.stage.StageStyle;


public class Main extends Application {
	@SuppressWarnings("static-access")
	@Override
	public void start(Stage primaryStage) throws IOException {
        primaryStage.setScene(new Scene(FXMLLoader.load(getClass().getResource("/fxml/login.fxml"))));
		primaryStage.initStyle(StageStyle.TRANSPARENT);
        primaryStage.show();
	}
	
	public static void main(String[] args) {
		launch(args);
	}
}
