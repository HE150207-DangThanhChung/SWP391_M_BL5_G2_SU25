<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.time.LocalDate" %>
<%
    String today = java.time.LocalDate.now().toString();
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm yêu cầu mới</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <style>
        html, body { height: 100%; font-family: "Inter", sans-serif; }
        .layout-wrapper { display: flex; min-height: 100vh; }
        .main-panel { flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .content { flex: 1; }
        a { text-decoration: none; }
        .action-btn { display: inline-flex; align-items: center; justify-content: center; padding: 0.5rem 1rem; border-radius: 0.375rem; font-weight: 500; transition: all 0.2s; gap: 0.5rem; border: none; cursor: pointer; }
        .btn-primary { background-color: #2563eb; color: white; }
        .btn-primary:hover { background-color: #1d4ed8; }
        .btn-back { background-color: #4b5563; color: white; }
        .btn-back:hover { background-color: #374151; }
        .action-buttons-container { display: flex; gap: 0.75rem; }
        @media (max-width: 640px) { .action-buttons-container { flex-direction: column; } }
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
                        <h1 class="text-3xl font-bold text-gray-900">Thêm yêu cầu mới</h1>
                        <p class="text-gray-600 mt-1">Tạo yêu cầu mới cho hệ thống</p>
                    </div>
                    <button onclick="history.back()" class="action-btn btn-back">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" class="w-4 h-4"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                        Quay lại
                    </button>
                </div>
            </div>
            <div class="max-w-2xl mx-auto">
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    <div class="p-6" id="formRequestForm">
                        <form id="addFormRequestForm">
                            <div class="mb-4">
                                <label class="block text-sm font-medium text-gray-700 mb-2">Mô tả yêu cầu *</label>
                                <input type="text" name="description" id="description" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400" placeholder="Nhập mô tả yêu cầu" required />
                            </div>
                            <!-- Ẩn trạng thái vì mặc định sẽ là "Chờ duyệt" -->
                            <input type="hidden" name="status" id="status" value="Pending" />
                            <div class="mb-4">
                                <label class="block text-sm font-medium text-gray-700 mb-2">Trạng thái</label>
                                <div class="w-full px-4 py-3 border border-gray-300 rounded-lg bg-gray-50 text-gray-700">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                        Chờ duyệt
                                    </span>
                                    <span class="ml-2 text-sm text-gray-500">(Trạng thái mặc định cho yêu cầu mới)</span>
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-sm font-medium text-gray-700 mb-2">Ngày tạo *</label>
                                <input type="date" name="createdAt" id="createdAt" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200" value="<%=today%>" required readonly />
                            </div>
                            <div class="mb-4">
                                <label class="block text-sm font-medium text-gray-700 mb-2">Nhân viên tạo *</label>
                                <input type="hidden" name="employeeId" id="employeeId" value="${employeeId}" required />
                                <div class="w-full px-4 py-3 border border-gray-300 rounded-lg bg-gray-50 text-gray-700">
                                    <c:choose>
                                        <c:when test="${not empty employeeName}">
                                            ${employeeName} (ID: ${employeeId})
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-red-500">Bạn chưa đăng nhập</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="action-buttons-container mt-8 pt-6 border-t border-gray-200">
                                <button type="submit" class="action-btn btn-primary">
                                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" class="w-4 h-4"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
                                    Thêm
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
        <jsp:include page="/views/common/footer.jsp"/>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function () {
        $('#addFormRequestForm').on('submit', function (e) {
            e.preventDefault();
            
            // Kiểm tra session trước khi thực hiện thêm mới
            $.ajax({
                url: '${pageContext.request.contextPath}/management/form-requests/add',
                method: 'GET',
                success: function() {
                    // Session vẫn còn hợp lệ, tiếp tục thêm mới
                    submitForm();
                },
                error: function() {
                    // Có vấn đề với session, chuyển hướng đến trang login
                    Swal.fire({
                        title: 'Phiên làm việc đã hết hạn!',
                        text: 'Vui lòng đăng nhập lại để tiếp tục.',
                        icon: 'warning',
                        confirmButtonColor: '#3b82f6'
                    }).then(() => {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    });
                }
            });
        });
        
        function submitForm() {
            // Hiển thị loading khi đang xử lý
            Swal.fire({
                title: 'Đang xử lý...',
                text: 'Vui lòng chờ trong giây lát',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            const data = $('#addFormRequestForm').serialize();
            
            $.ajax({
                url: '${pageContext.request.contextPath}/management/form-requests/add',
                method: 'POST',
                data: data,
                dataType: 'json',
                success: function (response) {
                    // Thành công - response là object JSON
                    let successMessage = 'Đã thêm yêu cầu mới!';
                    
                    // Hiển thị thông tin người tạo nếu có trong response
                    if (response.employeeName) {
                        successMessage += '<br><br>Người tạo: ' + response.employeeName + ' (ID: ' + response.employeeId + ')';
                    }
                    
                    Swal.fire({
                        title: 'Thành công!',
                        html: successMessage,
                        icon: 'success',
                        confirmButtonColor: '#3b82f6'
                    }).then(() => {
                        // Xóa thông tin "đã xem" để admin sẽ thấy thông báo mới
                        localStorage.removeItem('lastSeenNotificationTime');
                        localStorage.removeItem('headerLastSeenNotificationTime');
                        
                        // Chuyển về trang danh sách
                        window.location.href = '${pageContext.request.contextPath}/management/form-requests';
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
                            text: 'Đã xảy ra lỗi khi thêm yêu cầu.',
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
