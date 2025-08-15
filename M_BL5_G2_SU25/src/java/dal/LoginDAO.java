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

    public boolean checkLogin(String username, String password) {
        String sql = """
            SELECT *
            FROM Employee
            WHERE UserName = ? AND Password = ? 
            """;
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password); 
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
