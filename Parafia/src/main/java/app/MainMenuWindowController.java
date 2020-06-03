package app;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;

import java.net.URL;
import java.util.ResourceBundle;

public class MainMenuWindowController implements Initializable {

    @FXML Button LOGINBUTTON;
    @FXML TextField URL, USER;
    @FXML Label display;
    @FXML PasswordField PASSWORD;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        MainMenuWindow.URLString="jdbc:postgresql://localhost/";
    }


    public void login(ActionEvent actionEvent) {
        if(URL.getText().equals("") || USER.getText().equals("") || PASSWORD.getText().equals("")){
            display.setText("Please type correct data to log in");
        }
        else{
            MainMenuWindow.URLString+=URL.getText();
            MainMenuWindow.USERString=USER.getText();
            MainMenuWindow.PASSWORDString=PASSWORD.getText();
            MainMenuWindow.stage.close();
        }
    }
}
