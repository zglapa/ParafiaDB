package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnector {
    public static String URL;
    public static String USER;
    public static String PASSWORD;

    public static Connection connect() throws SQLException {
        Connection connection = null;
        try{
            connection = DriverManager.getConnection(URL,USER,PASSWORD);
            System.out.println("connected");
        }catch (SQLException e){
            e.printStackTrace();
        }
        return connection;
    }
}
