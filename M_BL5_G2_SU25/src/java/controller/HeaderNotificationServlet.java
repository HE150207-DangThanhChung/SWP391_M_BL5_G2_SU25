package controller;

import dal.FormRequestDAO;
import model.FormRequest;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HeaderNotificationServlet", urlPatterns = {"/api/header-notifications"})
public class HeaderNotificationServlet extends HttpServlet {
    private FormRequestDAO dao = new FormRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            // Kiểm tra quyền admin
            boolean isAdmin = false;
            Object authUserObj = request.getSession().getAttribute("authUser");
            if (authUserObj != null && authUserObj instanceof model.Employee) {
                model.Employee emp = (model.Employee) authUserObj;
                if (emp.getRoleId() == 1 || (emp.getRoleName() != null && emp.getRoleName().toLowerCase().contains("admin"))) {
                    isAdmin = true;
                }
            }
            
            if (isAdmin) {
                List<FormRequest> todayNewRequests = dao.getTodayNewRequests();
                int count = todayNewRequests.size();
                
                StringBuilder json = new StringBuilder();
                json.append("{\"count\":").append(count).append(",\"requests\":[");
                
                for (int i = 0; i < todayNewRequests.size(); i++) {
                    FormRequest req = todayNewRequests.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                        .append("\"id\":").append(req.getFormRequestId()).append(",")
                        .append("\"description\":\"").append(escapeJson(req.getDescription())).append("\",")
                        .append("\"employeeName\":\"").append(escapeJson(req.getEmployeeName())).append("\",")
                        .append("\"createdAt\":\"").append(req.getCreatedAt().toString()).append("\"")
                        .append("}");
                }
                
                json.append("]}");
                response.getWriter().write(json.toString());
            } else {
                response.getWriter().write("{\"count\":0,\"requests\":[]}");
            }
        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }
    
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
