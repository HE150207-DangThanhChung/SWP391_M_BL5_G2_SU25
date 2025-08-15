package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBContext class for managing SQL Server database connections.
 * Project: SWP391_M_BL5_G2_SU25
 */
public class DBContext {

    private static final String SERVER_NAME = "localhost";
    private static final String DB_NAME = "SWP391_M_BL5_G2_SU25";
    private static final String PORT_NUMBER = "1433"; // Default SQL Server port
    private static final String USER_ID = "Mavinhloc";
    private static final String PASSWORD = "123";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            System.err.println("SQL Server JDBC Driver not found.");
            e.printStackTrace();
        }
    }

    /**
     * Get a new database connection.
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        String url = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT_NUMBER
                   + ";databaseName=" + DB_NAME
                   + ";encrypt=false";

        Connection connection = DriverManager.getConnection(url, USER_ID, PASSWORD);
        System.out.println("Connected to " + DB_NAME + " successfully.");
        return connection;
    }

    /**
     * Close a database connection safely.
     * @param connection the Connection object to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    System.out.println("Database connection closed.");
                }
            } catch (SQLException e) {
                System.err.println("Error while closing the database connection.");
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn);
        }
    }
}
