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
        <style>
            /* 1) Make the page span the viewport height */
            html, body {
                height: 100%;
            }

            body {
                font-family: "Inter", sans-serif;
                background-color: #f9fafb;
                color: #374151;
                margin: 0;
                padding: 0;
            }

            /* 2) Ensure the outer wrapper and right panel are full-height flex columns */
            .layout-wrapper {
                display: flex;
                min-height: 100vh;       /* key */
            }

            .main-panel {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;  /* header | main | footer stacked */
                min-height: 100vh;       /* key */
            }

            /* 3) Let main content grow to fill available space */
            .content {
                width: 100%;
                margin: 0;
                padding-left: 10px;
                padding-top: 0;
                display: flex;
                flex-direction: column;
                flex: 1 1 auto;          /* key: pushes footer down */
            }

            /* 4) Footer sits at the bottom by taking remaining space above it */
            .main-panel > .footer,
            .main-panel > footer.footer {
                margin-top: auto;        /* key */
            }
        </style>

    </head>
    <body>
        <div class="layout-wrapper d-flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel">
                <jsp:include page="/views/common/header.jsp"/>
                <main class="content">
<!--                    <h1>This is Owner Dashboard</h1>
                    <%
                        // Lay username tu trong session
                        String username = (String) session.getAttribute("tendangnhap");
                        if (session != null) {
                            out.print("Chào bạn " + username);
                        } else {
                            // Neu chua dang nhap thi se la khach
                            out.print("Chào khách!");
                        }
                    %>
                    <c:url var="logoutUrl" value="/logout"/>
                    <h1><a href="${logoutUrl}">Đăng Xuất</a></h1>-->
                    
                </main>
                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>
    </body>
</html>
