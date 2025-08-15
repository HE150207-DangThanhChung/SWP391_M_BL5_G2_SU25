
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Store;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Role;

public class StoreDAO {

    private static Connection con;
    private static PreparedStatement ps;
    private static ResultSet rs;

    public static void main(String[] args) {
        StoreDAO sDao = new StoreDAO();
        System.out.println(sDao.getStoreById(1));
    }
    
    public List<Store> findAll() {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT StoreId, StoreName, Address, Phone, Status FROM Store ORDER BY StoreId";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Store s = new Store();
                s.setStoreId(rs.getInt("StoreId"));
                s.setStoreName(rs.getString("StoreName"));
                s.setAddress(rs.getString("Address"));
                s.setPhone(rs.getString("Phone"));
                s.setStatus(rs.getString("Status"));
                list.add(s);
            }
        } catch (Exception e) { // rộng hơn SQLException
            throw new RuntimeException("findAll() failed", e);
        }
        return list;
    }

    public Store getStoreById(int id) {
        Store s = new Store();
        String sql = """
            SELECT *
            FROM [SWP391_M_BL5_G2_SU25].[dbo].[Store]
            WHERE StoreId = ?
        """;

        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                s.setStoreId(rs.getInt("StoreId"));
                s.setStoreName(rs.getString("StoreName"));
                s.setAddress(rs.getString("Address"));
                s.setPhone(rs.getString("Phone"));
                s.setStatus(rs.getString("Status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(rs);
            DBContext.closeConnection(ps);
            DBContext.closeConnection(con);
        }
        return s;
    }
}
