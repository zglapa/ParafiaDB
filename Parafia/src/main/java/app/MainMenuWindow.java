package app;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.Stage;
import java.io.IOException;

public class MainMenuWindow {
    public static String URLString;
    public static String USERString;
    public static String PASSWORDString;
    public static int action;
    public static Stage stage;
    public void setUp() throws IOException {
        stage=new Stage();
        Parent setUpRoot = FXMLLoader.load(getClass().getResource("/mainmenufxml.fxml"));
        stage.setTitle("Parafia");
        stage.setScene(new Scene(setUpRoot, 1024, 768));
        System.out.println(stage);
        stage.showAndWait();
    }
}
