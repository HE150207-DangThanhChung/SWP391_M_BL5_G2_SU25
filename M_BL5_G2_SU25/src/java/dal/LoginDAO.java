/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Employee;

import java.sql.*;
import java.util.Date;

/**
 *
 * @author tayho
 */
public class LoginDAO {

    private final DBContext db = new DBContext();

    public Employee checkLogin(String username, String password) {
        String sql = """
            SELECT *
            FROM Employee
            WHERE UserName = ? AND Password = ? 
            """;
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password); 
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Employee employee = new Employee();
                    employee.setEmployeeId(rs.getInt("EmployeeId"));
                    employee.setFirstName(rs.getString("FirstName"));
                    employee.setMiddleName(rs.getString("MiddleName"));
                    employee.setLastName(rs.getString("LastName"));
                    employee.setUserName(rs.getString("UserName"));
                    // Set other properties as needed
                    
                    return employee;
                }
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
