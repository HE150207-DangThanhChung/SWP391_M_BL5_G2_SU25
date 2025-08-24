<%-- 
    Document   : viewReceipt
    Created on : Aug 24, 2025, 3:55:51 PM
    Author     : hoang
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa định dạng hoá đơn</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <style>
            html, body {
                height: 100%;
            }
            body {
                font-family: "Inter", sans-serif;
                background-color: #f8fafc;
                color: #374151;
                margin: 0;
                padding: 0;
            }
            .layout-wrapper {
                display: flex;
                min-height: 100vh;
            }
            .main-panel {
                flex: 1;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            .content {
                flex: 1;
                padding: 16px;
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                overflow-y: auto;
                max-height: calc(100vh - 120px); /* Account for header/footer */
            }
            .error-border {
                border-color: #ef4444 !important;
            }
            .error-text {
                color: #ef4444;
                font-size: 0.875rem;
            }
        </style>
    </head>
    <body class="bg-slate-50">
        <div class="layout-wrapper flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen">
                <jsp:include page="/views/common/header.jsp"/>

                <main class="content">
                    
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <script>
            
        </script>
    </body>
</html>