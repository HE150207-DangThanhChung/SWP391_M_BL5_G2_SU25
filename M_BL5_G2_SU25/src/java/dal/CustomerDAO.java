/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author tayho
 */
public class CustomerDAO {
// ---------- Row mapper ----------

    private Customer mapRow(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setCustomerId(rs.getInt("CustomerId"));
        c.setFirstName(rs.getString("FirstName"));
        c.setMiddleName(rs.getString("MiddleName"));     // may be null
        c.setLastName(rs.getString("LastName"));
        c.setPhone(rs.getString("Phone"));
        c.setEmail(rs.getString("Email"));
        c.setGender(rs.getString("Gender"));
        c.setAddress(rs.getString("Address"));
        c.setStatus(rs.getString("Status"));
        c.setTaxCode(rs.getString("TaxCode"));           // may be null

        int ward = rs.getInt("WardId");
        c.setWardId(rs.wasNull() ? null : ward);

        c.setDob(rs.getDate("DoB"));                     // java.sql.Date (nullable)

        // Joined display fields (present in list/getById)
        try {
            c.setWardName(rs.getString("WardName"));
        } catch (SQLException ignore) {
        }
        try {
            c.setCityName(rs.getString("CityName"));
        } catch (SQLException ignore) {
        }

        return c;
    }

    // ---------- Single item ----------
    public Customer getById(int id) {
        String sql = """
            SELECT c.CustomerId, c.FirstName, c.MiddleName, c.LastName, c.Phone, c.Email,
                   c.Gender, c.Address, c.Status, c.TaxCode, c.WardId, c.DoB,
                   w.WardName, ci.CityName
            FROM dbo.Customer c
            LEFT JOIN dbo.Ward w  ON c.WardId = w.WardId
            LEFT JOIN dbo.City ci ON w.CityId = ci.CityId
            WHERE c.CustomerId = ?
            """;
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ---------- Exists / validation ----------
    public boolean emailExists(String email, Integer excludeCustomerId) {
        String sql = "SELECT 1 FROM dbo.Customer WHERE Email = ?"
                + (excludeCustomerId != null ? " AND CustomerId <> ?" : "");
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, email);
            if (excludeCustomerId != null) {
                ps.setInt(2, excludeCustomerId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // conservative on error
        }
    }

    public boolean phoneExists(String phone, Integer excludeCustomerId) {
        String sql = "SELECT 1 FROM dbo.Customer WHERE Phone = ?"
                + (excludeCustomerId != null ? " AND CustomerId <> ?" : "");
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, phone);
            if (excludeCustomerId != null) {
                ps.setInt(2, excludeCustomerId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    // ---------- Insert / Update ----------
    public boolean insert(Customer x) {
        String sql = """
            INSERT INTO dbo.Customer
              (FirstName, MiddleName, LastName, Phone, Email, Gender,
               Address, Status, TaxCode, WardId, DoB)
            VALUES (?,?,?,?,?,?,?,?,?,?,?)
            """;
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int i = 1;
            ps.setString(i++, x.getFirstName());
            ps.setString(i++, x.getMiddleName());            // nullable
            ps.setString(i++, x.getLastName());
            ps.setString(i++, x.getPhone());
            ps.setString(i++, x.getEmail());
            ps.setString(i++, x.getGender());
            ps.setString(i++, x.getAddress());
            ps.setString(i++, x.getStatus());
            ps.setString(i++, x.getTaxCode());               // nullable
            if (x.getWardId() == null) {
                ps.setNull(i++, Types.INTEGER);
            } else {
                ps.setInt(i++, x.getWardId());
            }
            if (x.getDob() == null) {
                ps.setNull(i++, Types.DATE);
            } else {
                ps.setDate(i++, x.getDob());
            }

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        x.setCustomerId(keys.getInt(1));
                    }
                }
            }
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Customer x) {
        String sql = """
            UPDATE dbo.Customer
            SET FirstName=?, MiddleName=?, LastName=?, Phone=?, Email=?, Gender=?,
                Address=?, Status=?, TaxCode=?, WardId=?, DoB=?
            WHERE CustomerId=?
            """;
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            int i = 1;
            ps.setString(i++, x.getFirstName());
            ps.setString(i++, x.getMiddleName());            // nullable
            ps.setString(i++, x.getLastName());
            ps.setString(i++, x.getPhone());
            ps.setString(i++, x.getEmail());
            ps.setString(i++, x.getGender());
            ps.setString(i++, x.getAddress());
            ps.setString(i++, x.getStatus());
            ps.setString(i++, x.getTaxCode());               // nullable
            if (x.getWardId() == null) {
                ps.setNull(i++, Types.INTEGER);
            } else {
                ps.setInt(i++, x.getWardId());
            }
            if (x.getDob() == null) {
                ps.setNull(i++, Types.DATE);
            } else {
                ps.setDate(i++, x.getDob());
            }
            ps.setInt(i, x.getCustomerId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ---------- List + Pagination ----------
    /**
     * Paginated list with optional search (name/email/phone), status filter,
     * and sorting. sortBy whitelist: id | name | email | phone | status | dob
     */
    public List<Customer> list(int pageIndex, int pageSize,
            String search, String status,
            String sortBy, String sortDir) {

        String sortColumn = switch (sortBy == null ? "" : sortBy) {
            case "name" ->
                "c.LastName";
            case "email" ->
                "c.Email";
            case "phone" ->
                "c.Phone";
            case "status" ->
                "c.Status";
            case "dob" ->
                "c.DoB";
            default ->
                "c.CustomerId";
        };
        String direction = "DESC".equalsIgnoreCase(sortDir) ? "DESC" : "ASC";

        StringBuilder sql = new StringBuilder("""
            SELECT c.CustomerId, c.FirstName, c.MiddleName, c.LastName, c.Phone, c.Email,
                   c.Gender, c.Address, c.Status, c.TaxCode, c.WardId, c.DoB,
                   w.WardName, ci.CityName
            FROM dbo.Customer c
            LEFT JOIN dbo.Ward w  ON c.WardId = w.WardId
            LEFT JOIN dbo.City ci ON w.CityId = ci.CityId
            WHERE 1=1
            """);

        List<Object> params = new ArrayList<>();
        if (search != null && !search.isBlank()) {
            String kw = "%" + search.trim() + "%";
            sql.append("""
                AND (
                    c.FirstName LIKE ? OR c.MiddleName LIKE ? OR c.LastName LIKE ?
                    OR c.Email LIKE ? OR c.Phone LIKE ?
                )
                """);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND c.Status = ?");
            params.add(status.trim());
        }

        sql.append(" ORDER BY ").append(sortColumn).append(" ").append(direction)
                .append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        int offset = Math.max(0, (pageIndex - 1) * pageSize);
        params.add(offset);
        params.add(pageSize);

        List<Customer> list = new ArrayList<>();
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            // Bind parameters
            int idx = 1;
            for (Object p : params) {
                if (p instanceof Integer) {
                    ps.setInt(idx++, (Integer) p);
                } else {
                    ps.setString(idx++, p.toString());
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    

    // Soft-status helper (e.g., "Active" / "Banned")
    public boolean updateStatus(int customerId, String status) {
        String sql = "UPDATE dbo.Customer SET Status = ? WHERE CustomerId = ?";
        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int count(String search, String status) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM dbo.Customer c
            WHERE 1=1
            """);
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            String kw = "%" + search.trim() + "%";
            sql.append("""
                AND (
                    c.FirstName LIKE ? OR c.MiddleName LIKE ? OR c.LastName LIKE ?
                    OR c.Email LIKE ? OR c.Phone LIKE ?
                )
                """);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND c.Status = ?");
            params.add(status.trim());
        }

        try (Connection cn = DBContext.getConnection(); PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object p : params) {
                if (p instanceof Integer) {
                    ps.setInt(idx++, (Integer) p);
                } else {
                    ps.setString(idx++, p.toString());
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}
