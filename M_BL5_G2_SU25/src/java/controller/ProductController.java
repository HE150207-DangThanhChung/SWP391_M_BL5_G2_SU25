package controller;

import dal.ProductDAO;
import model.Product;
import model.ProductVariant;
import model.VariantSpecification;
import model.ProductImage;
import model.ProductSerial;
import model.Brand;
import model.Category;
import model.Supplier;
import model.Specification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author tayho
 */
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
        if (pathInfo == null) {
            pathInfo = "/"; // Default to root if null
        }

        switch (pathInfo) {
            case "/":
                List<Product> products = productDAO.getAllProducts();
                request.setAttribute("products", products);
                request.getRequestDispatcher("/views/product/listProduct.jsp").forward(request, response);
                break;
            case "/add":
                List<Category> categories = productDAO.getAllCategories();
                List<Brand> brands = productDAO.getAllBrands();
                List<Supplier> suppliers = productDAO.getAllSuppliers();
                List<Specification> specifications = productDAO.getAllSpecifications();
                request.setAttribute("categories", categories);
                request.setAttribute("brands", brands);
                request.setAttribute("suppliers", suppliers);
                request.setAttribute("specifications", specifications);
                request.getRequestDispatcher("/views/product/addProduct.jsp").forward(request, response);
                break;
            case "/edit":
                String productIdStr = request.getParameter("productId");
                if (productIdStr != null) {
                    int productId = Integer.parseInt(productIdStr);
                    Product product = productDAO.getProductById(productId);
                    categories = productDAO.getAllCategories();
                    brands = productDAO.getAllBrands();
                    suppliers = productDAO.getAllSuppliers();
                    specifications = productDAO.getAllSpecifications();
                    request.setAttribute("product", product);
                    request.setAttribute("categories", categories);
                    request.setAttribute("brands", brands);
                    request.setAttribute("suppliers", suppliers);
                    request.setAttribute("specifications", specifications);
                    request.getRequestDispatcher("/views/product/editProduct.jsp").forward(request, response);
                } else {
                    response.sendRedirect("/product");
                }
                break;
            case "/detail":
                productIdStr = request.getParameter("productId");
                if (productIdStr != null) {
                    int productId = Integer.parseInt(productIdStr);
                    Product product = productDAO.getProductById(productId);
                    specifications = productDAO.getAllSpecifications();
                    request.setAttribute("product", product);
                    request.setAttribute("specifications", specifications);
                    request.getRequestDispatcher("/views/product/productDetail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("/product");
                }
                break;
            default:
                response.sendRedirect("/product");
                break;
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
                String[] variantProductCodes = request.getParameterValues("variantProductCode[]");
                String[] variantPrices = request.getParameterValues("variantPrice[]");
                String[] variantWarranties = request.getParameterValues("variantWarranty[]");
                List<ProductVariant> variants = new ArrayList<>();

                if (variantProductCodes != null) {
                    for (int i = 0; i < variantProductCodes.length; i++) {
                        ProductVariant variant = new ProductVariant();
                        variant.setProductCode(variantProductCodes[i]);
                        variant.setPrice(Double.parseDouble(variantPrices[i]));
                        variant.setWarrantyDurationMonth(Integer.parseInt(variantWarranties[i]));

                        // Parse specifications
                        List<VariantSpecification> specs = new ArrayList<>();
                        for (String paramName : request.getParameterMap().keySet()) {
                            if (paramName.startsWith("specValue[")) {
                                String[] specValues = request.getParameterValues(paramName);
                                for (String value : specValues) {
                                    if (value != null && !value.isEmpty()) {
                                        String specIdStr = paramName.substring(10, paramName.indexOf("]"));
                                        int specId = Integer.parseInt(specIdStr);
                                        VariantSpecification spec = new VariantSpecification();
                                        spec.setSpecificationId(specId);
                                        spec.setValue(value); // Value should be the selected option (e.g., "8GB")
                                        specs.add(spec);
                                    }
                                }
                            }
                        }
                        variant.setSpecifications(specs);

                        // Parse serials
                        String[] serialNumbers = request.getParameterValues("variantSerial[" + i + "]");
                        String[] storeIds = request.getParameterValues("variantStoreId[" + i + "]");
                        List<ProductSerial> serials = new ArrayList<>();
                        if (serialNumbers != null && storeIds != null) {
                            for (int j = 0; j < serialNumbers.length; j++) {
                                if (serialNumbers[j] != null && !serialNumbers[j].isEmpty()) {
                                    ProductSerial serial = new ProductSerial();
                                    serial.setSerialNumber(serialNumbers[j]);
                                    serial.setStoreId(Integer.parseInt(storeIds[j]));
                                    serials.add(serial);
                                }
                            }
                        }
                        variant.setSerials(serials);

                        variants.add(variant);
                    }
                    product.setVariants(variants);
                }

                // Parse images
                List<List<Part>> variantImageParts = new ArrayList<>();
                List<List<String>> variantImageUrls = new ArrayList<>();
                for (int i = 0; i < variants.size(); i++) {
                    List<Part> parts = new ArrayList<>();
                    List<String> urls = new ArrayList<>();
                    for (Part part : request.getParts()) {
                        if (part.getName().equals("variantImage[" + i + "][]") && part.getSize() > 0) {
                            parts.add(part);
                        }
                    }
                    String[] urlParams = request.getParameterValues("variantImageUrl[" + i + "][]");
                    if (urlParams != null) {
                        for (String url : urlParams) {
                            if (url != null && !url.isEmpty()) {
                                urls.add(url);
                            }
                        }
                    }
                    variantImageParts.add(parts);
                    variantImageUrls.add(urls);
                }

                productDAO.addProduct(product, variantImageParts, variantImageUrls, request);
                request.setAttribute("message", "Product added successfully");
                doGet(request, response); // Reuse doGet to refresh the product list
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

                // Parse and update variants
                String[] variantIds = request.getParameterValues("variantId[]");
                String[] variantProductCodes = request.getParameterValues("variantProductCode[]");
                String[] variantPrices = request.getParameterValues("variantPrice[]");
                String[] variantWarranties = request.getParameterValues("variantWarranty[]");
                List<ProductVariant> variants = new ArrayList<>();

                if (variantIds != null) {
                    for (int i = 0; i < variantIds.length; i++) {
                        ProductVariant variant = product.getVariants().get(i); // Use existing variant
                        variant.setProductVariantId(Integer.parseInt(variantIds[i]));
                        variant.setProductCode(variantProductCodes[i]);
                        variant.setPrice(Double.parseDouble(variantPrices[i]));
                        variant.setWarrantyDurationMonth(Integer.parseInt(variantWarranties[i]));

                        // Parse specifications
                        List<VariantSpecification> specs = new ArrayList<>();
                        for (String paramName : request.getParameterMap().keySet()) {
                            if (paramName.startsWith("specValue[")) {
                                String[] specValues = request.getParameterValues(paramName);
                                for (String value : specValues) {
                                    if (value != null && !value.isEmpty()) {
                                        String specIdStr = paramName.substring(10, paramName.indexOf("]"));
                                        int specId = Integer.parseInt(specIdStr);
                                        VariantSpecification spec = new VariantSpecification();
                                        spec.setProductVariantId(variant.getProductVariantId());
                                        spec.setSpecificationId(specId);
                                        spec.setValue(value); // Value should be the selected option (e.g., "8GB")
                                        specs.add(spec);
                                    }
                                }
                            }
                        }
                        variant.setSpecifications(specs);

                        // Parse serials
                        String[] serialIds = request.getParameterValues("variantSerialId[" + i + "]");
                        String[] serialNumbers = request.getParameterValues("variantSerial[" + i + "]");
                        String[] storeIds = request.getParameterValues("variantStoreId[" + i + "]");
                        List<ProductSerial> serials = new ArrayList<>();
                        if (serialIds != null && serialNumbers != null && storeIds != null) {
                            for (int j = 0; j < serialIds.length; j++) {
                                ProductSerial serial = variant.getSerials().get(j); // Use existing serial
                                serial.setProductSerialId(Integer.parseInt(serialIds[j]));
                                serial.setSerialNumber(serialNumbers[j]);
                                serial.setStoreId(Integer.parseInt(storeIds[j]));
                                serials.add(serial);
                            }
                        }
                        variant.setSerials(serials);
                        variants.add(variant);
                    }
                    product.setVariants(variants);
                }

                // Parse images for update
                List<List<Part>> variantImageParts = new ArrayList<>();
                List<List<String>> variantImageUrls = new ArrayList<>();
                for (int i = 0; i < product.getVariants().size(); i++) {
                    List<Part> parts = new ArrayList<>();
                    List<String> urls = new ArrayList<>();
                    for (Part part : request.getParts()) {
                        if (part.getName().equals("variantImage[" + i + "][]") && part.getSize() > 0) {
                            parts.add(part);
                        }
                    }
                    String[] urlParams = request.getParameterValues("variantImageUrl[" + i + "][]");
                    if (urlParams != null) {
                        for (String url : urlParams) {
                            if (url != null && !url.isEmpty()) {
                                urls.add(url);
                            }
                        }
                    }
                    variantImageParts.add(parts);
                    variantImageUrls.add(urls);
                }

                productDAO.updateProduct(product, variantImageParts, variantImageUrls, request);
                request.setAttribute("message", "Product updated successfully");
                doGet(request, response); // Reuse doGet to refresh the product list
                break;
            }
            default:
                response.sendRedirect("/product");
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}