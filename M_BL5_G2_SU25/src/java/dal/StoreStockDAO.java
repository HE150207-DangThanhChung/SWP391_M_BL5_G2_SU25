package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.StoreStock;

public class StoreStockDAO extends DBContext {

    public StoreStock getStoreStock(int storeId, int productVariantId) {
        String sql = "SELECT * FROM StoreStock WHERE StoreId = ? AND ProductVariantId = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ps.setInt(2, productVariantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    StoreStock stock = new StoreStock();
                    stock.setStoreId(rs.getInt("StoreId"));
                    stock.setProductVariantId(rs.getInt("ProductVariantId"));
                    stock.setQuantity(rs.getInt("Quantity"));
                    return stock;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("getStoreStock() failed", e);
        }
        return null;
    }

    public List<StoreStock> getStoreStockByStore(int storeId) {
        List<StoreStock> stockList = new ArrayList<>();
        String sql = "SELECT * FROM StoreStock WHERE StoreId = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StoreStock stock = new StoreStock();
                    stock.setStoreId(rs.getInt("StoreId"));
                    stock.setProductVariantId(rs.getInt("ProductVariantId"));
                    stock.setQuantity(rs.getInt("Quantity"));
                    stockList.add(stock);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("getStoreStockByStore() failed", e);
        }
        return stockList;
    }

    public List<StoreStock> getStoreStockByProductVariant(int productVariantId) {
        List<StoreStock> stockList = new ArrayList<>();
        String sql = "SELECT * FROM StoreStock WHERE ProductVariantId = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productVariantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StoreStock stock = new StoreStock();
                    stock.setStoreId(rs.getInt("StoreId"));
                    stock.setProductVariantId(rs.getInt("ProductVariantId"));
                    stock.setQuantity(rs.getInt("Quantity"));
                    stockList.add(stock);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("getStoreStockByProductVariant() failed", e);
        }
        return stockList;
    }

    public boolean updateStoreStock(StoreStock stock) {
        String sql = "UPDATE StoreStock SET Quantity = ? WHERE StoreId = ? AND ProductVariantId = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, stock.getQuantity());
            ps.setInt(2, stock.getStoreId());
            ps.setInt(3, stock.getProductVariantId());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("updateStoreStock() failed", e);
        }
    }

    public boolean insertStoreStock(StoreStock stock) {
        String sql = "INSERT INTO StoreStock (StoreId, ProductVariantId, Quantity) VALUES (?, ?, ?)";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, stock.getStoreId());
            ps.setInt(2, stock.getProductVariantId());
            ps.setInt(3, stock.getQuantity());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("insertStoreStock() failed", e);
        }
    }

    public boolean deleteStoreStock(int storeId, int productVariantId) {
        String sql = "DELETE FROM StoreStock WHERE StoreId = ? AND ProductVariantId = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ps.setInt(2, productVariantId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("deleteStoreStock() failed", e);
        }
    }

    public boolean checkQuantityAvailable(int storeId, int productVariantId, int requiredQuantity) {
        StoreStock stock = getStoreStock(storeId, productVariantId);
        return stock != null && stock.getQuantity() >= requiredQuantity;
    }

    public int getTotalQuantityForProduct(int productVariantId) {
        String sql = "SELECT SUM(Quantity) as TotalQuantity FROM StoreStock WHERE ProductVariantId = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productVariantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("TotalQuantity");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("getTotalQuantityForProduct() failed", e);
        }
        return 0;
    }

    public List<StoreStock> getLowStockItems(int threshold) {
        List<StoreStock> lowStockItems = new ArrayList<>();
        String sql = "SELECT * FROM StoreStock WHERE Quantity <= ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, threshold);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StoreStock stock = new StoreStock();
                    stock.setStoreId(rs.getInt("StoreId"));
                    stock.setProductVariantId(rs.getInt("ProductVariantId"));
                    stock.setQuantity(rs.getInt("Quantity"));
                    lowStockItems.add(stock);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("getLowStockItems() failed", e);
        }
        return lowStockItems;
    }
}