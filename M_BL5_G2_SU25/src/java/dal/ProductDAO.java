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
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import model.Supplier;

public class ProductDAO {

<<<<<<< Updated upstream
    public void addProduct(Product product) {
        String insertProduct = "INSERT INTO Product (productName, brandId, categoryId, status) VALUES (?, ?, ?, ?)";
        String insertVariant = "INSERT INTO ProductVariant (productCode, price, quantity, status, productId) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection()) {
            // Start transaction
=======
    private static final String UPLOAD_DIR = "uploads";

    public void addProduct(Product product, Part imagePart, String imageUrl) throws IOException {
        String insertProduct = "INSERT INTO Product (ProductName, Status, CategoryId, BrandId, SupplierId) VALUES (?, ?, ?, ?, ?)";
        String insertVariant = "INSERT INTO ProductVariant (ProductCode, Price, WarrantyDurationMonth, ProductId) VALUES (?, ?, ?, ?)";
        String insertImage = "INSERT INTO ProductImage (src, alt, ProductVariantId) VALUES (?, ?, ?)";
        try (Connection conn = new DBContext().getConnection()) {
>>>>>>> Stashed changes
            conn.setAutoCommit(false);
            try {
                int productId;
                int productVariantId;
                String finalSrc = null;

                // Handle image upload or URL
                if (imagePart != null && imagePart.getSize() > 0) {
                    // Save uploaded file
                    String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                    String uploadPath = getUploadPath();
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    String fullPath = uploadPath + File.separator + fileName;
                    imagePart.write(fullPath);
                    finalSrc = UPLOAD_DIR + "/" + fileName;
                } else if (imageUrl != null && !imageUrl.isEmpty()) {
                    finalSrc = imageUrl;
                }

                // Insert product
                try (PreparedStatement stmt = conn.prepareStatement(insertProduct, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    stmt.setString(1, product.getProductName());
                    stmt.setString(2, product.getStatus());
                    stmt.setInt(3, product.getCategoryId());
                    stmt.setInt(4, product.getBrandId());
                    stmt.setInt(5, product.getSupplierId());
                    stmt.executeUpdate();
                    ResultSet rs = stmt.getGeneratedKeys();
                    if (rs.next()) {
                        productId = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to retrieve generated productId");
                    }
                }

                // Insert variant
                try (PreparedStatement stmt = conn.prepareStatement(insertVariant, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    stmt.setString(1, product.getProductCode());
                    stmt.setDouble(2, product.getPrice());
                    stmt.setInt(3, product.getWarrantyDurationMonth());
                    stmt.setInt(4, productId);
                    stmt.executeUpdate();
                    ResultSet rs = stmt.getGeneratedKeys();
                    if (rs.next()) {
                        productVariantId = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to retrieve generated productVariantId");
                    }
                }

                // Insert image if provided
                if (finalSrc != null) {
                    try (PreparedStatement stmt = conn.prepareStatement(insertImage)) {
                        stmt.setString(1, finalSrc);
                        stmt.setString(2, product.getProductName());
                        stmt.setInt(3, productVariantId);
                        stmt.executeUpdate();
                    }
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

    private String getUploadPath() {
        // Dynamic path based on project root for development
        return System.getProperty("user.dir") + "/src/main/webapp/" + UPLOAD_DIR;
        // For production, adjust to a persistent path (e.g., "/var/www/uploads")
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
<<<<<<< Updated upstream
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
=======
        String sql = "SELECT p.ProductId, p.ProductName, p.Status, p.CategoryId, c.CategoryName, "
                + "p.BrandId, b.BrandName, p.SupplierId, s.SupplierName, "
                + "pv.ProductCode, pv.Price, pv.WarrantyDurationMonth, "
                + "pi.src AS imageUrl "
                + "FROM Product p "
                + "JOIN Category c ON p.CategoryId = c.CategoryId "
                + "JOIN Brand b ON p.BrandId = b.BrandId "
                + "JOIN Supplier s ON p.SupplierId = s.SupplierId "
                + "JOIN ProductVariant pv ON p.ProductId = pv.ProductId "
                + "LEFT JOIN ProductImage pi ON pv.ProductVariantId = pi.ProductVariantId "
                + "WHERE p.Status = 'Active'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("ProductId"),
                        rs.getString("ProductName"),
                        rs.getString("Status"),
                        rs.getInt("CategoryId"),
                        rs.getString("CategoryName"),
                        rs.getInt("BrandId"),
                        rs.getString("BrandName"),
                        rs.getInt("SupplierId"),
                        rs.getString("SupplierName"),
                        rs.getString("ProductCode"),
                        rs.getDouble("Price"),
                        rs.getInt("WarrantyDurationMonth"),
                        rs.getString("imageUrl")
                );
                products.add(product);
>>>>>>> Stashed changes
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving products: " + e.getMessage(), e);
        }
        return products;
    }

    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT brandId, brandName FROM Brand WHERE status = 'ACTIVE'";
<<<<<<< Updated upstream
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
=======
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
=======
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
>>>>>>> Stashed changes
            while (rs.next()) {
                categories.add(new Category(rs.getInt("categoryId"), rs.getString("categoryName")));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving categories: " + e.getMessage(), e);
        }
        return categories;
    }

    public Product getProductById(int productId) {
<<<<<<< Updated upstream
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
=======
        String sql = "SELECT p.ProductId, p.ProductName, p.Status, p.CategoryId, c.CategoryName, "
                + "p.BrandId, b.BrandName, p.SupplierId, s.SupplierName, "
                + "pv.ProductCode, pv.Price, pv.WarrantyDurationMonth, "
                + "pi.src AS imageUrl "
                + "FROM Product p "
                + "JOIN Category c ON p.CategoryId = c.CategoryId "
                + "JOIN Brand b ON p.BrandId = b.BrandId "
                + "JOIN Supplier s ON p.SupplierId = s.SupplierId "
                + "JOIN ProductVariant pv ON p.ProductId = pv.ProductId "
                + "LEFT JOIN ProductImage pi ON pv.ProductVariantId = pi.ProductVariantId "
                + "WHERE p.ProductId = ? AND p.Status = 'Active'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product(
                            rs.getInt("ProductId"),
                            rs.getString("ProductName"),
                            rs.getString("Status"),
                            rs.getInt("CategoryId"),
                            rs.getString("CategoryName"),
                            rs.getInt("BrandId"),
                            rs.getString("BrandName"),
                            rs.getInt("SupplierId"),
                            rs.getString("SupplierName"),
                            rs.getString("ProductCode"),
                            rs.getDouble("Price"),
                            rs.getInt("WarrantyDurationMonth"),
                            rs.getString("imageUrl")
>>>>>>> Stashed changes
                    );
                    return product;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving product: " + e.getMessage(), e);
        }
        return null;
    }

    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT SupplierId, SupplierName, Phone, Email, TaxCode, Status "
                + "FROM Supplier "
                + "WHERE Status = 'Active'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Supplier supplier = new Supplier(
                        rs.getInt("SupplierId"),
                        rs.getString("SupplierName"),
                        rs.getString("Phone"),
                        rs.getString("Email"),
                        rs.getString("TaxCode"),
                        rs.getString("Status")
                );
                suppliers.add(supplier);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving suppliers: " + e.getMessage(), e);
        }
        return suppliers;
    }
}
