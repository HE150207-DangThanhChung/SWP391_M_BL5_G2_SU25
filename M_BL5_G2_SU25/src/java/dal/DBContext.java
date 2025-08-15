/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author tayho
 */
package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBContext class for managing SQL Server database connections.
 * Project: SWP391_M_BL5_G2_SU25
 */
public class DBContext {
    private final String serverName = "localhost";  
    private final String dbName = "SWP391_M_BL5_G2_SU25";
    private final String portNumber = "1433";       // Default SQL Server port
    private final String userID = "sa";
    private final String password = "123";

    /**
     * Get a database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            // Load SQL Server JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Connection URL
            String url = "jdbc:sqlserver://" + serverName + ":" + portNumber 
                       + ";databaseName=" + dbName 
                       + ";encrypt=false";

            // Create connection
            connection = DriverManager.getConnection(url, userID, password);
            System.out.println("Connected to " + dbName + " successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("SQL Server JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Connection to database failed.");
            throw e;
        }
        return connection;
    }

    public static void main(String[] args) {
        try {
            DBContext db = new DBContext();
            db.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}