/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbformat/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Payments;
import java.sql.*;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class PaymentsDAO {

    public List<Payments> getAllPayment() {
        List<Payments> listP = new ArrayList<>();
        String sql = "SELECT * FROM Payments";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payments p = new Payments();
                p.setOrderID(rs.getInt("OrderID"));
                p.setPaymentID(rs.getInt("PaymentID"));
                p.setPaymentMethod(rs.getString("PaymentMethod"));
                p.setPaymentDate(rs.getDate("PaymentDate"));
                p.setPaymentStatus(rs.getString("PaymentStatus"));
                p.setPrice(rs.getString("Price"));
                p.setTransactionCode(rs.getString("TransactionCode"));
                listP.add(p);
            }
        } catch (Exception e) {
            throw new RuntimeException("getAllPayment() failed", e);
        }
        return listP;
    }

    public List<Payments> getAllPaymentbySellerId(int sid) {
        List<Payments> listP = new ArrayList<>();
        String sql = "SELECT PM.PaymentID, PM.OrderID, " +
                     "FORMAT(SUM(OD.Quantity * CAST(REPLACE(OD.Price, '.', '') AS DECIMAL(18, 2))), 'N0', 'vi-VN') AS TotalAmount, " +
                     "PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.TransactionCode " +
                     "FROM Payments PM " +
                     "JOIN Orders O ON PM.OrderID = O.OrderID " +
                     "JOIN OrderDetails OD ON O.OrderID = OD.OrderID " +
                     "JOIN Products P ON OD.ProductID = P.ProductID " +
                     "WHERE P.SellerID = ? " +
                     "GROUP BY PM.PaymentID, PM.OrderID, PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.TransactionCode";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payments p = new Payments();
                p.setPaymentID(rs.getInt("PaymentID"));
                p.setOrderID(rs.getInt("OrderID"));
                p.setPaymentMethod(rs.getString("PaymentMethod"));
                p.setPaymentDate(rs.getDate("PaymentDate"));
                p.setPaymentStatus(rs.getString("PaymentStatus"));
                p.setPrice(rs.getString("TotalAmount"));
                p.setTransactionCode(rs.getString("TransactionCode"));
                listP.add(p);
            }
        } catch (Exception e) {
            throw new RuntimeException("getAllPaymentbySellerId() failed", e);
        }
        return listP;
    }

    public List<Payments> getAllPaymentbySellerIdandMethod(int sid, String method) {
        List<Payments> listP = new ArrayList<>();
        String sql = "SELECT PM.PaymentID, PM.OrderID, " +
                     "FORMAT(SUM(OD.Quantity * CAST(REPLACE(OD.Price, '.', '') AS DECIMAL(18, 2))), 'N0', 'vi-VN') AS TotalAmount, " +
                     "PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.TransactionCode " +
                     "FROM Payments PM " +
                     "JOIN Orders O ON PM.OrderID = O.OrderID " +
                     "JOIN OrderDetails OD ON O.OrderID = OD.OrderID " +
                     "JOIN Products P ON OD.ProductID = P.ProductID " +
                     "WHERE P.SellerID = ? AND PM.PaymentMethod = ? " +
                     "GROUP BY PM.PaymentID, PM.OrderID, PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.TransactionCode";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sid);
            ps.setString(2, method);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payments p = new Payments();
                p.setPaymentID(rs.getInt("PaymentID"));
                p.setOrderID(rs.getInt("OrderID"));
                p.setPaymentMethod(rs.getString("PaymentMethod"));
                p.setPaymentDate(rs.getDate("PaymentDate"));
                p.setPaymentStatus(rs.getString("PaymentStatus"));
                p.setPrice(rs.getString("TotalAmount"));
                p.setTransactionCode(rs.getString("TransactionCode"));
                listP.add(p);
            }
        } catch (Exception e) {
            throw new RuntimeException("getAllPaymentbySellerIdandMethod() failed", e);
        }
        return listP;
    }

    public List<Payments> getAllPaymentbySellerIdandStatus(int sid, String status) {
        List<Payments> listP = new ArrayList<>();
        String sql = "SELECT PM.PaymentID, PM.OrderID, " +
                     "FORMAT(SUM(OD.Quantity * CAST(REPLACE(OD.Price, '.', '') AS DECIMAL(18, 2))), 'N0', 'vi-VN') AS TotalAmount, " +
                     "PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.TransactionCode " +
                     "FROM Payments PM " +
                     "JOIN Orders O ON PM.OrderID = O.OrderID " +
                     "JOIN OrderDetails OD ON O.OrderID = OD.OrderID " +
                     "JOIN Products P ON OD.ProductID = P.ProductID " +
                     "WHERE P.SellerID = ? AND PM.PaymentStatus = ? " +
                     "GROUP BY PM.PaymentID, PM.OrderID, PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.TransactionCode";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sid);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payments p = new Payments();
                p.setPaymentID(rs.getInt("PaymentID"));
                p.setOrderID(rs.getInt("OrderID"));
                p.setPaymentMethod(rs.getString("PaymentMethod"));
                p.setPaymentDate(rs.getDate("PaymentDate"));
                p.setPaymentStatus(rs.getString("PaymentStatus"));
                p.setPrice(rs.getString("TotalAmount"));
                p.setTransactionCode(rs.getString("TransactionCode"));
                listP.add(p);
            }
        } catch (Exception e) {
            throw new RuntimeException("getAllPaymentbySellerIdandStatus() failed", e);
        }
        return listP;
    }

    public List<Payments> getAllPaymentbySellerIdandName(int sid, String name) {
        List<Payments> listP = new ArrayList<>();
        String sql = "SELECT PM.PaymentID, PM.OrderID, " +
                     "FORMAT(SUM(OD.Quantity * CAST(REPLACE(OD.Price, '.', '') AS DECIMAL(18, 2))), 'N0', 'vi-VN') AS TotalAmount, " +
                     "PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.TransactionCode " +
                     "FROM Payments PM " +
                     "JOIN Orders O ON PM.OrderID = O.OrderID " +
                     "JOIN OrderDetails OD ON O.OrderID = OD.OrderID " +
                     "JOIN Products P ON OD.ProductID = P.ProductID " +
                     "JOIN Users U ON O.CustomerID = U.UserID " +
                     "WHERE P.SellerID = ? AND CONCAT(U.FirstName, ' ', U.LastName) LIKE ? " +
                     "GROUP BY PM.PaymentID, PM.OrderID, PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.TransactionCode";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sid);
            ps.setString(2, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payments p = new Payments();
                p.setPaymentID(rs.getInt("PaymentID"));
                p.setOrderID(rs.getInt("OrderID"));
                p.setPaymentMethod(rs.getString("PaymentMethod"));
                p.setPaymentDate(rs.getDate("PaymentDate"));
                p.setPaymentStatus(rs.getString("PaymentStatus"));
                p.setPrice(rs.getString("TotalAmount"));
                p.setTransactionCode(rs.getString("TransactionCode"));
                listP.add(p);
            }
        } catch (Exception e) {
            throw new RuntimeException("getAllPaymentbySellerIdandName() failed", e);
        }
        return listP;
    }

    public boolean deletePayment(int paymentID) {
        String sql = "DELETE FROM Payments WHERE PaymentID = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, paymentID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            throw new RuntimeException("deletePayment() failed", e);
        }
    }

    public List<Payments> getAllPaymentStatus() {
        List<Payments> listP = new ArrayList<>();
        String sql = "SELECT DISTINCT PaymentStatus FROM Payments";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payments p = new Payments();
                p.setPaymentStatus(rs.getString("PaymentStatus"));
                listP.add(p);
            }
        } catch (Exception e) {
            throw new RuntimeException("getAllPaymentStatus() failed", e);
        }
        return listP;
    }

    public List<Payments> getAllPaymentMethod() {
        List<Payments> listP = new ArrayList<>();
        String sql = "SELECT DISTINCT PaymentMethod FROM Payments";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payments p = new Payments();
                p.setPaymentMethod(rs.getString("PaymentMethod"));
                listP.add(p);
            }
        } catch (Exception e) {
            throw new RuntimeException("getAllPaymentMethod() failed", e);
        }
        return listP;
    }

    public boolean updatePaymentStatusByOrder(int oid, String status) {
        String sql = "UPDATE Payments SET PaymentStatus = ? WHERE OrderID = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, oid);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            throw new RuntimeException("updatePaymentStatusByOrder() failed", e);
        }
    }

    public List<Payments> getPaymentsWithCriteria(String search, String status, String sort, int offset, int limit) {
        List<Payments> payments = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.* FROM Payments p JOIN Orders o ON p.OrderID = o.OrderID JOIN Users u ON o.CustomerID = u.UserID WHERE 1=1");
        if (search != null && !search.isEmpty()) {
            sql.append(" AND u.Email LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND p.PaymentStatus = ?");
        }
        if (sort != null && !sort.isEmpty()) {
            sql.append(" ORDER BY ").append(sort);
        } else {
            sql.append(" ORDER BY p.PaymentID");
        }
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payments p = new Payments();
                p.setOrderID(rs.getInt("OrderID"));
                p.setPaymentID(rs.getInt("PaymentID"));
                p.setPaymentMethod(rs.getString("PaymentMethod"));
                p.setPaymentDate(rs.getDate("PaymentDate"));
                p.setPaymentStatus(rs.getString("PaymentStatus"));
                p.setPrice(rs.getString("Price"));
                p.setTransactionCode(rs.getString("TransactionCode"));
                payments.add(p);
            }
        } catch (Exception e) {
            throw new RuntimeException("getPaymentsWithCriteria() failed", e);
        }
        return payments;
    }

    public int getTotalPaymentsCount(String search, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS count FROM Payments WHERE 1=1");
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (PaymentMethod LIKE ? OR PaymentStatus LIKE ?)");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND PaymentStatus = ?");
        }
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (Exception e) {
            throw new RuntimeException("getTotalPaymentsCount() failed", e);
        }
        return 0;
    }

    public int countPaidStatus() {
        String sql = "SELECT COUNT(*) AS count FROM Payments WHERE PaymentStatus = N'Đã thanh toán'";
        return getCount(sql);
    }

    public int countProcessingStatus() {
        String sql = "SELECT COUNT(*) AS count FROM Payments WHERE PaymentStatus = N'Đang xử lý'";
        return getCount(sql);
    }

    public int countCanceledStatus() {
        String sql = "SELECT COUNT(*) AS count FROM Payments WHERE PaymentStatus = N'Đã bị hủy'";
        return getCount(sql);
    }

    private int getCount(String sql) {
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (Exception e) {
            throw new RuntimeException("getCount() failed", e);
        }
        return 0;
    }

    public void savePayment(Payments payment) {
        String sql = "INSERT INTO Payments (OrderID, PaymentMethod, Price, PaymentDate, PaymentStatus, TransactionCode) VALUES (?, ?, ?, GETDATE(), ?, ?)";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, payment.getOrderID());
            ps.setString(2, payment.getPaymentMethod());
            ps.setString(3, payment.getPrice());
            ps.setString(4, payment.getPaymentStatus());
            ps.setString(5, payment.getTransactionCode());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("savePayment() failed", e);
        }
    }

    public Map<String, Integer> getMonthlyRevenue() {
        Map<String, Integer> revenueMap = new HashMap<>();
        String sql = "SELECT YEAR(PaymentDate) AS Year, MONTH(PaymentDate) AS Month, " +
                     "SUM(CAST(REPLACE(Price, '.', '') AS INT)) AS TotalRevenue " +
                     "FROM Payments " +
                     "GROUP BY YEAR(PaymentDate), MONTH(PaymentDate) " +
                     "ORDER BY Year, Month";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String yearMonth = rs.getInt("Year") + "-" + rs.getInt("Month");
                int revenue = rs.getInt("TotalRevenue");
                revenueMap.put(yearMonth, revenue);
            }
        } catch (Exception e) {
            throw new RuntimeException("getMonthlyRevenue() failed", e);
        }
        return revenueMap;
    }

    public static void main(String[] args) {
        PaymentsDAO u = new PaymentsDAO();
        Map<String, Integer> monthlyRevenue = u.getMonthlyRevenue();
        for (Map.Entry<String, Integer> entry : monthlyRevenue.entrySet()) {
            System.out.println("Year-Month: " + entry.getKey() + ", Revenue: " + entry.getValue());
        }
    }
}