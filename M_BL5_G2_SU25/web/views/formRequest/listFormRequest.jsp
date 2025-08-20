<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lí yêu cầu</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        a { text-decoration: none; }
        .action-button { background: none; border: none; cursor: pointer; font-family: inherit; font-size: inherit; padding: 0; text-align: left; margin: 0 5px; position: relative; display: inline-flex; align-items: center; transition: all 0.2s; }
        .action-button:hover::after { transform: scaleX(1); }
        .action-button::after { content: ''; position: absolute; bottom: -2px; left: 0; width: 100%; height: 2px; transform: scaleX(0); transform-origin: center; transition: transform 0.2s; }
        .btn-edit { color: #2563eb; } .btn-edit:hover { color: #1d4ed8; } .btn-edit::after { background-color: #2563eb; }
        .btn-view { color: #4f46e5; } .btn-view:hover { color: #4338ca; } .btn-view::after { background-color: #4f46e5; }
        .btn-delete { color: #dc2626; } .btn-delete:hover { color: #b91c1c; } .btn-delete::after { background-color: #dc2626; }
        .action-buttons-container { display: flex; gap: 12px; }
        .action-icon { margin-right: 4px; width: 16px; height: 16px; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800">
<div class="layout-wrapper" style="display:flex;min-height:100vh;">
    <jsp:include page="/views/common/sidebar.jsp"/>
    <div class="main-panel" style="flex:1;display:flex;flex-direction:column;min-height:100vh;">
        <jsp:include page="/views/common/header.jsp"/>
        <main class="content p-6" style="flex:1;">
            <div class="mb-6 flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-bold">Quản lí yêu cầu</h1>
                    <p class="text-gray-500">Quản lí tất cả các yêu cầu trong hệ thống</p>
                </div>
                <a href="${pageContext.request.contextPath}/management/form-requests/add"
                   class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors">
                    Thêm mới
                </a>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/management/form-requests" class="flex items-center gap-3 mb-4">
                <input type="text" name="search" value="${param.search}" placeholder="Tìm kiếm..."
                       class="border border-gray-300 rounded-md px-3 py-2 w-64 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
                <select name="status" class="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="">Tất cả</option>
                    <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                    <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Đã duyệt</option>
                    <option value="Rejected" ${param.status == 'Rejected' ? 'selected' : ''}>Đã huỷ</option>
                </select>
                <button type="submit" class="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded-md">Lọc</button>
                <a href="${pageContext.request.contextPath}/management/form-requests"><button type="button" class="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded-md">Xoá bộ lọc</button></a>
            </form>
            <div class="overflow-x-auto bg-white rounded-lg border border-gray-200">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">ID</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Mô tả</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Trạng thái</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ngày tạo</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tên nhân viên</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Hành động</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <c:choose>
                        <c:when test="${not empty formRequests}">
                            <c:forEach var="fr" items="${formRequests}">
                                <tr class="hover:bg-gray-50">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm">${fr.formRequestId}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm">${fr.description}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full
                                            ${fr.status == 'Pending' ? 'bg-yellow-100 text-yellow-800' : (fr.status == 'Approved' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800')}">
                                            ${fr.status == 'Pending' ? 'Chờ duyệt' : (fr.status == 'Approved' ? 'Đã duyệt' : 'Đã huỷ')}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm">${fr.createdAt}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm">${fr.employeeName}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                        <div class="action-buttons-container">
                                            <a href="${pageContext.request.contextPath}/management/form-requests/edit?id=${fr.formRequestId}"
                                               class="action-button btn-edit">
                                                <svg class="action-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                          d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                                </svg>
                                                Sửa
                                            </a>
                                            <a href="${pageContext.request.contextPath}/management/form-requests/view?id=${fr.formRequestId}"
                                               class="action-button btn-view">
                                                <svg class="action-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                          d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                          d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                                </svg>
                                                Chi tiết
                                            </a>
                                            <button type="button" class="action-button btn-delete delete-btn" data-id="${fr.formRequestId}">
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
                                <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                                    <div class="flex flex-col items-center">
                                        <svg class="w-12 h-12 text-gray-300 mb-4" fill="none" stroke="currentColor"
                                             viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                        </svg>
                                        <p class="text-sm text-gray-500">Không tìm thấy yêu cầu nào</p>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </main>
        <jsp:include page="/views/common/footer.jsp"/>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
    $(document).ready(function () {
        // Xử lý xóa yêu cầu với AJAX và SweetAlert2
        $('.delete-btn').on('click', function () {
            const id = $(this).data('id');
            
            Swal.fire({
                title: 'Xác nhận xóa?',
                text: 'Bạn có chắc chắn muốn xóa yêu cầu này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc2626',
                cancelButtonColor: '#6b7280',
                confirmButtonText: 'Xóa',
                cancelButtonText: 'Hủy bỏ'
            }).then((result) => {
                if (result.isConfirmed) {
                    deleteFormRequest(id);
                }
            });
        });
        
        function deleteFormRequest(id) {
            // Hiển thị loading khi đang xử lý
            Swal.fire({
                title: 'Đang xử lý...',
                text: 'Vui lòng chờ trong giây lát',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            $.ajax({
                url: '${pageContext.request.contextPath}/management/form-requests/delete',
                method: 'POST',
                data: { id: id },
                dataType: 'json',
                success: function (response) {
                    // Thành công
                    Swal.fire({
                        title: 'Đã xóa!',
                        text: 'Yêu cầu đã được xóa thành công.',
                        icon: 'success',
                        confirmButtonColor: '#3b82f6'
                    }).then(() => {
                        window.location.reload();
                    });
                },
                error: function (xhr) {
                    if (xhr.status === 401) {
                        // Unauthorized - Session timeout
                        Swal.fire({
                            title: 'Phiên làm việc đã hết hạn!',
                            text: 'Vui lòng đăng nhập lại để tiếp tục.',
                            icon: 'warning',
                            confirmButtonColor: '#3b82f6'
                        }).then(() => {
                            window.location.href = '${pageContext.request.contextPath}/login';
                        });
                    } else {
                        // Lỗi khác
                        Swal.fire({
                            title: 'Lỗi!',
                            text: 'Đã xảy ra lỗi khi xóa yêu cầu.',
                            icon: 'error',
                            confirmButtonColor: '#3b82f6'
                        });
                    }
                }
            });
        }
    });
</script>
</body>
</html>
