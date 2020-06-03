import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnector {
    private static String URL="jdbc:postgresql://localhost/zofia";
    private static String USER="zofia";
    private static String PASSWORD="qwerty";

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
