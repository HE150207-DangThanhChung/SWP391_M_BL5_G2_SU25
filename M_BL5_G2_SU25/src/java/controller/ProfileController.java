/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dal.EmployeeDAO;
import dal.SupplierDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import model.Employee;
import model.Supplier;

/**
 *
 * @author tayho
 */
/**
 * Chỉnh sửa lại annotation @WebServlet theo phần cá nhân làm riêng
 */
@WebServlet(name = "ProfileController", urlPatterns = {
    "/profile",
    "/profile/edit"
})
public class ProfileController extends HttpServlet {
    
    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private final int ITEMS_PER_PAGE = 2;
    private final String BASE_PATH = "/profile";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case BASE_PATH ->
                doGetDetail(request, response);
            case BASE_PATH + "/edit" ->
                doGetEdit(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case BASE_PATH + "/edit" ->
                doPostEdit(request, response);
        }
    }
    
    private void doGetDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("tendangnhap");
        EmployeeDAO eDao = new EmployeeDAO();
        
        if (username == null || username.isEmpty()) {
            response.sendError(404);
        }
        
        Employee e = eDao.getEmployeeByUsername(username);
        
        request.setAttribute("e", e);
        request.getRequestDispatcher("/views/profile/viewProfile.jsp").forward(request, response);
    }
    
    private void doGetEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        SupplierDAO dao = new SupplierDAO();
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(404);
        }
        
        int id = Integer.parseInt(idStr);
        
        Supplier s = dao.getSupplierById(id);
        
        request.setAttribute("s", s);
        request.getRequestDispatcher("/views/profile/editProfile.jsp").forward(request, response);
    }
    
    private void doPostEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SupplierDAO dao = new SupplierDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();
        
        try {
            String idStr = request.getParameter("id");
            String email = request.getParameter("email");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            String taxCode = request.getParameter("taxCode");
            
            int id = Integer.parseInt(idStr);
            
            Supplier s = dao.getSupplierById(id);
            
            if (!s.getEmail().equals(email)) {
                if (dao.isEmailExisted(email)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Email is already existed!");
                    sendJson(response, jsonMap);
                    return;
                }
            }
            if (!s.getSupplierName().equals(name)) {
                if (dao.isNameExisted(name)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Name is already existed!");
                    sendJson(response, jsonMap);
                    return;
                }
            }
            if (!s.getPhone().equals(phone)) {
                if (dao.isPhoneExisted(phone)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Phone is already existed!");
                    sendJson(response, jsonMap);
                    return;
                }
            }
            if (!s.getTaxCode().equals(taxCode)) {
                if (dao.isTaxCodeExisted(taxCode)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Tax Code is already existed!");
                    sendJson(response, jsonMap);
                    return;
                }
            }
            
            boolean success = dao.editSupplier(id, name, phone, email, taxCode, status);
            if (success) {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Supplier saved successfully!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Failed to save supplier. Please try again.");
            }
            sendJson(response, jsonMap);
        } catch (IOException e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Something wrong, please try again later!");
            sendJson(response, jsonMap);
        }
    }
    
    public static void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = gson.toJson(data);
        response.getWriter().write(json);
        response.getWriter().flush();
    }
    
}
