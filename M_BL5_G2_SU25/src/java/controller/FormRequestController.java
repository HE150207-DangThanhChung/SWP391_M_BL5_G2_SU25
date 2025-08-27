package controller;

import dal.FormRequestDAO;
import model.FormRequest;
import dal.EmployeeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "FormRequestController", urlPatterns = {"/management/form-requests", "/management/form-requests/add", "/management/form-requests/edit", "/management/form-requests/delete", "/management/form-requests/view"})
public class FormRequestController extends HttpServlet {
    private FormRequestDAO dao = new FormRequestDAO();
    private EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/management/form-requests":
                doGetList(request, response);
                break;
            case "/management/form-requests/add":
                // Lấy employeeId từ session đăng nhập
                Integer empIdSession = (Integer) request.getSession().getAttribute("employeeId");
                // Nếu chưa đăng nhập, chuyển hướng đến trang đăng nhập
                if (empIdSession == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                String employeeName = employeeDAO.getEmployeeNameById(empIdSession);
                request.setAttribute("employeeId", empIdSession);
                request.setAttribute("employeeName", employeeName);
                request.getRequestDispatcher("/views/formRequest/addFormRequest.jsp").forward(request, response);
                break;
            case "/management/form-requests/edit":
                doGetEdit(request, response);
                break;
            case "/management/form-requests/view":
                doGetView(request, response);
                break;
            default:
                response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/management/form-requests/add":
                doPostAdd(request, response);
                break;
            case "/management/form-requests/edit":
                doPostEdit(request, response);
                break;
            case "/management/form-requests/delete":
                doPostDelete(request, response);
                break;
            default:
                response.sendError(404);
        }
    }

    private void doGetList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        
        List<FormRequest> list;
        
        // Kiểm tra cả search và status
        if ((status != null && !status.isEmpty()) || (search != null && !search.isEmpty())) {
            // Ghi log để theo dõi
            System.out.println("Filtering with status: " + status + ", search: " + search);
            list = dao.getByFilter(status, search);
        } else {
            list = dao.getAll();
        }
        
        // Kiểm tra quyền admin và lấy thông báo yêu cầu mới
        boolean isAdmin = false;
        List<FormRequest> todayNewRequests = null;
        Object authUserObj = request.getSession().getAttribute("authUser");
        if (authUserObj != null && authUserObj instanceof model.Employee) {
            model.Employee emp = (model.Employee) authUserObj;
            // Giả sử roleId = 1 là admin, hoặc kiểm tra roleName nếu có
            if (emp.getRoleId() == 1 || (emp.getRoleName() != null && emp.getRoleName().toLowerCase().contains("admin"))) {
                isAdmin = true;
                todayNewRequests = dao.getTodayNewRequests();
            }
        }
        request.setAttribute("formRequests", list);
        request.setAttribute("isAdmin", isAdmin);
        request.setAttribute("todayNewRequests", todayNewRequests);
        request.getRequestDispatcher("/views/formRequest/listFormRequest.jsp").forward(request, response);
    }

    private void doGetEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra quyền admin trước khi cho phép edit
        boolean isAdmin = false;
        Object authUserObj = request.getSession().getAttribute("authUser");
        if (authUserObj != null && authUserObj instanceof model.Employee) {
            model.Employee emp = (model.Employee) authUserObj;
            // Admin có roleId = 1 HOẶC roleName chứa "admin" (không phân biệt hoa thường)
            if (emp.getRoleId() == 1) {
                isAdmin = true;
            } else if (emp.getRoleName() != null && emp.getRoleName().toLowerCase().contains("admin")) {
                isAdmin = true;
            }
            // Debug info để kiểm tra
            System.out.println("DEBUG doGetEdit - User ID: " + emp.getEmployeeId() + ", roleId: " + emp.getRoleId() + ", roleName: " + emp.getRoleName() + ", isAdmin: " + isAdmin);
        } else {
            System.out.println("DEBUG doGetEdit - authUser not found or not Employee type. authUserObj: " + authUserObj);
        }
        
        if (!isAdmin) {
            // Nếu không phải admin, chuyển hướng về danh sách với thông báo lỗi
            System.out.println("DEBUG doGetEdit - Access denied for non-admin user");
            response.sendRedirect(request.getContextPath() + "/management/form-requests?error=access_denied");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        FormRequest fr = dao.getById(id);
        String employeeName = employeeDAO.getEmployeeNameById(fr.getEmployeeId());
        request.setAttribute("formRequest", fr);
        request.setAttribute("employeeName", employeeName);
        request.getRequestDispatcher("/views/formRequest/editFormRequest.jsp").forward(request, response);
    }

    private void doGetView(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        FormRequest fr = dao.getById(id);
        request.setAttribute("formRequest", fr);
        request.getRequestDispatcher("/views/formRequest/viewFormRequest.jsp").forward(request, response);
    }

    private void doPostAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        // Lấy employeeId từ session đăng nhập để kiểm tra
        Integer sessionEmployeeId = (Integer) request.getSession().getAttribute("employeeId");
        if (sessionEmployeeId == null) {
            // Nếu chưa đăng nhập, trả về lỗi 401 Unauthorized
            response.setStatus(401); // Unauthorized
            response.getWriter().write("{\"success\":false,\"message\":\"Phiên đăng nhập đã hết hạn\"}");
            return;
        }
        
        try {
            String description = request.getParameter("description");
            // Luôn đặt status là "Pending" cho yêu cầu mới, không phụ thuộc vào input từ client
            String status = "Pending";
            Date createdAt = Date.valueOf(request.getParameter("createdAt"));
            
            // Sử dụng employeeId từ session thay vì từ form
            int employeeId = sessionEmployeeId.intValue(); // Convert Integer to int
            // Bỏ qua employeeId từ form (nếu có) và chắc chắn dùng employeeId từ session
            String employeeName = employeeDAO.getEmployeeNameById(employeeId);
            
            // Log để debug
            System.out.println("Creating form request with employeeId from session: " + employeeId);
            
            FormRequest fr = new FormRequest(0, description, status, createdAt, employeeId, employeeName);
            dao.add(fr);
            
            // Đã xóa phần xử lý thông báo
            
            // Trả về thành công kèm theo thông tin người tạo từ session
            response.getWriter().write("{\"success\":true,\"message\":\"Thêm yêu cầu thành công\",\"employeeId\":" + employeeId + ",\"employeeName\":\"" + employeeName + "\"}");
        } catch (Exception e) {
            // Trả về lỗi
            response.setStatus(500); // Internal Server Error
            response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    private void doPostEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        // Lấy employeeId từ session đăng nhập để kiểm tra
        Integer sessionEmployeeId = (Integer) request.getSession().getAttribute("employeeId");
        if (sessionEmployeeId == null) {
            // Nếu chưa đăng nhập, trả về lỗi 401 Unauthorized
            response.setStatus(401); // Unauthorized
            response.getWriter().write("{\"success\":false,\"message\":\"Phiên đăng nhập đã hết hạn\"}");
            return;
        }
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String description = request.getParameter("description");
            String statusFromRequest = request.getParameter("status");
            Date createdAt = Date.valueOf(request.getParameter("createdAt"));
            
            // Khi cập nhật, ta giữ nguyên employeeId ban đầu từ form
            // Nhưng chỉ cho phép người đăng nhập với quyền admin hoặc chính người tạo mới được cập nhật
            int formEmployeeId = Integer.parseInt(request.getParameter("employeeId"));
            
            // Kiểm tra quyền admin từ authUser
            boolean isAdmin = false;
            Object authUserObj = request.getSession().getAttribute("authUser");
            if (authUserObj != null && authUserObj instanceof model.Employee) {
                model.Employee emp = (model.Employee) authUserObj;
                // Admin có roleId = 1 HOẶC roleName chứa "admin" (không phân biệt hoa thường)
                if (emp.getRoleId() == 1) {
                    isAdmin = true;
                } else if (emp.getRoleName() != null && emp.getRoleName().toLowerCase().contains("admin")) {
                    isAdmin = true;
                }
                // Debug info để kiểm tra
                System.out.println("DEBUG doPostEdit - User ID: " + emp.getEmployeeId() + ", roleId: " + emp.getRoleId() + ", roleName: " + emp.getRoleName() + ", isAdmin: " + isAdmin);
            } else {
                System.out.println("DEBUG doPostEdit - authUser not found or not Employee type. authUserObj: " + authUserObj);
            }
            
            // Lấy trạng thái hiện tại từ database
            FormRequest currentRequest = dao.getById(id);
            String finalStatus = currentRequest.getStatus(); // Mặc định giữ nguyên trạng thái cũ
            
            // Chỉ admin mới được thay đổi trạng thái
            if (isAdmin) {
                finalStatus = statusFromRequest; // Admin có thể thay đổi trạng thái
            }
            
            // Kiểm tra quyền sửa: 
            if (!isAdmin) {
                // Người dùng thường chỉ có thể sửa yêu cầu của chính mình
                if (sessionEmployeeId.intValue() != formEmployeeId) {
                    response.setStatus(403); // Forbidden
                    response.getWriter().write("{\"success\":false,\"message\":\"Bạn không có quyền cập nhật yêu cầu này\"}");
                    return;
                }
            }
            // Admin có thể sửa mọi yêu cầu, không cần kiểm tra thêm
            
            String employeeName = employeeDAO.getEmployeeNameById(formEmployeeId);
            FormRequest fr = new FormRequest(id, description, finalStatus, createdAt, formEmployeeId, employeeName);
            dao.update(fr);
            
            // Trả về thành công
            response.getWriter().write("{\"success\":true,\"message\":\"Cập nhật yêu cầu thành công\",\"employeeId\":" + formEmployeeId + ",\"employeeName\":\"" + employeeName + "\"}");
        } catch (Exception e) {
            // Trả về lỗi
            response.setStatus(500); // Internal Server Error
            response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    private void doPostDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        // Lấy employeeId từ session đăng nhập để kiểm tra
        Integer sessionEmployeeId = (Integer) request.getSession().getAttribute("employeeId");
        if (sessionEmployeeId == null) {
            // Nếu chưa đăng nhập, trả về lỗi 401 Unauthorized
            response.setStatus(401); // Unauthorized
            response.getWriter().write("{\"success\":false,\"message\":\"Phiên đăng nhập đã hết hạn\"}");
            return;
        }
        
        // Kiểm tra quyền admin trước khi cho phép xóa
        boolean isAdmin = false;
        Object authUserObj = request.getSession().getAttribute("authUser");
        if (authUserObj != null && authUserObj instanceof model.Employee) {
            model.Employee emp = (model.Employee) authUserObj;
            if (emp.getRoleId() == 1 || (emp.getRoleName() != null && emp.getRoleName().toLowerCase().contains("admin"))) {
                isAdmin = true;
            }
        }
        
        if (!isAdmin) {
            response.setStatus(403); // Forbidden
            response.getWriter().write("{\"success\":false,\"message\":\"Bạn không có quyền xóa yêu cầu\"}");
            return;
        }
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
            
            // Trả về thành công
            response.getWriter().write("{\"success\":true,\"message\":\"Xóa yêu cầu thành công\"}");
        } catch (Exception e) {
            // Trả về lỗi
            response.setStatus(500); // Internal Server Error
            response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
} 