<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="model.FormRequest" %>
<%
    FormRequest fr = (FormRequest) request.getAttribute("formRequest");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chi tiết yêu cầu</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <style>
        html, body { height: 100%; font-family: "Inter", sans-serif; }
        .layout-wrapper { display: flex; min-height: 100vh; }
        .main-panel { flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .content { flex: 1; }
        a { text-decoration: none; }
        .action-btn { display: inline-flex; align-items: center; justify-content: center; padding: 0.5rem 1rem; border-radius: 0.375rem; font-weight: 500; transition: all 0.2s; gap: 0.5rem; }
        .btn-edit { background-color: #2563eb; color: white; }
        .btn-edit:hover { background-color: #1d4ed8; }
        .btn-back { background-color: #4b5563; color: white; }
        .btn-back:hover { background-color: #374151; }
        .btn-secondary { background-color: #e5e7eb; color: #4b5563; }
        .btn-secondary:hover { background-color: #d1d5db; }
        .action-buttons-container { display: flex; gap: 0.75rem; }
    </style>
    </head>
<body class="bg-gray-50 text-gray-800">
<div class="layout-wrapper">
    <jsp:include page="/views/common/sidebar.jsp"/>
    <div class="main-panel">
        <jsp:include page="/views/common/header.jsp"/>
        <main class="content p-6 bg-gray-50">
            <div class="mb-8 pt-2 pl-2">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-bold text-gray-900">Chi tiết yêu cầu</h1>
                        <p class="text-gray-600 mt-1">Xem thông tin chi tiết của yêu cầu</p>
                    </div>
                    <div class="action-buttons-container">
                        <!-- Chỉ admin mới thấy nút Chỉnh sửa -->
                        <c:if test="${sessionScope.authUser != null && sessionScope.authUser.roleId == 1}">
                            <a href="${pageContext.request.contextPath}/management/form-requests/edit?id=<%=fr.getFormRequestId()%>" class="action-btn btn-edit">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" class="w-4 h-4">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                                Chỉnh sửa
                            </a>
                        </c:if>
                        <button onclick="history.back()" class="action-btn btn-back">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" class="w-4 h-4">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                            </svg>
                            Quay lại
                        </button>
                    </div>
                </div>
            </div>
            <div class="max-w-2xl mx-auto">
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    <div class="p-6">
                        <ul class="divide-y divide-gray-200">
                            <li class="py-4 flex justify-between">
                                <span class="font-medium text-gray-700">ID:</span>
                                <span class="text-gray-900"><%=fr.getFormRequestId()%></span>
                            </li>
                            <li class="py-4 flex justify-between">
                                <span class="font-medium text-gray-700">Mô tả:</span>
                                <span class="text-gray-900"><%=fr.getDescription()%></span>
                            </li>
                            <li class="py-4 flex justify-between">
                                <span class="font-medium text-gray-700">Trạng thái:</span>
                                <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full
                                    <%=fr.getStatus().equals("Pending") ? "bg-yellow-100 text-yellow-800" : (fr.getStatus().equals("Approved") ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800")%>">
                                    <%=fr.getStatus().equals("Pending") ? "Chờ duyệt" : (fr.getStatus().equals("Approved") ? "Đã duyệt" : "Đã huỷ")%>
                                </span>
                            </li>
                            <li class="py-4 flex justify-between">
                                <span class="font-medium text-gray-700">Ngày tạo:</span>
                                <span class="text-gray-900"><%=fr.getCreatedAt()%></span>
                            </li>
                            <li class="py-4 flex justify-between">
                                <span class="font-medium text-gray-700">Tên nhân viên:</span>
                                <span class="text-gray-900"><%=fr.getEmployeeName()%></span>
                            </li>
                        </ul>
                    </div>
                    <div class="p-6 bg-gray-50 border-t border-gray-200 flex justify-end">
                        <a href="${pageContext.request.contextPath}/management/form-requests" class="action-btn btn-secondary">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" class="w-4 h-4">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
                            </svg>
                            Quay lại danh sách
                        </a>
                        <!-- Chỉ admin mới thấy nút Chỉnh sửa -->
                        <c:if test="${sessionScope.authUser != null && sessionScope.authUser.roleId == 1}">
                            <a href="${pageContext.request.contextPath}/management/form-requests/edit?id=<%=fr.getFormRequestId()%>" class="action-btn btn-edit">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" class="w-4 h-4">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                                Chỉnh sửa
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
        <jsp:include page="/views/common/footer.jsp"/>
    </div>
</div>
    </body>
</html>
