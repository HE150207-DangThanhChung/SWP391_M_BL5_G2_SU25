package controller;

import dal.FormRequestDAO;
import model.FormRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationController", urlPatterns = {"/api/notifications/form-requests"})
public class NotificationController extends HttpServlet {
    private FormRequestDAO dao = new FormRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        // Kiểm tra quyền admin
        boolean isAdmin = false;
        Object authUserObj = request.getSession().getAttribute("authUser");
        if (authUserObj != null && authUserObj instanceof model.Employee) {
            model.Employee emp = (model.Employee) authUserObj;
            // Giả sử roleId = 1 là admin, hoặc kiểm tra roleName nếu có
            if (emp.getRoleId() == 1 || (emp.getRoleName() != null && emp.getRoleName().toLowerCase().contains("admin"))) {
                isAdmin = true;
            }
        }
        
        if (isAdmin) {
            try {
                List<FormRequest> todayNewRequests = dao.getTodayNewRequests();
                int count = todayNewRequests.size();
                
                StringBuilder json = new StringBuilder();
                json.append("{\"count\":").append(count).append(",\"requests\":[");
                
                for (int i = 0; i < todayNewRequests.size(); i++) {
                    FormRequest req = todayNewRequests.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                        .append("\"id\":").append(req.getFormRequestId()).append(",")
                        .append("\"description\":\"").append(req.getDescription().replace("\"", "\\\"")).append("\",")
                        .append("\"employeeName\":\"").append(req.getEmployeeName().replace("\"", "\\\"")).append("\",")
                        .append("\"createdAt\":\"").append(req.getCreatedAt().toString()).append("\"")
                        .append("}");
                }
                
                json.append("]}");
                response.getWriter().write(json.toString());
            } catch (Exception e) {
                response.setStatus(500);
                response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
            }
        } else {
            response.getWriter().write("{\"count\":0,\"requests\":[]}");
        }
    }
}
