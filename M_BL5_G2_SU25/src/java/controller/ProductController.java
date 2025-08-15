/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ProductDAO;
import model.Product;
import model.Brand;
import model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.List;
import model.Supplier;

/**
 *
 * @author tayho
 */
/**
 * Chỉnh sửa lại annotation @WebServlet theo phần cá nhân làm riêng
 */
@WebServlet("/product/*")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
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
            List<Product> products = productDAO.getAllProducts();
            request.setAttribute("products", products);
            request.getRequestDispatcher("/views/product/listProduct.jsp").forward(request, response);
        } else if (pathInfo.equals("/detail")) {
            String productIdStr = request.getParameter("productId");
            if (productIdStr != null) {
                int productId = Integer.parseInt(productIdStr);
                Product product = productDAO.getProductById(productId);
                if (product != null) {
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/views/product/productDetail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("products");
                }
            } else {
                response.sendRedirect("products");
            }
        } else if (pathInfo.equals("/add")) {
            List<Brand> brands = productDAO.getAllBrands();
            List<Category> categories = productDAO.getAllCategories();
            List<Supplier> suppliers = productDAO.getAllSuppliers();
            request.setAttribute("brands", brands);
            request.setAttribute("categories", categories);
            request.setAttribute("suppliers", suppliers);
            request.getRequestDispatcher("/views/product/addProduct.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.equals("/add")) {
            String productName = request.getParameter("productName");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int brandId = Integer.parseInt(request.getParameter("brandId"));
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String productCode = request.getParameter("productCode");
            double price = Double.parseDouble(request.getParameter("price"));
            int warrantyDurationMonth = Integer.parseInt(request.getParameter("warrantyDurationMonth"));
            String status = request.getParameter("status");
            Part imagePart = request.getPart("image");
            String imageUrl = request.getParameter("imageUrl");

            Product product = new Product();
            product.setProductName(productName);
            product.setCategoryId(categoryId);
            product.setBrandId(brandId);
            product.setSupplierId(supplierId);
            product.setProductCode(productCode);
            product.setPrice(price);
            product.setWarrantyDurationMonth(warrantyDurationMonth);
            product.setStatus(status);

            productDAO.addProduct(product, imagePart, imageUrl);
            request.getRequestDispatcher("../product/listProduct.jsp").forward(request, response);
        }
    }
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
