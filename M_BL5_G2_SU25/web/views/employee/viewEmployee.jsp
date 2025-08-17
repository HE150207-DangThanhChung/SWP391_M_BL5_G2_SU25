<%-- 
    Document   : viewEmployee
    Created on : Aug 15, 2025, 10:11:36 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết nhân viên</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

        <style>
            html, body {
                height: 100%;
                font-family: "Inter", sans-serif;
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
            }
            
            /* Remove underlines from links */
            a {
                text-decoration: none;
            }
            
            /* Action button styles */
            .action-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 0.5rem 1rem;
                border-radius: 0.375rem;
                font-weight: 500;
                transition: all 0.2s;
                gap: 0.5rem;
            }
            
            .action-btn svg {
                width: 1rem;
                height: 1rem;
            }
            
            /* Edit button */
            .btn-edit {
                background-color: #2563eb; /* blue-600 */
                color: white;
            }
            
            .btn-edit:hover {
                background-color: #1d4ed8; /* blue-700 */
            }
            
            /* Back button */
            .btn-back {
                background-color: #4b5563; /* gray-600 */
                color: white;
            }
            
            .btn-back:hover {
                background-color: #374151; /* gray-700 */
            }
            
            /* Secondary button */
            .btn-secondary {
                background-color: #e5e7eb; /* gray-200 */
                color: #4b5563; /* gray-600 */
            }
            
            .btn-secondary:hover {
                background-color: #d1d5db; /* gray-300 */
            }
            
            /* Button container */
            .action-buttons-container {
                display: flex;
                gap: 0.75rem;
            }
        </style>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <div class="layout-wrapper">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel">
                <jsp:include page="/views/common/header.jsp"/>

                <main class="content p-6 bg-gray-50">
                    <!-- Header Section -->
                    <div class="mb-8 pt-2 pl-2">
                        <div class="flex items-center justify-between">
                            <div>
                                <h1 class="text-3xl font-bold text-gray-900">Chi tiết nhân viên</h1>
                                <p class="text-gray-600 mt-1">Xem thông tin chi tiết của nhân viên</p>
                            </div>
                            <div class="action-buttons-container">
                                <a href="${pageContext.request.contextPath}/management/employees/edit?id=${e.employeeId}"
                                   class="action-btn btn-edit">
                                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                          d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                                    </svg>
                                    Chỉnh sửa
                                </a>
                                <button onclick="history.back()"
                                        class="action-btn btn-back">
                                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                          d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                                    </svg>
                                    Quay lại
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Employee Details Container -->
                    <div class="max-w-4xl mx-auto">
                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                            <!-- Profile Header -->
                            <div class="p-6 bg-gray-50 border-b border-gray-200">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0">
                                        <c:choose>
                                            <c:when test="${not empty e.avatar}">
                                                <img src="${e.avatar}" alt="Profile" class="h-24 w-24 rounded-full object-cover border-4 border-white shadow-md">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="h-24 w-24 rounded-full bg-blue-100 flex items-center justify-center text-blue-500 text-2xl font-bold border-4 border-white shadow-md">
                                                    ${fn:substring(e.firstName, 0, 1)}${fn:substring(e.lastName, 0, 1)}
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="ml-6">
                                        <h2 class="text-2xl font-bold text-gray-900">${e.firstName} ${e.lastName}</h2>
                                        <div class="mt-1 flex items-center">
                                            <span class="text-gray-600">${e.roleName}</span>
                                            <span class="mx-2 text-gray-400">•</span>
                                            <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full 
                                                  ${e.status == 'Active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                                ${e.status}
                                            </span>
                                        </div>
                                        <p class="text-gray-500 mt-1">ID: ${e.employeeId}</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Employee Information -->
                            <div class="p-6">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <!-- Personal Information -->
                                    <div>
                                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Thông tin cá nhân</h3>
                                        <dl class="space-y-3">
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Tên đăng nhập</dt>
                                                <dd class="mt-1 text-sm text-gray-900">${e.userName}</dd>
                                            </div>
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Họ và tên</dt>
                                                <dd class="mt-1 text-sm text-gray-900">${e.firstName} ${e.lastName}</dd>
                                            </div>
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Giới tính</dt>
                                                <dd class="mt-1 text-sm text-gray-900">
                                                    <c:choose>
                                                        <c:when test="${e.gender == 'Male'}">Nam</c:when>
                                                        <c:when test="${e.gender == 'Female'}">Nữ</c:when>
                                                        <c:otherwise>Khác</c:otherwise>
                                                    </c:choose>
                                                </dd>
                                            </div>
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Ngày sinh</dt>
                                                <dd class="mt-1 text-sm text-gray-900">
                                                    <c:if test="${not empty e.dob}">
                                                        <fmt:formatDate value="${e.dob}" pattern="dd/MM/yyyy" />
                                                    </c:if>
                                                </dd>
                                            </div>
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">CCCD</dt>
                                                <dd class="mt-1 text-sm text-gray-900">${e.cccd}</dd>
                                            </div>
                                        </dl>
                                    </div>

                                    <!-- Contact Information -->
                                    <div>
                                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Thông tin liên hệ</h3>
                                        <dl class="space-y-3">
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Email</dt>
                                                <dd class="mt-1 text-sm text-gray-900">${e.email}</dd>
                                            </div>
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Số điện thoại</dt>
                                                <dd class="mt-1 text-sm text-gray-900">${e.phone}</dd>
                                            </div>
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Địa chỉ</dt>
                                                <dd class="mt-1 text-sm text-gray-900">${e.address}</dd>
                                            </div>
                                        </dl>
                                    </div>

                                    <!-- Employment Information -->
                                    <div>
                                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Thông tin công việc</h3>
                                        <dl class="space-y-3">
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Vai trò</dt>
                                                <dd class="mt-1 text-sm text-gray-900">${e.roleName}</dd>
                                            </div>
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Cửa hàng</dt>
                                                <dd class="mt-1 text-sm text-gray-900">${e.storeName}</dd>
                                            </div>
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Ngày bắt đầu</dt>
                                                <dd class="mt-1 text-sm text-gray-900">
                                                    <c:if test="${not empty e.startAt}">
                                                        <fmt:formatDate value="${e.startAt}" pattern="dd/MM/yyyy" />
                                                    </c:if>
                                                </dd>
                                            </div>
                                            <div>
                                                <dt class="text-sm font-medium text-gray-500">Trạng thái</dt>
                                                <dd class="mt-1 text-sm">
                                                    <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full 
                                                          ${e.status == 'Active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                                        ${e.status}
                                                    </span>
                                                </dd>
                                            </div>
                                        </dl>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="p-6 bg-gray-50 border-t border-gray-200">
                                <div class="flex justify-end space-x-3">
                                    <a href="${pageContext.request.contextPath}/management/employees"
                                       class="action-btn btn-secondary">
                                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" class="w-4 h-4">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                                  d="M4 6h16M4 10h16M4 14h16M4 18h16"></path>
                                        </svg>
                                        Quay lại danh sách
                                    </a>
                                    <a href="${pageContext.request.contextPath}/management/employees/edit?id=${e.employeeId}"
                                       class="action-btn btn-edit">
                                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" class="w-4 h-4">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                                        </svg>
                                        Chỉnh sửa
                                    </a>
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
