package app;

import app.MainMenuWindow;
import database.DBConnector;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Main extends Application {
    private static MainMenuWindow mainMenuWindow=new MainMenuWindow();;
    public static String URL="jdbc:postgresql://localhost/zofia";
    public static String USER="zofia";
    public static String PASSWORD="qwerty";
    public static void main(String[] args){
        launch(args);
    }
    Parent root;
    public void start(Stage stage) throws Exception {
        //mainMenuWindow.setUp();
        //TEMPORARY DELETE BEFORE PRESENTATION
        MainMenuWindow.URLString=URL;
        MainMenuWindow.USERString=USER;
        MainMenuWindow.PASSWORDString=PASSWORD;
        //------------------------------------------//

        DBConnector.URL=MainMenuWindow.URLString;
        DBConnector.USER=MainMenuWindow.USERString;
        DBConnector.PASSWORD=MainMenuWindow.PASSWORDString;
        root = FXMLLoader.load(getClass().getResource("/databasefxml.fxml"));
        stage.setTitle("Parafia");
        stage.setScene(new Scene(root, 1280, 800));
        stage.show();
    }
}
