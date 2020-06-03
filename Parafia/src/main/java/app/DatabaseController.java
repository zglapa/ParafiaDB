package app;

import database.QueryExecutor;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.util.Callback;

import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class DatabaseController implements Initializable {
    @FXML
    TableView<ObservableList> tableviewSelect;
    @FXML
    ComboBox<String> selectComboBox;
    ObservableList<ObservableList> data;
    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {

    }
    private void changeTable(ResultSet rs) throws SQLException {
        tableviewSelect.getItems().clear();
        tableviewSelect.getColumns().clear();
        for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){
            //We are using non property style for making dynamic table
            int j = i;
            TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));
            col.setCellValueFactory(new Callback<TableColumn.CellDataFeatures<ObservableList,String>, ObservableValue<String>>(){
                public ObservableValue<String> call(TableColumn.CellDataFeatures<ObservableList, String> param) {
                    String s;
                    try{
                        s = param.getValue().get(j).toString();
                    }catch (NullPointerException e){
                        s="null";
                    }
                    return new SimpleStringProperty(s);
                }
            });

            tableviewSelect.getColumns().addAll(col);
            //System.out.println("Column ["+i+"] ");
        }

    }
    private void addRows(ResultSet rs) throws SQLException {
        while(rs.next()){
            //Iterate Row
            ObservableList<String> row = FXCollections.observableArrayList();
            for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                //Iterate Column
                row.add(rs.getString(i));
            }
            System.out.println("Row [1] added "+row );
            data.add(row);
        }

    }
    public void showSelectResult(ActionEvent actionEvent) {
        String select = "select * from ";
        select+=selectComboBox.getValue()+";";
        try {
            ResultSet result = QueryExecutor.executeSelect(select);
            data = FXCollections.observableArrayList();
            changeTable(result);
            addRows(result);
            tableviewSelect.setItems(data);
        }catch (SQLException e){
            e.printStackTrace();
        }
    }
}
