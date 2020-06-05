package app;

import javafx.geometry.Pos;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.VBox;

import java.util.ArrayList;

public class JoinBox {
    public ComboBox<String> tableComboBox;
    public ComboBox<String> columnComboBoxLeft;
    public ComboBox<String> columnComboBoxRight;
    public ArrayList<String> tableNames;
    public VBox block;
    public Label comparator;
    private void fillTableNames(ComboBox<String> cb){
        tableNames = new ArrayList<>();
        tableNames.addAll(cb.getItems());
    }
    JoinBox(ComboBox<String> cb){
        tableComboBox = new ComboBox<>();
        fillTableNames(cb);
        tableComboBox.getItems().addAll(tableNames);
        columnComboBoxLeft = new ComboBox<>();
        columnComboBoxRight = new ComboBox<>();
        columnComboBoxLeft.setPrefWidth(200);
        columnComboBoxRight.setPrefWidth(200);
        tableComboBox.setPrefWidth(200);
        comparator = new Label("=");
        block = new VBox();
        block.setSpacing(5);
        block.setAlignment(Pos.TOP_CENTER);
        block.getChildren().addAll(tableComboBox,columnComboBoxLeft,comparator,columnComboBoxRight);
    }
}
