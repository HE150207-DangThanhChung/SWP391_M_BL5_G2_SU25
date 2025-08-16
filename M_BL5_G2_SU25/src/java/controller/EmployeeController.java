/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dal.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import model.Employee;

@WebServlet(name = "EmployeeController", urlPatterns = {
    "/management/employees",
    "/management/employees/add",
    "/management/employees/edit",
    "/management/employees/detail"
})
public class EmployeeController extends HttpServlet {

    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private final int ITEMS_PER_PAGE = 10;
    private final String BASE_PATH = "/management/employees";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case BASE_PATH -> doGetList(request, response);
            case BASE_PATH + "/add" -> doGetAdd(request, response);
            case BASE_PATH + "/edit" -> doGetEdit(request, response);
            case BASE_PATH + "/detail" -> doGetDetail(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case BASE_PATH + "/add" -> doPostAdd(request, response);
            case BASE_PATH + "/edit" -> doPostEdit(request, response);
        }
    }

    private void doGetList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchKey = request.getParameter("search");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");

        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {
            }
        }

        int offset = (page - 1) * ITEMS_PER_PAGE;
        EmployeeDAO dao = new EmployeeDAO();

        List<Employee> employees = dao.getAllEmployeesWithPagingAndFilter(searchKey, status, offset, ITEMS_PER_PAGE);
        int totalEmployees = dao.countEmployeesWithFilter(searchKey, status);
        int totalPages = (int) Math.ceil((double) totalEmployees / ITEMS_PER_PAGE);
        int endItem = Math.min(offset + ITEMS_PER_PAGE, totalEmployees);

        request.setAttribute("startItem", totalEmployees == 0 ? 0 : offset + 1);
        request.setAttribute("endItem", endItem);
        request.setAttribute("totalItems", totalEmployees);
        request.setAttribute("employees", employees);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKey", searchKey);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/views/employee/listEmployee.jsp").forward(request, response);
    }

    private void doGetAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/employee/addEmployee.jsp").forward(request, response);
    }

    private void doGetEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(404);
            return;
        }
        int id = Integer.parseInt(idStr);
        EmployeeDAO dao = new EmployeeDAO();
        Employee e = dao.getEmployeeById(id);
        request.setAttribute("e", e);
        request.getRequestDispatcher("/views/employee/editDetailEmployee.jsp").forward(request, response);
    }

    private void doGetDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(404);
            return;
        }
        int id = Integer.parseInt(idStr);
        EmployeeDAO dao = new EmployeeDAO();
        Employee e = dao.getEmployeeById(id);
        request.setAttribute("e", e);
        request.getRequestDispatcher("/views/employee/viewEmployee.jsp").forward(request, response);
    }

    private void doPostAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EmployeeDAO dao = new EmployeeDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();
        try {
            String username = request.getParameter("username");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String status = request.getParameter("status");
            String gender = request.getParameter("gender");

            if (dao.isUsernameExisted(username)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Username is already existed!");
                sendJson(response, jsonMap);
                return;
            }
            if (dao.isEmailExisted(email)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Email is already existed!");
                sendJson(response, jsonMap);
                return;
            }
            if (dao.isPhoneExisted(phone)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Phone is already existed!");
                sendJson(response, jsonMap);
                return;
            }

            boolean success = dao.addEmployee(username, firstName, lastName, phone, email, gender, status);
            if (success) {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Employee added successfully!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Failed to add employee. Please try again.");
            }
            sendJson(response, jsonMap);
        } catch (Exception e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Something wrong, please try again later!");
            sendJson(response, jsonMap);
        }
    }

    private void doPostEdit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EmployeeDAO dao = new EmployeeDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();
        try {
            String idStr = request.getParameter("id");
            String username = request.getParameter("username");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String status = request.getParameter("status");
            String gender = request.getParameter("gender");

            int id = Integer.parseInt(idStr);

            Employee current = dao.getEmployeeById(id);
            if (current == null || current.getEmployeeId() == 0) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Employee not found!");
                sendJson(response, jsonMap);
                return;
            }

            if (!current.getUserName().equals(username) && dao.isUsernameExisted(username)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Username is already existed!");
                sendJson(response, jsonMap);
                return;
            }
            if (!current.getEmail().equals(email) && dao.isEmailExisted(email)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Email is already existed!");
                sendJson(response, jsonMap);
                return;
            }
            if (!current.getPhone().equals(phone) && dao.isPhoneExisted(phone)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Phone is already existed!");
                sendJson(response, jsonMap);
                return;
            }

            boolean success = dao.editEmployee(id, username, firstName, lastName, phone, email, gender, status);
            if (success) {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Employee saved successfully!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Failed to save employee. Please try again.");
            }
            sendJson(response, jsonMap);
        } catch (Exception e) {
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
