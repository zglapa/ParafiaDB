package app;

import database.QueryExecutor;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.Pane;
import javafx.util.Callback;

import java.net.URL;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.ResourceBundle;

public class DatabaseController implements Initializable {

    @FXML ScrollPane whereScrollPane;
    @FXML Label selectLog;
    @FXML Pane whereSelectPane,joinSelectPane;
    @FXML FlowPane whereFlowPane,updateFlowPane,insertFlowPane, columnCheckBoxFlowPane,whereSelectFP, joinSelectFP;
    @FXML Label insertLog,updateLog;
    @FXML Button insertButton,updateButton,checkRecordButton,whereButton,selectButton, joinButton, addJoinButton;
    @FXML
    TableView<ObservableList> tableviewSelect;
    @FXML
    ComboBox<String> selectComboBox, insertComboBox, updateComboBox;
    ObservableList<ObservableList> data;
    ArrayList<InsertField> insertFields;
    ArrayList<InsertField> updateFields;
    ArrayList<InsertField> whereFields;
    ArrayList<ColumnCheckBox> columnCheckBoxes;
    ArrayList<WhereField> whereSelectFields;
    ArrayList<JoinBox> joinBoxes;
    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        insertFields = new ArrayList<>();
        updateFields = new ArrayList<>();
        whereFields = new ArrayList<>();
        columnCheckBoxes = new ArrayList<>();
        whereSelectFields = new ArrayList<>();
        joinBoxes = new ArrayList<>();
        whereScrollPane.setStyle("-fx-background-color:transparent; -fx-control-inner-background: transparent;");
        whereSelectFP.setStyle("-fx-background-color:#d3d3d3;");
        insertButton.setDisable(true);
        updateButton.setDisable(true);
        checkRecordButton.setDisable(true);
        whereButton.setDisable(true);
        selectButton.setDisable(true);
        joinButton.setDisable(true);
    }
    private void changeTable(ResultSet rs) throws SQLException {
        tableviewSelect.getItems().clear();
        tableviewSelect.getColumns().clear();
        for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){
            int j = i;
            TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));
            System.out.println(rs.getMetaData().getColumnTypeName(i+1) );
            if(rs.getMetaData().getColumnTypeName(i+1).equals("int4") || rs.getMetaData().getColumnTypeName(i+1).equals("serial")){
                col.setCellValueFactory(new Callback<TableColumn.CellDataFeatures<ObservableList, Integer>, SimpleIntegerProperty>(){
                    public SimpleIntegerProperty call(TableColumn.CellDataFeatures<ObservableList, Integer> param) {
                        Integer s;
                        try{
                            s = Integer.valueOf(param.getValue().get(j).toString());
                        }catch (NullPointerException e){
                            s=0;
                        }
                        return new SimpleIntegerProperty(s);
                    }
                });
            }else{
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
            }


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
    private void changeColumnCheckBoxFlowPane(ResultSetMetaData tableData) throws SQLException {
        boolean dontChange = true;
        for(int i=1; i <=tableData.getColumnCount(); ++i){
            if(columnCheckBoxes.size()<i || !columnCheckBoxes.get(i-1).label.getText().equals(tableData.getColumnName(i)) ){
                dontChange = false;
                break;
            }
        }
        if(dontChange) return;
        columnCheckBoxFlowPane.getChildren().clear();
        columnCheckBoxes.clear();
        for(int i=1; i <=tableData.getColumnCount(); ++i){
            ColumnCheckBox columnCheckBox = new ColumnCheckBox(tableData.getColumnName(i));
            columnCheckBoxFlowPane.getChildren().add(columnCheckBox.block);
            columnCheckBoxes.add(columnCheckBox);
            columnCheckBox.checkBox.setOnAction(this::selectBasedOnCheckedBoxes);
        }
    }
    public void selectBasedOnCheckedBoxes(ActionEvent actionEvent){
        CheckBox triggered = (CheckBox) actionEvent.getSource();
        System.out.println(triggered.isSelected());
        selectButtonClicked(actionEvent);
    }
    private void executeSelect(String select, String tableName, boolean updateCCBFP, String where, String join){
        StringBuilder selectToExecute=new StringBuilder("select ");
        selectToExecute.append(select).append(" from ").append(tableName);
        selectToExecute.append(" l ");
        if(join!=null && !join.equals("")){
            selectToExecute.append(" join ").append(join);
        }
        if(where!=null && !where.equals("")){
            selectToExecute.append(" where ").append(where);
        }
        if(selectToExecute.indexOf(";") >=0){
            selectLog.setText("Haha... trying to be funny? - visit https://xkcd.com/327/ ");
            return;
        }
        selectToExecute.append(" order by 1;");
        System.out.println(selectToExecute.toString());
        try {
            ResultSet result = QueryExecutor.executeSelect(selectToExecute.toString());
            data = FXCollections.observableArrayList();
            ResultSet resultForCheckBox = QueryExecutor.executeSelect("select * from " + tableName + ";");
            if(updateCCBFP)changeColumnCheckBoxFlowPane(resultForCheckBox.getMetaData());
            changeTable(result);
            addRows(result);
            tableviewSelect.setItems(data);
            selectLog.setText("Select successfull");
        }catch (Exception e){
            e.printStackTrace();
            selectLog.setText("Select unsuccessful");
        }
    }
    public void showSelectResult(ActionEvent actionEvent) {
        String select = "*";
        executeSelect(select,selectComboBox.getValue(), true,null,null);
        whereSelectPane.setVisible(false);
        joinSelectPane.setVisible(false);
        whereButton.setDisable(false);
        joinButton.setDisable(false);
        selectButton.setDisable(false);
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
            StringBuilder select = new StringBuilder("select ");
            for(int i = 1;i <= tableMetaData.getColumnCount(); ++i){
                if(!tableMetaData.getColumnTypeName(i).equals("serial")){
                    select.append(tableMetaData.getColumnName(i));
                    select.append(",");
                }
            }
            select.delete(select.length()-1,select.length());
            select.append(" from ").append(tableName).append(";");
            ResultSetMetaData resultSetMetaData = QueryExecutor.executeSelect(select.toString()).getMetaData();
            changeFlowPane(resultSetMetaData);
            insertButton.setDisable(false);
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
        insert.append(insertComboBox.getValue()).append(" (");
        try{
            ResultSetMetaData resultSetMetaData = QueryExecutor.executeSelect("select * from " + insertComboBox.getValue() + ";").getMetaData();
            for(int i = 1; i <= resultSetMetaData.getColumnCount(); ++i){
                if(!resultSetMetaData.getColumnTypeName(i).equals("serial")){
                    insert.append(resultSetMetaData.getColumnName(i));
                    insert.append(",");
                }
            }
            insert.delete(insert.length()-1, insert.length());
            insert.append(")");
            insert.append(" values (");
            int i=1;
            for(InsertField insertField : insertFields){
                insert.append("'").append(insertField.textField.getText()).append("'");
                i++;
                if(i <= insertFields.size()) insert.append(",");
            }
            if(insert.indexOf(";") >=0){
                insertLog.setText("Haha... trying to be funny? - visit https://xkcd.com/327/ ");
                return;
            }
            insert.append(");");
            System.out.println(insert.toString());
            try{
                insertIntoTable(insert.toString(), insertComboBox.getValue());
            }catch (Exception e){
                e.printStackTrace();
            }
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
            System.out.println(tableData.getColumnTypeName(i));
            if(tableData.getColumnTypeName(i).equals("serial")){
                insertField.textField.setEditable(false);
            }
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
        if(query.indexOf(";") >=0){
            updateLog.setText("Haha... trying to be funny? - visit https://xkcd.com/327/ ");
            return;
        }
        query.append(";");
        System.out.println(query.toString());
        try{
            QueryExecutor.executeQuery(query.toString());
            updateLog.setText("Update successful");
            updateButton.setDisable(true);
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
        if(query.indexOf(";") >=0){
            updateLog.setText("Haha... trying to be funny? - visit https://xkcd.com/327/ ");
            return;
        }
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
                updateButton.setDisable(false);
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
            checkRecordButton.setDisable(false);
            updateButton.setDisable(true);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    private void fillWhereSelectFP(ResultSetMetaData tableData) throws SQLException{
        whereSelectFields.clear();
        whereSelectFP.getChildren().clear();
        whereSelectPane.setVisible(true);
        for(int i = 1; i <= tableData.getColumnCount(); ++i){
            WhereField whereField = new WhereField(tableData.getColumnName(i));
            whereSelectFP.getChildren().add(whereField.block);
            whereSelectFields.add(whereField);
        }
    }
    public void whereSelectButtonClicked(ActionEvent actionEvent) {
        joinSelectPane.setVisible(false);
        if(whereSelectPane.isVisible()){
            whereSelectPane.setVisible(false);
        }else if(selectComboBox.getValue()!=null){
            StringBuilder helpQuery = new StringBuilder("select * from ");
            helpQuery.append(selectComboBox.getValue());
            if(joinBoxes.size()>0 && joinBoxes.get(0).tableComboBox.getValue()!=null && joinBoxes.get(0).columnComboBoxLeft.getValue()!=null && joinBoxes.get(0).columnComboBoxRight.getValue()!=null){
                helpQuery.append(" l ");
                helpQuery.append(" join ");
                helpQuery.append(joinBoxes.get(0).tableComboBox.getValue());
                helpQuery.append(" p ");
                helpQuery.append(" on ");
                helpQuery.append("l.").append(joinBoxes.get(0).columnComboBoxLeft.getValue()).append("=").append("p.").append(joinBoxes.get(0).columnComboBoxRight.getValue());
            }
            helpQuery.append(";");
            try {
                ResultSet resultSet = QueryExecutor.executeSelect(helpQuery.toString());
                fillWhereSelectFP(resultSet.getMetaData());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void selectButtonClicked(ActionEvent actionEvent) {
        StringBuilder join = new StringBuilder("");
        for(JoinBox joinBox : joinBoxes){
            if(!joinBox.columnComboBoxLeft.getValue().equals("") && !joinBox.columnComboBoxRight.getValue().equals("") ){
                join.append(joinBox.tableComboBox.getValue());
                join.append(" p ");
                join.append(" on ");
                join.append("l.");
                join.append(joinBox.columnComboBoxLeft.getValue());
                join.append("=");
                join.append("p.");
                join.append(joinBox.columnComboBoxRight.getValue());
            }
        }
        StringBuilder columns = new StringBuilder("");
        int columnsLNumber = 40;
        if(!join.toString().equals("")){
            try{
                ResultSetMetaData resultSetMetaData = QueryExecutor.executeSelect("select * from " + selectComboBox.getValue() + ";" ).getMetaData();
                columnsLNumber = resultSetMetaData.getColumnCount();
                ResultSetMetaData rsmd = QueryExecutor.executeSelect("select * from " + selectComboBox.getValue() + " l join " + join+";").getMetaData();
                changeColumnCheckBoxFlowPane(rsmd);
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        int i = 1;
        StringBuilder where = new StringBuilder("");
        for(WhereField whereField : whereSelectFields){
            if(!whereField.textField.getText().equals("")){
                where.append((i<=columnsLNumber)?"l.":"p.");
                where.append(whereField.label.getText());
                where.append(whereField.comboBox.getValue());
                where.append("'");
                where.append(whereField.textField.getText());
                where.append("'");
                where.append(" and ");
            }
            i++;
        }
        if(where.length() > 4)
            where.delete(where.length()-4,where.length());
        i=1;
        for(ColumnCheckBox columnCheckBox : columnCheckBoxes){
            if(columnCheckBox.checkBox.isSelected()){
                columns.append((i<=columnsLNumber)?"l.":"p.");
                columns.append(columnCheckBox.label.getText());
                columns.append(",");
            }
            i++;
        }
        if(columns.length() > 0)
            columns.delete(columns.length()-1,columns.length());
        else columns.append("*");
        System.out.println(join.toString());
        executeSelect(columns.toString(),selectComboBox.getValue(),false,where.toString(),join.toString());

    }
    private void fillJoinSelectFlowPane(){
        joinSelectFP.getChildren().clear();
        joinBoxes.clear();
        JoinBox joinBox = new JoinBox(selectComboBox);
        joinSelectFP.getChildren().add(joinBox.block);
        joinBox.tableComboBox.setOnAction(this::changeJoinBox);
        joinBoxes.add(joinBox);
    }
    public void changeJoinBox(ActionEvent actionEvent){
        ComboBox<?> comboBox = (ComboBox<?>)(actionEvent.getSource());
        JoinBox joinBox= null;
        for(JoinBox jb : joinBoxes){
            if(comboBox==jb.tableComboBox){
                joinBox = jb;
            }
        }
        try{
            ResultSetMetaData resultSetMetaData = QueryExecutor.executeSelect("select * from " + selectComboBox.getValue() + ";").getMetaData();
            assert joinBox != null;
            joinBox.columnComboBoxLeft.getItems().clear();
            joinBox.columnComboBoxRight.getItems().clear();
            for(int i = 1; i <= resultSetMetaData.getColumnCount(); ++i){
                joinBox.columnComboBoxLeft.getItems().add(resultSetMetaData.getColumnName(i));
            }
            //joinBox.columnComboBoxLeft.setValue(resultSetMetaData.getColumnName(1));
            ResultSetMetaData resultSetMetaData2 = QueryExecutor.executeSelect("select * from " + joinBox.tableComboBox.getValue() + ";").getMetaData();
            for(int i = 1; i <= resultSetMetaData2.getColumnCount(); ++i){
                joinBox.columnComboBoxRight.getItems().add(resultSetMetaData2.getColumnName(i));
            }
            //joinBox.columnComboBoxRight.setValue(resultSetMetaData2.getColumnName(1));
            System.out.println(joinBox.columnComboBoxLeft.getWidth());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void joinSelectButtonClicked(ActionEvent actionEvent) {
        whereSelectPane.setVisible(false);
        joinSelectPane.setVisible(!joinSelectPane.isVisible());
    }

    public void addJoinButtonClicked(ActionEvent actionEvent) {
        if(joinSelectFP.getChildren().size() == 0)
        fillJoinSelectFlowPane();
    }
}
