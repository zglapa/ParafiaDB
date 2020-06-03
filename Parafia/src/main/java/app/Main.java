package app;

import app.MainMenuWindow;
import javafx.application.Application;
import javafx.scene.Parent;
import javafx.stage.Stage;

public class Main extends Application {
    private static MainMenuWindow mainMenuWindow=new MainMenuWindow();;
    public static void main(String[] args){
        launch(args);
    }
    Parent root;
    public void start(Stage stage) throws Exception {
        mainMenuWindow.setUp();
        /*root = FXMLLoader.load(getClass().getResource("/GameFXML.fxml"));
        stage.setTitle("Parafia");
        stage.setScene(new Scene(root, 1600, 900));
        stage.show();

         */
    }
}
