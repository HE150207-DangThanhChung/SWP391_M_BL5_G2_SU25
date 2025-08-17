
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Store;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StoreDAO {


    public List<Store> findAll(int pageNumber, int pageSize, String searchKeyword, String filterStatus) {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT StoreId, StoreName, Address, Phone, Status FROM Store WHERE 1=1";
        
     
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql += " AND (StoreName LIKE ? OR Address LIKE ? OR Phone LIKE ?)";
        }
        
     
        if (filterStatus != null && !filterStatus.trim().isEmpty()) {
            sql += " AND Status = ?";
        }
        
     
        sql += " ORDER BY StoreId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            int paramIndex = 1;
            
      
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
   
            if (filterStatus != null && !filterStatus.trim().isEmpty()) {
                ps.setString(paramIndex++, filterStatus);
            }
            
         
            ps.setInt(paramIndex++, (pageNumber - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Store s = new Store();
                s.setStoreId(rs.getInt("StoreId"));
                s.setStoreName(rs.getString("StoreName"));
                s.setAddress(rs.getString("Address"));
                s.setPhone(rs.getString("Phone"));
                s.setStatus(rs.getString("Status"));
                list.add(s);
            }
        } catch (Exception e) {
            throw new RuntimeException("findAll() failed", e);
        }
        return list;
    }


    public int getTotalStores(String searchKeyword, String filterStatus) {
        String sql = "SELECT COUNT(*) FROM Store WHERE 1=1";
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql += " AND (StoreName LIKE ? OR Address LIKE ? OR Phone LIKE ?)";
        }
        
        if (filterStatus != null && !filterStatus.trim().isEmpty()) {
            sql += " AND Status = ?";
        }
        
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            int paramIndex = 1;
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            if (filterStatus != null && !filterStatus.trim().isEmpty()) {
                ps.setString(paramIndex, filterStatus);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("getTotalStores() failed", e);
        }
        return 0;
    }

    
    public Store findById(int storeId) {
        String sql = "SELECT StoreId, StoreName, Address, Phone, Status FROM Store WHERE StoreId = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Store s = new Store();
                s.setStoreId(rs.getInt("StoreId"));
                s.setStoreName(rs.getString("StoreName"));
                s.setAddress(rs.getString("Address"));
                s.setPhone(rs.getString("Phone"));
                s.setStatus(rs.getString("Status"));
                return s;
            }
        } catch (Exception e) {
            throw new RuntimeException("findById() failed", e);
        }
        return null;
    }

    
    public boolean update(Store store) {
        String sql = "UPDATE Store SET StoreName = ?, Address = ?, Phone = ?, Status = ? WHERE StoreId = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, store.getStoreName());
            ps.setString(2, store.getAddress());
            ps.setString(3, store.getPhone());
            ps.setString(4, store.getStatus());
            ps.setInt(5, store.getStoreId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            throw new RuntimeException("update() failed", e);
        }
    }


    public boolean add(Store store) {
        String sql = "INSERT INTO Store (StoreName, Address, Phone, Status) VALUES (?, ?, ?, ?)";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, store.getStoreName());
            ps.setString(2, store.getAddress());
            ps.setString(3, store.getPhone());
            ps.setString(4, store.getStatus());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            throw new RuntimeException("add() failed", e);
        }
    }


    public boolean delete(int storeId) {
        String sql = "DELETE FROM Store WHERE StoreId = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, storeId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            throw new RuntimeException("delete() failed", e);
        }
    }

}

