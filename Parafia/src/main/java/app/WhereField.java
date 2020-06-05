package app;

import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;

import java.util.ArrayList;

public class WhereField {
    public ArrayList<String> comparators;
    public GridPane block;
    public Label label;
    public ComboBox<String> comboBox;
    public TextField textField;
    private void fillComp(){
        comparators = new ArrayList<>();
        comparators.add("=");
        comparators.add("<");
        comparators.add("<=");
        comparators.add(">");
        comparators.add(">=");
        comparators.add("<>");
    }
    public WhereField(String text){
        label = new Label(text);
        textField = new TextField();
        comboBox = new ComboBox<>();
        fillComp();
        comboBox.getItems().addAll(comparators);
        comboBox.setValue("=");
        block = new GridPane();
        block.setHgap(5);
        block.setMinWidth(100);
        block.add(label,1,0);
        block.add(comboBox,0,1);
        block.add(textField,1,1);
    }
}
