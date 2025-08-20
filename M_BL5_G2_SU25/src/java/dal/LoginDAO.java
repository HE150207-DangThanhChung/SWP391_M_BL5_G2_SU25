/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Employee;

import java.sql.*;

/**
 *
 * @author tayho
 */
public class LoginDAO {

    private final DBContext db = new DBContext();

    public boolean checkLogin(String username, String password) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            return false;
        }
        String sql = """
            SELECT 1
            FROM Employee
            WHERE UserName = ? AND Password = ? AND Status = 'Active'
            """;
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username == null ? null : username.trim());
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Employee getProfile(String username) {
        if (username == null || username.isBlank()) {
            return null;
        }
        String sql = """
            SELECT e.EmployeeId, e.UserName, e.FirstName, e.MiddleName, e.LastName,
                   e.Phone, e.Email, e.CCCD, e.Status, e.Avatar, e.DoB, e.Address,
                   e.StartAt, e.Gender, e.RoleId, e.StoreId, e.WardId,
                   r.RoleName AS RoleName, s.StoreName AS StoreName
                    , w.WardName AS WardName   
            FROM Employee e
            JOIN Role  r ON e.RoleId  = r.RoleId
            JOIN Store s ON e.StoreId = s.StoreId
            LEFT JOIN Ward w ON e.WardId = w.WardId
            WHERE e.UserName = ? AND e.Status = 'Active'
            """;
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username == null ? null : username.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

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
                Date dob = rs.getDate("DoB");
                if (dob != null) {
                    e.setDob(new java.util.Date(dob.getTime()));
                }
                e.setAddress(rs.getString("Address"));
                Date startAt = rs.getDate("StartAt");
                if (startAt != null) {
                    e.setStartAt(new java.util.Date(startAt.getTime()));
                }
                e.setGender(rs.getString("Gender"));
                e.setRoleId(rs.getInt("RoleId"));
                e.setStoreId(rs.getInt("StoreId"));
                int wardRaw = rs.getInt("WardId");
                e.setWardId(rs.wasNull() ? null : wardRaw);
                e.setRoleName(rs.getString("RoleName"));
                e.setStoreName(rs.getString("StoreName"));

                e.setWardName(rs.getString("WardName"));
                return e;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }
    // 4.1 Check if email exists and is Active

    public boolean existsEmailActive(String email) {
        String sql = """
        SELECT 1
        FROM Employee
        WHERE Email = ? AND Status = 'Active'
        """;
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email == null ? null : email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4.2 Update password by email (plaintext for now)
    public boolean updatePasswordByEmail(String email, String newPassword) {
        String sql = """
        UPDATE Employee
        SET Password = ?
        WHERE Email = ? AND Status = 'Active'
        """;
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newPassword); // later: set hash
            ps.setString(2, email == null ? null : email.trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
