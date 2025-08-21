package dal;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import model.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class ProductDAO {

    private static final String UPLOAD_DIR = "uploads";

    public void addProduct(Product product, List<List<Part>> variantImageParts, List<List<String>> variantImageUrls, HttpServletRequest request) throws IOException {
        String checkProductName = "SELECT COUNT(*) FROM Product WHERE ProductName = ? AND Status = 'Active'";
        String insertProduct = "INSERT INTO Product (ProductName, Status, CategoryId, BrandId, SupplierId) VALUES (?, ?, ?, ?, ?)";
        String checkProductCode = "SELECT COUNT(*) FROM ProductVariant WHERE ProductCode = ?";
        String insertVariant = "INSERT INTO ProductVariant (ProductCode, Price, WarrantyDurationMonth, ProductId) VALUES (?, ?, ?, ?)";
        String insertSpec = "INSERT INTO VariantSpecification (ProductVariantId, SpecificationId, Value) VALUES (?, ?, ?)";
        String insertImage = "INSERT INTO ProductImage (src, alt, ProductVariantId) VALUES (?, ?, ?)";
        String checkSerialNumber = "SELECT COUNT(*) FROM ProductSerial WHERE SerialNumber = ?";
        String insertSerial = "INSERT INTO ProductSerial (SerialNumber, ProductVariantId, StoreId, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?)";
        String upsertStock = "MERGE INTO StoreStock AS target "
                + "USING (SELECT ? AS StoreId, ? AS ProductVariantId, ? AS Quantity) AS source "
                + "ON target.StoreId = source.StoreId AND target.ProductVariantId = source.ProductVariantId "
                + "WHEN MATCHED THEN UPDATE SET Quantity = target.Quantity + source.Quantity "
                + "WHEN NOT MATCHED THEN INSERT (StoreId, ProductVariantId, Quantity) VALUES (source.StoreId, source.ProductVariantId, source.Quantity);";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Check for duplicate ProductName
                try (PreparedStatement stmt = conn.prepareStatement(checkProductName)) {
                    stmt.setString(1, product.getProductName());
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new SQLException("Product with name '" + product.getProductName() + "' already exists.");
                    }
                }

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
                        product.setProductId(productId);
                    } else {
                        throw new SQLException("Failed to retrieve generated productId");
                    }
                }

                for (int i = 0; i < product.getVariants().size(); i++) {
                    ProductVariant variant = product.getVariants().get(i);
                    // Check for duplicate ProductCode
                    try (PreparedStatement stmt = conn.prepareStatement(checkProductCode)) {
                        stmt.setString(1, variant.getProductCode());
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next() && rs.getInt(1) > 0) {
                            throw new SQLException("Product variant with code '" + variant.getProductCode() + "' already exists.");
                        }
                    }

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
                            variant.setProductVariantId(productVariantId);
                            System.out.println("Inserted ProductVariant with ID: " + productVariantId);
                        } else {
                            throw new SQLException("Failed to retrieve generated productVariantId");
                        }
                    }

                    // Validate ProductVariantId
                    try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM ProductVariant WHERE ProductVariantId = ?")) {
                        stmt.setInt(1, productVariantId);
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next() && rs.getInt(1) == 0) {
                            throw new SQLException("ProductVariantId " + productVariantId + " does not exist in ProductVariant table");
                        }
                    }

                    for (VariantSpecification spec : variant.getSpecifications()) {
                        try (PreparedStatement stmt = conn.prepareStatement(insertSpec)) {
                            stmt.setInt(1, productVariantId);
                            stmt.setInt(2, spec.getSpecificationId());
                            stmt.setString(3, spec.getValue());
                            stmt.executeUpdate();
                        }
                    }

                    List<Part> imageParts = (i < variantImageParts.size()) ? variantImageParts.get(i) : new ArrayList<>();
                    List<String> imageUrls = (i < variantImageUrls.size()) ? variantImageUrls.get(i) : new ArrayList<>();
                    for (int j = 0; j < Math.max(imageParts.size(), imageUrls.size()); j++) {
                        String finalSrc = null;
                        String altText = product.getProductName() + " Variant " + (i + 1) + " Image " + (j + 1);
                        Part imagePart = (j < imageParts.size()) ? imageParts.get(j) : null;
                        String imageUrl = (j < imageUrls.size()) ? imageUrls.get(j) : null;
                        if (imagePart != null && imagePart.getSize() > 0) {
                            String fileName = UUID.randomUUID().toString() + "_" + imagePart.getSubmittedFileName();
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
                        if (finalSrc != null) {
                            try (PreparedStatement stmt = conn.prepareStatement(insertImage)) {
                                stmt.setString(1, finalSrc);
                                stmt.setString(2, altText);
                                stmt.setInt(3, productVariantId);
                                stmt.executeUpdate();
                            }
                        }
                    }

                    Map<Integer, Integer> storeQuantities = new HashMap<>();
                    for (ProductSerial serial : variant.getSerials()) {
                        // Check for duplicate SerialNumber
                        try (PreparedStatement stmt = conn.prepareStatement(checkSerialNumber)) {
                            stmt.setString(1, serial.getSerialNumber());
                            ResultSet rs = stmt.executeQuery();
                            if (rs.next() && rs.getInt(1) > 0) {
                                throw new SQLException("Serial number '" + serial.getSerialNumber() + "' already exists.");
                            }
                        }

                        try (PreparedStatement stmt = conn.prepareStatement(insertSerial, PreparedStatement.RETURN_GENERATED_KEYS)) {
                            stmt.setString(1, serial.getSerialNumber());
                            stmt.setInt(2, productVariantId);
                            stmt.setInt(3, serial.getStoreId());
                            Timestamp now = new Timestamp(System.currentTimeMillis());
                            stmt.setTimestamp(4, now);
                            stmt.setTimestamp(5, now);
                            stmt.executeUpdate();
                            ResultSet rs = stmt.getGeneratedKeys();
                            if (rs.next()) {
                                serial.setProductSerialId(rs.getInt(1));
                            }
                        }
                        storeQuantities.put(serial.getStoreId(), storeQuantities.getOrDefault(serial.getStoreId(), 0) + 1);
                    }

                    for (Map.Entry<Integer, Integer> entry : storeQuantities.entrySet()) {
                        try (PreparedStatement stmt = conn.prepareStatement(upsertStock)) {
                            stmt.setInt(1, entry.getKey());
                            stmt.setInt(2, productVariantId);
                            stmt.setInt(3, entry.getValue());
                            stmt.executeUpdate();
                        }
                    }
                }

                String fetchNames = "SELECT c.CategoryName, b.BrandName, s.SupplierName "
                        + "FROM Category c, Brand b, Supplier s "
                        + "WHERE c.CategoryId = ? AND b.BrandId = ? AND s.SupplierId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(fetchNames)) {
                    stmt.setInt(1, product.getCategoryId());
                    stmt.setInt(2, product.getBrandId());
                    stmt.setInt(3, product.getSupplierId());
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        product.setCategoryName(rs.getString("CategoryName"));
                        product.setBrandName(rs.getString("BrandName"));
                        product.setSupplierName(rs.getString("SupplierName"));
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

    public void updateProduct(Product product, List<List<Part>> variantImageParts, List<List<String>> variantImageUrls, HttpServletRequest request) throws IOException {
        String checkProductName = "SELECT COUNT(*) FROM Product WHERE ProductName = ? AND ProductId != ? AND Status = 'Active'";
        String updateProduct = "UPDATE Product SET ProductName = ?, Status = ?, CategoryId = ?, BrandId = ?, SupplierId = ? WHERE ProductId = ?";
        String checkProductCode = "SELECT COUNT(*) FROM ProductVariant WHERE ProductCode = ? AND ProductVariantId != ?";
        String insertVariant = "INSERT INTO ProductVariant (ProductCode, Price, WarrantyDurationMonth, ProductId) VALUES (?, ?, ?, ?)";
        String updateVariant = "UPDATE ProductVariant SET ProductCode = ?, Price = ?, WarrantyDurationMonth = ? WHERE ProductVariantId = ?";
        String deleteVariant = "DELETE FROM ProductVariant WHERE ProductVariantId = ? AND ProductId = ?";
        String insertSpec = "INSERT INTO VariantSpecification (ProductVariantId, SpecificationId, Value) VALUES (?, ?, ?)";
        String updateSpec = "UPDATE VariantSpecification SET Value = ? WHERE ProductVariantId = ? AND SpecificationId = ?";
        String deleteSpec = "DELETE FROM VariantSpecification WHERE ProductVariantId = ? AND SpecificationId = ?";
        String insertImage = "INSERT INTO ProductImage (src, alt, ProductVariantId) VALUES (?, ?, ?)";
        String updateImage = "UPDATE ProductImage SET src = ?, alt = ? WHERE ProductImageId = ?";
        String deleteImage = "DELETE FROM ProductImage WHERE ProductImageId = ? AND ProductVariantId = ?";
        String checkSerialNumber = "SELECT COUNT(*) FROM ProductSerial WHERE SerialNumber = ? AND ProductSerialId != ?";
        String insertSerial = "INSERT INTO ProductSerial (SerialNumber, ProductVariantId, StoreId, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?)";
        String updateSerial = "UPDATE ProductSerial SET SerialNumber = ?, StoreId = ?, UpdatedAt = ? WHERE ProductSerialId = ?";
        String deleteSerial = "DELETE FROM ProductSerial WHERE ProductSerialId = ? AND ProductVariantId = ?";
        String upsertStock = "MERGE INTO StoreStock AS target "
                + "USING (SELECT ? AS StoreId, ? AS ProductVariantId, ? AS Quantity) AS source "
                + "ON target.StoreId = source.StoreId AND target.ProductVariantId = source.ProductVariantId "
                + "WHEN MATCHED THEN UPDATE SET Quantity = target.Quantity + source.Quantity "
                + "WHEN NOT MATCHED THEN INSERT (StoreId, ProductVariantId, Quantity) VALUES (source.StoreId, source.ProductVariantId, source.Quantity);";
        String deleteStock = "DELETE FROM StoreStock WHERE ProductVariantId = ? AND StoreId = ?";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Check for duplicate ProductName
                try (PreparedStatement stmt = conn.prepareStatement(checkProductName)) {
                    stmt.setString(1, product.getProductName());
                    stmt.setInt(2, product.getProductId());
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new SQLException("Product with name '" + product.getProductName() + "' already exists.");
                    }
                }

                // Update Product
                try (PreparedStatement stmt = conn.prepareStatement(updateProduct)) {
                    stmt.setString(1, product.getProductName());
                    stmt.setString(2, product.getStatus());
                    stmt.setInt(3, product.getCategoryId());
                    stmt.setInt(4, product.getBrandId());
                    stmt.setInt(5, product.getSupplierId());
                    stmt.setInt(6, product.getProductId());
                    stmt.executeUpdate();
                }

                // Get existing variants
                List<Integer> existingVariantIds = new ArrayList<>();
                String selectVariants = "SELECT ProductVariantId FROM ProductVariant WHERE ProductId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(selectVariants)) {
                    stmt.setInt(1, product.getProductId());
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        existingVariantIds.add(rs.getInt("ProductVariantId"));
                    }
                }

                // Process variants
                List<Integer> submittedVariantIds = new ArrayList<>();
                for (int i = 0; i < product.getVariants().size(); i++) {
                    ProductVariant variant = product.getVariants().get(i);
                    int productVariantId = variant.getProductVariantId();
                    // Check for duplicate ProductCode
                    try (PreparedStatement stmt = conn.prepareStatement(checkProductCode)) {
                        stmt.setString(1, variant.getProductCode());
                        stmt.setInt(2, productVariantId);
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next() && rs.getInt(1) > 0) {
                            throw new SQLException("Product variant with code '" + variant.getProductCode() + "' already exists.");
                        }
                    }

                    if (productVariantId > 0) {
                        // Update existing variant
                        try (PreparedStatement stmt = conn.prepareStatement(updateVariant)) {
                            stmt.setString(1, variant.getProductCode());
                            stmt.setDouble(2, variant.getPrice());
                            stmt.setInt(3, variant.getWarrantyDurationMonth());
                            stmt.setInt(4, productVariantId);
                            stmt.executeUpdate();
                        }
                        submittedVariantIds.add(productVariantId);
                    } else {
                        // Insert new variant
                        try (PreparedStatement stmt = conn.prepareStatement(insertVariant, PreparedStatement.RETURN_GENERATED_KEYS)) {
                            stmt.setString(1, variant.getProductCode());
                            stmt.setDouble(2, variant.getPrice());
                            stmt.setInt(3, variant.getWarrantyDurationMonth());
                            stmt.setInt(4, product.getProductId());
                            stmt.executeUpdate();
                            ResultSet rs = stmt.getGeneratedKeys();
                            if (rs.next()) {
                                productVariantId = rs.getInt(1);
                                variant.setProductVariantId(productVariantId);
                                submittedVariantIds.add(productVariantId);
                                System.out.println("Inserted ProductVariant with ID: " + productVariantId);
                            } else {
                                throw new SQLException("Failed to retrieve generated ProductVariantId for ProductCode: " + variant.getProductCode());
                            }
                        }
                    }

                    // Validate ProductVariantId
                    try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM ProductVariant WHERE ProductVariantId = ?")) {
                        stmt.setInt(1, productVariantId);
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next() && rs.getInt(1) == 0) {
                            throw new SQLException("ProductVariantId " + productVariantId + " does not exist in ProductVariant table");
                        }
                    }

                    // Process specifications
                    List<Integer> existingSpecIds = new ArrayList<>();
                    String selectSpecs = "SELECT SpecificationId FROM VariantSpecification WHERE ProductVariantId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(selectSpecs)) {
                        stmt.setInt(1, productVariantId);
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                            existingSpecIds.add(rs.getInt("SpecificationId"));
                        }
                    }
                    List<Integer> submittedSpecIds = new ArrayList<>();
                    for (VariantSpecification spec : variant.getSpecifications()) {
                        int specId = spec.getSpecificationId();
                        try (PreparedStatement stmt = conn.prepareStatement(existingSpecIds.contains(specId) ? updateSpec : insertSpec)) {
                            stmt.setString(1, spec.getValue());
                            stmt.setInt(2, productVariantId);
                            stmt.setInt(3, specId);
                            stmt.executeUpdate();
                        }
                        submittedSpecIds.add(specId);
                    }
                    // Delete removed specifications
                    for (int specId : existingSpecIds) {
                        if (!submittedSpecIds.contains(specId)) {
                            try (PreparedStatement stmt = conn.prepareStatement(deleteSpec)) {
                                stmt.setInt(1, productVariantId);
                                stmt.setInt(2, specId);
                                stmt.executeUpdate();
                            }
                        }
                    }

                    // Process images
                    List<Integer> existingImageIds = new ArrayList<>();
                    String selectImages = "SELECT ProductImageId FROM ProductImage WHERE ProductVariantId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(selectImages)) {
                        stmt.setInt(1, productVariantId);
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                            existingImageIds.add(rs.getInt("ProductImageId"));
                        }
                    }
                    List<Part> imageParts = (i < variantImageParts.size()) ? variantImageParts.get(i) : new ArrayList<>();
                    List<String> imageUrls = (i < variantImageUrls.size()) ? variantImageUrls.get(i) : new ArrayList<>();
                    List<Integer> submittedImageIds = new ArrayList<>();
                    for (int j = 0; j < Math.max(imageParts.size(), imageUrls.size()); j++) {
                        String finalSrc = null;
                        String altText = product.getProductName() + " Variant " + (i + 1) + " Image " + (j + 1);
                        Part imagePart = (j < imageParts.size()) ? imageParts.get(j) : null;
                        String imageUrl = (j < imageUrls.size()) ? imageUrls.get(j) : null;
                        int imageId = (j < variant.getImages().size()) ? variant.getImages().get(j).getProductImageId() : 0;
                        if (imagePart != null && imagePart.getSize() > 0) {
                            String fileName = UUID.randomUUID().toString() + "_" + imagePart.getSubmittedFileName();
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
                        } else if (imageId > 0) {
                            finalSrc = variant.getImages().get(j).getSrc();
                            altText = variant.getImages().get(j).getAlt();
                        }
                        if (finalSrc != null) {
                            if (imageId > 0) {
                                try (PreparedStatement stmt = conn.prepareStatement(updateImage)) {
                                    stmt.setString(1, finalSrc);
                                    stmt.setString(2, altText);
                                    stmt.setInt(3, imageId);
                                    stmt.executeUpdate();
                                }
                                submittedImageIds.add(imageId);
                            } else {
                                try (PreparedStatement stmt = conn.prepareStatement(insertImage, PreparedStatement.RETURN_GENERATED_KEYS)) {
                                    stmt.setString(1, finalSrc);
                                    stmt.setString(2, altText);
                                    stmt.setInt(3, productVariantId);
                                    stmt.executeUpdate();
                                    ResultSet rs = stmt.getGeneratedKeys();
                                    if (rs.next()) {
                                        submittedImageIds.add(rs.getInt(1));
                                    }
                                }
                            }
                        }
                    }
                    // Delete removed images
                    for (int imageId : existingImageIds) {
                        if (!submittedImageIds.contains(imageId)) {
                            try (PreparedStatement stmt = conn.prepareStatement(deleteImage)) {
                                stmt.setInt(1, imageId);
                                stmt.setInt(2, productVariantId);
                                stmt.executeUpdate();
                            }
                        }
                    }

                    // Process serials
                    List<Integer> existingSerialIds = new ArrayList<>();
                    String selectSerials = "SELECT ProductSerialId FROM ProductSerial WHERE ProductVariantId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(selectSerials)) {
                        stmt.setInt(1, productVariantId);
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                            existingSerialIds.add(rs.getInt("ProductSerialId"));
                        }
                    }
                    Map<Integer, Integer> storeQuantities = new HashMap<>();
                    List<Integer> submittedSerialIds = new ArrayList<>();
                    for (ProductSerial serial : variant.getSerials()) {
                        int serialId = serial.getProductSerialId();
                        // Check for duplicate SerialNumber
                        try (PreparedStatement stmt = conn.prepareStatement(checkSerialNumber)) {
                            stmt.setString(1, serial.getSerialNumber());
                            stmt.setInt(2, serialId);
                            ResultSet rs = stmt.executeQuery();
                            if (rs.next() && rs.getInt(1) > 0) {
                                throw new SQLException("Serial number '" + serial.getSerialNumber() + "' already exists.");
                            }
                        }

                        if (serialId > 0) {
                            try (PreparedStatement stmt = conn.prepareStatement(updateSerial)) {
                                stmt.setString(1, serial.getSerialNumber());
                                stmt.setInt(2, serial.getStoreId());
                                stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                                stmt.setInt(4, serialId);
                                stmt.executeUpdate();
                            }
                            submittedSerialIds.add(serialId);
                        } else {
                            try (PreparedStatement stmt = conn.prepareStatement(insertSerial, PreparedStatement.RETURN_GENERATED_KEYS)) {
                                stmt.setString(1, serial.getSerialNumber());
                                stmt.setInt(2, productVariantId);
                                stmt.setInt(3, serial.getStoreId());
                                Timestamp now = new Timestamp(System.currentTimeMillis());
                                stmt.setTimestamp(4, now);
                                stmt.setTimestamp(5, now);
                                stmt.executeUpdate();
                                ResultSet rs = stmt.getGeneratedKeys();
                                if (rs.next()) {
                                    serial.setProductSerialId(rs.getInt(1));
                                    submittedSerialIds.add(rs.getInt(1));
                                }
                            }
                        }
                        storeQuantities.put(serial.getStoreId(), storeQuantities.getOrDefault(serial.getStoreId(), 0) + 1);
                    }
                    // Delete removed serials
                    for (int serialId : existingSerialIds) {
                        if (!submittedSerialIds.contains(serialId)) {
                            int storeId = 0;
                            String selectSerialStore = "SELECT StoreId FROM ProductSerial WHERE ProductSerialId = ?";
                            try (PreparedStatement stmt = conn.prepareStatement(selectSerialStore)) {
                                stmt.setInt(1, serialId);
                                ResultSet rs = stmt.executeQuery();
                                if (rs.next()) {
                                    storeId = rs.getInt("StoreId");
                                }
                            }
                            try (PreparedStatement stmt = conn.prepareStatement(deleteSerial)) {
                                stmt.setInt(1, serialId);
                                stmt.setInt(2, productVariantId);
                                stmt.executeUpdate();
                            }
                            try (PreparedStatement stmt = conn.prepareStatement("UPDATE StoreStock SET Quantity = Quantity - 1 WHERE StoreId = ? AND ProductVariantId = ? AND Quantity > 0")) {
                                stmt.setInt(1, storeId);
                                stmt.setInt(2, productVariantId);
                                stmt.executeUpdate();
                            }
                        }
                    }
                    // Update StoreStock
                    for (Map.Entry<Integer, Integer> entry : storeQuantities.entrySet()) {
                        try (PreparedStatement stmt = conn.prepareStatement(upsertStock)) {
                            stmt.setInt(1, entry.getKey());
                            stmt.setInt(2, productVariantId);
                            stmt.setInt(3, entry.getValue());
                            stmt.executeUpdate();
                        }
                    }
                }

                // Delete removed variants
                for (int variantId : existingVariantIds) {
                    if (!submittedVariantIds.contains(variantId)) {
                        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM VariantSpecification WHERE ProductVariantId = ?")) {
                            stmt.setInt(1, variantId);
                            stmt.executeUpdate();
                        }
                        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM ProductImage WHERE ProductVariantId = ?")) {
                            stmt.setInt(1, variantId);
                            stmt.executeUpdate();
                        }
                        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM ProductSerial WHERE ProductVariantId = ?")) {
                            stmt.setInt(1, variantId);
                            stmt.executeUpdate();
                        }
                        String selectStocks = "SELECT StoreId FROM StoreStock WHERE ProductVariantId = ?";
                        List<Integer> storeIds = new ArrayList<>();
                        try (PreparedStatement stmt = conn.prepareStatement(selectStocks)) {
                            stmt.setInt(1, variantId);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                                storeIds.add(rs.getInt("StoreId"));
                            }
                        }
                        for (int storeId : storeIds) {
                            try (PreparedStatement stmt = conn.prepareStatement(deleteStock)) {
                                stmt.setInt(1, variantId);
                                stmt.setInt(2, storeId);
                                stmt.executeUpdate();
                            }
                        }
                        try (PreparedStatement stmt = conn.prepareStatement(deleteVariant)) {
                            stmt.setInt(1, variantId);
                            stmt.setInt(2, product.getProductId());
                            stmt.executeUpdate();
                        }
                    }
                }

                // Fetch CategoryName, BrandName, SupplierName
                String fetchNames = "SELECT c.CategoryName, b.BrandName, s.SupplierName "
                        + "FROM Category c, Brand b, Supplier s "
                        + "WHERE c.CategoryId = ? AND b.BrandId = ? AND s.SupplierId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(fetchNames)) {
                    stmt.setInt(1, product.getCategoryId());
                    stmt.setInt(2, product.getBrandId());
                    stmt.setInt(3, product.getSupplierId());
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        product.setCategoryName(rs.getString("CategoryName"));
                        product.setBrandName(rs.getString("BrandName"));
                        product.setSupplierName(rs.getString("SupplierName"));
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

    private String getUploadPath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("/" + UPLOAD_DIR);
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.ProductId, p.ProductName, p.Status, p.CategoryId, c.CategoryName,
                   p.BrandId, b.BrandName, p.SupplierId, s.SupplierName,
                   pv.ProductVariantId, pv.ProductCode, pv.Price
            FROM Product p 
            JOIN Category c ON p.CategoryId = c.CategoryId 
            JOIN Brand b ON p.BrandId = b.BrandId 
            JOIN Supplier s ON p.SupplierId = s.SupplierId
            JOIN ProductVariant pv ON p.ProductId = pv.ProductId
            WHERE p.Status = 'Active'
            ORDER BY p.ProductId, pv.ProductVariantId
            """;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
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
        String sql = "SELECT pv.ProductVariantId, pv.ProductCode, pv.Price, pv.WarrantyDurationMonth, pv.ProductId "
                + "FROM ProductVariant pv WHERE pv.ProductId = ?";
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
        String sql = "SELECT vs.ProductVariantId, vs.SpecificationId, vs.Value "
                + "FROM VariantSpecification vs WHERE vs.ProductVariantId = ?";
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
        String sql = "SELECT pi.ProductImageId, pi.src, pi.alt, pi.ProductVariantId "
                + "FROM ProductImage pi WHERE pi.ProductVariantId = ?";
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
        String sql = "SELECT ps.ProductSerialId, ps.SerialNumber, ps.ProductVariantId, ps.StoreId, s.StoreName, ps.CreatedAt, ps.UpdatedAt "
                + "FROM ProductSerial ps JOIN Store s ON ps.StoreId = s.StoreId WHERE ps.ProductVariantId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productVariantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductSerial serial = new ProductSerial();
                    serial.setProductSerialId(rs.getInt("ProductSerialId"));
                    serial.setSerialNumber(rs.getString("SerialNumber"));
                    serial.setProductVariantId(rs.getInt("ProductVariantId"));
                    serial.setStoreId(rs.getInt("StoreId"));
                    serial.setStoreName(rs.getString("StoreName"));
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
        String sql = "SELECT p.ProductId, p.ProductName, p.Status, p.CategoryId, c.CategoryName, "
                + "p.BrandId, b.BrandName, p.SupplierId, s.SupplierName "
                + "FROM Product p "
                + "JOIN Category c ON p.CategoryId = c.CategoryId "
                + "JOIN Brand b ON p.BrandId = b.BrandId "
                + "JOIN Supplier s ON p.SupplierId = s.SupplierId "
                + "WHERE p.ProductId = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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
                    product.setVariants(getVariantsByProductId(product.getProductId(), conn));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving product: " + e.getMessage(), e);
        }
        return product;
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
                + "FROM Supplier WHERE Status = 'Active'";
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
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
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

    public List<Store> getAllStores() {
        List<Store> stores = new ArrayList<>();
        String sql = "SELECT StoreId, StoreName, Address, Phone, Status FROM Store WHERE Status = 'Active'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Store store = new Store(
                        rs.getInt("StoreId"),
                        rs.getString("StoreName"),
                        rs.getString("Address"),
                        rs.getString("Phone"),
                        rs.getString("Status")
                );
                stores.add(store);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving stores: " + e.getMessage(), e);
        }
        return stores;
    }

    public List<Product> getFilteredAndSortedProducts(String categoryId, String brandId, String status,
            Double minPrice, Double maxPrice, String sortBy, String sortOrder) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.ProductId, p.ProductName, p.Status, p.CategoryId, c.CategoryName, "
                + "p.BrandId, b.BrandName, p.SupplierId, s.SupplierName "
                + "FROM Product p "
                + "JOIN Category c ON p.CategoryId = c.CategoryId "
                + "JOIN Brand b ON p.BrandId = b.BrandId "
                + "JOIN Supplier s ON p.SupplierId = s.SupplierId WHERE 1=1 ");
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
        if (sortBy != null && !sortBy.isEmpty()) {
            if ("price".equals(sortBy)) {
                sql.append("ORDER BY (SELECT MIN(Price) FROM ProductVariant pv WHERE pv.ProductId = p.ProductId) ");
            } else if ("name".equals(sortBy)) {
                sql.append("ORDER BY p.ProductName ");
            }
            sql.append(sortOrder != null && "desc".equalsIgnoreCase(sortOrder) ? "DESC " : "ASC ");
        }
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
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
                    product.setVariants(getVariantsByProductId(product.getProductId(), conn));
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving filtered and sorted products: " + e.getMessage(), e);
        }
        return products;
    }

    public ProductVariant getVariantById(int productVariantId) {
        ProductVariant variant = null;
        String sql = "SELECT pv.ProductVariantId, pv.ProductCode, pv.Price, pv.WarrantyDurationMonth, p.ProductId, p.ProductName, p.Status, "
                + "c.CategoryName, b.BrandName, s.SupplierName "
                + "FROM ProductVariant pv "
                + "JOIN Product p ON pv.ProductId = p.ProductId "
                + "LEFT JOIN Category c ON p.CategoryId = c.CategoryId "
                + "LEFT JOIN Brand b ON p.BrandId = b.BrandId "
                + "LEFT JOIN Supplier s ON p.SupplierId = s.SupplierId "
                + "WHERE pv.ProductVariantId = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productVariantId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                variant = new ProductVariant();
                variant.setProductVariantId(rs.getInt("ProductVariantId"));
                variant.setProductCode(rs.getString("ProductCode"));
                variant.setPrice(rs.getDouble("Price"));
                variant.setWarrantyDurationMonth(rs.getInt("WarrantyDurationMonth"));
                variant.setProductId(rs.getInt("ProductId"));
                variant.setProductName(rs.getString("ProductName"));
                variant.setStatus(rs.getString("Status"));
                variant.setCategoryName(rs.getString("CategoryName"));
                variant.setBrandName(rs.getString("BrandName"));
                variant.setSupplierName(rs.getString("SupplierName"));
                variant.setSpecifications(getSpecificationsByVariantId(productVariantId, conn));
                variant.setImages(getImagesByVariantId(productVariantId, conn));
                variant.setSerials(getSerialsByVariantId(productVariantId, conn));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving variant: " + e.getMessage(), e);
        }
        return variant;
    }

    public void updateProductVariant(ProductVariant variant, List<Part> imageParts, List<String> imageUrls, HttpServletRequest request) throws IOException, SQLException {
        String updateVariant = "UPDATE ProductVariant SET ProductCode = ?, Price = ?, WarrantyDurationMonth = ? WHERE ProductVariantId = ?";
        String insertSpec = "INSERT INTO VariantSpecification (ProductVariantId, SpecificationId, Value) VALUES (?, ?, ?)";
        String updateSpec = "UPDATE VariantSpecification SET Value = ? WHERE ProductVariantId = ? AND SpecificationId = ?";
        String deleteSpec = "DELETE FROM VariantSpecification WHERE ProductVariantId = ? AND SpecificationId = ?";
        String insertImage = "INSERT INTO ProductImage (src, alt, ProductVariantId) VALUES (?, ?, ?)";
        String updateImage = "UPDATE ProductImage SET src = ?, alt = ? WHERE ProductImageId = ?";
        String deleteImage = "DELETE FROM ProductImage WHERE ProductImageId = ? AND ProductVariantId = ?";
        String insertSerial = "INSERT INTO ProductSerial (SerialNumber, ProductVariantId, StoreId, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?)";
        String updateSerial = "UPDATE ProductSerial SET SerialNumber = ?, StoreId = ?, UpdatedAt = ? WHERE ProductSerialId = ?";
        String deleteSerial = "DELETE FROM ProductSerial WHERE ProductSerialId = ? AND ProductVariantId = ?";
        String upsertStock = "MERGE INTO StoreStock AS target "
                + "USING (SELECT ? AS StoreId, ? AS ProductVariantId, ? AS Quantity) AS source "
                + "ON target.StoreId = source.StoreId AND target.ProductVariantId = source.ProductVariantId "
                + "WHEN MATCHED THEN UPDATE SET Quantity = target.Quantity + source.Quantity "
                + "WHEN NOT MATCHED THEN INSERT (StoreId, ProductVariantId, Quantity) VALUES (source.StoreId, source.ProductVariantId, source.Quantity);";
        String deleteStock = "DELETE FROM StoreStock WHERE ProductVariantId = ? AND StoreId = ?";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Update variant details
                try (PreparedStatement stmt = conn.prepareStatement(updateVariant)) {
                    stmt.setString(1, variant.getProductCode());
                    stmt.setDouble(2, variant.getPrice());
                    stmt.setInt(3, variant.getWarrantyDurationMonth());
                    stmt.setInt(4, variant.getProductVariantId());
                    stmt.executeUpdate();
                }

                // Process specifications
                List<Integer> existingSpecIds = new ArrayList<>();
                String selectSpecs = "SELECT SpecificationId FROM VariantSpecification WHERE ProductVariantId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(selectSpecs)) {
                    stmt.setInt(1, variant.getProductVariantId());
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        existingSpecIds.add(rs.getInt("SpecificationId"));
                    }
                }

                List<Integer> submittedSpecIds = new ArrayList<>();
                for (VariantSpecification spec : variant.getSpecifications()) {
                    int specId = spec.getSpecificationId();
                    String value = spec.getValue();
                    if (value != null && !value.trim().isEmpty()) {
                        try (PreparedStatement stmt = conn.prepareStatement(existingSpecIds.contains(specId) ? updateSpec : insertSpec)) {
                            stmt.setString(1, value);
                            stmt.setInt(2, variant.getProductVariantId());
                            stmt.setInt(3, specId);
                            stmt.executeUpdate();
                        }
                        submittedSpecIds.add(specId);
                    }
                }

                // Delete removed specifications
                for (int specId : existingSpecIds) {
                    if (!submittedSpecIds.contains(specId)) {
                        try (PreparedStatement stmt = conn.prepareStatement(deleteSpec)) {
                            stmt.setInt(1, variant.getProductVariantId());
                            stmt.setInt(2, specId);
                            stmt.executeUpdate();
                        }
                    }
                }

                // Process images
                List<Integer> existingImageIds = new ArrayList<>();
                String selectImages = "SELECT ProductImageId FROM ProductImage WHERE ProductVariantId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(selectImages)) {
                    stmt.setInt(1, variant.getProductVariantId());
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        existingImageIds.add(rs.getInt("ProductImageId"));
                    }
                }

                List<Integer> submittedImageIds = new ArrayList<>();
                for (int i = 0; i < Math.max(imageParts.size(), imageUrls.size()); i++) {
                    String finalSrc = null;
                    String altText = variant.getProductName() + " Image " + (i + 1);
                    Part imagePart = (i < imageParts.size()) ? imageParts.get(i) : null;
                    String imageUrl = (i < imageUrls.size()) ? imageUrls.get(i) : null;
                    int imageId = (i < variant.getImages().size()) ? variant.getImages().get(i).getProductImageId() : 0;

                    if (imagePart != null && imagePart.getSize() > 0) {
                        String fileName = UUID.randomUUID().toString() + "_" + imagePart.getSubmittedFileName();
                        String uploadPath = getUploadPath(request);
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        String fullPath = uploadPath + File.separator + fileName;
                        imagePart.write(fullPath);
                        finalSrc = UPLOAD_DIR + "/" + fileName;
                    } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                        finalSrc = imageUrl;
                    } else if (imageId > 0) {
                        finalSrc = variant.getImages().get(i).getSrc();
                        altText = variant.getImages().get(i).getAlt();
                    }

                    if (finalSrc != null) {
                        if (imageId > 0) {
                            try (PreparedStatement stmt = conn.prepareStatement(updateImage)) {
                                stmt.setString(1, finalSrc);
                                stmt.setString(2, altText);
                                stmt.setInt(3, imageId);
                                stmt.executeUpdate();
                            }
                            submittedImageIds.add(imageId);
                        } else {
                            try (PreparedStatement stmt = conn.prepareStatement(insertImage, PreparedStatement.RETURN_GENERATED_KEYS)) {
                                stmt.setString(1, finalSrc);
                                stmt.setString(2, altText);
                                stmt.setInt(3, variant.getProductVariantId());
                                stmt.executeUpdate();
                                ResultSet rs = stmt.getGeneratedKeys();
                                if (rs.next()) {
                                    submittedImageIds.add(rs.getInt(1));
                                }
                            }
                        }
                    }
                }

                // Delete removed images
                for (int imageId : existingImageIds) {
                    if (!submittedImageIds.contains(imageId)) {
                        try (PreparedStatement stmt = conn.prepareStatement(deleteImage)) {
                            stmt.setInt(1, imageId);
                            stmt.setInt(2, variant.getProductVariantId());
                            stmt.executeUpdate();
                        }
                    }
                }

                // Process serials
                List<Integer> existingSerialIds = new ArrayList<>();
                String selectSerials = "SELECT ProductSerialId, StoreId FROM ProductSerial WHERE ProductVariantId = ?";
                Map<Integer, Integer> oldStoreQuantities = new HashMap<>();
                try (PreparedStatement stmt = conn.prepareStatement(selectSerials)) {
                    stmt.setInt(1, variant.getProductVariantId());
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        existingSerialIds.add(rs.getInt("ProductSerialId"));
                        int storeId = rs.getInt("StoreId");
                        oldStoreQuantities.put(storeId, oldStoreQuantities.getOrDefault(storeId, 0) + 1);
                    }
                }

                Map<Integer, Integer> newStoreQuantities = new HashMap<>();
                List<Integer> submittedSerialIds = new ArrayList<>();
                for (ProductSerial serial : variant.getSerials()) {
                    int serialId = serial.getProductSerialId();
                    if (serial.getSerialNumber() != null && !serial.getSerialNumber().trim().isEmpty() && serial.getStoreId() > 0) {
                        if (serialId > 0) {
                            try (PreparedStatement stmt = conn.prepareStatement(updateSerial)) {
                                stmt.setString(1, serial.getSerialNumber());
                                stmt.setInt(2, serial.getStoreId());
                                stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                                stmt.setInt(4, serialId);
                                stmt.executeUpdate();
                            }
                            submittedSerialIds.add(serialId);
                        } else {
                            try (PreparedStatement stmt = conn.prepareStatement(insertSerial, PreparedStatement.RETURN_GENERATED_KEYS)) {
                                stmt.setString(1, serial.getSerialNumber());
                                stmt.setInt(2, variant.getProductVariantId());
                                stmt.setInt(3, serial.getStoreId());
                                Timestamp now = new Timestamp(System.currentTimeMillis());
                                stmt.setTimestamp(4, now);
                                stmt.setTimestamp(5, now);
                                stmt.executeUpdate();
                                ResultSet rs = stmt.getGeneratedKeys();
                                if (rs.next()) {
                                    serial.setProductSerialId(rs.getInt(1));
                                    submittedSerialIds.add(rs.getInt(1));
                                }
                            }
                        }
                        newStoreQuantities.put(serial.getStoreId(), newStoreQuantities.getOrDefault(serial.getStoreId(), 0) + 1);
                    }
                }

                // Delete removed serials
                for (int serialId : existingSerialIds) {
                    if (!submittedSerialIds.contains(serialId)) {
                        int storeId = 0;
                        String selectSerialStore = "SELECT StoreId FROM ProductSerial WHERE ProductSerialId = ?";
                        try (PreparedStatement stmt = conn.prepareStatement(selectSerialStore)) {
                            stmt.setInt(1, serialId);
                            ResultSet rs = stmt.executeQuery();
                            if (rs.next()) {
                                storeId = rs.getInt("StoreId");
                            }
                        }
                        try (PreparedStatement stmt = conn.prepareStatement(deleteSerial)) {
                            stmt.setInt(1, serialId);
                            stmt.setInt(2, variant.getProductVariantId());
                            stmt.executeUpdate();
                        }
                        try (PreparedStatement stmt = conn.prepareStatement("UPDATE StoreStock SET Quantity = Quantity - 1 WHERE StoreId = ? AND ProductVariantId = ? AND Quantity > 0")) {
                            stmt.setInt(1, storeId);
                            stmt.setInt(2, variant.getProductVariantId());
                            stmt.executeUpdate();
                        }
                    }
                }

                // Update StoreStock
                for (Map.Entry<Integer, Integer> entry : newStoreQuantities.entrySet()) {
                    try (PreparedStatement stmt = conn.prepareStatement(upsertStock)) {
                        stmt.setInt(1, entry.getKey());
                        stmt.setInt(2, variant.getProductVariantId());
                        stmt.setInt(3, entry.getValue());
                        stmt.executeUpdate();
                    }
                }

                // Clean up StoreStock for stores with zero quantity
                for (Map.Entry<Integer, Integer> entry : oldStoreQuantities.entrySet()) {
                    int storeId = entry.getKey();
                    if (!newStoreQuantities.containsKey(storeId)) {
                        try (PreparedStatement stmt = conn.prepareStatement(deleteStock)) {
                            stmt.setInt(1, variant.getProductVariantId());
                            stmt.setInt(2, storeId);
                            stmt.executeUpdate();
                        }
                    }
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw new RuntimeException("Error updating variant: " + e.getMessage(), e);
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}
