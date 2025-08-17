<%-- 
    Document   : listEmployee
    Created on : Aug 13, 2025, 8:47:22 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lí nhân viên</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

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
            
            /* Custom action button styles */
            .action-button {
                background: none;
                border: none;
                cursor: pointer;
                font-family: inherit;
                font-size: inherit;
                padding: 0;
                text-align: left;
                margin: 0 5px;
                position: relative;
                display: inline-flex;
                align-items: center;
                transition: all 0.2s;
            }
            
            .action-button:hover::after {
                transform: scaleX(1);
            }
            
            .action-button::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 100%;
                height: 2px;
                transform: scaleX(0);
                transform-origin: center;
                transition: transform 0.2s;
            }
            
            /* Edit button */
            .btn-edit {
                color: #2563eb; /* blue-600 */
            }
            
            .btn-edit:hover {
                color: #1d4ed8; /* blue-700 */
            }
            
            .btn-edit::after {
                background-color: #2563eb;
            }
            
            /* View button */
            .btn-view {
                color: #4f46e5; /* indigo-600 */
            }
            
            .btn-view:hover {
                color: #4338ca; /* indigo-700 */
            }
            
            .btn-view::after {
                background-color: #4f46e5;
            }
            
            /* Toggle status button */
            .btn-toggle {
                color: #ca8a04; /* yellow-600 */
            }
            
            .btn-toggle:hover {
                color: #a16207; /* yellow-700 */
            }
            
            .btn-toggle::after {
                background-color: #ca8a04;
            }
            
            /* Delete button */
            .btn-delete {
                color: #dc2626; /* red-600 */
            }
            
            .btn-delete:hover {
                color: #b91c1c; /* red-700 */
            }
            
            .btn-delete::after {
                background-color: #dc2626;
            }
            
            /* Action button container */
            .action-buttons-container {
                display: flex;
                gap: 12px;
            }
            
            /* Icon styles for action buttons */
            .action-icon {
                margin-right: 4px;
                width: 16px;
                height: 16px;
            }
        </style>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <div class="layout-wrapper">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel">
                <jsp:include page="/views/common/header.jsp"/>

                <main class="content p-6">
                    <!-- Header Section -->
                    <div class="mb-6 flex items-center justify-between">
                        <div>
                            <h1 class="text-2xl font-bold">Quản lí nhân viên</h1>
                            <p class="text-gray-500">Quản lí tất cả các nhân viên trong hệ thống</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/management/employees/add"
                           class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors">
                            Thêm mới
                        </a>
                    </div>

                    <!-- Search & Filter -->
                    <form method="get" action="${pageContext.request.contextPath}/management/employees" class="flex items-center gap-3 mb-4">
                        <input type="text" name="search" value="${param.search}" placeholder="Tìm kiếm..."
                               class="border border-gray-300 rounded-md px-3 py-2 w-64 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
                        <select name="status" class="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="">Tất cả</option>
                            <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                            <option value="Deactive" ${param.status == 'Deactive' ? 'selected' : ''}>Không hoạt động</option>
                        </select>
                        <button type="submit" class="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded-md">Lọc</button>
                        <a href="${pageContext.request.contextPath}/management/employees"><button type="button" class="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded-md">Xoá bộ lọc</button></a>
                    </form>

                    <!-- Table -->
                    <div class="overflow-x-auto bg-white rounded-lg border border-gray-200">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">ID</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tên đăng nhập</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Họ</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tên đệm</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tên</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Số điện thoại</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Vai trò</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Trạng thái</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Hành động</th>
                </tr>
            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:choose>
                                    <c:when test="${not empty employees}">
                                        <c:forEach var="e" items="${employees}">
                                            <tr class="hover:bg-gray-50" id="employee-row-${e.employeeId}">
                                                <td class="px-6 py-4 whitespace-nowrap text-sm">${e.employeeId}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">${e.userName}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm">${e.firstName}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm">${e.middleName}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm">${e.lastName}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${e.phone}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${e.email}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${e.roleName}</td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <span id="status-badge-${e.employeeId}" class="inline-flex px-2 py-1 text-xs font-semibold rounded-full 
                                                          ${e.status == 'Active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                                        ${e.status == 'Active' ? 'Hoạt động' : 'Không hoạt động'}
                                                    </span>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                    <div class="action-buttons-container">
                                                        <a href="${pageContext.request.contextPath}/management/employees/edit?id=${e.employeeId}"
                                                           class="action-button btn-edit">
                                                            <svg class="action-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                                                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                                            </svg>
                                                            Sửa
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/management/employees/detail?id=${e.employeeId}"
                                                           class="action-button btn-view">
                                                            <svg class="action-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                                                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                                                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                                            </svg>
                                                            Chi tiết
                                                        </a>
                                                        <button type="button" 
                                                                onclick="toggleStatus(${e.employeeId}, '${e.status == 'Active' ? 'Deactive' : 'Active'}')"
                                                                class="action-button btn-toggle">
                                                            <svg class="action-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                                                      d="M8 11V7a4 4 0 118 0m-4 8v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2z"/>
                                                            </svg>
                                                            ${e.status == 'Active' ? 'Vô hiệu hoá' : 'Kích hoạt'}
                                                        </button>
                                                        <button type="button"
                                                                onclick="confirmDelete(${e.employeeId}, '${e.firstName} ${e.lastName}')"
                                                                class="action-button btn-delete">
                                                            <svg class="action-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                                                      d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                                            </svg>
                                                            Xoá
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="10" class="px-6 py-12 text-center text-gray-500">
                                                <div class="flex flex-col items-center">
                                                    <svg class="w-12 h-12 text-gray-300 mb-4" fill="none" stroke="currentColor"
                                                         viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                                    </svg>
                                                    <p class="text-sm text-gray-500">Không tìm thấy nhân viên nào</p>
                                                </div>
                    </td>
                </tr>
                                    </c:otherwise>
                                </c:choose>
            </tbody>
        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="flex items-center justify-between mt-6">
                            <!-- Left side info -->
                            <div class="text-sm text-gray-700">
                                Hiển thị từ <span class="font-medium">${startItem}</span> đến <span class="font-medium">${endItem}</span> của <span class="font-medium">${totalItems}</span> kết quả
                            </div>

                            <!-- Right side pagination buttons -->
                            <div class="flex space-x-2">
                                <!-- Previous -->
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}&search=${param.search}&status=${param.status}"
                                       class="px-3 py-1 text-sm bg-white border border-gray-300 text-gray-500 rounded-md hover:bg-gray-50">
                                        Trước
                                    </a>
                                </c:if>

                                <!-- Numbered pages -->
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="?page=${i}&search=${param.search}&status=${param.status}"
                                       class="px-3 py-1 text-sm border rounded-md
                                       ${i == currentPage ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-500 border-gray-300 hover:bg-gray-50'}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <!-- Next -->
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}&search=${param.search}&status=${param.status}"
                                       class="px-3 py-1 text-sm bg-white border border-gray-300 text-gray-500 rounded-md hover:bg-gray-50">
                                        Sau
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function confirmDelete(employeeId, employeeName) {
                Swal.fire({
                    title: 'Xác nhận xoá?',
                    html: `Bạn có chắc chắn muốn xoá nhân viên <strong>${employeeName}</strong>?<br>Hành động này không thể hoàn tác!`,
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#ef4444',
                    cancelButtonColor: '#6b7280',
                    confirmButtonText: 'Xoá',
                    cancelButtonText: 'Huỷ',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        deleteEmployee(employeeId);
                    }
                });
            }
            
            function deleteEmployee(employeeId) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/management/employees/delete',
                    method: 'POST',
                    data: {
                        id: employeeId
                    },
                    success: function(response) {
                        if (response.ok == true) {
                            Swal.fire({
                                title: 'Thành công!',
                                text: response.message,
                                icon: 'success',
                                confirmButtonColor: '#3b82f6'
                            }).then(() => {
                                // Remove the row from the table
                                $('#employee-row-' + employeeId).fadeOut(300, function() {
                                    $(this).remove();
                                    
                                    // Check if table is empty
                                    if ($('tbody tr').length == 0) {
                                        location.reload(); // Reload to show empty state
                                    }
                                });
                            });
                        } else {
                            Swal.fire({
                                title: 'Lỗi!',
                                text: response.message,
                                icon: 'error',
                                confirmButtonColor: '#3b82f6'
                            });
                        }
                    },
                    error: function() {
                        Swal.fire({
                            title: 'Lỗi!',
                            text: 'Đã xảy ra lỗi khi xoá nhân viên. Vui lòng thử lại sau.',
                            icon: 'error',
                            confirmButtonColor: '#3b82f6'
                        });
                    }
                });
            }
            
            function toggleStatus(employeeId, newStatus) {
                const actionText = newStatus == 'Active' ? 'kích hoạt' : 'vô hiệu hoá';
                
                Swal.fire({
                    title: `Xác nhận ${actionText}?`,
                    html: `Bạn có chắc chắn muốn ${actionText} nhân viên này?`,
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#3b82f6',
                    cancelButtonColor: '#6b7280',
                    confirmButtonText: 'Xác nhận',
                    cancelButtonText: 'Huỷ',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        changeEmployeeStatus(employeeId, newStatus);
                    }
                });
            }
            
            function changeEmployeeStatus(employeeId, newStatus) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/management/employees/change-status',
                    method: 'POST',
                    data: {
                        id: employeeId,
                        status: newStatus
                    },
                    success: function(response) {
                        if (response.ok == true) {
                            Swal.fire({
                                title: 'Thành công!',
                                text: response.message,
                                icon: 'success',
                                confirmButtonColor: '#3b82f6',
                                timer: 1500,
                                timerProgressBar: true
                            }).then(() => {
                                // Reload the page to refresh all data
                                location.reload();
                            });
                        } else {
                            Swal.fire({
                                title: 'Lỗi!',
                                text: response.message,
                                icon: 'error',
                                confirmButtonColor: '#3b82f6'
                            });
                        }
                    },
                    error: function() {
                        Swal.fire({
                            title: 'Lỗi!',
                            text: 'Đã xảy ra lỗi khi cập nhật trạng thái. Vui lòng thử lại sau.',
                            icon: 'error',
                            confirmButtonColor: '#3b82f6'
                        });
                    }
                });
            }
        </script>
    </body>
</html>
