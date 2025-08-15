package dal;

import jakarta.servlet.http.HttpServletRequest;
import model.Product;
import model.Brand;
import model.Category;
import model.Supplier;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;

public class ProductDAO {

    private static final String UPLOAD_DIR = "uploads";

    public void addProduct(Product product, Part imagePart, String imageUrl, HttpServletRequest request) throws IOException {
        String insertProduct = "INSERT INTO Product (ProductName, Status, CategoryId, BrandId, SupplierId) VALUES (?, ?, ?, ?, ?)";
        String insertVariant = "INSERT INTO ProductVariant (ProductCode, Price, WarrantyDurationMonth, ProductId) VALUES (?, ?, ?, ?)";
        String insertImage = "INSERT INTO ProductImage (src, alt, ProductVariantId) VALUES (?, ?, ?)";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int productId;
                int productVariantId;
                String finalSrc = null;

                // Handle image upload or URL
                if (imagePart != null && imagePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                    String uploadPath = getUploadPath(request);
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

    private String getUploadPath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("/uploads");
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
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
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving products: " + e.getMessage(), e);
        }
        return products;
    }

    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT brandId, brandName FROM Brand WHERE status = 'ACTIVE'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
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
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                categories.add(new Category(rs.getInt("categoryId"), rs.getString("categoryName")));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving categories: " + e.getMessage(), e);
        }
        return categories;
    }

    public Product getProductById(int productId) {
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
                    return new Product(
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

    public void updateProduct(Product product, Part imagePart, String imageUrl, HttpServletRequest request) throws IOException {
        String updateProductSQL = "UPDATE Product SET ProductName = ?, Status = ?, CategoryId = ?, BrandId = ?, SupplierId = ? WHERE ProductId = ?";
        String updateVariantSQL = "UPDATE ProductVariant SET ProductCode = ?, Price = ?, WarrantyDurationMonth = ? WHERE ProductId = ?";
        String updateImageSQL = "UPDATE ProductImage SET src = ?, alt = ? WHERE ProductVariantId = ?";
        String insertImageSQL = "INSERT INTO ProductImage (src, alt, ProductVariantId) VALUES (?, ?, ?)";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                String finalSrc = null;

                // Handle new image upload or URL
                if (imagePart != null && imagePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                    String uploadPath = getUploadPath(request);
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

                // Update Product table
                try (PreparedStatement stmt = conn.prepareStatement(updateProductSQL)) {
                    stmt.setString(1, product.getProductName());
                    stmt.setString(2, product.getStatus());
                    stmt.setInt(3, product.getCategoryId());
                    stmt.setInt(4, product.getBrandId());
                    stmt.setInt(5, product.getSupplierId());
                    stmt.setInt(6, product.getProductId());
                    stmt.executeUpdate();
                }

                // Update ProductVariant table
                int productVariantId = -1;
                try (PreparedStatement stmt = conn.prepareStatement(updateVariantSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    stmt.setString(1, product.getProductCode());
                    stmt.setDouble(2, product.getPrice());
                    stmt.setInt(3, product.getWarrantyDurationMonth());
                    stmt.setInt(4, product.getProductId());
                    stmt.executeUpdate();

                    // Retrieve the ProductVariantId (for image update/insert)
                    try (PreparedStatement getPvStmt = conn.prepareStatement(
                            "SELECT ProductVariantId FROM ProductVariant WHERE ProductId = ?")) {
                        getPvStmt.setInt(1, product.getProductId());
                        try (ResultSet rs = getPvStmt.executeQuery()) {
                            if (rs.next()) {
                                productVariantId = rs.getInt(1);
                            }
                        }
                    }
                }

                // Update or insert ProductImage if a new image was provided
                if (finalSrc != null && productVariantId != -1) {
                    boolean imageExists = false;
                    try (PreparedStatement checkStmt = conn.prepareStatement(
                            "SELECT COUNT(*) FROM ProductImage WHERE ProductVariantId = ?")) {
                        checkStmt.setInt(1, productVariantId);
                        try (ResultSet rs = checkStmt.executeQuery()) {
                            if (rs.next() && rs.getInt(1) > 0) {
                                imageExists = true;
                            }
                        }
                    }

                    if (imageExists) {
                        try (PreparedStatement stmt = conn.prepareStatement(updateImageSQL)) {
                            stmt.setString(1, finalSrc);
                            stmt.setString(2, product.getProductName());
                            stmt.setInt(3, productVariantId);
                            stmt.executeUpdate();
                        }
                    } else {
                        try (PreparedStatement stmt = conn.prepareStatement(insertImageSQL)) {
                            stmt.setString(1, finalSrc);
                            stmt.setString(2, product.getProductName());
                            stmt.setInt(3, productVariantId);
                            stmt.executeUpdate();
                        }
                    }
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw new RuntimeException("Error updating product: " + e.getMessage(), e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database connection error: " + e.getMessage(), e);
        }
    }

}
