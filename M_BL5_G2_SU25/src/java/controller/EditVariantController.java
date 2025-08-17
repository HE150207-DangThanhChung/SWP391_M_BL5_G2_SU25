package controller;

import dal.ProductDAO;
import model.ProductVariant;
import model.ProductSerial;
import model.VariantSpecification;
import model.ProductImage;
import model.Specification;
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
import java.util.List;

@WebServlet(name = "EditVariantController", urlPatterns = {"/editVariant"})
@MultipartConfig
public class EditVariantController extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productVariantId = Integer.parseInt(request.getParameter("productVariantId"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        ProductVariant variant = productDAO.getVariantById(productVariantId);
        List<Specification> allSpecifications = productDAO.getAllSpecifications();
        List<Store> stores = productDAO.getAllStores();

        if (variant == null) {
            request.setAttribute("error", "Không tìm thấy biến thể.");
            request.getRequestDispatcher("views/product/productDetail.jsp").forward(request, response);
            return;
        }

        request.setAttribute("variant", variant);
        request.setAttribute("productId", productId);
        request.setAttribute("allSpecifications", allSpecifications);
        request.setAttribute("stores", stores);
        request.getRequestDispatcher("views/product/editProductVariant.jsp").forward(request, response);
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

            // Process specifications
            List<VariantSpecification> specifications = new ArrayList<>();
            List<Specification> allSpecifications = productDAO.getAllSpecifications();
            for (Specification spec : allSpecifications) {
                String value = request.getParameter("spec_" + spec.getSpecificationId());
                if (value != null && !value.trim().isEmpty()) {
                    VariantSpecification variantSpec = new VariantSpecification();
                    variantSpec.setProductVariantId(productVariantId);
                    variantSpec.setSpecificationId(spec.getSpecificationId());
                    variantSpec.setValue(value);
                    specifications.add(variantSpec);
                }
            }
            variant.setSpecifications(specifications);

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
                    image.setAlt(variant.getProductName() + " Image");
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
                    int storeId = Integer.parseInt(request.getParameter("storeId_" + existingSerial.getProductSerialId()));
                    ProductSerial serial = new ProductSerial();
                    serial.setProductSerialId(existingSerial.getProductSerialId());
                    serial.setSerialNumber(serialNumber);
                    serial.setStoreId(storeId);
                    serial.setProductVariantId(productVariantId);
                    serials.add(serial);
                }
            }
            // Handle new serial
            String newSerialNumber = request.getParameter("newSerialNumber");
            String newStoreId = request.getParameter("newStoreId");
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
}