package controller;

import com.google.gson.Gson;
import dal.ProductDAO;
import model.Product;
import model.ProductVariant;
import model.AttributeOption;
import model.ProductImage;
import model.ProductSerial;
import model.Brand;
import model.Category;
import model.Supplier;
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
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/product/*")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB max file size
public class ProductController extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo)) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                List<Product> products = productDAO.getAllProducts();
                Gson gson = new Gson();
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(products));
                out.flush();
                return;
            }
            List<Product> products = productDAO.getAllProducts();
            List<Category> categories = productDAO.getAllCategories();
            List<Brand> brands = productDAO.getAllBrands();
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("brands", brands);
            request.getRequestDispatcher("/views/product/listProduct.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            List<Category> categories = productDAO.getAllCategories();
            List<Brand> brands = productDAO.getAllBrands();
            List<Supplier> suppliers = productDAO.getAllSuppliers();
            List<Attribute> attributes = productDAO.getAllAttributes();
            Map<Integer, List<AttributeOption>> attributeOptions = new HashMap<>();
            for (Attribute attribute : attributes) {
                attributeOptions.put(attribute.getAttributeId(), productDAO.getAttributeOptionsByAttributeId(attribute.getAttributeId()));
            }
            List<Store> stores = productDAO.getAllStores();
            request.setAttribute("categories", categories);
            request.setAttribute("brands", brands);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("attributes", attributes);
            request.setAttribute("attributeOptions", attributeOptions);
            request.setAttribute("stores", stores);
            request.getRequestDispatcher("/views/product/addProduct.jsp").forward(request, response);
        } else if (pathInfo.equals("/edit")) {
            String productIdStr = request.getParameter("productId");
            if (productIdStr != null) {
                int productId = Integer.parseInt(productIdStr);
                Product product = productDAO.getProductById(productId);
                List<Category> categories = productDAO.getAllCategories();
                List<Brand> brands = productDAO.getAllBrands();
                List<Supplier> suppliers = productDAO.getAllSuppliers();
                List<Attribute> attributes = productDAO.getAllAttributes();
                List<Store> stores = productDAO.getAllStores();
                request.setAttribute("product", product);
                request.setAttribute("categories", categories);
                request.setAttribute("brands", brands);
                request.setAttribute("suppliers", suppliers);
                request.setAttribute("attributes", attributes);
                request.setAttribute("stores", stores);
                request.getRequestDispatcher("/views/product/editProduct.jsp").forward(request, response);
            } else {
                response.sendRedirect("/product");
            }
        } else if (pathInfo.equals("/detail")) {
            String productIdStr = request.getParameter("productId");
            if (productIdStr != null) {
                int productId = Integer.parseInt(productIdStr);
                Product product = productDAO.getProductById(productId);
                List<Attribute> attributes = productDAO.getAllAttributes();
                request.setAttribute("product", product);
                request.setAttribute("attributes", attributes);
                request.getRequestDispatcher("/views/product/productDetail.jsp").forward(request, response);
            } else {
                response.sendRedirect("/product");
            }
        } else if (pathInfo.equals("/filter")) {
            String categoryId = request.getParameter("categoryId");
            String brandId = request.getParameter("brandId");
            String status = request.getParameter("status");
            Double minPrice = request.getParameter("minPrice") != null && !request.getParameter("minPrice").isEmpty() ? Double.parseDouble(request.getParameter("minPrice")) : null;
            Double maxPrice = request.getParameter("maxPrice") != null && !request.getParameter("maxPrice").isEmpty() ? Double.parseDouble(request.getParameter("maxPrice")) : null;
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            List<Product> products = productDAO.getFilteredAndSortedProducts(categoryId, brandId, status, minPrice, maxPrice, sortBy, sortOrder);
            Gson gson = new Gson();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(products));
            out.flush();
        } else {
            response.sendRedirect("/product");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendRedirect("/product");
            return;
        }

        switch (pathInfo) {
            case "/add": {
                // Parse product data
                String productName = request.getParameter("productName");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                int brandId = Integer.parseInt(request.getParameter("brandId"));
                int supplierId = Integer.parseInt(request.getParameter("supplierId"));
                String status = request.getParameter("status");

                Product product = new Product();
                product.setProductName(productName);
                product.setCategoryId(categoryId);
                product.setBrandId(brandId);
                product.setSupplierId(supplierId);
                product.setStatus(status);

                // Parse variants
                List<ProductVariant> variants = new ArrayList<>();
                List<List<Part>> variantImageParts = new ArrayList<>();
                List<List<String>> variantImageUrls = new ArrayList<>();
                int variantIndex = 0;
                while (request.getParameter("variantProductCode[" + variantIndex + "]") != null) {
                    ProductVariant variant = new ProductVariant();
                    variant.setProductCode(request.getParameter("variantProductCode[" + variantIndex + "]"));
                    variant.setPrice(Double.parseDouble(request.getParameter("variantPrice[" + variantIndex + "]")));
                    variant.setWarrantyDurationMonth(Integer.parseInt(request.getParameter("variantWarranty[" + variantIndex + "]")));

                    // Parse attributes for this variant
                    List<AttributeOption> attributes = new ArrayList<>();
                    String[] attributeOptionIds = request.getParameterValues("attributeOptionId[" + variantIndex + "][]");
                    if (attributeOptionIds != null) {
                        for (String optionIdStr : attributeOptionIds) {
                            if (optionIdStr != null && !optionIdStr.isEmpty()) {
                                AttributeOption attrOption = new AttributeOption();
                                attrOption.setAttributeOptionId(Integer.parseInt(optionIdStr));
                                // Fetch AttributeOption details to set Attribute
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

                    // Parse serials for this variant
                    List<ProductSerial> serials = new ArrayList<>();
                    int serialIndex = 0;
                    while (request.getParameter("variantSerial[" + variantIndex + "][" + serialIndex + "]") != null) {
                        String serialNumber = request.getParameter("variantSerial[" + variantIndex + "][" + serialIndex + "]");
                        String storeIdStr = request.getParameter("variantStoreId[" + variantIndex + "][" + serialIndex + "]");
                        String serialStatus = request.getParameter("variantSerialStatus[" + variantIndex + "][" + serialIndex + "]");
                        if (serialNumber != null && !serialNumber.isEmpty() && storeIdStr != null && !storeIdStr.isEmpty()) {
                            ProductSerial serial = new ProductSerial();
                            serial.setSerialNumber(serialNumber);
                            serial.setStoreId(Integer.parseInt(storeIdStr));
                            serials.add(serial);
                        }
                        serialIndex++;
                    }
                    variant.setSerials(serials);

                    // Parse images for this variant
                    List<Part> parts = new ArrayList<>();
                    for (Part part : request.getParts()) {
                        if (part.getName().equals("variantImage[" + variantIndex + "][]") && part.getSize() > 0) {
                            parts.add(part);
                        }
                    }
                    String[] urlParams = request.getParameterValues("variantImageUrl[" + variantIndex + "][]");
                    List<String> urls = new ArrayList<>();
                    if (urlParams != null) {
                        for (String url : urlParams) {
                            if (url != null && !url.isEmpty()) {
                                urls.add(url);
                            }
                        }
                    }
                    variantImageParts.add(parts);
                    variantImageUrls.add(urls);

                    variants.add(variant);
                    variantIndex++;
                }
                product.setVariants(variants);

                productDAO.addProduct(product, variantImageParts, variantImageUrls, request);
                request.setAttribute("message", "Product added successfully");
                request.getRequestDispatcher("/views/product/addProduct.jsp").forward(request, response);
                break;
            }
            case "/edit": {
                int productId = Integer.parseInt(request.getParameter("productId"));
                Product product = productDAO.getProductById(productId);
                String productName = request.getParameter("productName");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                int brandId = Integer.parseInt(request.getParameter("brandId"));
                int supplierId = Integer.parseInt(request.getParameter("supplierId"));
                String status = request.getParameter("status");

                product.setProductName(productName);
                product.setCategoryId(categoryId);
                product.setBrandId(brandId);
                product.setSupplierId(supplierId);
                product.setStatus(status);

                String[] variantIds = request.getParameterValues("variantId[]");
                String[] variantProductCodes = request.getParameterValues("variantProductCode[]");
                String[] variantPrices = request.getParameterValues("variantPrice[]");
                String[] variantWarranties = request.getParameterValues("variantWarranty[]");
                List<ProductVariant> variants = new ArrayList<>();
                List<List<Part>> variantImageParts = new ArrayList<>();
                List<List<String>> variantImageUrls = new ArrayList<>();

                if (variantProductCodes != null) {
                    for (int i = 0; i < variantProductCodes.length; i++) {
                        ProductVariant variant = new ProductVariant();
                        int variantId = (variantIds != null && i < variantIds.length && !variantIds[i].isEmpty()) ? Integer.parseInt(variantIds[i]) : 0;
                        variant.setProductVariantId(variantId);
                        variant.setProductCode(variantProductCodes[i]);
                        variant.setPrice(Double.parseDouble(variantPrices[i]));
                        variant.setWarrantyDurationMonth(Integer.parseInt(variantWarranties[i]));

                        // Parse attributes for this variant
                        List<AttributeOption> attributes = new ArrayList<>();
                        String[] attributeOptionIds = request.getParameterValues("attributeOptionId[" + i + "][]");
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

                        // Parse serials for this variant
                        List<ProductSerial> serials = new ArrayList<>();
                        int serialIndex = 0;
                        while (request.getParameter("variantSerial[" + i + "][" + serialIndex + "]") != null) {
                            String serialIdStr = request.getParameter("variantSerialId[" + i + "][" + serialIndex + "]");
                            String serialNumber = request.getParameter("variantSerial[" + i + "][" + serialIndex + "]");
                            String storeIdStr = request.getParameter("variantStoreId[" + i + "][" + serialIndex + "]");
                            String serialStatus = request.getParameter("variantSerialStatus[" + i + "][" + serialIndex + "]");
                            if (serialNumber != null && !serialNumber.isEmpty() && storeIdStr != null && !storeIdStr.isEmpty()) {
                                ProductSerial serial = new ProductSerial();
                                serial.setProductSerialId(serialIdStr != null && !serialIdStr.isEmpty() ? Integer.parseInt(serialIdStr) : 0);
                                serial.setSerialNumber(serialNumber);
                                serial.setStoreId(Integer.parseInt(storeIdStr));
                                serials.add(serial);
                            }
                            serialIndex++;
                        }
                        variant.setSerials(serials);

                        // Parse images for this variant
                        List<Part> parts = new ArrayList<>();
                        for (Part part : request.getParts()) {
                            if (part.getName().equals("variantImage[" + i + "][]") && part.getSize() > 0) {
                                parts.add(part);
                            }
                        }
                        String[] urlParams = request.getParameterValues("variantImageUrl[" + i + "][]");
                        List<String> urls = new ArrayList<>();
                        if (urlParams != null) {
                            for (String url : urlParams) {
                                if (url != null && !url.isEmpty()) {
                                    urls.add(url);
                                }
                            }
                        }
                        variantImageParts.add(parts);
                        variantImageUrls.add(urls);

                        List<ProductImage> images = new ArrayList<>();
                        String[] imageIds = request.getParameterValues("variantImageId[" + i + "][]");
                        if (imageIds != null) {
                            for (int j = 0; j < imageIds.length; j++) {
                                if (imageIds[j] != null && !imageIds[j].isEmpty()) {
                                    ProductImage image = new ProductImage();
                                    image.setProductImageId(Integer.parseInt(imageIds[j]));
                                    images.add(image);
                                }
                            }
                        }
                        variant.setImages(images);

                        variants.add(variant);
                    }
                    product.setVariants(variants);
                }

                productDAO.updateProduct(product, variantImageParts, variantImageUrls, request);
                request.setAttribute("message", "Product updated successfully");
                response.sendRedirect(request.getContextPath() + "/product/edit?productId=" + productId);
                break;
            }
            default:
                response.sendRedirect("/product");
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Product Controller Servlet";
    }
}
