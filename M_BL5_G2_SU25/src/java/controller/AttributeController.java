package controller;

import dal.ProductDAO;
import model.Attribute;
import model.AttributeOption;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AttributeController", urlPatterns = {"/attribute/*"})
public class AttributeController extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/list")) {
            try {
                List<Attribute> attributes = productDAO.getAllAttributes();
                request.setAttribute("attributes", attributes);
                request.getRequestDispatcher("/views/attribute/ListAttributes.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi khi tải danh sách thuộc tính: " + e.getMessage());
                request.getRequestDispatcher("/views/attribute/ListAttributes.jsp").forward(request, response);
            }
        } else if (pathInfo.equals("/add")) {
            request.getRequestDispatcher("/views/attribute/AddAttribute.jsp").forward(request, response);
        } else if (pathInfo.equals("/detail")) {
            try {
                int attributeId = Integer.parseInt(request.getParameter("attributeId"));
                Attribute attribute = productDAO.getAttributeById(attributeId); // Assume this method is added to ProductDAO
                List<AttributeOption> options = productDAO.getAttributeOptionsByAttributeId(attributeId);
                request.setAttribute("attribute", attribute);
                request.setAttribute("options", options);
                request.getRequestDispatcher("/views/attribute/AttributeDetails.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID thuộc tính không hợp lệ.");
                request.getRequestDispatcher("/views/attribute/ListAttributes.jsp").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("error", "Lỗi khi tải chi tiết thuộc tính: " + e.getMessage());
                request.getRequestDispatcher("/views/attribute/ListAttributes.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo.equals("/add")) {
            try {
                String attributeName = request.getParameter("attributeName");
                Attribute attribute = new Attribute();
                attribute.setAttributeName(attributeName);
                int attributeId = productDAO.addAttribute(attribute); // Assume this method is added to ProductDAO
                String[] optionValues = request.getParameterValues("optionValue[]");
                if (optionValues != null) {
                    for (String value : optionValues) {
                        if (value != null && !value.trim().isEmpty()) {
                            AttributeOption option = new AttributeOption();
                            option.setValue(value);
                            option.setAttribute(attribute);
                            productDAO.addAttributeOption(attributeId, option); // Assume this method is added to ProductDAO
                        }
                    }
                }
                request.setAttribute("message", "Thuộc tính đã được thêm thành công.");
                request.getRequestDispatcher("/views/attribute/AddAttribute.jsp").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("error", "Lỗi khi thêm thuộc tính: " + e.getMessage());
                request.getRequestDispatcher("/views/attribute/AddAttribute.jsp").forward(request, response);
            }
        } else if (pathInfo.equals("/addOption")) {
            try {
                int attributeId = Integer.parseInt(request.getParameter("attributeId"));
                String value = request.getParameter("value");
                if (value != null && !value.trim().isEmpty()) {
                    AttributeOption option = new AttributeOption();
                    option.setValue(value);
                    productDAO.addAttributeOption(attributeId, option);
                }
                response.sendRedirect(request.getContextPath() + "/attribute/detail?attributeId=" + attributeId);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID thuộc tính không hợp lệ.");
                request.getRequestDispatcher("/views/attribute/AttributeDetails.jsp").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("error", "Lỗi khi thêm giá trị: " + e.getMessage());
                request.getRequestDispatcher("/views/attribute/AttributeDetails.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Attribute Controller Servlet";
    }
}