/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.EmployeeDAO;
import dal.FormRequestDAO;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Employee;
import model.FormRequest;

@WebServlet(name = "EmployeeController", urlPatterns = {
    "/management/employees",
    "/management/employees/add",
    "/management/employees/edit",
    "/management/employees/detail",
    "/management/employees/delete",
    "/management/employees/change-status",
    "/management/employees/upload-avatar",
    "/management/employees/report"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class EmployeeController extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "uploads/avatars";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EmployeeController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EmployeeController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        System.out.println("DEBUG: EmployeeController doGet called with path: " + path);
        
        switch (path) {
            case "/management/employees":
                doGetList(request, response);
                break;
            case "/management/employees/add":
                doGetAdd(request, response);
                break;
            case "/management/employees/edit":
                doGetEdit(request, response);
                break;
            case "/management/employees/detail":
                doGetDetail(request, response);
                break;
            case "/management/employees/report":
                System.out.println("DEBUG: Routing to doGetReport method");
                doGetReport(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case "/management/employees/add":
                doPostAdd(request, response);
                break;
            case "/management/employees/edit":
                doPostEdit(request, response);
                break;
            case "/management/employees/delete":
                doPostDelete(request, response);
                break;
            case "/management/employees/change-status":
                doPostChangeStatus(request, response);
                break;
            case "/management/employees/upload-avatar":
                doPostUploadAvatar(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }
    
    private void doGetList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EmployeeDAO dao = new EmployeeDAO();
        
        // Pagination parameters
        int page = 1;
        int limit = 10;
        
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            // Keep default page value
        }
        
        // Search and filter parameters
        String searchKey = request.getParameter("search");
        String status = request.getParameter("status");
        
        // Calculate offset for pagination
        int offset = (page - 1) * limit;
        
        // Get filtered and paginated data
        java.util.List<Employee> employees = dao.getAllEmployeesWithPagingAndFilter(searchKey, status, offset, limit);
        int totalEmployees = dao.countEmployeesWithFilter(searchKey, status);
        
        // Calculate total pages
        int totalPages = (int) Math.ceil((double) totalEmployees / limit);
        
        // Set attributes for JSP
        request.setAttribute("employees", employees);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKey", searchKey);
        request.setAttribute("status", status);
        
        // Forward to JSP
        request.getRequestDispatcher("/views/employee/listEmployee.jsp").forward(request, response);
    }
    
    private void doGetAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/employee/addEmployee.jsp").forward(request, response);
    }
    
    private void doGetEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EmployeeDAO dao = new EmployeeDAO();
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/management/employees");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Employee employee = dao.getEmployeeById(id);
            
            if (employee == null || employee.getEmployeeId() == 0) {
                response.sendRedirect(request.getContextPath() + "/management/employees");
                return;
            }
            
            request.setAttribute("e", employee);
            request.getRequestDispatcher("/views/employee/editDetailEmployee.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/management/employees");
        }
    }
    
    private void doGetDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EmployeeDAO dao = new EmployeeDAO();
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/management/employees");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Employee employee = dao.getEmployeeById(id);
            
            if (employee == null || employee.getEmployeeId() == 0) {
                response.sendRedirect(request.getContextPath() + "/management/employees");
                return;
            }
            
            request.setAttribute("e", employee);
            request.getRequestDispatcher("/views/employee/viewEmployee.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/management/employees");
        }
    }
    
    private void doPostAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EmployeeDAO dao = new EmployeeDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();
        try {
            String username = request.getParameter("username");
            String firstName = request.getParameter("firstName");
            String middleName = request.getParameter("middleName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String status = request.getParameter("status");
            String gender = request.getParameter("gender");
            
            // Get password or use default
            String password = request.getParameter("password");
            if (password == null || password.isEmpty()) {
                // Default password is the username + "123"
                password = username + "123";
            }
            
            // Get CCCD or use default
            String cccd = request.getParameter("cccd");
            if (cccd == null) {
                // Default to empty string
                cccd = "";
            }
            
            // Get Address or use default
            String address = request.getParameter("address");
            if (address == null) {
                // Default to empty string
                address = "";
            }
            
            // Avatar is null by default
            String avatar = request.getParameter("avatar");
            
            // Get DoB or use default
            java.sql.Date dob;
            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    dob = java.sql.Date.valueOf(dobStr); // Expects format YYYY-MM-DD
                } catch (IllegalArgumentException e) {
                    // If date format is invalid, use default
                    dob = java.sql.Date.valueOf("2000-01-01");
                }
            } else {
                // Default DoB is 2000-01-01
                dob = java.sql.Date.valueOf("2000-01-01");
            }
            
            // Always set StartAt to today's date
            java.sql.Date startAt = new java.sql.Date(System.currentTimeMillis());
            
            // Get roleId and storeId with default values of 1 if not provided
            int roleId = 1;
            int storeId = 1;
            
            try {
                String roleIdStr = request.getParameter("roleId");
                if (roleIdStr != null && !roleIdStr.isEmpty()) {
                    roleId = Integer.parseInt(roleIdStr);
                }
            } catch (NumberFormatException e) {
                // Use default value if parsing fails
            }
            
            try {
                String storeIdStr = request.getParameter("storeId");
                if (storeIdStr != null && !storeIdStr.isEmpty()) {
                    storeId = Integer.parseInt(storeIdStr);
                }
            } catch (NumberFormatException e) {
                // Use default value if parsing fails
            }

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

            boolean success = dao.addEmployee(username, firstName, middleName, lastName, phone, email, gender, status, roleId, storeId, password, cccd, dob, startAt, address, avatar);
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
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String firstName = request.getParameter("firstName");
            String middleName = request.getParameter("middleName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String status = request.getParameter("status");
            String gender = request.getParameter("gender");
            
            // Get CCCD or use default
            String cccd = request.getParameter("cccd");
            if (cccd == null) {
                // Default to empty string
                cccd = "";
            }
            
            // Get Address or use default
            String address = request.getParameter("address");
            if (address == null) {
                // Default to empty string
                address = "";
            }
            
            // Avatar is kept as is by default
            String avatar = request.getParameter("avatar");
            
            // Get DoB or use default
            java.sql.Date dob = null;
            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    dob = java.sql.Date.valueOf(dobStr); // Expects format YYYY-MM-DD
                } catch (IllegalArgumentException e) {
                    // If date format is invalid, use default
                    dob = null;
                }
            }

            // Check if username, email, phone exists (except for the current employee)
            Employee currentEmployee = dao.getEmployeeById(id);
            if (!currentEmployee.getUserName().equals(username) && dao.isUsernameExisted(username)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Username is already existed!");
                sendJson(response, jsonMap);
                return;
            }
            if (!currentEmployee.getEmail().equals(email) && dao.isEmailExisted(email)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Email is already existed!");
                sendJson(response, jsonMap);
                return;
            }
            if (!currentEmployee.getPhone().equals(phone) && dao.isPhoneExisted(phone)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Phone is already existed!");
                sendJson(response, jsonMap);
                return;
            }

            boolean success = dao.editEmployee(id, username, firstName, middleName, lastName, phone, email, gender, status, cccd, dob, address, avatar);
            if (success) {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Employee updated successfully!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Failed to update employee. Please try again.");
            }
            sendJson(response, jsonMap);
        } catch (Exception e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Something wrong, please try again later!");
            sendJson(response, jsonMap);
        }
    }
    
    private void doPostDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EmployeeDAO dao = new EmployeeDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Get the employee to check if avatar exists and should be deleted
            Employee employee = dao.getEmployeeById(id);
            
            boolean success = dao.deleteEmployee(id);
            if (success) {
                // If employee had an avatar, delete it from the server
                if (employee != null && employee.getAvatar() != null && !employee.getAvatar().isEmpty()) {
                    String avatarPath = getServletContext().getRealPath("") + File.separator + employee.getAvatar();
                    try {
                        Files.deleteIfExists(Paths.get(avatarPath));
                    } catch (IOException e) {
                        // Log error but continue
                        System.err.println("Failed to delete avatar file: " + avatarPath);
                    }
                }
                
                jsonMap.put("ok", true);
                jsonMap.put("message", "Employee deleted successfully!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Failed to delete employee. Please try again.");
            }
            sendJson(response, jsonMap);
        } catch (Exception e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Something wrong, please try again later!");
            sendJson(response, jsonMap);
        }
    }
    
    private void doPostChangeStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EmployeeDAO dao = new EmployeeDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            
            boolean success = dao.changeEmployeeStatus(id, status);
            if (success) {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Employee status updated successfully!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Failed to update employee status. Please try again.");
            }
            sendJson(response, jsonMap);
        } catch (Exception e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Something wrong, please try again later!");
            sendJson(response, jsonMap);
        }
    }
    
    private void doPostUploadAvatar(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HashMap<String, Object> jsonMap = new HashMap<>();
        
        try {
            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Get the file part
            Part filePart = request.getPart("avatar");
            if (filePart == null) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "No file uploaded");
                sendJson(response, jsonMap);
                return;
            }
            
            // Get file name and generate unique name to prevent overwriting
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = "";
            int i = fileName.lastIndexOf('.');
            if (i > 0) {
                fileExtension = fileName.substring(i);
            }
            
            // Generate unique file name
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            String filePath = uploadPath + File.separator + uniqueFileName;
            
            // Save the file
            filePart.write(filePath);
            
            // Return the relative path to the file (without context path)
            String relativePath = UPLOAD_DIRECTORY + "/" + uniqueFileName;
            
            jsonMap.put("ok", true);
            jsonMap.put("message", "File uploaded successfully");
            jsonMap.put("filePath", relativePath);
            
            sendJson(response, jsonMap);
            
        } catch (Exception e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Error uploading file: " + e.getMessage());
            sendJson(response, jsonMap);
        }
    }
    
    private void sendJson(HttpServletResponse response, HashMap<String, Object> jsonMap) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String jsonString = "{";
        boolean first = true;
        for (String key : jsonMap.keySet()) {
            if (!first) {
                jsonString += ",";
            }
            first = false;
            
            Object value = jsonMap.get(key);
            if (value instanceof String) {
                jsonString += "\"" + key + "\":\"" + value + "\"";
            } else {
                jsonString += "\"" + key + "\":" + value;
            }
        }
        jsonString += "}";
        
        response.getWriter().write(jsonString);
    }
    
    // New method for handling employee reports
    private void doGetReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EmployeeDAO employeeDao = new EmployeeDAO();
        FormRequestDAO formRequestDao = new FormRequestDAO();
        String idStr = request.getParameter("id");
        String searchQuery = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        
        // Debug output to help diagnose the issue
        System.out.println("DEBUG: doGetReport called with id=" + idStr + ", search=" + searchQuery + ", status=" + statusFilter);
        
        if (idStr == null || idStr.isEmpty()) {
            // If no specific employee ID is provided, show all employee reports
            List<Employee> employees = employeeDao.getAllActiveEmployees();
            
            // Apply search filter if provided
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String search = searchQuery.trim().toLowerCase();
                employees = employees.stream()
                    .filter(emp -> 
                        emp.getFirstName().toLowerCase().contains(search) ||
                        emp.getLastName().toLowerCase().contains(search) ||
                        emp.getEmail().toLowerCase().contains(search) ||
                        String.valueOf(emp.getEmployeeId()).contains(search))
                    .collect(java.util.stream.Collectors.toList());
            }
            
            // Fetch all form requests for all employees
            List<FormRequest> allFormRequests = new ArrayList<>();
            
            // Filter by status if provided
            if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                allFormRequests = formRequestDao.getByStatus(statusFilter);
            } else {
                allFormRequests = formRequestDao.getAll();
            }
            
            // Get report stats for all employees
            HashMap<String, Integer> overallStats = new HashMap<>();
            int totalReports = allFormRequests.size();
            
            // Count report statuses
            int pendingReports = (int) allFormRequests.stream().filter(r -> "Pending".equals(r.getStatus())).count();
            int approvedReports = (int) allFormRequests.stream().filter(r -> "Approved".equals(r.getStatus())).count();
            int rejectedReports = (int) allFormRequests.stream().filter(r -> "Rejected".equals(r.getStatus())).count();
            int resolvedReports = approvedReports;
            
            // Calculate approval rate
            double approvalRate = totalReports > 0 ? (double) approvedReports / totalReports * 100 : 0;
            
            // Set attributes for the view
            request.setAttribute("employees", employees);
            request.setAttribute("search", searchQuery);
            request.setAttribute("employeeReports", allFormRequests);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("isAllReportsView", true);
            
            // Set statistics
            request.setAttribute("totalReports", totalReports);
            request.setAttribute("pendingReports", pendingReports);
            request.setAttribute("approvedReports", approvedReports);
            request.setAttribute("rejectedReports", rejectedReports);
            request.setAttribute("resolvedReports", resolvedReports);
            request.setAttribute("approvalRate", approvalRate);
            
            request.getRequestDispatcher("/views/employee/viewEmployeeReport.jsp").forward(request, response);
            return;
        }
        
        try {
            System.out.println("DEBUG: Parsing employee ID from: " + idStr);
            
            // Ensure we have a valid ID string
            if (idStr == null || idStr.trim().isEmpty()) {
                System.out.println("ERROR: Employee ID is null or empty");
                response.sendRedirect(request.getContextPath() + "/management/employees");
                return;
            }
            
            int id = Integer.parseInt(idStr.trim());
            System.out.println("DEBUG: Successfully parsed employee ID: " + id);
            
            // Get employee information
            Employee employee = employeeDao.getEmployeeById(id);
            
            System.out.println("DEBUG: Retrieved employee: " + (employee != null ? 
                "ID=" + employee.getEmployeeId() + ", Name=" + employee.getFirstName() + " " + employee.getLastName() : "null"));
            
            if (employee == null || employee.getEmployeeId() == 0) {
                System.out.println("ERROR: Employee not found for ID: " + id);
                response.sendRedirect(request.getContextPath() + "/management/employees");
                return;
            }
            
            // Get form requests (reports) for this specific employee using optimized DAO methods
            List<FormRequest> employeeReports;
            
            // Use appropriate DAO method based on filter
            if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                // If status filter is provided, use the method that filters by both employee ID and status
                System.out.println("DEBUG: Getting reports for Employee ID: " + id + " with status: " + statusFilter);
                employeeReports = formRequestDao.getByEmployeeIdAndStatus(id, statusFilter);
            } else {
                // Otherwise just get all reports for this employee
                System.out.println("DEBUG: Getting all reports for Employee ID: " + id);
                employeeReports = formRequestDao.getByEmployeeId(id);
            }
            
            System.out.println("DEBUG: Found " + employeeReports.size() + " reports for employee " + id);
            
            // Check if no reports are found
            if (employeeReports.isEmpty()) {
                if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                    // If a filter is applied and no results, just let the JSP handle it with its existing message
                    System.out.println("DEBUG: No reports found for Employee ID " + id + " with status filter: " + statusFilter);
                } else {
                    // If no filter and still no reports, check if employee has any reports at all
                    HashMap<String, Integer> statsCheck = formRequestDao.getEmployeeReportStats(id);
                    if (statsCheck.get("total") == 0) {
                        System.out.println("DEBUG: Employee has no reports at all - redirecting with message");
                        request.getSession().setAttribute("noReportsMessage", 
                            "Nhân viên " + employee.getFirstName() + " " + employee.getLastName() + " chưa có yêu cầu nào được ghi nhận.");
                        response.sendRedirect(request.getContextPath() + "/management/employees?showNoReportsAlert=true");
                        return;
                    }
                }
            } else {
                System.out.println("DEBUG: Reports found - NOT setting noReports flag");
                // Ensure noReports flag is false when we have reports
                request.setAttribute("noReports", false);
            }
            
            // No need to sort - reports are already sorted by creation date (newest first) in the SQL query
            
            // Pass employee object as "e" (to match JSP naming convention)
            request.setAttribute("e", employee);
            request.setAttribute("employeeReports", employeeReports);
            request.setAttribute("statusFilter", statusFilter);
            
            // Get optimized statistics directly from the database
            HashMap<String, Integer> reportStats = formRequestDao.getEmployeeReportStats(id);
            
            int totalReports = reportStats.get("total");
            int pendingReports = reportStats.get("pending");
            int approvedReports = reportStats.get("approved");
            int rejectedReports = reportStats.get("rejected");
            int resolvedReports = approvedReports; // For now, approved means resolved
            
            System.out.println("DEBUG: Statistics - Total: " + totalReports + ", Pending: " + pendingReports + ", Approved: " + approvedReports + ", Rejected: " + rejectedReports);
            
            request.setAttribute("totalReports", totalReports);
            request.setAttribute("pendingReports", pendingReports);
            request.setAttribute("approvedReports", approvedReports);
            request.setAttribute("rejectedReports", rejectedReports);
            request.setAttribute("resolvedReports", resolvedReports);
            
            // Calculate performance metrics
            double approvalRate = totalReports > 0 ? (double) approvedReports / totalReports * 100 : 0;
            request.setAttribute("approvalRate", approvalRate);
            
            request.getRequestDispatcher("/views/employee/viewEmployeeReport.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/management/employees");
        }
    }
}
