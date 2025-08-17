<%-- 
    Document   : editProfile
    Created on : Aug 14, 2025, 8:42:18 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa hồ sơ</title>
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
                flex: 1;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            .content {
                flex: 1;
                padding: 20px;
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
    <body class="bg-gray-50 text-gray-800">
        <div class="layout-wrapper flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen">
                <jsp:include page="/views/common/header.jsp"/>

                <main class="content">
                    <div class="mb-6 flex justify-between items-center">
                        <div>
                            <h1 class="text-3xl font-bold">Chỉnh sửa hồ sơ</h1>
                            <p class="text-gray-600">Cập nhật thông tin cá nhân và công việc</p>
                        </div>
                        <button onclick="history.back()" 
                                class="px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg">
                            Quay lại
                        </button>
                    </div>

                    <div class="max-w-4xl mx-auto bg-white p-6 rounded-xl shadow border">
                        <form id="editProfileForm" enctype="multipart/form-data">
                            <!-- Avatar -->
                            <div class="flex items-center gap-4 mb-6">
                                <img id="avatarPreview" src="${e.avatar}" 
                                     class="w-24 h-24 rounded-full border object-cover" alt="Avatar">
                                <div>
                                    <input type="file" id="avatar" name="avatar" 
                                           accept="image/*" class="block text-sm text-gray-500">
                                    <p class="text-xs text-gray-400 mt-1">Chọn ảnh mới để thay đổi avatar</p>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-sm font-medium">Họ</label>
                                    <input type="text" name="firstName" value="${e.firstName}"
                                           class="w-full px-4 py-2 border rounded-lg">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium">Tên đệm</label>
                                    <input type="text" name="lastName" value="${e.middleName}"
                                           class="w-full px-4 py-2 border rounded-lg">
                                </div>
                                           
                                <div>
                                    <label class="block text-sm font-medium">Tên</label>
                                    <input type="text" name="lastName" value="${e.lastName}"
                                           class="w-full px-4 py-2 border rounded-lg">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium">Username</label>
                                    <input type="text" name="userName" value="${e.userName}" readonly
                                           class="w-full px-4 py-2 border rounded-lg bg-gray-100">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium">Số điện thoại</label>
                                    <input type="text" name="phone" value="${e.phone}"
                                           class="w-full px-4 py-2 border rounded-lg">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium">Email</label>
                                    <input type="email" name="email" value="${e.email}"
                                           class="w-full px-4 py-2 border rounded-lg">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium">CCCD</label>
                                    <input type="text" name="cccd" value="${e.cccd}" readonly
                                           class="w-full px-4 py-2 border rounded-lg bg-gray-100">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium">Ngày sinh</label>
                                    <input type="date" name="dob" value="${e.dob}"
                                           class="w-full px-4 py-2 border rounded-lg">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium">Địa chỉ</label>
                                    <input type="text" name="address" value="${e.address}"
                                           class="w-full px-4 py-2 border rounded-lg">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium">Giới tính</label>
                                    <select name="gender" class="w-full px-4 py-2 border rounded-lg">
                                        <option value="Male" ${e.gender=="Male"?"selected":""}>Nam</option>
                                        <option value="Female" ${e.gender=="Female"?"selected":""}>Nữ</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mt-8 flex justify-end">
                                <button type="submit" 
                                        class="px-6 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg">
                                    Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <script>
                            // Preview avatar before upload
                            $("#avatar").on("change", function () {
                                const file = this.files[0];
                                if (file) {
                                    let reader = new FileReader();
                                    reader.onload = e => $("#avatarPreview").attr("src", e.target.result);
                                    reader.readAsDataURL(file);
                                }
                            });

                            // AJAX submit form
                            $("#editProfileForm").on("submit", function (e) {
                                e.preventDefault();

                                let formData = new FormData(this);

                                $.ajax({
                                    url: "${pageContext.request.contextPath}/profile/edit", // Servlet endpoint
                                    type: "POST",
                                    data: formData,
                                    processData: false,
                                    contentType: false,
                                    success: function (res) {
                                        showToast("Cập nhật thành công!", "success");
                                    },
                                    error: function () {
                                        showToast("Có lỗi xảy ra, vui lòng thử lại!", "error");
                                    }
                                });
                            });

                            function showToast(message, type) {
                                let colors = {
                                    success: "linear-gradient(to right, #00b09b, #96c93d)",
                                    error: "linear-gradient(to right, #ff416c, #ff4b2b)"
                                };
                                Toastify({
                                    text: message,
                                    duration: 2000,
                                    close: true,
                                    gravity: "top",
                                    position: "right",
                                    backgroundColor: colors[type] || "#333"
                                }).showToast();
                            }
        </script>
    </body>
</html>
