import java.sql.ResultSet;
import java.sql.SQLException;

public class Main {
    public static void main(String [] args) throws SQLException {
        ResultSet result = QueryExecutor.executeSelect("select * from public.laybrothers");
        for(int i = 0; i < 10 ;++i){
            result.next();
            String res = result.getString("forename");
            System.out.println(res);
        }

    }
}
