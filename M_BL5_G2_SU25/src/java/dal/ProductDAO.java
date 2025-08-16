package dal;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import model.Product;
import model.ProductImage;
import model.ProductSerial;
import model.VariantSpecification;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Brand;
import model.Category;
import model.ProductVariant;
import model.Specification;
import model.Supplier;

public class ProductDAO {

    private static final String UPLOAD_DIR = "uploads";

    public void addProduct(Product product, List<List<Part>> variantImageParts, List<List<String>> variantImageUrls, HttpServletRequest request) throws IOException {
        String insertProduct = "INSERT INTO Product (ProductName, Status, CategoryId, BrandId, SupplierId) VALUES (?, ?, ?, ?, ?)";
        String insertVariant = "INSERT INTO ProductVariant (ProductCode, Price, WarrantyDurationMonth, ProductId) VALUES (?, ?, ?, ?)";
        String insertSpec = "INSERT INTO VariantSpecification (ProductVariantId, SpecificationId, Value) VALUES (?, ?, ?)";
        String insertImage = "INSERT INTO ProductImage (src, alt, ProductVariantId) VALUES (?, ?, ?)";
        String insertSerial = "INSERT INTO ProductSerial (SerialNumber, ProductVariantId, StoreId, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int productId;
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

                for (int i = 0; i < product.getVariants().size(); i++) {
                    ProductVariant variant = product.getVariants().get(i);
                    int productVariantId;
                    try (PreparedStatement stmt = conn.prepareStatement(insertVariant, PreparedStatement.RETURN_GENERATED_KEYS)) {
                        stmt.setString(1, variant.getProductCode());
                        stmt.setDouble(2, variant.getPrice());
                        stmt.setInt(3, variant.getWarrantyDurationMonth());
                        stmt.setInt(4, productId);
                        stmt.executeUpdate();
                        ResultSet rs = stmt.getGeneratedKeys();
                        if (rs.next()) {
                            productVariantId = rs.getInt(1);
                        } else {
                            throw new SQLException("Failed to retrieve generated productVariantId");
                        }
                    }

                    // Insert specifications
                    for (VariantSpecification spec : variant.getSpecifications()) {
                        try (PreparedStatement stmt = conn.prepareStatement(insertSpec)) {
                            stmt.setInt(1, productVariantId);
                            stmt.setInt(2, spec.getSpecificationId());
                            stmt.setString(3, spec.getValue());
                            stmt.executeUpdate();
                        }
                    }

                    // Insert images
                    List<Part> imageParts = variantImageParts.get(i);
                    List<String> imageUrls = variantImageUrls.get(i);
                    for (int j = 0; j < Math.max(imageParts.size(), imageUrls.size()); j++) {
                        String finalSrc = null;
                        Part imagePart = (j < imageParts.size()) ? imageParts.get(j) : null;
                        String imageUrl = (j < imageUrls.size()) ? imageUrls.get(j) : null;

                        if (imagePart != null && imagePart.getSize() > 0) {
                            String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                            String uploadPath = getUploadPath(request);
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) uploadDir.mkdirs();
                            String fullPath = uploadPath + File.separator + fileName;
                            imagePart.write(fullPath);
                            finalSrc = UPLOAD_DIR + "/" + fileName;
                        } else if (imageUrl != null && !imageUrl.isEmpty()) {
                            finalSrc = imageUrl;
                        }

                        if (finalSrc != null) {
                            try (PreparedStatement stmt = conn.prepareStatement(insertImage)) {
                                stmt.setString(1, finalSrc);
                                stmt.setString(2, product.getProductName()); // Use product name as alt for now
                                stmt.setInt(3, productVariantId);
                                stmt.executeUpdate();
                            }
                        }
                    }

                    // Insert serials
                    for (ProductSerial serial : variant.getSerials()) {
                        try (PreparedStatement stmt = conn.prepareStatement(insertSerial)) {
                            stmt.setString(1, serial.getSerialNumber());
                            stmt.setInt(2, productVariantId);
                            stmt.setInt(3, serial.getStoreId());
                            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                            stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                            stmt.executeUpdate();
                        }
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
        String sql = "SELECT p.ProductId, p.ProductName, p.Status, p.CategoryId, c.CategoryName, " +
                     "p.BrandId, b.BrandName, p.SupplierId, s.SupplierName " +
                     "FROM Product p " +
                     "JOIN Category c ON p.CategoryId = c.CategoryId " +
                     "JOIN Brand b ON p.BrandId = b.BrandId " +
                     "JOIN Supplier s ON p.SupplierId = s.SupplierId " +
                     "WHERE p.Status = 'Active' ";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("ProductId"));
                product.setProductName(rs.getString("ProductName"));
                product.setStatus(rs.getString("Status"));
                product.setCategoryId(rs.getInt("CategoryId"));
                product.setCategoryName(rs.getString("CategoryName"));
                product.setBrandId(rs.getInt("BrandId"));
                product.setBrandName(rs.getString("BrandName"));
                product.setSupplierId(rs.getInt("SupplierId"));
                product.setSupplierName(rs.getString("SupplierName"));

                // Fetch variants for this product
                product.setVariants(getVariantsByProductId(product.getProductId(), conn));
                products.add(product);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving products: " + e.getMessage(), e);
        }
        return products;
    }

    private List<ProductVariant> getVariantsByProductId(int productId, Connection conn) throws SQLException {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT pv.ProductVariantId, pv.ProductCode, pv.Price, pv.WarrantyDurationMonth, pv.ProductId " +
                     "FROM ProductVariant pv " +
                     "WHERE pv.ProductId = ? ";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductVariant variant = new ProductVariant();
                    variant.setProductVariantId(rs.getInt("ProductVariantId"));
                    variant.setProductCode(rs.getString("ProductCode"));
                    variant.setPrice(rs.getDouble("Price"));
                    variant.setWarrantyDurationMonth(rs.getInt("WarrantyDurationMonth"));
                    variant.setProductId(rs.getInt("ProductId"));

                    // Fetch specifications, images, serials
                    variant.setSpecifications(getSpecificationsByVariantId(variant.getProductVariantId(), conn));
                    variant.setImages(getImagesByVariantId(variant.getProductVariantId(), conn));
                    variant.setSerials(getSerialsByVariantId(variant.getProductVariantId(), conn));
                    variants.add(variant);
                }
            }
        }
        return variants;
    }

    private List<VariantSpecification> getSpecificationsByVariantId(int productVariantId, Connection conn) throws SQLException {
        List<VariantSpecification> specs = new ArrayList<>();
        String sql = "SELECT vs.ProductVariantId, vs.SpecificationId, vs.Value " +
                     "FROM VariantSpecification vs " +
                     "WHERE vs.ProductVariantId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productVariantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    VariantSpecification spec = new VariantSpecification();
                    spec.setProductVariantId(rs.getInt("ProductVariantId"));
                    spec.setSpecificationId(rs.getInt("SpecificationId"));
                    spec.setValue(rs.getString("Value"));
                    specs.add(spec);
                }
            }
        }
        return specs;
    }

    private List<ProductImage> getImagesByVariantId(int productVariantId, Connection conn) throws SQLException {
        List<ProductImage> images = new ArrayList<>();
        String sql = "SELECT pi.ProductImageId, pi.src, pi.alt, pi.ProductVariantId " +
                     "FROM ProductImage pi " +
                     "WHERE pi.ProductVariantId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productVariantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductImage image = new ProductImage();
                    image.setProductImageId(rs.getInt("ProductImageId"));
                    image.setSrc(rs.getString("src"));
                    image.setAlt(rs.getString("alt"));
                    image.setProductVariantId(rs.getInt("ProductVariantId"));
                    images.add(image);
                }
            }
        }
        return images;
    }

    private List<ProductSerial> getSerialsByVariantId(int productVariantId, Connection conn) throws SQLException {
        List<ProductSerial> serials = new ArrayList<>();
        String sql = "SELECT ps.ProductSerialId, ps.SerialNumber, ps.ProductVariantId, ps.StoreId, ps.CreatedAt, ps.UpdatedAt " +
                     "FROM ProductSerial ps " +
                     "WHERE ps.ProductVariantId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productVariantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductSerial serial = new ProductSerial();
                    serial.setProductSerialId(rs.getInt("ProductSerialId"));
                    serial.setSerialNumber(rs.getString("SerialNumber"));
                    serial.setProductVariantId(rs.getInt("ProductVariantId"));
                    serial.setStoreId(rs.getInt("StoreId"));
                    serial.setCreatedAt(rs.getString("CreatedAt"));
                    serial.setUpdatedAt(rs.getString("UpdatedAt"));
                    serials.add(serial);
                }
            }
        }
        return serials;
    }

    public Product getProductById(int productId) {
        Product product = null;
        String sql = "SELECT p.ProductId, p.ProductName, p.Status, p.CategoryId, c.CategoryName, " +
                     "p.BrandId, b.BrandName, p.SupplierId, s.SupplierName " +
                     "FROM Product p " +
                     "JOIN Category c ON p.CategoryId = c.CategoryId " +
                     "JOIN Brand b ON p.BrandId = b.BrandId " +
                     "JOIN Supplier s ON p.SupplierId = s.SupplierId " +
                     "WHERE p.ProductId = ? AND p.Status = 'Active'";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    product = new Product();
                    product.setProductId(rs.getInt("ProductId"));
                    product.setProductName(rs.getString("ProductName"));
                    product.setStatus(rs.getString("Status"));
                    product.setCategoryId(rs.getInt("CategoryId"));
                    product.setCategoryName(rs.getString("CategoryName"));
                    product.setBrandId(rs.getInt("BrandId"));
                    product.setBrandName(rs.getString("BrandName"));
                    product.setSupplierId(rs.getInt("SupplierId"));
                    product.setSupplierName(rs.getString("SupplierName"));

                    // Fetch variants for this product
                    product.setVariants(getVariantsByProductId(product.getProductId(), conn));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving product: " + e.getMessage(), e);
        }
        return product;
    }

    public void updateProduct(Product product, List<List<Part>> variantImageParts, List<List<String>> variantImageUrls, HttpServletRequest request) throws IOException {
        String updateProduct = "UPDATE Product SET ProductName = ?, Status = ?, CategoryId = ?, BrandId = ?, SupplierId = ? WHERE ProductId = ?";
        String updateVariant = "UPDATE ProductVariant SET ProductCode = ?, Price = ?, WarrantyDurationMonth = ? WHERE ProductVariantId = ?";
        String updateSpec = "UPDATE VariantSpecification SET Value = ? WHERE ProductVariantId = ? AND SpecificationId = ?";
        String updateImage = "UPDATE ProductImage SET src = ?, alt = ? WHERE ProductImageId = ?";
        String updateSerial = "UPDATE ProductSerial SET SerialNumber = ?, StoreId = ?, UpdatedAt = ? WHERE ProductSerialId = ?";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Update product
                try (PreparedStatement stmt = conn.prepareStatement(updateProduct)) {
                    stmt.setString(1, product.getProductName());
                    stmt.setString(2, product.getStatus());
                    stmt.setInt(3, product.getCategoryId());
                    stmt.setInt(4, product.getBrandId());
                    stmt.setInt(5, product.getSupplierId());
                    stmt.setInt(6, product.getProductId());
                    stmt.executeUpdate();
                }

                // Update variants
                for (int i = 0; i < product.getVariants().size(); i++) {
                    ProductVariant variant = product.getVariants().get(i);
                    try (PreparedStatement stmt = conn.prepareStatement(updateVariant)) {
                        stmt.setString(1, variant.getProductCode());
                        stmt.setDouble(2, variant.getPrice());
                        stmt.setInt(3, variant.getWarrantyDurationMonth());
                        stmt.setInt(4, variant.getProductVariantId());
                        stmt.executeUpdate();
                    }

                    // Update specifications
                    for (VariantSpecification spec : variant.getSpecifications()) {
                        try (PreparedStatement stmt = conn.prepareStatement(updateSpec)) {
                            stmt.setString(1, spec.getValue());
                            stmt.setInt(2, spec.getProductVariantId());
                            stmt.setInt(3, spec.getSpecificationId());
                            stmt.executeUpdate();
                        }
                    }

                    // Update images
                    List<Part> imageParts = (i < variantImageParts.size()) ? variantImageParts.get(i) : new ArrayList<>();
                    List<String> imageUrls = (i < variantImageUrls.size()) ? variantImageUrls.get(i) : new ArrayList<>();
                    for (int j = 0; j < variant.getImages().size(); j++) {
                        ProductImage image = variant.getImages().get(j);
                        String finalSrc = null;
                        Part imagePart = (j < imageParts.size()) ? imageParts.get(j) : null;
                        String imageUrl = (j < imageUrls.size()) ? imageUrls.get(j) : null;

                        if (imagePart != null && imagePart.getSize() > 0) {
                            String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                            String uploadPath = getUploadPath(request);
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) uploadDir.mkdirs();
                            String fullPath = uploadPath + File.separator + fileName;
                            imagePart.write(fullPath);
                            finalSrc = UPLOAD_DIR + "/" + fileName;
                        } else if (imageUrl != null && !imageUrl.isEmpty()) {
                            finalSrc = imageUrl;
                        } else {
                            finalSrc = image.getSrc(); // Keep existing if no new upload/URL
                        }

                        if (finalSrc != null) {
                            try (PreparedStatement stmt = conn.prepareStatement(updateImage)) {
                                stmt.setString(1, finalSrc);
                                stmt.setString(2, image.getAlt());
                                stmt.setInt(3, image.getProductImageId());
                                stmt.executeUpdate();
                            }
                        }
                    }

                    // Update serials
                    for (ProductSerial serial : variant.getSerials()) {
                        try (PreparedStatement stmt = conn.prepareStatement(updateSerial)) {
                            stmt.setString(1, serial.getSerialNumber());
                            stmt.setInt(2, serial.getStoreId());
                            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                            stmt.setInt(4, serial.getProductSerialId());
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
    
    public List<Specification> getAllSpecifications() {
        List<Specification> specifications = new ArrayList<>();
        String sql = "SELECT SpecificationId, AttributeName FROM Specification";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Specification spec = new Specification();
                spec.setSpecificationId(rs.getInt("SpecificationId"));
                spec.setAttributeName(rs.getString("AttributeName"));
                specifications.add(spec);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving specifications: " + e.getMessage(), e);
        }
        return specifications;
    }
    
    public List<Product> getFilteredAndSortedProducts(String categoryId, String brandId, String status, 
                                                    Double minPrice, Double maxPrice, String sortBy, String sortOrder) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.ProductId, p.ProductName, p.Status, p.CategoryId, c.CategoryName, " +
                                             "p.BrandId, b.BrandName, p.SupplierId, s.SupplierName " +
                                             "FROM Product p " +
                                             "JOIN Category c ON p.CategoryId = c.CategoryId " +
                                             "JOIN Brand b ON p.BrandId = b.BrandId " +
                                             "JOIN Supplier s ON p.SupplierId = s.SupplierId " +
                                             "WHERE p.Status = 'Active' ");

        // Add filter conditions
        List<Object> params = new ArrayList<>();
        if (categoryId != null && !categoryId.isEmpty()) {
            sql.append("AND p.CategoryId = ? ");
            params.add(Integer.parseInt(categoryId));
        }
        if (brandId != null && !brandId.isEmpty()) {
            sql.append("AND p.BrandId = ? ");
            params.add(Integer.parseInt(brandId));
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND p.Status = ? ");
            params.add(status);
        }
        if (minPrice != null) {
            sql.append("AND (SELECT MIN(Price) FROM ProductVariant pv WHERE pv.ProductId = p.ProductId) >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append("AND (SELECT MAX(Price) FROM ProductVariant pv WHERE pv.ProductId = p.ProductId) <= ? ");
            params.add(maxPrice);
        }

        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            if ("price".equals(sortBy)) {
                sql.append("ORDER BY (SELECT MIN(Price) FROM ProductVariant pv WHERE pv.ProductId = p.ProductId) ");
            } else if ("name".equals(sortBy)) {
                sql.append("ORDER BY p.ProductName ");
            }
            sql.append(sortOrder != null && "desc".equalsIgnoreCase(sortOrder) ? "DESC " : "ASC ");
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setProductId(rs.getInt("ProductId"));
                    product.setProductName(rs.getString("ProductName"));
                    product.setStatus(rs.getString("Status"));
                    product.setCategoryId(rs.getInt("CategoryId"));
                    product.setCategoryName(rs.getString("CategoryName"));
                    product.setBrandId(rs.getInt("BrandId"));
                    product.setBrandName(rs.getString("BrandName"));
                    product.setSupplierId(rs.getInt("SupplierId"));
                    product.setSupplierName(rs.getString("SupplierName"));

                    // Fetch variants for this product
                    product.setVariants(getVariantsByProductId(product.getProductId(), conn));
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving filtered and sorted products: " + e.getMessage(), e);
        }
        return products;
    }

}
