/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import model.Coupon;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author tayho
 */
public class CouponDAO {
    private final DBContext db = new DBContext();
    
    // Hàm để mapping, tránh lặp code
    private Coupon mapRow(ResultSet rs) throws SQLException {
        Coupon c = new Coupon();
        c.setCouponId(rs.getInt("CouponId"));
        c.setCouponCode(rs.getString("CouponCode"));
        c.setDiscountPercent(rs.getDouble("DiscountPercent"));
        c.setMaxDiscount(rs.getDouble("MaxDiscount"));
        c.setRequirement(rs.getString("Requirement"));
        c.setMinTotal(rs.getDouble("MinTotal"));
        c.setMinProduct(rs.getInt("MinProduct"));
        c.setApplyLimit(rs.getInt("ApplyLimit"));
        c.setFromDate(rs.getDate("FromDate"));
        c.setToDate(rs.getDate("ToDate"));
        c.setStatus(rs.getString("Status"));
        return c;
    }

    // Tìm 1 record coupon bằng ID
    public Coupon getById(int id) {
        String sql = """
            SELECT CouponId, CouponCode, DiscountPercent, MaxDiscount, Requirement,
                   MinTotal, MinProduct, ApplyLimit, FromDate, ToDate, Status
            FROM dbo.Coupon
            WHERE CouponId = ?
            """;
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // Tìm 1 record Coupon bằng coupon code
    public Coupon getByCode(String code) {
        String sql = """
            SELECT CouponId, CouponCode, DiscountPercent, MaxDiscount, Requirement,
                   MinTotal, MinProduct, ApplyLimit, FromDate, ToDate, Status
            FROM dbo.Coupon
            WHERE CouponCode = ?
            """;
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ---------- EXISTS / VALIDATION ----------
    
    // Kiểm tra lặp cho coupon code, ngoại trừ coupon code đang xử lý, vì nếu không nó sẽ bị đánh dấu là bị lặp
    public boolean codeExists(String code, Integer excludeCouponId) {
        String sql = "SELECT 1 FROM dbo.Coupon WHERE CouponCode = ?"
                   + (excludeCouponId != null ? " AND CouponId <> ?" : "");
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, code);
            if (excludeCouponId != null) ps.setInt(2, excludeCouponId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // be conservative on error
        }
    }
    // Thêm hàm validate ở dưới đây

    // ---------- INSERT / UPDATE ----------
    public boolean insert(Coupon c) {
        String sql = """
            INSERT INTO dbo.Coupon
              (CouponCode, DiscountPercent, MaxDiscount, Requirement,
               MinTotal, MinProduct, ApplyLimit, FromDate, ToDate, Status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int i = 1;
            ps.setString(i++, c.getCouponCode());
            ps.setDouble(i++, c.getDiscountPercent());
            ps.setDouble(i++, c.getMaxDiscount());
            ps.setString(i++, c.getRequirement());
            ps.setDouble(i++, c.getMinTotal());
            ps.setInt(i++, c.getMinProduct());
            ps.setInt(i++, c.getApplyLimit());
            ps.setDate(i++, c.getFromDate());
            ps.setDate(i++, c.getToDate());
            ps.setString(i++, c.getStatus());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) c.setCouponId(keys.getInt(1));
                }
            }
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Coupon c) {
        String sql = """
            UPDATE dbo.Coupon
            SET CouponCode = ?, DiscountPercent = ?, MaxDiscount = ?, Requirement = ?,
                MinTotal = ?, MinProduct = ?, ApplyLimit = ?, FromDate = ?, ToDate = ?, Status = ?
            WHERE CouponId = ?
            """;
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            int i = 1;
            ps.setString(i++, c.getCouponCode());
            ps.setDouble(i++, c.getDiscountPercent());
            ps.setDouble(i++, c.getMaxDiscount());
            ps.setString(i++, c.getRequirement());
            ps.setDouble(i++, c.getMinTotal());
            ps.setInt(i++, c.getMinProduct());
            ps.setInt(i++, c.getApplyLimit());
            ps.setDate(i++, c.getFromDate());
            ps.setDate(i++, c.getToDate());
            ps.setString(i++, c.getStatus());
            ps.setInt(i, c.getCouponId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Soft-status helper (e.g., "Active"/"Deactivate")
    public boolean updateStatus(int couponId, String status) {
        String sql = "UPDATE dbo.Coupon SET Status = ? WHERE CouponId = ?";
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Optional hard delete (use only if you really need it)
    public boolean delete(int couponId) {
        String sql = "DELETE FROM dbo.Coupon WHERE CouponId = ?";
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // FK constraints might block this; prefer updateStatus instead.
            e.printStackTrace();
            return false;
        }
    }

    // ---------- LIST + PAGINATION ----------
    /**
     * Paginated list with optional search (by code or requirement), status filter,
     * and sorting. Sort by any column in the whitelist.
     */
    public List<Coupon> list(int pageIndex, int pageSize,
                             String search, String status,
                             String sortBy, String sortDir) {
        // Whitelist sortable columns to avoid SQL injection in ORDER BY
        String sortColumn = switch (sortBy == null ? "" : sortBy) {
            case "couponCode" -> "CouponCode";
            case "discountPercent" -> "DiscountPercent";
            case "maxDiscount" -> "MaxDiscount";
            case "minTotal" -> "MinTotal";
            case "fromDate" -> "FromDate";
            case "toDate" -> "ToDate";
            case "status" -> "Status";
            default -> "CouponId";
        };
        String direction = "DESC".equalsIgnoreCase(sortDir) ? "DESC" : "ASC";

        StringBuilder sql = new StringBuilder("""
            SELECT CouponId, CouponCode, DiscountPercent, MaxDiscount, Requirement,
                   MinTotal, MinProduct, ApplyLimit, FromDate, ToDate, Status
            FROM dbo.Coupon
            WHERE 1=1
            """);

        List<Object> params = new ArrayList<>();
        if (search != null && !search.isBlank()) {
            sql.append(" AND (CouponCode LIKE ? OR Requirement LIKE ?)");
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND Status = ?");
            params.add(status.trim());
        }

        sql.append(" ORDER BY ").append(sortColumn).append(" ").append(direction)
           .append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        params.add(Math.max(0, (pageIndex - 1) * pageSize));
        params.add(pageSize);

        List<Coupon> list = new ArrayList<>();
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object v = params.get(i);
                if (v instanceof Integer) ps.setInt(i + 1, (Integer) v);
                else if (v instanceof Double) ps.setDouble(i + 1, (Double) v);
                else ps.setString(i + 1, v.toString());
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    
    public int count(String search, String status) {
        // Dynamic SQL bằng WHERE 1=1
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM dbo.Coupon WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.isBlank()) {
            sql.append(" AND (CouponCode LIKE ? OR Requirement LIKE ?)");
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND Status = ?");
            params.add(status.trim());
        }

        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object v = params.get(i);
                if (v instanceof Integer) ps.setInt(i + 1, (Integer) v);
                else ps.setString(i + 1, v.toString());
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    
    // ---------- CONVENIENCE ----------
    // Giảm số lần áp dụng còn lại của coupon
    public boolean decrementApplyLimit(int couponId) {
        String sql = "UPDATE dbo.Coupon SET ApplyLimit = ApplyLimit - 1 WHERE CouponId = ? AND ApplyLimit > 0";
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Hàm tìm kiếm tùy theo yêu cầu
    // Hàm tìm kiếm các coupon còn hoạt động
    public List<Coupon> getAllActive() {
        String sql = """
            SELECT CouponId, CouponCode, DiscountPercent, MaxDiscount, Requirement,
                   MinTotal, MinProduct, ApplyLimit, FromDate, ToDate, Status
            FROM dbo.Coupon
            WHERE Status = 'Active'
            ORDER BY FromDate DESC
            """;
        List<Coupon> list = new ArrayList<>();
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public static void main(String[] args) {
    CouponDAO dao = new CouponDAO();

    // Mã coupon cần test (đảm bảo có trong DB)
    String testCode = "BACK2SCHOOL"; // ví dụ

    Coupon coupon = dao.getByCode(testCode);

    if (coupon != null) {
        System.out.println("✅ Tìm thấy coupon:");
        System.out.println("ID: " + coupon.getCouponId());
        System.out.println("Code: " + coupon.getCouponCode());
        System.out.println("Discount Percent: " + coupon.getDiscountPercent());
        System.out.println("Max Discount: " + coupon.getMaxDiscount());
        System.out.println("Requirement: " + coupon.getRequirement());
        System.out.println("Min Total: " + coupon.getMinTotal());
        System.out.println("Min Product: " + coupon.getMinProduct());
        System.out.println("Apply Limit: " + coupon.getApplyLimit());
        System.out.println("From Date: " + coupon.getFromDate());
        System.out.println("To Date: " + coupon.getToDate());
        System.out.println("Status: " + coupon.getStatus());
    } else {
        System.out.println("❌ Không tìm thấy coupon với code: " + testCode);
    }
}

}
