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
                e.setMiddleName(rs.getString("MiddleName"));
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
                e.setMiddleName(rs.getString("MiddleName"));
                e.setWardId(rs.getInt("WardId"));
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
        SELECT e.[EmployeeId], e.[UserName], e.[FirstName], e.[MiddleName], e.[LastName], 
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
                e.setMiddleName(rs.getString("MiddleName"));
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
        SELECT e.[EmployeeId], e.[UserName], e.[FirstName], e.[MiddleName], e.[LastName], 
               e.[Phone], e.[Email], e.[CCCD], e.[Status], e.[Avatar],
               e.[DoB], e.[Address], e.[StartAt], e.[Gender], 
               e.[RoleId], e.[StoreId], r.[RoleName], s.[StoreName]
        FROM [Employee] e
        LEFT JOIN [Role] r ON e.RoleId = r.RoleId
        LEFT JOIN [Store] s ON e.StoreId = s.StoreId
        WHERE 1=1
        """);

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (e.FirstName LIKE ? OR e.MiddleName LIKE ? OR e.LastName LIKE ? OR e.UserName LIKE ? OR e.Phone LIKE ? OR e.Email LIKE ?) ");
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
                e.setMiddleName(rs.getString("MiddleName"));
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

    public boolean addEmployee(String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status) {
        return addEmployee(username, firstName, middleName, lastName, phone, email, gender, status, 1, 1, "123456", "000000000000", java.sql.Date.valueOf("2000-01-01"), new java.sql.Date(System.currentTimeMillis()), "", null); // Default values with today's date and empty address
    }

    public boolean addEmployee(String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId) {
        return addEmployee(username, firstName, middleName, lastName, phone, email, gender, status, roleId, storeId, "123456", "000000000000", java.sql.Date.valueOf("2000-01-01"), new java.sql.Date(System.currentTimeMillis()), "", null); // Default values with today's date and empty address
    }

    public boolean addEmployee(String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password) {
        return addEmployee(username, firstName, middleName, lastName, phone, email, gender, status, roleId, storeId, password, "000000000000", java.sql.Date.valueOf("2000-01-01"), new java.sql.Date(System.currentTimeMillis()), "", null); // Default values with today's date and empty address
    }

    public boolean addEmployee(String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd) {
        return addEmployee(username, firstName, middleName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, java.sql.Date.valueOf("2000-01-01"), new java.sql.Date(System.currentTimeMillis()), "", null); // Default values with today's date and empty address
    }

    public boolean addEmployee(String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd, java.sql.Date dob) {
        return addEmployee(username, firstName, middleName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, dob, new java.sql.Date(System.currentTimeMillis()), "", null); // Today's date and empty address
    }

    public boolean addEmployee(String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd, java.sql.Date dob, java.sql.Date startAt) {
        return addEmployee(username, firstName, middleName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, dob, startAt, "", null); // Empty address
    }

    public boolean addEmployee(String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd, java.sql.Date dob, java.sql.Date startAt, String address) {
        return addEmployee(username, firstName, middleName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, dob, startAt, address, null); // Null avatar
    }

    public boolean addEmployee(String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status, int roleId, int storeId, String password, String cccd, java.sql.Date dob, java.sql.Date startAt, String address, String avatar) {
        String sql = """
             INSERT INTO Employee (UserName, FirstName, MiddleName, LastName, Phone, Email, Gender, Status, RoleId, StoreId, Password, CCCD, DoB, StartAt, Address, Avatar)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
             """;

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, firstName);
            ps.setString(3, middleName);
            ps.setString(4, lastName);
            ps.setString(5, phone);
            ps.setString(6, email);
            ps.setString(7, gender);
            ps.setString(8, status);
            ps.setInt(9, roleId);
            ps.setInt(10, storeId);
            ps.setString(11, password);
            ps.setString(12, cccd);
            ps.setDate(13, dob);
            ps.setDate(14, startAt);
            ps.setString(15, address);

            // Handle null avatar
            if (avatar == null) {
                ps.setNull(16, java.sql.Types.VARCHAR);
            } else {
                ps.setString(16, avatar);
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

    public boolean editEmployee(int employeeId, String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status) {
        return editEmployee(employeeId, username, firstName, middleName, lastName, phone, email, gender, status, null, null, null, null);
    }

    public boolean editEmployee(int employeeId, String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status, String cccd, java.sql.Date dob, String address, String avatar) {
        StringBuilder sql = new StringBuilder("""
            UPDATE Employee
            SET UserName = ?, 
                FirstName = ?, 
                MiddleName = ?,
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
        if (avatar != null) {
            sql.append(", Avatar = ?");
        }

        sql.append(" WHERE EmployeeId = ?");

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());

            int paramIndex = 1;
            ps.setString(paramIndex++, username);
            ps.setString(paramIndex++, firstName);
            ps.setString(paramIndex++, middleName);
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
            if (avatar != null) {
                ps.setString(paramIndex++, avatar);
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

    // For backward compatibility
    public boolean editEmployee(int employeeId, String username, String firstName, String lastName, String phone, String email, String gender, String status, String cccd, java.sql.Date dob, String address) {
        return editEmployee(employeeId, username, firstName, null, lastName, phone, email, gender, status, cccd, dob, address, null);
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
public String getEmployeeNameById(int id) {
        String sql = "SELECT CONCAT(LastName, ' ', MiddleName, ' ', FirstName) AS EmployeeName FROM Employee WHERE EmployeeId = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("EmployeeName");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
     public boolean editProfile(int employeeId, String username, String firstName, String middleName, String lastName, String phone, String email, String gender, String status, String cccd, java.sql.Date dob, String address, String avatar, int wardId) {
        StringBuilder sql = new StringBuilder("""
            UPDATE Employee
            SET UserName = ?, 
                FirstName = ?, 
                MiddleName = ?,
                LastName = ?, 
                Phone = ?, 
                Email = ?, 
                Gender = ?, 
                Status = ?,
                WardId = ?
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
        if (avatar != null) {
            sql.append(", Avatar = ?");
        }

        sql.append(" WHERE EmployeeId = ?");

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());

            int paramIndex = 1;
            ps.setString(paramIndex++, username);
            ps.setString(paramIndex++, firstName);
            ps.setString(paramIndex++, middleName);
            ps.setString(paramIndex++, lastName);
            ps.setString(paramIndex++, phone);
            ps.setString(paramIndex++, email);
            ps.setString(paramIndex++, gender);
            ps.setString(paramIndex++, status);
            ps.setInt(paramIndex++, wardId);

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
            if (avatar != null) {
                ps.setString(paramIndex++, avatar);
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
    
}
