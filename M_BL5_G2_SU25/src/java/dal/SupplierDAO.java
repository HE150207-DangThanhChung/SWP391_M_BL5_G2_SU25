/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import model.Supplier;

/**
 *
 * @author tayho
 */
public class SupplierDAO {

    private static Connection con;
    private static PreparedStatement ps;
    private static ResultSet rs;

    public static void main(String[] args) {
        SupplierDAO supDao = new SupplierDAO();
//        System.out.println(supDao.GetAllSupplierWithPagingAndFilter("", null, 0, 10));
        System.out.println(supDao.getSupplierById(1));
    }

    public Supplier getSupplierById(int id){
        Supplier s = new Supplier();

        StringBuilder sql = new StringBuilder("""
        SELECT [SupplierId],
               [SupplierName],
               [Phone],
               [Email],
               [TaxCode],
               [Status]
        FROM [SWP391_M_BL5_G2_SU25].[dbo].[Supplier]
        WHERE SupplierId = ?
    """);

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());

            ps.setInt(1, id);

            rs = ps.executeQuery();

            while (rs.next()) {
                s.setSupplierId(rs.getInt("SupplierId"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setEmail(rs.getString("Email"));
                s.setPhone(rs.getString("Phone"));
                s.setTaxCode(rs.getString("TaxCode"));
                s.setStatus(rs.getString("Status"));
            }

        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }

        return s;
    }
    
    public boolean addSupplier(String name, String phone, String email, String taxCode, String status) {
        String sql = """
                 INSERT INTO Supplier (SupplierName, Phone, Email, TaxCode, Status)
                 VALUES (?, ?, ?, ?, ?)
                 """;

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, taxCode);
            ps.setString(5, status);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e);
        } finally {
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignored) {
            }
            DBContext.closeConnection(con);
        }

        return false;
    }

    public List<Supplier> GetAllSupplierWithPagingAndFilter(String searchKey, String status, int offset, int limit) {
        List<Supplier> supList = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT [SupplierId],
               [SupplierName],
               [Phone],
               [Email],
               [TaxCode],
               [Status]
        FROM [SWP391_M_BL5_G2_SU25].[dbo].[Supplier]
        WHERE 1=1
    """);

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (SupplierName LIKE ? OR Phone LIKE ? OR Email LIKE ? OR TaxCode LIKE ?) ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ? ");
        }

        sql.append(" ORDER BY SupplierId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

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
            }

            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }

            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, limit);

            rs = ps.executeQuery();

            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierId(rs.getInt("SupplierId"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setEmail(rs.getString("Email"));
                s.setPhone(rs.getString("Phone"));
                s.setTaxCode(rs.getString("TaxCode"));
                s.setStatus(rs.getString("Status"));
                supList.add(s);
            }

        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }

        return supList;
    }

    public int countSuppliersWithFilter(String searchKey, String status) {
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*) AS total
        FROM [SWP391_M_BL5_G2_SU25].[dbo].[Supplier]
        WHERE 1=1
    """);

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (SupplierName LIKE ? OR Phone LIKE ? OR Email LIKE ? OR TaxCode LIKE ?) ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ? ");
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int total = 0;

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (searchKey != null && !searchKey.trim().isEmpty()) {
                String pattern = "%" + searchKey.trim() + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
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
            if (rs != null) try {
                rs.close();
            } catch (SQLException ignored) {
            }
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignored) {
            }
            DBContext.closeConnection(con);
        }

        return total;
    }

    public boolean isPhoneExisted(String phone) {
        return isFieldValueExisted("Phone", phone);
    }

    public boolean isNameExisted(String name) {
        return isFieldValueExisted("Name", name);
    }

    public boolean isEmailExisted(String email) {
        return isFieldValueExisted("Email", email);
    }

    public boolean isTaxCodeExisted(String taxCode) {
        return isFieldValueExisted("TaxCode", taxCode);
    }

    private boolean isFieldValueExisted(String columnName, String value) {
        String sql = "SELECT 1 FROM Supplier WHERE " + columnName + " = ?";

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, value);

            rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException ignored) {
            }
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignored) {
            }
            DBContext.closeConnection(con);
        }

        return false;
    }

}
