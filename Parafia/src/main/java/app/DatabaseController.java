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
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import javafx.util.Callback;
import javafx.util.Duration;

import java.net.URL;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.ResourceBundle;

public class DatabaseController implements Initializable {

    @FXML TitledPane SELECT;
    @FXML Accordion acordionPane;
    @FXML
    AnchorPane backgroundPane;
    @FXML StackPane usefulPane;
    @FXML ListView<String> listView;
    @FXML Button usefulExecuteButton;
    @FXML Button usefulButton;
    @FXML TextArea customSelectArea;
    @FXML ScrollPane whereScrollPane;
    @FXML Label selectLog;
    @FXML Pane whereSelectPane,joinSelectPane, customSQPane;
    @FXML FlowPane whereFlowPane,updateFlowPane,insertFlowPane, columnCheckBoxFlowPane,whereSelectFP, joinSelectFP;
    @FXML Label insertLog,updateLog;
    @FXML Button insertButton,updateButton,checkRecordButton,whereButton,selectButton, joinButton, addJoinButton, clearButton,customSQButton,executeButton;
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
    HashMap<String,String> usefulSelects;
    Tooltip mandatoryTooltip;
    Tooltip optionalTooltip;
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
        Tooltip customSelectTooltip = new Tooltip("click to enter custom select query");
        customSelectTooltip.setShowDelay(new Duration(500));
        customSelectTooltip.setHideDelay(Duration.ZERO);
        customSelectTooltip.setShowDuration(Duration.INDEFINITE);
        Tooltip whereTooltip = new Tooltip("click to add where clause");
        whereTooltip.setShowDelay(new Duration(500));
        whereTooltip.setHideDelay(Duration.ZERO);
        whereTooltip.setShowDuration(Duration.INDEFINITE);
        Tooltip joinTooltip = new Tooltip("click to join another table");
        joinTooltip.setShowDelay(new Duration(500));
        joinTooltip.setHideDelay(Duration.ZERO);
        joinTooltip.setShowDuration(Duration.INDEFINITE);
        Tooltip selectTooltip = new Tooltip("click to execute select");
        selectTooltip.setShowDelay(new Duration(500));
        selectTooltip.setHideDelay(Duration.ZERO);
        selectTooltip.setShowDuration(Duration.INDEFINITE);
        Tooltip clearTooltip = new Tooltip("click to clear current select");
        clearTooltip.setShowDelay(new Duration(500));
        clearTooltip.setHideDelay(Duration.ZERO);
        clearTooltip.setShowDuration(Duration.INDEFINITE);
        whereButton.setTooltip(whereTooltip);
        joinButton.setTooltip(joinTooltip);
        selectButton.setTooltip(selectTooltip);
        clearButton.setTooltip(clearTooltip);
        mandatoryTooltip=new Tooltip("mandatory field");
        mandatoryTooltip.setShowDelay(new Duration(500));
        mandatoryTooltip.setHideDelay(Duration.ZERO);
        mandatoryTooltip.setShowDuration(Duration.INDEFINITE);
        optionalTooltip=new Tooltip("optional field");
        optionalTooltip.setShowDelay(new Duration(500));
        optionalTooltip.setHideDelay(Duration.ZERO);
        optionalTooltip.setShowDuration(Duration.INDEFINITE);
        populateListView();
        backgroundPane.setStyle("-fx-background-color: LIGHTGRAY");
        acordionPane.setExpandedPane(SELECT);
    }

    String getTip(String dataType) {
        if(dataType.equals("bool"))
            return " ('t' or 'f')";
        if(dataType.equals("date"))
            return " (YYYY-MM-DD)";
        if(dataType.equals("serial"))
            return " (automatic)";
        if(dataType.equals("bpchar"))
            return " ('M' or 'F')";
        return "";
    }

    //  TABLEVIEW MANAGEMENT
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
    // SELECT
    // ---> checkboxes
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
    // ---> select execution
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
    private void executeCustomSelect(String select){
        try{
            System.out.println(select);
            ResultSet result = QueryExecutor.executeSelect(select);
            data = FXCollections.observableArrayList();
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
        if(selectComboBox.getValue()==null) return;
        String select = "*";
        executeSelect(select,selectComboBox.getValue(), true,null,null);
        whereSelectPane.setVisible(false);
        joinSelectPane.setVisible(false);
        whereButton.setDisable(false);
        joinButton.setDisable(false);
        selectButton.setDisable(false);
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
    // ---> where management
    private void fillWhereSelectFP(ResultSetMetaData tableData) throws SQLException{
        whereSelectFields.clear();
        whereSelectFP.getChildren().clear();
        whereSelectPane.setVisible(true);
        String tableName="";
        for(int i = 1; i <= tableData.getColumnCount(); ++i){
            if(!tableName.equals(tableData.getTableName(i))){
                tableName=tableData.getTableName(i);
                Label tableSeparator = new Label("--" + tableName.toUpperCase() + "--");
                whereSelectFP.getChildren().add(tableSeparator);
            }
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
    // ---> join management
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
    // ---> clear the view
    public void clearButtonClicked(ActionEvent actionEvent) {
        whereSelectFP.getChildren().clear();
        whereSelectFields.clear();
        whereSelectPane.setVisible(false);
        joinSelectFP.getChildren().clear();
        joinBoxes.clear();
        joinSelectPane.setVisible(false);
        columnCheckBoxes.clear();
        columnCheckBoxFlowPane.getChildren().clear();
        tableviewSelect.getItems().clear();
        tableviewSelect.getColumns().clear();
        whereButton.setDisable(true);
        joinButton.setDisable(true);
        selectButton.setDisable(true);
        selectComboBox.setValue(null);
        selectLog.setText("View cleared");
    }
    // ----> custom select
    public void showCustomSelectPane(ActionEvent actionEvent) {
        if(customSQPane.isVisible()){
            customSQPane.setVisible(false);
            return;
        }
        clearButtonClicked(actionEvent);
        selectLog.setText("Warning : this may be potentially harmful to the database - use with caution");
        customSQPane.setVisible(true);
    }
    public void customSelectButtonClicked(ActionEvent actionEvent) {
        String select = customSelectArea.getText();
        if(select.equals("")){
            selectLog.setText("Query must not be empty");
            showCustomSelectPane(actionEvent);
            return;
        }
        if(select.indexOf(';') != select.length()-1) {
            selectLog.setText("Character ';' has to be at the end of the query");
            showCustomSelectPane(actionEvent);
            return;
        }
        if(!select.substring(0,6).equalsIgnoreCase("select")){
            selectLog.setText("Query must start with SELECT clause");
            showCustomSelectPane(actionEvent);
            return;
        }
        whereButton.setDisable(true);
        selectButton.setDisable(true);
        joinButton.setDisable(true);
        customSQPane.setVisible(false);
        executeCustomSelect(select);
    }
    //  INSERT
    private void changeFlowPane(ResultSetMetaData tableData) throws SQLException {
        insertFlowPane.getChildren().clear();
        insertFields.clear();
        for(int i = 1; i <= tableData.getColumnCount(); ++i){
            InsertField insertField = new InsertField(tableData.getColumnName(i),getTip(tableData.getColumnTypeName(i)));
            if(tableData.isNullable(i)==ResultSetMetaData.columnNoNulls){
                insertField.setMandatory(true);
                insertField.description.setTooltip(mandatoryTooltip);
            }else{
                insertField.description.setTooltip(optionalTooltip);
            }
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
        try{
            QueryExecutor.executeQuery(insertString);
        }catch (Exception ignored){
            insertLog.setText(insertString + "\n" + "unsuccessful");
            return;
        }
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
            if(insertField.textField.getText().equals("") && insertField.mandatory) return;
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
                if(insertField.textField.getText().equals("")){
                    insert.append("null");
                }
                else insert.append("'").append(insertField.textField.getText()).append("'");
                i++;
                if(i <= insertFields.size()) insert.append(",");
            }
            if(insert.indexOf(";") >=0){
                insertLog.setText("Character ';' is not allowed as value - visit https://xkcd.com/327/ ");
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
    //  UPDATE
    private void changeUpdateFlowPane(ResultSetMetaData tableData) throws SQLException {
        updateFlowPane.getChildren().clear();
        updateFields.clear();
        for(int i = 1; i <= tableData.getColumnCount(); ++i){
            InsertField insertField = new InsertField(tableData.getColumnName(i),getTip(tableData.getColumnTypeName(i)));
            updateFlowPane.getChildren().add(insertField.block);
            if(tableData.isNullable(i)==ResultSetMetaData.columnNoNulls){
                insertField.setMandatory(true);
                insertField.description.setTooltip(mandatoryTooltip);
            }else{
                insertField.description.setTooltip(optionalTooltip);
            }
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
        String tableName="";
        for(int i = 1; i <= tableData.getColumnCount(); ++i){
            InsertField insertField = new InsertField(tableData.getColumnName(i),getTip(tableData.getColumnTypeName(i)));
            whereFlowPane.getChildren().add(insertField.block);
            whereFields.add(insertField);
        }
    }
    public void updateButtonClicked(ActionEvent actionEvent) {
        StringBuilder query = new StringBuilder("update ");
        query.append(updateComboBox.getValue());
        query.append(" set ");
        for(InsertField updateField : updateFields){
            if(updateField.textField.getText() != null &&!updateField.textField.getText().equals("")){
                query.append(updateField.label.getText());
                query.append("='");
                query.append(updateField.textField.getText());
                query.append("' , ");
            }
        }
        query.delete(query.length()-3,query.length()-1);
        query.append(" where ");
        for(InsertField whereField : whereFields){
            if(whereField.textField.getText() != null &&!whereField.textField.getText().equals("")){
                query.append(whereField.label.getText());
                query.append("='");
                query.append(whereField.textField.getText());
                query.append("' and ");
            }
        }
        query.delete(query.length()-5,query.length()-1);
        if(query.indexOf(";") >=0){
            updateLog.setText("Character ';' is not allowed as value - visit https://xkcd.com/327/ ");
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
            updateLog.setText("Character ';' is not allowed as value - visit https://xkcd.com/327/ ");
            return;
        }
        query.append(";");
        System.out.println(query.toString());
        try {
            ResultSet resultSet = QueryExecutor.executeSelect(query.toString());
            resultSet.last();
            int rowNum = resultSet.getRow();
            if(rowNum <1 ){
                updateLog.setText("Record does not exist - Please change update requirements ");
            }else {
                updateLog.setText("");
                changeUpdateFlowPane(resultSet.getMetaData());
                if(rowNum==1)fillUpdateFields(resultSet);
                else{
                    updateLog.setText("Warning: your update will affect multiple records");
                }
                resultSet.first();
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


    public void usefulExecuteButtonClicked(ActionEvent actionEvent) {
        usefulPane.setVisible(false);
        clearButtonClicked(actionEvent);
        String select = usefulSelects.get(listView.getSelectionModel().getSelectedItem());
        if(select != null)
        executeCustomSelect(select);
    }

    public void usefulButtonClicked(ActionEvent actionEvent) {
        usefulPane.setVisible(!usefulPane.isVisible());
    }
    private void populateListView(){
        listView.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
        usefulSelects = new HashMap<>();
        UsefulSelect sel = new UsefulSelect("Parents info",
                "select person.id, person.forename || ' ' || person.surname AS \"Child\"," +
                    " person.gender AS \"Gender\",person.isparishioner AS \"Parishioner\",person.dateofbirth AS \"Date of birth\"," +
                    " person.motherid AS \"MotherID\",mother.forename || ' ' || mother.surname AS \"Mother\",mother.dateofbirth AS \"Date of birth\"," +
                    " person.fatherid AS \"FatherID\",father.forename || ' ' || father.surname AS \"Father\",father.dateofbirth AS \"Date of birth\"" +
                    " from laybrothers person join laybrothers mother on person.motherid=mother.id join laybrothers father on person.fatherid=father.id;");
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);

        sel.name="Priests with most masses as secondary";
        sel.select=
                "SELECT forename || ' ' || surname AS \"Priest\", count(massid) AS \"Number of masses\"" +
                " FROM priestsmasses left join laybrothers l on priestsmasses.priestid = l.id" +
                " GROUP BY 1" +
                " ORDER BY 2 DESC;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);

        sel.name="Top acolytes in terms of number of masses";
        sel.select="SELECT forename || ' ' || surname AS \"Acolyte\"," +
                " count(massid) AS \"Number of masses\"" +
                " FROM acolytesmasses left join acolytes a on acolytesmasses.acolyteid = a.laybrotherid left join laybrothers l on a.laybrotherid = l.id" +
                " GROUP BY 1 ORDER BY 2 DESC;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);

        sel.name="Most faithful laybrothers";
        sel.select="SELECT forename || ' ' || surname AS \"Laybrother\", sum(amount) AS \"Money donated\" FROM donations left join laybrothers l on laybrotherid = l.id GROUP BY 1 ORDER BY 2 DESC;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);

        sel.name="Most romantic masstypes";
        sel.select="SELECT type AS \"Type of mass\", count(marriages.id) AS \"Number of married couples\" FROM marriages left join masses a on marriages.massid = a.massid left join masstypes t on a.masstype = t.id GROUP BY 1 ORDER BY 2 DESC;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);

        sel.name="Average age on acolytes meetings";
        sel.select="SELECT meetingtypes.meetingtype AS \"Type of meeting\", count(l.dateofbirth) AS \"Number of acolytes\", round(sum(EXTRACT(YEAR FROM AGE(now(), l.dateofbirth)))/count(l.dateofbirth)) AS \"Average age\"" +
                " FROM meetingtypes left join acolytemeetings m on m.meetingtype = meetingtypes.id left join acolytesonmeetings o on o.meetingid = m.id left join acolytes a on o.acolyteid = a.laybrotherid left join laybrothers l on l.id = a.laybrotherid" +
                " GROUP BY 1 ORDER BY 2 DESC;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Laybrothers and their godparents";
        sel.select="select person.id as \"id\", person.forename || ' ' || person.surname as \"name\", person.godmotherid as \"godmother id\", gmother.forename || ' ' || gmother.surname as \"godmother\",person.godfatherid as \"godfather id\", gfather.forename || ' ' || gfather.surname as \"godfather\" from laybrothers person join laybrothers gmother on person.godmotherid=gmother.id join laybrothers gfather on person.godfatherid=gfather.id;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Women and their children";
        sel.select="select person.id, person.forename || ' ' || person.surname as \"name\", child.id as \"child id\",child.forename ||' '|| child.surname as \"child\",child.dateofbirth as \"child date of birth\", child.gender as \"child gender\" from laybrothers person join laybrothers child on person.id=child.motherid;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Men and their children";
        sel.select="select person.id, person.forename || ' ' || person.surname as \"name\", child.id as \"child id\",child.forename ||' '|| child.surname as \"child\",child.dateofbirth as \"child date of birth\", child.gender as \"child gender\" from laybrothers person join laybrothers child on person.id=child.fatherid;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Married couples";
        sel.select="select person.id as \"wife id\", person.forename || ' ' || person.surname as \"wife\", spouse.id as \"husband id\", spouse.forename || ' ' || spouse.surname as \"husband\" from laybrothers person join marriages m on person.id = m.wifeid join laybrothers spouse on m.husbandid=spouse.id;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Women and their bestpeople";
        sel.select="select person.id , person.forename || ' ' || person.surname as \"name\", best.id as \"bestperson id\",best.forename || ' ' || best.surname as \"bestperson\" from laybrothers person join marriages m on person.id = m.wifeid join laybrothers best on m.wifebestpersonid=best.id;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Men and their bestpeople";
        sel.select="select person.id , person.forename || ' ' || person.surname as \"name\", best.id as \"bestperson id\",best.forename || ' ' || best.surname as \"bestperson\" from laybrothers person join marriages m on person.id = m.husbandid join laybrothers best on m.husbandbestpersonid=best.id;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Married couples and priests who lead the ceremony";
        sel.select="select m2.massdate as \"marriage date\", person.forename  || ' ' || person.surname as \"wife\",spouse.forename || ' ' || spouse.surname as \"husband \", l2.forename  || ' ' || l2.surname as \"priest\" from laybrothers person join marriages m on person.id = m.wifeid join laybrothers spouse on m.husbandid=spouse.id join masses m2 on m.massid = m2.massid join laybrothers l2 on m2.leadingpriestid=l2.id;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Apostates names";
        sel.select="select person.id, person.forename || ' ' || person.surname as \"name\", person.dateofbirth as \"date of birth\", a.apostasydate from laybrothers person join apostates a on person.id = a.laybrotherid;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Excommunicated names";
        sel.select="select person.id,person.forename || ' ' || person.surname as \"name\", person.dateofbirth as \"date of birth\", a.excommuniondate from laybrothers person join excommunicated a on person.id = a.laybrotherid;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Married couples and their bestpeople";
        sel.select="select m2.massdate as \"mass date\",w.forename || ' ' || w.surname as \"wife\",h.forename || ' ' || h.surname as \"husband\",wb.forename  || ' ' || wb.surname as \"wife's bestperson\",hb.forename  || ' ' ||  hb.surname as \"husband's bestperson \" from marriages m join laybrothers w on m.wifeid = w.id join laybrothers h on m.husbandid=h.id  join laybrothers wb on m.wifebestpersonid=wb.id  join laybrothers hb on m.husbandbestpersonid=hb.id join masses m2 on m.massid = m2.massid;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Weddings with the highest offering";
        sel.select="select m2.offering as \"offering\",w.forename || ' ' || w.surname as \"wife\",h.forename || ' ' || h.surname as \"husband\" from marriages m join laybrothers w on m.wifeid = w.id join laybrothers h on m.husbandid=h.id join masses m2 on m.massid = m2.massid order by m2.offering DESC;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Donors names";
        sel.select="select d.id,d.amount,d.donationdate,l.forename || ' ' ||l.surname as \"donor\" from donations d join laybrothers l on d.laybrotherid = l.id;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Parishioner donors vs non-parishioner donors";
        sel.select="select (select sum(d.amount) from donations d join laybrothers l2 on d.laybrotherid = l2.id where l2.isparishioner='true') as \"Parishioners donations\", (select sum(d.amount) from donations d join laybrothers l2 on d.laybrotherid = l2.id where l2.isparishioner='false') as \"Non-parishioner donations\";";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Parishioner vs non-parishioner donors (number of donations)";
        sel.select="select (select count(*) from donations d join laybrothers l2 on d.laybrotherid = l2.id where l2.isparishioner='true') as \"Parishioners donations\", (select count(*) from donations d join laybrothers l2 on d.laybrotherid = l2.id where l2.isparishioner='false') as \"Non-parishioner donations\";";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Dead people and the priests who lead the funerals";
        sel.select="select d.deathdate,l.forename || ' ' ||l.surname as \"name\",date_part('years',age(d.deathdate,l.dateofbirth)) as age, l.isparishioner \"parishioner\",m.massdate as \"funeral date\",l2.forename ||' ' || l2.surname as \"priest\" from deaths d join laybrothers l on d.laybrotherid = l.id left join masses m on d.massid =  m.massid left join priestsmasses p on m.massid = p.massid join laybrothers l2 on leadingpriestid=l2.id ;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Acolytes names";
        sel.select="select distinct l.forename || ' ' ||l.surname as \"name\",date_part('years',age(current_timestamp,l.dateofbirth)) as age,l.gender from acolytes a join laybrothers l on a.laybrotherid = l.id;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Number of acolytes on masses";
        sel.select="select m.massdate as \"mass date\", count(p.laybrotherid) as \"number of acolytes\" from acolytes p join acolytesmasses a on p.laybrotherid = a.acolyteid right join masses m on a.massid = m.massid join laybrothers l on p.laybrotherid = l.id group by m.massid order by 2 desc;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Number of meetings that an acolyte attended";
        sel.select="select l.forename || ' ' ||l.surname as \"acolyte\",m.meetingtype as \"meeting type\", count(am.meetingid) \"number of meetings\" from acolytesonmeetings am join acolytemeetings a on am.meetingid = a.id join laybrothers l on am.acolyteid = l.id join meetingtypes m on a.meetingtype = m.id group by  l.id,l.forename, l.surname,m.meetingtype order by l.id,3 desc;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Most comon meeting types";
        sel.select="select m.meetingtype as \"meeting type\", count(a.id) as \"number of meetings\" from meetingtypes m left join acolytemeetings a on m.id = a.meetingtype group by m.meetingtype order by 2 desc;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="People who were given sacraments and priests who lead the ceremony";
        sel.select="select m.massdate as \"mass date\", t.sacramenttype as \"sacrament type\",l.forename || ' ' ||l.surname as \"name\",date_part('years',age(m.massdate,l.dateofbirth)) as age, ll.forename || ' ' || ll.surname as \"priest\"  from initializationsacraments i join initializationsacramentstypes t on i.sacramenttype = t.id join laybrothers l on i.laybrotherid = l.id join masses m on i.massid = m.massid join laybrothers ll on ll.id=m.leadingpriestid;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        sel.name="Number of people on cerain sacraments";
        sel.select="select m.massdate as \"mass date\", count(i.id) as \"number of people\", t.sacramenttype \"sacrament type\" from initializationsacraments i join masses m on i.massid = m.massid join initializationsacramentstypes t on i.sacramenttype = t.id group by m.massid, m.massdate, t.sacramenttype;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);
        /*sel.name="Number of men vs women who were given sacraments";
        sel.select="select m.massdate, t.sacramenttype, sum(case when l.gender='F' then 1 else 0 end ) as \"number of women\",sum(case when l.gender='M' then 1 else 0 end ) as \"number of men\" from initializationsacraments i join masses m on i.massid = m.massid join initializationsacramentstypes t on i.sacramenttype = t.id join laybrothers l on i.laybrotherid = l.id  group by m.massid, m.massdate, t.sacramenttype;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);*/
        sel.name="Number of sacraments divided into types";
        sel.select="select i2.sacramenttype as \"sacrament type\" ,count(i.id) as \"number of sacraments\" from initializationsacraments i join initializationsacramentstypes i2 on i.sacramenttype = i2.id group by i2.sacramenttype;";
        usefulSelects.put(sel.name,sel.select);
        listView.getItems().add(sel.name);

    }
}
