/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Product;
import model.Brand;
import model.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author tayho
 */
public class ProductDAO {

    public void addProduct(Product product) {
        String insertProduct = "INSERT INTO Product (productName, brandId, categoryId, status) VALUES (?, ?, ?, ?)";
        String insertVariant = "INSERT INTO ProductVariant (productCode, price, quantity, status, productId) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection()) {
            // Start transaction
            conn.setAutoCommit(false);
            try {
                // Insert into Product table
                int productId;
                try (PreparedStatement stmt = conn.prepareStatement(insertProduct, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    stmt.setString(1, product.getProductName());
                    stmt.setInt(2, product.getBrandId());
                    stmt.setInt(3, product.getCategoryId());
                    stmt.setString(4, product.getStatus());
                    stmt.executeUpdate();
                    ResultSet rs = stmt.getGeneratedKeys();
                    if (rs.next()) {
                        productId = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to retrieve generated productId");
                    }
                }
                // Insert into ProductVariant table
                try (PreparedStatement stmt = conn.prepareStatement(insertVariant)) {
                    stmt.setString(1, product.getProductCode());
                    stmt.setDouble(2, product.getPrice());
                    stmt.setInt(3, product.getQuantity());
                    stmt.setString(4, product.getStatus());
                    stmt.setInt(5, productId);
                    stmt.executeUpdate();
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw new RuntimeException("Error adding product: " + e.getMessage(), e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database connection error: " + e.getMessage(), e);
        }
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.productId, p.productName, p.brandId, b.brandName, p.categoryId, c.categoryName, "
                + "pv.productCode, pv.price, pv.quantity, pv.status "
                + "FROM Product p "
                + "JOIN Brand b ON p.brandId = b.brandId "
                + "JOIN Category c ON p.categoryId = c.categoryId "
                + "JOIN ProductVariant pv ON p.productId = pv.productId "
                + "WHERE p.status = 'ACTIVE'";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("productId"),
                        rs.getString("productName"),
                        rs.getInt("brandId"),
                        rs.getString("brandName"),
                        rs.getInt("categoryId"),
                        rs.getString("categoryName"),
                        rs.getString("productCode"),
                        rs.getDouble("price"),
                        rs.getInt("quantity"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving products: " + e.getMessage(), e);
        }
        return products;
    }

    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT brandId, brandName FROM Brand WHERE status = 'ACTIVE'";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                brands.add(new Brand(rs.getInt("brandId"), rs.getString("brandName")));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving brands: " + e.getMessage(), e);
        }
        return brands;
    }

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT categoryId, categoryName FROM Category WHERE status = 'ACTIVE'";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                categories.add(new Category(rs.getInt("categoryId"), rs.getString("categoryName")));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving categories: " + e.getMessage(), e);
        }
        return categories;
    }

    public Product getProductById(int productId) {
        String sql = "SELECT p.productId, p.productName, p.brandId, b.brandName, p.categoryId, c.categoryName, "
                + "pv.productCode, pv.price, pv.quantity, pv.status "
                + "FROM Product p "
                + "JOIN Brand b ON p.brandId = b.brandId "
                + "JOIN Category c ON p.categoryId = c.categoryId "
                + "JOIN ProductVariant pv ON p.productId = pv.productId "
                + "WHERE p.productId = ? AND p.status = 'ACTIVE'";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Product(
                            rs.getInt("productId"),
                            rs.getString("productName"),
                            rs.getInt("brandId"),
                            rs.getString("brandName"),
                            rs.getInt("categoryId"),
                            rs.getString("categoryName"),
                            rs.getString("productCode"),
                            rs.getDouble("price"),
                            rs.getInt("quantity"),
                            rs.getString("status")
                    );
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving product: " + e.getMessage(), e);
        }
        return null; // Return null if not found
    }
}
