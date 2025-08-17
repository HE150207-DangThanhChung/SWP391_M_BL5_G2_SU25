<%-- 
    Document   : sidebar
    Created on : Aug 14, 2025, 9:13:02 AM
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
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"
            crossorigin="anonymous"
            />
        <link
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
            rel="stylesheet"
            />
        <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
            rel="stylesheet"
            />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
        <style>
            body {
                font-family: "Inter", sans-serif;
                background-color: #f9fafb;
                color: #ff0e7a;
                margin: 0;
                padding: 0;
            }
            .report-section {
                position: relative;
                width: 100%;
                padding:5px 17px;
                font-weight: 500
            }

            /* Ẩn checkbox */
            .report-toggle {
                display: none;
            }

            .report-label {
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                color: #333;
            }

            .report-label i:last-of-type {
                transition: transform 0.5s ease;
                position: absolute;
                right:15px;
            }

            /* Khối nội dung sẽ trượt xuống */
            .report-content {
                margin-top: 5px;
                overflow: hidden;
                max-height: 0;
                transition: max-height 0.5s ease;
                border-left: 1px solid black;
                margin-left: 20px;

            }

            /* Khi checkbox được check: hiện nội dung */
            .report-toggle:checked ~ .report-content {
                max-height: 500px; /* Giới hạn max, đảm bảo vừa nội dung */
            }

            /* Quay mũi tên xuống thành mũi tên lên */
            .report-toggle:checked + .report-label i:last-of-type {
                transform: rotate(180deg);
            }

            .report-content a {
                display: block;
                color: #333;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <aside class="sidebar">
            <div class="sidebar-header">
                <img
                    src="https://storage.googleapis.com/a1aa/image/c15bc769-7eec-44e1-44a6-dd7ee21bd113.jpg"
                    alt="Sapo logo white letter S on dark background"
                    width="32"
                    height="32"
                    />
                <span>Happy Sale</span>

            </div>
            <nav class="sidebar-nav">
                <c:set var="currentPath" value="${pageContext.request.servletPath}" />
                // Mỗi người làm phần nào sẽ vào đây và điền link cho phần đó nhé
                <!--<a href="${pageContext.request.contextPath} sau đó điền link vào đây">-->

                <a href="">    
                    <i class="fas fa-warehouse"></i>
                    Quản lý cửa hàng
                </a>
                <a href="">
                    <i class="fas fa-user-friends"></i> 
                    Quản lí nhân viên
                </a>
                <a href="">
                    <i class="fas fa-tags"></i> 
                    Quản lí khách hàng
                </a>
                <a href="">
                    <i class="fas fa-tags"></i> 
                    Quản lí nhập kho
                </a>
                <a href="">
                    <i class="fas fa-tags"></i> 
                    Quản lí danh mục
                </a>
                <a href="${pageContext.request.contextPath}/management/suplliers">
                    <i class="fas fa-tags"></i> 
                    Quản lí nhà cung cấp
                </a>
                <a href="">
                    <i class="fas fa-tags"></i> 
                    Quản lí mã khuyến mãi
                </a>
                <a href="">
                    <i class="fas fa-tags"></i> 
                    Quản lí đơn hàng
                </a>
                <a href="">
                    <i class="fas fa-tags"></i> 
                    Quản lí báo cáo
                </a>
                <a href="">
                    <i class="fas fa-tags"></i> 
                    Quản lí sản phẩm
                </a>

        </aside>
    </body>
</html>
