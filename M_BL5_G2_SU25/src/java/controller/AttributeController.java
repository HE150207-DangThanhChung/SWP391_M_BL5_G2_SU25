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
                Attribute attribute = productDAO.getAttributeById(attributeId);
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
        } else if (pathInfo.equals("/edit")) { // New: Handle GET for edit form
            try {
                int attributeId = Integer.parseInt(request.getParameter("attributeId"));
                Attribute attribute = productDAO.getAttributeById(attributeId);
                List<AttributeOption> options = productDAO.getAttributeOptionsByAttributeId(attributeId);
                request.setAttribute("attribute", attribute);
                request.setAttribute("options", options);
                request.getRequestDispatcher("/views/attribute/EditAttribute.jsp").forward(request, response); // NEW JSP
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID thuộc tính không hợp lệ.");
                request.getRequestDispatcher("/views/attribute/ListAttributes.jsp").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("error", "Lỗi khi tải thông tin thuộc tính để chỉnh sửa: " + e.getMessage());
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
                int attributeId = productDAO.addAttribute(attribute);
                String[] optionValues = request.getParameterValues("optionValue[]");
                if (optionValues != null) {
                    for (String value : optionValues) {
                        if (value != null && !value.trim().isEmpty()) {
                            AttributeOption option = new AttributeOption();
                            option.setValue(value);
                            productDAO.addAttributeOption(attributeId, option);
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
        } else if (pathInfo.equals("/edit")) { // NEW: Handle POST for editing an existing attribute
            try {
                int attributeId = Integer.parseInt(request.getParameter("attributeId"));
                String attributeName = request.getParameter("attributeName");
                Attribute attribute = new Attribute();
                attribute.setAttributeId(attributeId);
                attribute.setAttributeName(attributeName);
                productDAO.updateAttribute(attribute); // Assume this method is added to ProductDAO

                // Handle existing options
                String[] existingOptionIds = request.getParameterValues("existingOptionId[]");
                String[] existingOptionValues = request.getParameterValues("existingOptionValue[]");
                if (existingOptionIds != null && existingOptionValues != null) {
                    for (int i = 0; i < existingOptionIds.length; i++) {
                        int optionId = Integer.parseInt(existingOptionIds[i]);
                        String value = existingOptionValues[i];
                        if (value != null && !value.trim().isEmpty()) {
                            AttributeOption option = new AttributeOption();
                            option.setAttributeOptionId(optionId);
                            option.setValue(value);
                            productDAO.updateAttributeOption(option); // Assume this method is added
                        }
                    }
                }

                // Handle new options
                String[] newOptionValues = request.getParameterValues("newOptionValue[]");
                if (newOptionValues != null) {
                    for (String value : newOptionValues) {
                        if (value != null && !value.trim().isEmpty()) {
                            AttributeOption option = new AttributeOption();
                            option.setValue(value);
                            productDAO.addAttributeOption(attributeId, option);
                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/attribute/detail?attributeId=" + attributeId);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Dữ liệu ID không hợp lệ.");
                request.getRequestDispatcher("/views/attribute/EditAttribute.jsp").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("error", "Lỗi khi cập nhật thuộc tính: " + e.getMessage());
                request.getRequestDispatcher("/views/attribute/EditAttribute.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Attribute Controller Servlet";
    }
}