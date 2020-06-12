package app;

import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.control.Tooltip;
import javafx.scene.layout.GridPane;

public class InsertField {
    public GridPane block;
    public Label label,description;
    public TextField textField;
    public boolean mandatory;

    public InsertField(String text){
        label = new Label(text);
        description = new Label(text);
        textField = new TextField();
        textField.setMinWidth(300);
        block = new GridPane();
        block.add(description,0,0);
        block.add(textField,0,1);
    }

    public InsertField(String text, String tip){
        label = new Label(text);
        description = new Label(text+tip);
        textField = new TextField();
        textField.setMinWidth(300);
        block = new GridPane();
        block.add(description,0,0);
        block.add(textField,0,1);
    }

    public void setMandatory(boolean mandatory) {
        this.mandatory = mandatory;
        description.setStyle("-fx-text-fill: darkred");
    }
}
