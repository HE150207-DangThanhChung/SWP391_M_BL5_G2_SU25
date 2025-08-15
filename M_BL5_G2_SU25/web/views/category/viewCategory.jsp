<%-- 
    Document   : categoryDetail
    Created on : Aug 16, 2025, 11:00:00 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết danh mục</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <style>
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
            .layout-wrapper {
                display: flex;
                min-height: 100vh;
            }
            .main-panel {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            .content {
                width: 100%;
                margin: 0;
                padding-left: 10px;
                padding-top: 0;
                display: flex;
                flex-direction: column;
                flex: 1 1 auto;
            }
            .main-panel > .footer,
            .main-panel > footer.footer {
                margin-top: auto;
            }
        </style>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <div class="layout-wrapper d-flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen">
                <jsp:include page="/views/common/header.jsp"/>

                <main class="content flex-1 p-6 bg-gray-50">
                    <!-- Tiêu đề -->
                    <div class="mb-8 pt-2 pl-2">
                        <div class="flex items-center justify-between">
                            <div>
                                <h1 class="text-3xl font-bold text-gray-900">Chi tiết danh mục</h1>
                                <p class="text-gray-600 mt-1">Thông tin đầy đủ của danh mục sản phẩm</p>
                            </div>
                            <button onclick="history.back()"
                                    class="inline-flex items-center px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white font-medium rounded-lg transition-colors duration-200">
                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                                </svg>
                                Quay lại
                            </button>
                        </div>
                    </div>

                    <!-- Thông tin danh mục -->
                    <div class="max-w-4xl mx-auto">
                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden p-6">
                            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Mã danh mục</label>
                                    <p class="px-4 py-3 border border-gray-300 rounded-lg bg-gray-50">${c.categoryId}</p>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Tên danh mục</label>
                                    <p class="px-4 py-3 border border-gray-300 rounded-lg bg-gray-50">${c.categoryName}</p>
                                </div>

                                <div class="lg:col-span-2">
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Mô tả</label>
                                    <p class="px-4 py-3 border border-gray-300 rounded-lg bg-gray-50">${c.description}</p>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Trạng thái</label>
                                    <p class="px-4 py-3 border border-gray-300 rounded-lg bg-gray-50">
                                        <c:choose>
                                            <c:when test="${c.status == 'Active'}">
                                                <span class="text-green-600 font-semibold">Đang hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-red-600 font-semibold">Ngừng hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>
    </body>
</html>
