package app;

import database.QueryExecutor;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.GridPane;
import javafx.util.Callback;

import java.net.URL;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.ResourceBundle;

public class DatabaseController implements Initializable {

    @FXML FlowPane whereFlowPane,updateFlowPane,insertFlowPane;
    @FXML Label insertLog,updateLog;
    @FXML Button insertButton,updateButton,checkRecordButton;
    @FXML
    TableView<ObservableList> tableviewSelect;
    @FXML
    ComboBox<String> selectComboBox, insertComboBox, updateComboBox;
    ObservableList<ObservableList> data;
    ArrayList<InsertField> insertFields;
    ArrayList<InsertField> updateFields;
    ArrayList<InsertField> whereFields;
    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        insertFields = new ArrayList<>();
        updateFields = new ArrayList<>();
        whereFields = new ArrayList<>();
    }
    private void changeTable(ResultSet rs) throws SQLException {
        tableviewSelect.getItems().clear();
        tableviewSelect.getColumns().clear();
        for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){
            int j = i;
            TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));
            col.setCellValueFactory(new Callback<TableColumn.CellDataFeatures<ObservableList,String>, ObservableValue<String>>(){
                public ObservableValue<String> call(TableColumn.CellDataFeatures<ObservableList, String> param) {
                    String s;
                    try{                        s = param.getValue().get(j).toString();
                    }catch (NullPointerException e){
                        s="null";
                    }
                    return new SimpleStringProperty(s);
                }
            });

            tableviewSelect.getColumns().addAll(col);
        }

    }
    private void addRows(ResultSet rs) throws SQLException {
        while(rs.next()){
            ObservableList<String> row = FXCollections.observableArrayList();
            for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                row.add(rs.getString(i));
            }
            data.add(row);
        }

    }
    public void showSelectResult(ActionEvent actionEvent) {
        String select = "select * from ";
        select+=selectComboBox.getValue()+" order by 1;";
        try {
            ResultSet result = QueryExecutor.executeSelect(select);
            data = FXCollections.observableArrayList();
            changeTable(result);
            addRows(result);
            tableviewSelect.setItems(data);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    private void changeFlowPane(ResultSetMetaData tableData) throws SQLException {
        insertFlowPane.getChildren().clear();
        insertFields.clear();
        for(int i = 1; i <= tableData.getColumnCount(); ++i){
            InsertField insertField = new InsertField(tableData.getColumnName(i));
            insertFlowPane.getChildren().add(insertField.block);
            insertFields.add(insertField);
        }
    }
    public void insertRecord(ActionEvent actionEvent) {
        String tableName = insertComboBox.getValue();
        try{
            ResultSet table = QueryExecutor.executeSelect("select * from " + tableName+";");
            ResultSetMetaData tableMetaData = table.getMetaData();
            changeFlowPane(tableMetaData);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    private void insertIntoTable(String insertString, String tableName) throws SQLException {
        ResultSet rs1 = QueryExecutor.executeSelect("select count(*) from " + tableName + ";");
        rs1.next();
        String before = rs1.getString(1);
        QueryExecutor.executeQuery(insertString);
        ResultSet rs2 = QueryExecutor.executeSelect("select count(*) from " + tableName + ";");
        rs2.next();
        String after = rs2.getString(1);
        if(!before.equals(after)){
            insertLog.setText(insertString + "\n" + "successful");
        }else{
            insertLog.setText(insertString + "\n" + "unsuccessful");
        }

    }
    public void insertButtonClicked(ActionEvent actionEvent) {
        insertLog.setText("");
        for(InsertField insertField : insertFields){
            if(insertField.textField.getText().equals("")) return;
        }
        StringBuilder insert = new StringBuilder("insert into ");
        insert.append(insertComboBox.getValue()).append(" values (");
        int i=1;
        for(InsertField insertField : insertFields){
            insert.append("'").append(insertField.textField.getText()).append("'");
            i++;
            if(i <= insertFields.size()) insert.append(",");
        }
        insert.append(");");
        System.out.println(insert.toString());
        try{
            insertIntoTable(insert.toString(), insertComboBox.getValue());
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    private void changeUpdateFlowPane(ResultSetMetaData tableData) throws SQLException {
        updateFlowPane.getChildren().clear();
        updateFields.clear();
        for(int i = 1; i <= tableData.getColumnCount(); ++i){
            InsertField insertField = new InsertField(tableData.getColumnName(i));
            updateFlowPane.getChildren().add(insertField.block);
            updateFields.add(insertField);
        }
    }
    private void fillUpdateFields(ResultSet resultSet) throws SQLException{
        for(int i = 1; i <= resultSet.getMetaData().getColumnCount(); ++i){
            updateFields.get(i-1).textField.setText(resultSet.getString(i));
        }
    }
    private void changeWhereFlowPane(ResultSetMetaData tableData) throws SQLException {
        whereFlowPane.getChildren().clear();
        updateFlowPane.getChildren().clear();
        updateFields.clear();
        whereFields.clear();
        for(int i = 1; i <= tableData.getColumnCount(); ++i){
            InsertField insertField = new InsertField(tableData.getColumnName(i));
            whereFlowPane.getChildren().add(insertField.block);
            whereFields.add(insertField);
        }
    }
    public void updateButtonClicked(ActionEvent actionEvent) {
        StringBuilder query = new StringBuilder("update ");
        query.append(updateComboBox.getValue());
        query.append(" set ");
        for(InsertField updateField : updateFields){
            if(!updateField.textField.getText().equals("")){
                query.append(updateField.label.getText());
                query.append("='");
                query.append(updateField.textField.getText());
                query.append("' , ");
            }
        }
        query.delete(query.length()-3,query.length()-1);
        query.append(" where ");
        for(InsertField whereField : whereFields){
            if(!whereField.textField.getText().equals("")){
                query.append(whereField.label.getText());
                query.append("='");
                query.append(whereField.textField.getText());
                query.append("' and ");
            }
        }
        query.delete(query.length()-5,query.length()-1);
        query.append(";");
        System.out.println(query.toString());
        try{
            QueryExecutor.executeQuery(query.toString());
            updateLog.setText("Update successful");
        }catch (Exception e){
            e.printStackTrace();
            updateLog.setText("Update unsuccessful");
        }
    }

    public void checkButtonClicked(ActionEvent actionEvent) {
        StringBuilder query = new StringBuilder("select * from ");
        query.append(updateComboBox.getValue());
        query.append(" where ");
        for(InsertField whereField : whereFields){
            if(!whereField.textField.getText().equals("")){
                query.append(whereField.label.getText());
                query.append("='");
                query.append(whereField.textField.getText());
                query.append("' and ");
            }
        }
        query.delete(query.length()-5,query.length()-1);
        query.append(";");
        System.out.println(query.toString());
        try {
            ResultSet resultSet = QueryExecutor.executeSelect(query.toString());
            resultSet.last();
            int rowNum = resultSet.getRow();
            if(rowNum > 1){
                updateLog.setText("Query result <" + query.toString() + "> is ambiguous - Please precise update requirements");
            }else if(rowNum <1 ){
                updateLog.setText("Record does not exist - Please change update requirements ");
            }else {
                updateLog.setText("");
                changeUpdateFlowPane(resultSet.getMetaData());
                resultSet.first();
                fillUpdateFields(resultSet);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void updateComboBoxValue(ActionEvent actionEvent) {
        String tableName = updateComboBox.getValue();
        try{
            ResultSet table = QueryExecutor.executeSelect("select * from " + tableName+";");
            ResultSetMetaData tableMetaData = table.getMetaData();
            changeWhereFlowPane(tableMetaData);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
