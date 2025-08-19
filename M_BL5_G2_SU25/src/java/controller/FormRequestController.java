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
        
        request.setAttribute("formRequests", list);
        request.getRequestDispatcher("/views/formRequest/listFormRequest.jsp").forward(request, response);
    }

    private void doGetEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            String status = request.getParameter("status");
            Date createdAt = Date.valueOf(request.getParameter("createdAt"));
            
            // Sử dụng employeeId từ session thay vì từ form
            int employeeId = sessionEmployeeId.intValue(); // Convert Integer to int
            // Bỏ qua employeeId từ form (nếu có) và chắc chắn dùng employeeId từ session
            String employeeName = employeeDAO.getEmployeeNameById(employeeId);
            
            // Log để debug
            System.out.println("Creating form request with employeeId from session: " + employeeId);
            
            FormRequest fr = new FormRequest(0, description, status, createdAt, employeeId, employeeName);
            dao.add(fr);
            
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
            String status = request.getParameter("status");
            Date createdAt = Date.valueOf(request.getParameter("createdAt"));
            
            // Khi cập nhật, ta giữ nguyên employeeId ban đầu từ form
            // Nhưng chỉ cho phép người đăng nhập với quyền admin hoặc chính người tạo mới được cập nhật
            int formEmployeeId = Integer.parseInt(request.getParameter("employeeId"));
            
            // Nếu không phải admin và không phải chính người tạo, không cho phép cập nhật
            // Giả định rằng admin có một thuộc tính isAdmin trong session
            Boolean isAdmin = (Boolean) request.getSession().getAttribute("isAdmin");
            if (isAdmin == null) isAdmin = false;
            
            if (!isAdmin && sessionEmployeeId.intValue() != formEmployeeId) {
                response.setStatus(403); // Forbidden
                response.getWriter().write("{\"success\":false,\"message\":\"Bạn không có quyền cập nhật yêu cầu này\"}");
                return;
            }
            
            String employeeName = employeeDAO.getEmployeeNameById(formEmployeeId);
            FormRequest fr = new FormRequest(id, description, status, createdAt, formEmployeeId, employeeName);
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