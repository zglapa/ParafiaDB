package app;

import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;

public class InsertField {
    public GridPane block;
    public Label label;
    public TextField textField;
    public InsertField(String text){
        label = new Label(text);
        textField = new TextField();
        block = new GridPane();
        block.add(label,0,0);
        block.add(textField,0,1);
    }
}
