package database;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class QueryExecutor {

    public static ResultSet executeSelect(String selectQuery) {
        try{
            Connection connection = DBConnector.connect();
            Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
            return statement.executeQuery(selectQuery);
        }catch (SQLException e){
            throw new RuntimeException(e.getMessage());
        }
    }

    public static void executeQuery(String query) {
        try{
            Connection connection = DBConnector.connect();
            Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
            statement.execute(query);
        }catch (SQLException e){
            throw new RuntimeException(e.getMessage());
        }
    }
}
