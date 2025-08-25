<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="dal.FormRequestDAO, model.FormRequest, java.util.List" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    try {
        FormRequestDAO dao = new FormRequestDAO();
        
        // Kiểm tra quyền admin
        boolean isAdmin = false;
        Object authUserObj = session.getAttribute("authUser");
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
                
                String description = req.getDescription();
                String employeeName = req.getEmployeeName();
                
                // Escape JSON strings
                if (description != null) {
                    description = description.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
                }
                if (employeeName != null) {
                    employeeName = employeeName.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
                }
                
                json.append("{")
                    .append("\"id\":").append(req.getFormRequestId()).append(",")
                    .append("\"description\":\"").append(description != null ? description : "").append("\",")
                    .append("\"employeeName\":\"").append(employeeName != null ? employeeName : "").append("\",")
                    .append("\"createdAt\":\"").append(req.getCreatedAt().toString()).append("\"")
                    .append("}");
            }
            
            json.append("]}");
            out.print(json.toString());
        } else {
            out.print("{\"count\":0,\"requests\":[]}");
        }
    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
    }
%>
