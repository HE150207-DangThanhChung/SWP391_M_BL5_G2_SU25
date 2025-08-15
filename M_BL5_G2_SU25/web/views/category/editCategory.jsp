<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chỉnh sửa danh mục</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <div class="layout-wrapper flex min-h-screen">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen w-full">
                <jsp:include page="/views/common/header.jsp"/>
                <main class="content flex-1 p-6 bg-gray-50">
                    <div class="mb-8">
                        <div class="flex items-center justify-between">
                            <div>
                                <h1 class="text-3xl font-bold text-gray-900">Chỉnh sửa danh mục</h1>
                                <p class="text-gray-600 mt-1">Cập nhật thông tin danh mục</p>
                            </div>
                            <button onclick="history.back()" class="inline-flex items-center px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg">
                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                                </svg> Quay lại
                            </button>
                        </div>
                    </div>

                    <div class="max-w-3xl mx-auto">
                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                            <div class="p-6" id="categoryForm">
                                <div class="grid grid-cols-1 gap-6">
                                    <!-- Category Name -->
                                    <div>
                                        <label for="categoryName" class="block text-sm font-medium text-gray-700 mb-2">Tên danh mục *</label>
                                        <input id="categoryName" type="text" value="${c.categoryName}"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                                               placeholder="Nhập tên danh mục">
                                        <span id="categoryNameError" class="error-text hidden text-red-500 text-sm"></span>
                                    </div>

                                    <!-- Description -->
                                    <div>
                                        <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Mô tả</label>
                                        <textarea id="description" rows="4"
                                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                                                  placeholder="Nhập mô tả">${c.description}</textarea>
                                        <span id="descriptionError" class="error-text hidden text-red-500 text-sm"></span>
                                    </div>

                                    <!-- Status -->
                                    <div>
                                        <label for="status" class="block text-sm font-medium text-gray-700 mb-2">Trạng thái *</label>
                                        <select id="status"
                                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 bg-white">
                                            <option value="">-- Chọn trạng thái --</option>
                                            <option value="Active" ${c.status == 'Active' ? 'selected' : ''}>Active</option>
                                            <option value="Deactive" ${c.status == 'Deactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                        <span id="statusError" class="error-text hidden text-red-500 text-sm"></span>
                                    </div>
                                </div>

                                <!-- Actions -->
                                <div class="flex flex-col sm:flex-row gap-4 mt-8 pt-6 border-t border-gray-200">
                                    <button type="button" id="saveCategoryBtn" onclick="editCategory()"
                                            class="inline-flex items-center justify-center px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg">
                                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                                        </svg>
                                        <span id="btnText">Lưu</span>
                                    </button>
                                    <button type="button" onclick="history.back()"
                                            class="inline-flex items-center justify-center px-6 py-3 bg-white border border-gray-300 hover:bg-gray-50 rounded-lg">
                                        Huỷ
                                    </button>
                                </div>
                                <p class="text-sm text-gray-500 mt-4"><span class="text-red-500">*</span> Trường bắt buộc</p>
                            </div>
                        </div>
                    </div>
                </main>
                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <script>
                                        function showToast(message, type = 'success') {
                                            let colors = {
                                                success: "linear-gradient(to right, #00b09b, #96c93d)",
                                                error: "linear-gradient(to right, #ff416c, #ff4b2b)",
                                                warning: "linear-gradient(to right, #ffa502, #ff6348)",
                                                info: "linear-gradient(to right, #1e90ff, #3742fa)"
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

                                        function validateCategoryName(name) {
                                            if (!name.trim())
                                                return "Tên danh mục không được để trống";
                                            return null;
                                        }
                                        function validateStatus(status) {
                                            if (!status)
                                                return "Vui lòng chọn trạng thái";
                                            return null;
                                        }

                                        function clearError(fieldId) {
                                            $("#" + fieldId).removeClass("border-red-500");
                                            $("#" + fieldId + "Error").addClass("hidden").text("");
                                        }
                                        function showError(fieldId, message) {
                                            $("#" + fieldId).addClass("border-red-500");
                                            $("#" + fieldId + "Error").removeClass("hidden").text(message);
                                        }

                                        function validateForm() {
                                            let valid = true;
                                            clearError("categoryName");
                                            clearError("status");

                                            let nameError = validateCategoryName($("#categoryName").val());
                                            if (nameError) {
                                                showError("categoryName", nameError);
                                                valid = false;
                                            }

                                            let statusError = validateStatus($("#status").val());
                                            if (statusError) {
                                                showError("status", statusError);
                                                valid = false;
                                            }

                                            return valid;
                                        }

                                        function editCategory() {
                                            if (!validateForm()) {
                                                showToast("Vui lòng sửa các lỗi trước khi lưu", "error");
                                                return;
                                            }
                                            let btn = $("#saveCategoryBtn");
                                            btn.prop("disabled", true);
                                            $("#btnText").text("Đang lưu...");

                                            $.ajax({
                                                url: "${pageContext.request.contextPath}/management/category/edit",
                                                method: "POST",
                                                data: {
                                                    id: ${c.categoryId},
                                                    name: $("#categoryName").val().trim(),
                                                    description: $("#description").val().trim(),
                                                    status: $("#status").val()
                                                },
                                                success: function (response) {
                                                    if (response.ok === true) {
                                                        showToast(response.message);
                                                    } else {
                                                        showToast(response.message, "error");
                                                    }
                                                },
                                                error: function () {
                                                    showToast("Có lỗi khi lưu danh mục", "error");
                                                },
                                                complete: function () {
                                                    btn.prop("disabled", false);
                                                    $("#btnText").text("Lưu");
                                                }
                                            });
                                        }
        </script>
    </body>
</html>
