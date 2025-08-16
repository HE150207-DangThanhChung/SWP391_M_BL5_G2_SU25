/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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
    
    public Employee getEmployeeById(int id) {
        Employee e = new Employee();
        
        StringBuilder sql = new StringBuilder("""
        SELECT e.[EmployeeId], e.[UserName], e.[FirstName], e.[LastName], 
               e.[Phone], e.[Email], e.[CCCD], e.[Status], e.[Avatar],
               e.[DoB], e.[Address], e.[StartAt], e.[Gender], 
               e.[RoleId], e.[StoreId], r.[RoleName], s.[StoreName]
        FROM [Employee] e
        LEFT JOIN [Role] r ON e.RoleId = r.RoleId
        LEFT JOIN [Store] s ON e.StoreId = s.StoreId
        WHERE e.EmployeeId = ?
        """);
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());
            ps.setInt(1, id);
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
                e.setRoleName(rs.getString("RoleName"));
                e.setStoreName(rs.getString("StoreName"));
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
    
    public List<Employee> getAllEmployeesWithPagingAndFilter(String searchKey, String status, int offset, int limit) {
        List<Employee> empList = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
        SELECT e.[EmployeeId], e.[UserName], e.[FirstName], e.[LastName], 
               e.[Phone], e.[Email], e.[CCCD], e.[Status], e.[Avatar],
               e.[DoB], e.[Address], e.[StartAt], e.[Gender], 
               e.[RoleId], e.[StoreId], r.[RoleName], s.[StoreName]
        FROM [Employee] e
        LEFT JOIN [Role] r ON e.RoleId = r.RoleId
        LEFT JOIN [Store] s ON e.StoreId = s.StoreId
        WHERE 1=1
        """);
        
        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (e.FirstName LIKE ? OR e.LastName LIKE ? OR e.UserName LIKE ? OR e.Phone LIKE ? OR e.Email LIKE ?) ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND e.Status = ? ");
        }
        
        sql.append(" ORDER BY e.EmployeeId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            if (searchKey != null && !searchKey.trim().isEmpty()) {
                String searchPattern = "%" + searchKey.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, limit);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Employee e = new Employee();
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
                e.setRoleName(rs.getString("RoleName"));
                e.setStoreName(rs.getString("StoreName"));
                empList.add(e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        
        return empList;
    }
    
    public int countEmployeesWithFilter(String searchKey, String status) {
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*) AS total
        FROM [Employee] e
        WHERE 1=1
        """);
        
        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (e.FirstName LIKE ? OR e.LastName LIKE ? OR e.UserName LIKE ? OR e.Phone LIKE ? OR e.Email LIKE ?) ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND e.Status = ? ");
        }
        
        int total = 0;
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            if (searchKey != null && !searchKey.trim().isEmpty()) {
                String searchPattern = "%" + searchKey.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        
        return total;
    }
    
    public boolean addEmployee(String username, String firstName, String lastName, String phone, String email, String gender, String status) {
        String sql = """
                 INSERT INTO Employee (UserName, FirstName, LastName, Phone, Email, Gender, Status)
                 VALUES (?, ?, ?, ?, ?, ?, ?)
                 """;
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            
            ps.setString(1, username);
            ps.setString(2, firstName);
            ps.setString(3, lastName);
            ps.setString(4, phone);
            ps.setString(5, email);
            ps.setString(6, gender);
            ps.setString(7, status);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        
        return false;
    }
    
    public boolean editEmployee(int employeeId, String username, String firstName, String lastName, String phone, String email, String gender, String status) {
        String sql = """
            UPDATE Employee
            SET UserName = ?, 
                FirstName = ?, 
                LastName = ?, 
                Phone = ?, 
                Email = ?, 
                Gender = ?, 
                Status = ?
            WHERE EmployeeId = ?
            """;
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            
            ps.setString(1, username);
            ps.setString(2, firstName);
            ps.setString(3, lastName);
            ps.setString(4, phone);
            ps.setString(5, email);
            ps.setString(6, gender);
            ps.setString(7, status);
            ps.setInt(8, employeeId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        
        return false;
    }
    
    public boolean isUsernameExisted(String username) {
        return isFieldValueExisted("UserName", username);
    }
    
    public boolean isEmailExisted(String email) {
        return isFieldValueExisted("Email", email);
    }
    
    public boolean isPhoneExisted(String phone) {
        return isFieldValueExisted("Phone", phone);
    }
    
    private boolean isFieldValueExisted(String columnName, String value) {
        String sql = "SELECT 1 FROM Employee WHERE " + columnName + " = ?";
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, value);
            
            rs = ps.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        
        return false;
    }
}
