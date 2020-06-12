package app;

import database.DBConnector;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.util.Map;

import static javafx.application.Platform.exit;

public class Main extends Application {
    private static MainMenuWindow mainMenuWindow=new MainMenuWindow();
    public static String URL="jdbc:postgresql://localhost/zofia";
    public static String USER="zofia";
    public static String PASSWORD="qwerty";
    public static void main(String[] args){
        launch(args);
    }
    Parent root;
    public void start(Stage stage) throws Exception {

        //TEMPORARY DELETE BEFORE PRESENTATION
        /*MainMenuWindow.URLString=URL;
        MainMenuWindow.USERString=USER;
        MainMenuWindow.PASSWORDString=PASSWORD;*/
        //------------------------------------------//
        mainMenuWindow.setUp();
        if(MainMenuWindow.action==0)
            return;
        root = FXMLLoader.load(getClass().getResource("/databasefxml.fxml"));
        stage.setTitle("ParishDB");
        stage.setScene(new Scene(root, 1280, 800));
        stage.show();
    }

}
