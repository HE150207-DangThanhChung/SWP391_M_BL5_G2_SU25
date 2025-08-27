package dal;

import model.OrderCoupon;
import model.Order;
import model.Coupon;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderCouponDAO {
    private final DBContext db = new DBContext();
    private OrderCoupon mapRow(ResultSet rs) throws SQLException {
        OrderCoupon oc = new OrderCoupon();
        oc.setOrderId(rs.getInt("OrderId"));
        oc.setCouponId(rs.getInt("CouponId"));
        oc.setAppliedAt(rs.getTimestamp("AppliedAt"));
        oc.setAppliedAmount(rs.getDouble("AppliedAmount"));
        return oc;
    }

    // Insert a new OrderCoupon record
    public boolean insert(OrderCoupon oc) {
        String sql = """
            INSERT INTO dbo.OrderCoupon (OrderId, CouponId, AppliedAmount)
            VALUES (?, ?, ?)
            """;
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, oc.getOrderId());
            ps.setInt(2, oc.getCouponId());
            ps.setDouble(3, oc.getAppliedAmount());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get OrderCoupon by Order ID and Coupon ID
    public OrderCoupon getByIds(int orderId, int couponId) {
        String sql = """
            SELECT OrderId, CouponId, AppliedAt, AppliedAmount
            FROM dbo.OrderCoupon
            WHERE OrderId = ? AND CouponId = ?
            """;
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, couponId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // Get all coupons applied to an order
    public List<OrderCoupon> getByOrderId(int orderId) {
        String sql = """
            SELECT OrderId, CouponId, AppliedAt, AppliedAmount
            FROM dbo.OrderCoupon
            WHERE OrderId = ?
            """;
        List<OrderCoupon> list = new ArrayList<>();
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
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

    // Get all orders that used a specific coupon
    public List<OrderCoupon> getByCouponId(int couponId) {
        String sql = """
            SELECT OrderId, CouponId, AppliedAt, AppliedAmount
            FROM dbo.OrderCoupon
            WHERE CouponId = ?
            """;
        List<OrderCoupon> list = new ArrayList<>();
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
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

    // Update applied amount
    public boolean updateAppliedAmount(int orderId, int couponId, double amount) {
        String sql = """
            UPDATE dbo.OrderCoupon
            SET AppliedAmount = ?
            WHERE OrderId = ? AND CouponId = ?
            """;
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setDouble(1, amount);
            ps.setInt(2, orderId);
            ps.setInt(3, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a specific OrderCoupon record
    public boolean delete(int orderId, int couponId) {
        String sql = """
            DELETE FROM dbo.OrderCoupon
            WHERE OrderId = ? AND CouponId = ?
            """;
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Count how many times a coupon has been used
    public int getCouponUsageCount(int couponId) {
        String sql = "SELECT COUNT(*) FROM dbo.OrderCoupon WHERE CouponId = ?";
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Get total amount saved by a specific coupon
    public double getTotalAmountSaved(int couponId) {
        String sql = "SELECT SUM(AppliedAmount) FROM dbo.OrderCoupon WHERE CouponId = ?";
        try (Connection cn = db.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    public static void main(String[] args) {
    OrderCouponDAO dao = new OrderCouponDAO();

    }

}
