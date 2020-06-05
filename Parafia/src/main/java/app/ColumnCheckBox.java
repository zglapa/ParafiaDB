package app;

import javafx.geometry.Pos;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.VBox;

public class ColumnCheckBox {
    public VBox block;
    public Label label;
    public CheckBox checkBox;
    public ColumnCheckBox(String text){
        label = new Label(text);
        checkBox = new CheckBox();
        checkBox.setSelected(true);
        block = new VBox();
        block.setAlignment(Pos.CENTER);
        block.setSpacing(5);
        block.getChildren().add(label);
        block.getChildren().add(checkBox);
    }
}
