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

    public Payments getPaymentByOrderId(int orderId) {
        String sql = "SELECT * FROM Payments WHERE OrderID = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Payments p = new Payments();
                p.setOrderID(rs.getInt("OrderID"));
                p.setPaymentID(rs.getInt("PaymentID"));
                p.setPaymentMethod(rs.getString("PaymentMethod"));
                p.setPaymentDate(rs.getDate("PaymentDate"));
                p.setPaymentStatus(rs.getString("PaymentStatus"));
                p.setPrice(rs.getString("Price"));
                p.setTransactionCode(rs.getString("TransactionCode"));
                return p;
            }
        } catch (Exception e) {
            throw new RuntimeException("getPaymentByOrderId() failed", e);
        }
        return null;
    }

    public void updatePayment(Payments payment) {
        String sql = "UPDATE Payments SET PaymentMethod = ?, Price = ?, PaymentDate = ?, PaymentStatus = ?, TransactionCode = ? WHERE OrderID = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, payment.getPaymentMethod());
            ps.setString(2, payment.getPrice());
            ps.setDate(3, new java.sql.Date(payment.getPaymentDate().getTime()));
            ps.setString(4, payment.getPaymentStatus());
            ps.setString(5, payment.getTransactionCode());
            ps.setInt(6, payment.getOrderID());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("updatePayment() failed", e);
        }
    }

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
        String sql = "SELECT PM.PaymentID, PM.OrderID, PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.Price, PM.TransactionCode " +
                     "FROM Payments PM " +
                     "JOIN [Order] O ON PM.OrderID = O.OrderId " +
                     "WHERE O.SaleBy = ?";
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
                p.setPrice(rs.getString("Price"));
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
        String sql = "SELECT PM.PaymentID, PM.OrderID, PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.Price, PM.TransactionCode " +
                     "FROM Payments PM " +
                     "JOIN [Order] O ON PM.OrderID = O.OrderID " + 
                     "WHERE O.SaleBy = ? AND PM.PaymentMethod = ?";
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
                p.setPrice(rs.getString("Price"));
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
        String sql = "SELECT PM.PaymentID, PM.OrderID, PM.PaymentMethod, PM.PaymentDate, PM.PaymentStatus, PM.Price, PM.TransactionCode " +
                     "FROM Payments PM " +
                     "JOIN [Order] O ON PM.OrderID = O.OrderID " +
                     "WHERE O.SaleBy = ? AND PM.PaymentStatus = ?";
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
                p.setPrice(rs.getString("Price"));
                p.setTransactionCode(rs.getString("TransactionCode"));
                listP.add(p);
            }
        } catch (Exception e) {
            throw new RuntimeException("getAllPaymentbySellerIdandStatus() failed", e);
        }
        return listP;
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

    

    public static void main(String[] args) {
        PaymentsDAO u = new PaymentsDAO();
      List<Payments> p = u.getAllPaymentbySellerId(5);
        for (Payments payments : p) {
            System.out.println(payments);
        }
    }
}