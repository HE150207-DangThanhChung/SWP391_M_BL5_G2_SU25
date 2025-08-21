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

@WebServlet(name = "EditVariantController", urlPatterns = {"/editVariant"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB max file size
public class EditVariantController extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int productVariantId = Integer.parseInt(request.getParameter("productVariantId"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            ProductVariant variant = productDAO.getVariantById(productVariantId);
            List<Attribute> allAttributes = productDAO.getAllAttributes();
            Map<Integer, List<AttributeOption>> attributeOptions = new HashMap<>();
            for (Attribute attribute : allAttributes) {
                attributeOptions.put(attribute.getAttributeId(), productDAO.getAttributeOptionsByAttributeId(attribute.getAttributeId()));
            }
            List<Store> stores = productDAO.getAllStores();

            if (variant == null) {
                request.setAttribute("error", "Không tìm thấy biến thể.");
                request.getRequestDispatcher("views/product/productDetail.jsp").forward(request, response);
                return;
            }

            request.setAttribute("variant", variant);
            request.setAttribute("productId", productId);
            request.setAttribute("allAttributes", allAttributes);
            request.setAttribute("attributeOptions", attributeOptions);
            request.setAttribute("stores", stores);
            request.getRequestDispatcher("views/product/editProductVariant.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID biến thể hoặc sản phẩm không hợp lệ.");
            request.getRequestDispatcher("views/product/productDetail.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
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

            // Process attributes
            List<AttributeOption> attributes = new ArrayList<>();
            String[] attributeOptionIds = request.getParameterValues("attributeOptionId[]");
            if (attributeOptionIds != null) {
                for (String optionIdStr : attributeOptionIds) {
                    if (optionIdStr != null && !optionIdStr.isEmpty()) {
                        AttributeOption attrOption = new AttributeOption();
                        attrOption.setAttributeOptionId(Integer.parseInt(optionIdStr));
                        // Fetch AttributeOption details
                        List<AttributeOption> options = productDAO.getAttributeOptionsByAttributeId(
                            productDAO.getAllAttributes().stream()
                                .filter(attr -> productDAO.getAttributeOptionsByAttributeId(attr.getAttributeId())
                                    .stream().anyMatch(opt -> opt.getAttributeOptionId() == Integer.parseInt(optionIdStr)))
                                .findFirst().map(Attribute::getAttributeId).orElse(0)
                        );
                        options.stream()
                            .filter(opt -> opt.getAttributeOptionId() == Integer.parseInt(optionIdStr))
                            .findFirst()
                            .ifPresent(opt -> {
                                attrOption.setValue(opt.getValue());
                                attrOption.setAttribute(opt.getAttribute());
                            });
                        attributes.add(attrOption);
                    }
                }
            }
            variant.setAttributes(attributes);

            // Process images
            List<Part> imageParts = new ArrayList<>();
            List<String> imageUrls = new ArrayList<>();
            List<ProductImage> images = new ArrayList<>();
            ProductVariant existingVariant = productDAO.getVariantById(productVariantId);
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
            // Handle new image
            Part newImageFile = request.getPart("newImageFile");
            String newImageUrl = request.getParameter("newImageUrl");
            if (newImageFile != null && newImageFile.getSize() > 0) {
                imageParts.add(newImageFile);
            } else if (newImageUrl != null && !newImageUrl.trim().isEmpty()) {
                imageUrls.add(newImageUrl);
            }
            variant.setImages(images);

            // Process serials
            List<ProductSerial> serials = new ArrayList<>();
            for (ProductSerial existingSerial : existingVariant.getSerials()) {
                String serialIdParam = request.getParameter("serialId_" + existingSerial.getProductSerialId());
                if (serialIdParam != null) {
                    String serialNumber = request.getParameter("serialNumber_" + existingSerial.getProductSerialId());
                    String storeIdStr = request.getParameter("storeId_" + existingSerial.getProductSerialId());
                    String serialStatus = request.getParameter("serialStatus_" + existingSerial.getProductSerialId());
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
            // Handle new serial
            String newSerialNumber = request.getParameter("newSerialNumber");
            String newStoreId = request.getParameter("newStoreId");
            String newSerialStatus = request.getParameter("newSerialStatus");
            if (newSerialNumber != null && !newSerialNumber.trim().isEmpty() && newStoreId != null && !newStoreId.trim().isEmpty()) {
                ProductSerial serial = new ProductSerial();
                serial.setSerialNumber(newSerialNumber);
                serial.setStoreId(Integer.parseInt(newStoreId));
                serial.setProductVariantId(productVariantId);
                serials.add(serial);
            }
            variant.setSerials(serials);

            // Update variant in database
            productDAO.updateProductVariant(variant, imageParts, imageUrls, request);

            // Redirect to product detail page
            response.sendRedirect(request.getContextPath() + "/product/detail?productId=" + productId);
        } catch (SQLException | NumberFormatException e) {
            request.setAttribute("error", "Lỗi khi cập nhật biến thể: " + e.getMessage());
            request.getRequestDispatcher("views/product/editProductVariant.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Edit Variant Controller Servlet";
    }
}