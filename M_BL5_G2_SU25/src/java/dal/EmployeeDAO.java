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
        return addEmployee(username, firstName, lastName, phone, email, gender, status, 1, 1, "123456", "000000000000", java.sql.Date.valueOf("2000-01-01"), new java.sql.Date(System.currentTimeMillis()), "", null); // Default values with today's date, empty address, and null avatar
    }
    
    public boolean addEmployee(String username, String firstName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId) {
        return addEmployee(username, firstName, lastName, phone, email, gender, status, roleId, storeId, "123456", "000000000000", java.sql.Date.valueOf("2000-01-01"), new java.sql.Date(System.currentTimeMillis()), "", null); // Default values with today's date, empty address, and null avatar
    }
    
    public boolean addEmployee(String username, String firstName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password) {
        return addEmployee(username, firstName, lastName, phone, email, gender, status, roleId, storeId, password, "000000000000", java.sql.Date.valueOf("2000-01-01"), new java.sql.Date(System.currentTimeMillis()), "", null); // Default values with today's date, empty address, and null avatar
    }
    
    public boolean addEmployee(String username, String firstName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd) {
        return addEmployee(username, firstName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, java.sql.Date.valueOf("2000-01-01"), new java.sql.Date(System.currentTimeMillis()), "", null); // Default values with today's date, empty address, and null avatar
    }
    
    public boolean addEmployee(String username, String firstName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd, java.sql.Date dob) {
        return addEmployee(username, firstName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, dob, new java.sql.Date(System.currentTimeMillis()), "", null); // Today's date, empty address, and null avatar
    }
    
    public boolean addEmployee(String username, String firstName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd, java.sql.Date dob, java.sql.Date startAt) {
        return addEmployee(username, firstName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, dob, startAt, "", null); // Empty address and null avatar
    }
    
    public boolean addEmployee(String username, String firstName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd, java.sql.Date dob, java.sql.Date startAt, String address) {
        return addEmployee(username, firstName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, dob, startAt, address, null); // Null avatar
    }
    
    public boolean addEmployee(String username, String firstName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd, java.sql.Date dob, java.sql.Date startAt, String address, String avatar) {
        String sql = """
             INSERT INTO Employee (UserName, FirstName, LastName, Phone, Email, Gender, Status, RoleId, StoreId, Password, CCCD, DoB, StartAt, Address, Avatar)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
            ps.setInt(8, roleId);
            ps.setInt(9, storeId);
            ps.setString(10, password);
            ps.setString(11, cccd);
            ps.setDate(12, dob);
            ps.setDate(13, startAt);
            ps.setString(14, address);
            
            // Handle null avatar
            if (avatar == null) {
                ps.setNull(15, java.sql.Types.VARCHAR);
            } else {
                ps.setString(15, avatar);
            }
            
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
        return editEmployee(employeeId, username, firstName, lastName, phone, email, gender, status, null, null, null);
    }

    public boolean editEmployee(int employeeId, String username, String firstName, String lastName, String phone, String email, String gender, String status, String cccd, java.sql.Date dob, String address) {
        StringBuilder sql = new StringBuilder("""
            UPDATE Employee
            SET UserName = ?, 
                FirstName = ?, 
                LastName = ?, 
                Phone = ?, 
                Email = ?, 
                Gender = ?, 
                Status = ?
            """);
        
        // Add optional fields if they are provided
        if (cccd != null) {
            sql.append(", CCCD = ?");
        }
        if (dob != null) {
            sql.append(", DoB = ?");
        }
        if (address != null) {
            sql.append(", Address = ?");
        }
        
        sql.append(" WHERE EmployeeId = ?");
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            ps.setString(paramIndex++, username);
            ps.setString(paramIndex++, firstName);
            ps.setString(paramIndex++, lastName);
            ps.setString(paramIndex++, phone);
            ps.setString(paramIndex++, email);
            ps.setString(paramIndex++, gender);
            ps.setString(paramIndex++, status);
            
            // Set optional parameters if provided
            if (cccd != null) {
                ps.setString(paramIndex++, cccd);
            }
            if (dob != null) {
                ps.setDate(paramIndex++, dob);
            }
            if (address != null) {
                ps.setString(paramIndex++, address);
            }
            
            ps.setInt(paramIndex, employeeId);
            
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
    
    public boolean deleteEmployee(int employeeId) {
        String sql = """
            DELETE FROM Employee
            WHERE EmployeeId = ?
            """;
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            
            ps.setInt(1, employeeId);
            
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
    
    public boolean changeEmployeeStatus(int employeeId, String status) {
        String sql = """
            UPDATE Employee
            SET Status = ?
            WHERE EmployeeId = ?
            """;
        
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            
            ps.setString(1, status);
            ps.setInt(2, employeeId);
            
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
    public static void main(String[] args) {
        EmployeeDAO eDao = new EmployeeDAO();

        // Thông tin nhân viên test
        String username = "zoo_user";
        String firstName = "Zoo";
        String lastName = "Test";
        String phone = "0987654321";
        String email = "zoo.test@example.com";
        String gender = "Male";
        String status = "Active";
        int roleId = 1; // Default role (assuming 1 is a valid role ID)
        int storeId = 1; // Default store (assuming 1 is a valid store ID)
        String password = "123456"; // Default password
        String cccd = "123456789012"; // Default CCCD (citizen ID)
        java.sql.Date dob = java.sql.Date.valueOf("2000-01-01"); // Default DoB
        java.sql.Date startAt = new java.sql.Date(System.currentTimeMillis()); // Today's date
        String address = "123 Test St"; // Default address
        String avatar = null; // Default avatar is null

        boolean added = eDao.addEmployee(username, firstName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, dob, startAt, address, avatar);

        if (added) {
            System.out.println("✅ Thêm nhân viên thành công!");
            Employee emp = eDao.getEmployeeByUsername(username);
            System.out.println("ID: " + emp.getEmployeeId());
            System.out.println("Tên: " + emp.getFirstName() + " " + emp.getLastName());
            System.out.println("Email: " + emp.getEmail());
            System.out.println("Phone: " + emp.getPhone());
            System.out.println("Address: " + emp.getAddress());
        } else {
            System.out.println("❌ Thêm nhân viên thất bại!");
        }
    }
}
