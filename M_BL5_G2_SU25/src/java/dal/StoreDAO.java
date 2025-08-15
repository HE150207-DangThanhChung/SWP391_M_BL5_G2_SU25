///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package dal;
//
//import model.Store;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class StoreDAO {
//    public List<Store> findAll() {
//        List<Store> list = new ArrayList<>();
//        String sql = "SELECT StoreId, StoreName, Address, Phone, Status FROM Store ORDER BY StoreId";
//
//        try (Connection con = new DBContext().getConnection();
//             PreparedStatement ps = con.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                Store s = new Store();
//                s.setStoreId(rs.getInt("StoreId"));
//                s.setStoreName(rs.getNString("StoreName")); // NVARCHAR → getNString
//                s.setAddress(rs.getNString("Address"));
//                s.setPhone(rs.getString("Phone"));
//                s.setStatus(rs.getNString("Status"));
//                list.add(s);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace(); // hoặc log
//        }
//        return list;
//    }
//}
//
