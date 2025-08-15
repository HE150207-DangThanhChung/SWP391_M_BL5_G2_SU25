<%-- 
    Document   : ownerDashboard
    Created on : Aug 14, 2025, 8:39:00 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>This is Owner Dashboard</h1>
        <%
            // Lay username tu trong session
            String username = (String)session.getAttribute("tendangnhap");
            if (session != null) {
                    out.print("Chào bạn " + username);
                }else {
                // Neu chua dang nhap thi se la khach
                out.print("Chào khách!");
            }
            %>
            <h1><a href="LogoutController">Đăng Xuất</a></h1>
    </body>
</html>
