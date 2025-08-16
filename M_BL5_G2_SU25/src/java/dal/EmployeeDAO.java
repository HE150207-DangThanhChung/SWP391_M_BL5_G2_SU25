/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Employee;

/**
 *
 * @author tayho
 */
public class EmployeeDAO {
    
    private static Connection con;
    private static PreparedStatement ps;
    private static ResultSet rs;
    
    public static void main(String[] args) {
        EmployeeDAO eDao = new EmployeeDAO();
        System.out.println(eDao.getEmployeeByUsername("admin"));
    }
    
    public Employee getEmployeeByUsername(String username) {
        Employee e = new Employee();
        String sql = """
                     SELECT * FROM Employee Where Username = ?
                     """;
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                e.setEmployeeId(rs.getInt("EmployeeId"));
                e.setUserName(rs.getString("UserName"));
                e.setFirstName(rs.getString("FirstName"));
                e.setLastName(rs.getString("LastName"));
                e.setPhone(rs.getString("Phone"));
                e.setEmail(rs.getString("Email"));
                e.setCccd(rs.getString("CCCD"));
                e.setStatus(rs.getString("Status"));
                e.setAvatar(rs.getString("Avatar"));
                e.setDob(rs.getDate("DoB"));
                e.setAddress(rs.getString("Address"));
                e.setStartAt(rs.getDate("StartAt"));
                e.setGender(rs.getString("Gender"));
                e.setRoleId(rs.getInt("RoleId"));
                e.setStoreId(rs.getInt("StoreId"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        
        return e;
    }
}
