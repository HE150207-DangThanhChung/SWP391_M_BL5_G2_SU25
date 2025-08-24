/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CityDAO;
import dal.CustomerDAO;
import dal.WardDAO;
import model.Customer;
import model.Ward;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author tayho
 */
/**
 * Chỉnh sửa lại annotation @WebServlet theo phần cá nhân làm riêng
 */
@WebServlet(name = "CustomerController", urlPatterns = {"/customer"})
public class CustomerController extends HttpServlet {

    // View paths
    private static final String VIEW_LIST = "/views/customer/listCustomer.jsp";
    private static final String VIEW_ADD = "/views/customer/addCustomer.jsp";
    private static final String VIEW_EDIT = "/views/customer/editDetailCustomer.jsp";
    private static final String VIEW_DETAIL = "/views/customer/viewCustomer.jsp";

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final CityDAO cityDAO = new CityDAO();
    private final WardDAO wardDAO = new WardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = nvl(request.getParameter("action"), "list");

        switch (action) {
            case "addForm" ->
                handleAddForm(request, response);
            case "editForm" ->
                handleEditForm(request, response);
            case "view" ->
                handleView(request, response);
            case "updateStatus" ->
                handleUpdateStatus(request, response);
            default ->
                handleList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = nvl(request.getParameter("action"), "list");

        switch (action) {
            case "add" ->
                handleAdd(request, response);
            case "edit" ->
                handleEdit(request, response);
            case "updateStatus" ->
                handleUpdateStatus(request, response); // NEW
            default ->
                handleList(request, response);
        }
    }

    private void handleAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("cities", cityDAO.getAll());
        req.getRequestDispatcher(VIEW_ADD).forward(req, resp);
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = parseInt(req.getParameter("customerId"), -1);
        String status = nvl(req.getParameter("status"), "Active"); // "Active" | "Banned"
        if (id > 0) {
            customerDAO.updateStatus(id, status);
        }
        resp.sendRedirect(req.getContextPath() + "/customer?action=list&msg=status");
    }

    private void handleEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = parseInt(req.getParameter("customerId"), -1);
        Customer c = customerDAO.getById(id);
        if (c == null) {
            req.setAttribute("error", "Customer not found.");
            handleList(req, resp);
            return;
        }

        // preload cities for dropdown
        req.setAttribute("cities", cityDAO.getAll());

        // try to preselect city in the form if ward known
        if (c.getWardId() != null) {
            Ward w = wardDAO.getById(c.getWardId());
            if (w != null) {
                req.setAttribute("selectedCityId", w.getCityId());
            }
        }
        req.setAttribute("customer", c);
        req.getRequestDispatcher(VIEW_EDIT).forward(req, resp);
    }

    private void handleView(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = parseInt(req.getParameter("customerId"), -1);
        Customer c = customerDAO.getById(id);
        if (c == null) {
            req.setAttribute("error", "Customer not found.");
            handleList(req, resp);
            return;
        }
        req.setAttribute("customer", c);
        req.getRequestDispatcher(VIEW_DETAIL).forward(req, resp);
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int pageIndex = parseInt(req.getParameter("page"), 1);
        int pageSize = parseInt(req.getParameter("size"), 10);
        String search = trimToNull(req.getParameter("search"));
        String status = trimToNull(req.getParameter("status"));
        String sortBy = nvl(trimToNull(req.getParameter("sortBy")), "id");    // id|name|email|phone|status|dob
        String sortDir = nvl(trimToNull(req.getParameter("sortDir")), "ASC");  // ASC|DESC

        int total = customerDAO.count(search, status);
        int totalPages = Math.max(1, (int) Math.ceil((double) total / pageSize));
        if (pageIndex > totalPages) {
            pageIndex = totalPages;
        }
        if (pageIndex < 1) {
            pageIndex = 1;
        }

        List<Customer> list = customerDAO.list(pageIndex, pageSize, search, status, sortBy, sortDir);

        req.setAttribute("listCustomers", list);
        req.setAttribute("page", pageIndex);
        req.setAttribute("size", pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", total);
        req.setAttribute("search", nvl(search, ""));
        req.setAttribute("status", nvl(status, ""));
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortDir", sortDir);

        req.getRequestDispatcher(VIEW_LIST).forward(req, resp);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<String> errors = new ArrayList<>();
        Customer c = bindFromRequest(req, errors, null);

        // unique checks
        if (c.getEmail() != null && customerDAO.emailExists(c.getEmail(), null)) {
            errors.add("Email already exists.");
        }
        if (c.getPhone() != null && customerDAO.phoneExists(c.getPhone(), null)) {
            errors.add("Phone already exists.");
        }

        // ward ∈ city validation (if both provided)
        Integer wardId = c.getWardId();
        int cityId = parseInt(req.getParameter("cityId"), 0);
        if (wardId != null && cityId > 0 && !wardDAO.existsInCity(wardId, cityId)) {
            errors.add("Selected ward does not belong to the chosen city.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("customer", c);
            req.setAttribute("cities", cityDAO.getAll());
            req.getRequestDispatcher(VIEW_ADD).forward(req, resp);
            return;
        }

        boolean ok = customerDAO.insert(c);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/customer?action=list&msg=added");
        } else {
            errors.add("Failed to add customer. Please try again.");
            req.setAttribute("errors", errors);
            req.setAttribute("customer", c);
            req.setAttribute("cities", cityDAO.getAll());
            req.getRequestDispatcher(VIEW_ADD).forward(req, resp);
        }
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = parseInt(req.getParameter("customerId"), -1);
        List<String> errors = new ArrayList<>();
        Customer c = bindFromRequest(req, errors, id);
        c.setCustomerId(id);

        if (id <= 0) {
            errors.add("Invalid customerId.");
        }

        // unique checks (exclude current id)
        if (c.getEmail() != null && customerDAO.emailExists(c.getEmail(), id)) {
            errors.add("Email already exists on another record.");
        }
        if (c.getPhone() != null && customerDAO.phoneExists(c.getPhone(), id)) {
            errors.add("Phone already exists on another record.");
        }

        // ward ∈ city validation
        Integer wardId = c.getWardId();
        int cityId = parseInt(req.getParameter("cityId"), 0);
        if (wardId != null && cityId > 0 && !wardDAO.existsInCity(wardId, cityId)) {
            errors.add("Selected ward does not belong to the chosen city.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("customer", c);
            req.setAttribute("cities", cityDAO.getAll());
            req.getRequestDispatcher(VIEW_EDIT).forward(req, resp);
            return;
        }

        boolean ok = customerDAO.update(c);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/customer?action=list&msg=updated");
        } else {
            errors.add("Failed to update customer. Please try again.");
            req.setAttribute("errors", errors);
            req.setAttribute("customer", c);
            req.setAttribute("cities", cityDAO.getAll());
            req.getRequestDispatcher(VIEW_EDIT).forward(req, resp);
        }
    }

    
    private Customer bindFromRequest(HttpServletRequest req, List<String> errors, Integer idForUpdate) {
        Customer c = new Customer();

        String first = trimToNull(req.getParameter("firstName"));
        String last = trimToNull(req.getParameter("lastName"));
        String email = trimToNull(req.getParameter("email"));
        String phone = trimToNull(req.getParameter("phone"));
        String gender = trimToNull(req.getParameter("gender"));
        String address = trimToNull(req.getParameter("address"));
        String status = nvl(trimToNull(req.getParameter("status")), "Active");

        if (first == null) {
            errors.add("First name is required.");
        }
        if (last == null) {
            errors.add("Last name is required.");
        }
        if (email == null) {
            errors.add("Email is required.");
        }
        if (phone == null) {
            errors.add("Phone is required.");
        }
        if (gender == null) {
            errors.add("Gender is required.");
        }
        if (address == null) {
            errors.add("Address is required.");
        }

        c.setFirstName(first);
        c.setMiddleName(trimToNull(req.getParameter("middleName")));
        c.setLastName(last);
        c.setEmail(email);
        c.setPhone(phone);
        c.setGender(gender);
        c.setAddress(address);
        c.setStatus(status);
        c.setTaxCode(trimToNull(req.getParameter("taxCode")));

        // nullable)
        Integer wardId = null;
        String wardRaw = req.getParameter("wardId");
        if (wardRaw != null && !wardRaw.isBlank()) {
            try {
                wardId = Integer.parseInt(wardRaw.trim());
            } catch (NumberFormatException ignore) {
            }
        }
        c.setWardId(wardId);

        c.setDob(parseSqlDate(req.getParameter("dob"), null));

        return c;
    }

    private static String trimToNull(String s) {
        if (s == null) {
            return null;
        }
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private static String nvl(String s, String def) {
        return s == null ? def : s;
    }

    private static int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    /**
     * Accepts yyyy-MM-dd; returns null and optionally adds an error message.
     */
    private static Date parseSqlDate(String s, List<String> errors) {
        return parseSqlDate(s, errors, null);
    }

    private static Date parseSqlDate(String s, List<String> errors, String msgIfBlank) {
        if (s == null || s.isBlank()) {
            if (errors != null && msgIfBlank != null) {
                errors.add(msgIfBlank);
            }
            return null;
        }
        try {
            return Date.valueOf(s.trim());
        } catch (IllegalArgumentException ex) {
            if (errors != null) {
                errors.add("Invalid date format for DoB (expected yyyy-MM-dd).");
            }
            return null;
        }
    }
}
