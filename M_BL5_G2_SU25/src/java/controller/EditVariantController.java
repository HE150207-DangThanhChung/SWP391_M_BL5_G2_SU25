package controller;

import dal.ProductDAO;
import model.ProductVariant;
import model.ProductSerial;
import model.AttributeOption;
import model.ProductImage;
import model.Attribute;
import model.Store;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "EditVariantController", urlPatterns = {"/editVariant"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB max file size
public class EditVariantController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EditVariantController.class.getName());
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");

            int productVariantId = Integer.parseInt(request.getParameter("productVariantId"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            ProductVariant variant = productDAO.getVariantById(productVariantId);
            if (variant == null) {
                LOGGER.log(Level.WARNING, "Variant not found for ID: {0}", productVariantId);
                request.setAttribute("error", "Không tìm thấy biến thể.");
                request.getRequestDispatcher("/views/product/productDetail.jsp").forward(request, response);
                return;
            }

            List<Attribute> allAttributes = productDAO.getAllAttributes();
            Map<Integer, List<AttributeOption>> attributeOptions = new HashMap<>();
            for (Attribute attribute : allAttributes) {
                attributeOptions.put(attribute.getAttributeId(), productDAO.getAttributeOptionsByAttributeId(attribute.getAttributeId()));
            }
            List<Store> stores = productDAO.getAllStores();

            request.setAttribute("variant", variant);
            request.setAttribute("productId", productId);
            request.setAttribute("allAttributes", allAttributes);
            request.setAttribute("attributeOptions", attributeOptions);
            request.setAttribute("stores", stores);
            request.getRequestDispatcher("/views/product/editProductVariant.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid productVariantId or productId", e);
            request.setAttribute("error", "ID biến thể hoặc sản phẩm không hợp lệ.");
            request.getRequestDispatcher("/views/product/productDetail.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in doGet", e);
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/views/product/productDetail.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setBufferSize(8192); // Increase buffer size to avoid premature flush

            int productVariantId = Integer.parseInt(request.getParameter("productVariantId"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            String productCode = request.getParameter("productCode");
            double price = Double.parseDouble(request.getParameter("price"));
            int warrantyDurationMonth = Integer.parseInt(request.getParameter("warrantyDurationMonth"));

            ProductVariant variant = new ProductVariant();
            variant.setProductVariantId(productVariantId);
            variant.setProductId(productId);
            variant.setProductCode(productCode);
            variant.setPrice(price);
            variant.setWarrantyDurationMonth(warrantyDurationMonth);

            // Cache attributes to avoid redundant database calls
            List<Attribute> allAttributes = productDAO.getAllAttributes();
            Map<Integer, List<AttributeOption>> attributeOptionsCache = new HashMap<>();
            for (Attribute attribute : allAttributes) {
                attributeOptionsCache.put(attribute.getAttributeId(), productDAO.getAttributeOptionsByAttributeId(attribute.getAttributeId()));
            }

            // Process attributes
            List<AttributeOption> attributes = new ArrayList<>();
            String[] attributeOptionIds = request.getParameterValues("attributeOptionId[]");
            if (attributeOptionIds != null) {
                for (String optionIdStr : attributeOptionIds) {
                    if (optionIdStr != null && !optionIdStr.isEmpty()) {
                        try {
                            int optionId = Integer.parseInt(optionIdStr);
                            AttributeOption attrOption = new AttributeOption();
                            attrOption.setAttributeOptionId(optionId);
                            for (List<AttributeOption> options : attributeOptionsCache.values()) {
                                options.stream()
                                    .filter(opt -> opt.getAttributeOptionId() == optionId)
                                    .findFirst()
                                    .ifPresent(opt -> {
                                        attrOption.setValue(opt.getValue());
                                        attrOption.setAttribute(opt.getAttribute());
                                    });
                            }
                            if (attrOption.getValue() != null) {
                                attributes.add(attrOption);
                            } else {
                                LOGGER.log(Level.WARNING, "Invalid attributeOptionId: {0}", optionIdStr);
                            }
                        } catch (NumberFormatException e) {
                            LOGGER.log(Level.WARNING, "Invalid attributeOptionId format: {0}", optionIdStr);
                        }
                    }
                }
            }
            variant.setAttributes(attributes);

            // Process images
            List<Part> imageParts = new ArrayList<>();
            List<String> imageUrls = new ArrayList<>();
            List<ProductImage> images = new ArrayList<>();
            ProductVariant existingVariant = productDAO.getVariantById(productVariantId);
            if (existingVariant == null) {
                throw new SQLException("Variant not found for ID: " + productVariantId);
            }
            for (ProductImage existingImage : existingVariant.getImages()) {
                String imageIdParam = request.getParameter("imageId_" + existingImage.getProductImageId());
                if (imageIdParam != null) {
                    String imageUrl = request.getParameter("imageUrl_" + existingImage.getProductImageId());
                    Part imageFile = request.getPart("imageFile_" + existingImage.getProductImageId());
                    if (imageFile != null && imageFile.getSize() > 0) {
                        imageParts.add(imageFile);
                    } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                        imageUrls.add(imageUrl);
                    } else {
                        imageUrls.add(existingImage.getSrc());
                    }
                    ProductImage image = new ProductImage();
                    image.setProductImageId(existingImage.getProductImageId());
                    image.setProductVariantId(productVariantId);
                    image.setSrc(imageUrl != null && !imageUrl.trim().isEmpty() ? imageUrl : existingImage.getSrc());
                    image.setAlt(variant.getProductName() != null ? variant.getProductName() + " Image" : existingImage.getAlt());
                    images.add(image);
                }
            }
            // Handle new images
            String[] newImageUrls = request.getParameterValues("newImageUrl[]");
            for (Part part : request.getParts()) {
                if (part.getName().startsWith("newImageFile[")) {
                    if (part.getSize() > 0) {
                        imageParts.add(part);
                    }
                }
            }
            if (newImageUrls != null) {
                for (String url : newImageUrls) {
                    if (url != null && !url.trim().isEmpty()) {
                        imageUrls.add(url);
                        ProductImage image = new ProductImage();
                        image.setProductVariantId(productVariantId);
                        image.setSrc(url);
                        image.setAlt(variant.getProductName() != null ? variant.getProductName() + " Image" : "New Image");
                        images.add(image);
                    }
                }
            }
            variant.setImages(images);

            // Process serials
            List<ProductSerial> serials = new ArrayList<>();
            for (ProductSerial existingSerial : existingVariant.getSerials()) {
                String serialIdParam = request.getParameter("serialId_" + existingSerial.getProductSerialId());
                if (serialIdParam != null) {
                    String serialNumber = request.getParameter("serialNumber_" + existingSerial.getProductSerialId());
                    String storeIdStr = request.getParameter("storeId_" + existingSerial.getProductSerialId());
                    if (serialNumber != null && !serialNumber.isEmpty() && storeIdStr != null && !storeIdStr.isEmpty()) {
                        ProductSerial serial = new ProductSerial();
                        serial.setProductSerialId(existingSerial.getProductSerialId());
                        serial.setSerialNumber(serialNumber);
                        serial.setStoreId(Integer.parseInt(storeIdStr));
                        serial.setProductVariantId(productVariantId);
                        serials.add(serial);
                    }
                }
            }
            // Handle new serials
            String[] newSerialNumbers = request.getParameterValues("newSerialNumber[]");
            String[] newStoreIds = request.getParameterValues("newStoreId[]");
            if (newSerialNumbers != null && newStoreIds != null) {
                for (int i = 0; i < Math.min(newSerialNumbers.length, newStoreIds.length); i++) {
                    if (newSerialNumbers[i] != null && !newSerialNumbers[i].trim().isEmpty() &&
                        newStoreIds[i] != null && !newStoreIds[i].trim().isEmpty()) {
                        ProductSerial serial = new ProductSerial();
                        serial.setSerialNumber(newSerialNumbers[i]);
                        serial.setStoreId(Integer.parseInt(newStoreIds[i]));
                        serial.setProductVariantId(productVariantId);
                        serials.add(serial);
                    }
                }
            }
            variant.setSerials(serials);

            // Update variant in database
            productDAO.updateProductVariant(variant, imageParts, imageUrls, request);

            // Redirect to product detail page
            response.sendRedirect(request.getContextPath() + "/product/detail?productId=" + productId);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid input format", e);
            request.setAttribute("error", "Dữ liệu đầu vào không hợp lệ: " + e.getMessage());
            doGet(request, response); // Re-render form with error
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while updating variant", e);
            request.setAttribute("error", "Lỗi khi cập nhật biến thể: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in doPost", e);
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Edit Variant Controller Servlet";
    }
}