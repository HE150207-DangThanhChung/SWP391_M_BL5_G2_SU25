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
            .form-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(226, 232, 240, 0.8);
                max-height: calc(100vh - 140px);
                overflow-y: auto;
            }
            .avatar-container {
                position: relative;
                display: inline-block;
            }
            .avatar-overlay {
                position: absolute;
                bottom: 0;
                right: 0;
                background: #3b82f6;
                border-radius: 50%;
                padding: 6px;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            .avatar-overlay:hover {
                background: #2563eb;
            }
            .form-section {
                border-bottom: 1px solid #e5e7eb;
                padding-bottom: 16px;
                margin-bottom: 16px;
            }
            .form-section:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }
            .input-group {
                position: relative;
            }
            .form-input {
                transition: all 0.2s;
                border: 1px solid #e5e7eb;
                font-size: 14px;
            }
            .form-input:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.1);
                outline: none;
            }
            .form-input:disabled {
                background-color: #f9fafb;
                color: #6b7280;
            }
            .section-title {
                color: #1f2937;
                font-weight: 600;
                font-size: 1rem;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .btn-primary {
                background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                transition: all 0.2s;
                transform: translateY(0);
            }
            .btn-primary:hover {
                background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
            }
            .btn-secondary {
                background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
                transition: all 0.2s;
            }
            .btn-secondary:hover {
                background: linear-gradient(135deg, #4b5563 0%, #374151 100%);
            }

            /* Compact spacing for single screen view */
            .compact-header {
                padding: 12px 0;
            }
            .compact-grid {
                gap: 12px;
            }
            .compact-input {
                padding: 8px 12px;
            }
            .compact-avatar {
                width: 80px;
                height: 80px;
            }

            /* Responsive adjustments */
            @media (max-height: 800px) {
                .form-section {
                    padding-bottom: 12px;
                    margin-bottom: 12px;
                }
                .section-title {
                    margin-bottom: 8px;
                    font-size: 0.9rem;
                }
                .compact-grid {
                    gap: 8px;
                }
            }
        </style>
    </head>
    <body class="bg-slate-50">
        <div class="layout-wrapper flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen">
                <jsp:include page="/views/common/header.jsp"/>

                <main class="content">
                    <!-- Compact Header Section -->
                    <div class="compact-header mb-4">
                        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
                            <div>
                                <h1 class="text-2xl font-bold text-gray-900 mb-1">Chỉnh sửa hồ sơ</h1>
                                <p class="text-gray-600 text-sm">Cập nhật thông tin cá nhân và công việc của bạn</p>
                            </div>
                            <button onclick="location.href = '${pageContext.request.contextPath}/profile'" 
                                    class="btn-secondary px-4 py-2 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all duration-200 text-sm">
                                ← Quay lại
                            </button>
                        </div>
                    </div>

                    <!-- Main Form Container -->
                    <div class="max-w-6xl mx-auto">
                        <div class="form-card p-6">
                            <form id="editProfileForm" enctype="multipart/form-data">

                                <!-- Avatar Section -->
                                <div class="form-section">
                                    <h2 class="section-title">
                                        <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                        </svg>
                                        Ảnh đại diện
                                    </h2>
                                    <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
                                        <div class="avatar-container">
                                            <img id="avatarPreview" src="${e.avatar}" 
                                                 class="compact-avatar rounded-full border-2 border-white shadow-lg object-cover" alt="Avatar">
                                            <label for="avatar" class="avatar-overlay">
                                                <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"></path>
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                                </svg>
                                            </label>
                                        </div>
                                        <div class="flex-1">
                                            <input type="file" id="avatar" name="avatar" accept="image/*" class="hidden">
                                            <div class="bg-blue-50 border border-blue-200 rounded-lg p-3">
                                                <p class="text-blue-800 font-medium mb-1 text-sm">Cập nhật ảnh đại diện</p>
                                                <p class="text-blue-600 text-xs">Nhấp vào biểu tượng camera để chọn ảnh mới. JPG, PNG, GIF (max 5MB)</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                                    <!-- Personal Information Section -->
                                    <div class="form-section">
                                        <h2 class="section-title">
                                            <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2"></path>
                                            </svg>
                                            Thông tin cá nhân
                                        </h2>
                                        <div class="compact-grid grid grid-cols-1 md:grid-cols-2 gap-3">
                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Họ *</label>
                                                <input type="text" name="firstName" value="${e.firstName}"
                                                       class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                            </div>

                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Tên đệm *</label>
                                                <input type="text" name="middleName" value="${e.middleName}"
                                                       class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                            </div>

                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Tên *</label>
                                                <input type="text" name="lastName" value="${e.lastName}"
                                                       class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                            </div>

                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Username</label>
                                                <input type="text" name="userName" value="${e.userName}" readonly
                                                       class="form-input compact-input w-full border rounded-lg bg-gray-50 cursor-not-allowed">
                                            </div>

                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">CCCD</label>
                                                <input type="text" name="cccd" value="${e.cccd}" readonly
                                                       class="form-input compact-input w-full border rounded-lg bg-gray-50 cursor-not-allowed">
                                            </div>

                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Giới tính *</label>
                                                <select name="gender" class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                                    <option value="Male" ${e.gender=="Male"?"selected":""}>Nam</option>
                                                    <option value="Female" ${e.gender=="Female"?"selected":""}>Nữ</option>
                                                </select>
                                            </div>

                                            <div class="input-group md:col-span-2">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Ngày sinh *</label>
                                                <input type="date" name="dob" value="${e.dob}"
                                                       class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Contact & Address Information Section -->
                                    <div class="form-section">
                                        <h2 class="section-title">
                                            <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                                            </svg>
                                            Liên hệ & Địa chỉ
                                        </h2>
                                        <div class="compact-grid grid grid-cols-1 md:grid-cols-2 gap-3">
                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Số điện thoại *</label>
                                                <input type="text" name="phone" value="${e.phone}"
                                                       class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                                       placeholder="0xxx xxx xxx">
                                            </div>

                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Email *</label>
                                                <input type="email" name="email" value="${e.email}"
                                                       class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                                       placeholder="example@email.com">
                                            </div>

                                            <div class="input-group md:col-span-2">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Địa chỉ *</label>
                                                <input type="text" name="address" value="${e.address}"
                                                       class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                                       placeholder="Số nhà, tên đường...">
                                            </div>

                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Thành phố *</label>
                                                <select name="city" class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                                    <option value="">Chọn thành phố</option>
                                                    <c:forEach items="${cList}" var="c">
                                                        <option value="${c.cityId}" ${c.cityId == w.cityId ? 'selected' : ''}>
                                                            ${c.cityName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="input-group">
                                                <label class="block text-xs font-semibold text-gray-700 mb-1">Phường/Xã *</label>
                                                <select name="ward" class="form-input compact-input w-full border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                                    <option value="">Chọn phường/xã</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="flex flex-col sm:flex-row gap-3 sm:justify-end pt-4 border-t">
                                    <button type="button" onclick="location.href = '${pageContext.request.contextPath}/profile'" 
                                            class="btn-secondary px-6 py-2 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all duration-200 order-2 sm:order-1 text-sm">
                                        Hủy bỏ
                                    </button>
                                    <button type="submit" 
                                            class="btn-primary px-6 py-2 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all duration-200 order-1 sm:order-2 text-sm">
                                        💾 Lưu thay đổi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <script>
                                        $(document).ready(function () {
                                            const selectedCityId = $('select[name="city"]').val();
                                            const selectedWardId = "${w.wardId != null ? w.wardId : ""}"; // safely inject

                                            if (selectedCityId) {
                                                loadWards(selectedCityId, selectedWardId);
                                            }
                                        });

                                        $('select[name="city"]').on('change', function () {
                                            const cityId = $(this).val();
                                            const wardSelect = $('select[name="ward"]');

                                            if (cityId) {
                                                wardSelect.prop('disabled', true).html('<option>Đang tải...</option>');

                                                loadWards(cityId);
                                            } else {
                                                wardSelect.prop('disabled', true).html('<option>Chọn phường</option>');
                                            }
                                        });

                                        function loadWards(cityId, selectedWardId = null) {
                                            $.ajax({
                                                url: "${pageContext.request.contextPath}/profile/get/ward",
                                                type: "GET",
                                                data: {cityId: cityId},
                                                dataType: "json",
                                                success: function (response) {
                                                    const wardSelect = $('select[name="ward"]');
                                                    wardSelect.empty();
                                                    wardSelect.append('<option value="">Chọn phường</option>');

                                                    if (response.ok === true) {
                                                        $.each(response.wards, function (index, ward) {
                                                            const isSelected = selectedWardId && ward.wardId.toString() === selectedWardId.toString() ? 'selected' : '';
                                                            wardSelect.append(`<option value="` + ward.wardId + `"` + isSelected + `>` + ward.wardName + `</option>`);
                                                        });
                                                        wardSelect.prop('disabled', false);
                                                    } else {
                                                        wardSelect.append('<option>Không có phường nào</option>');
                                                    }
                                                },
                                                error: function () {
                                                    const wardSelect = $('select[name="ward"]');
                                                    wardSelect.html('<option>Lỗi tải dữ liệu</option>');
                                                    showToast("Không thể tải danh sách phường", "error");
                                                }
                                            });
                                        }

                                        $("#avatar").on("change", function () {
                                            const file = this.files[0];
                                            if (file) {
                                                let reader = new FileReader();
                                                reader.onload = e => $("#avatarPreview").attr("src", e.target.result);
                                                reader.readAsDataURL(file);
                                            }
                                        });

// Form validation
                                        function validateForm() {
                                            let valid = true;
                                            let errors = [];

                                            function isBlank(value) {
                                                return !value || value.trim().length === 0;
                                            }

                                            // Get values
                                            let firstName = $("input[name='firstName']").val();
                                            let middleName = $("input[name='middleName']").val();
                                            let lastName = $("input[name='lastName']").val();
                                            let phone = $("input[name='phone']").val();
                                            let email = $("input[name='email']").val();
                                            let dob = $("input[name='dob']").val();
                                            let address = $("input[name='address']").val();
                                            let city = $("select[name='city']").val();
                                            let ward = $("select[name='ward']").val();
                                            let gender = $("select[name='gender']").val();

                                            // Validate names
                                            if (isBlank(firstName)) {
                                                errors.push("Họ không được để trống.");
                                            }
                                            if (isBlank(middleName)) {
                                                errors.push("Tên đệm không được để trống.");
                                            }
                                            if (isBlank(lastName)) {
                                                errors.push("Tên không được để trống.");
                                            }

                                            // Validate phone (Vietnam)
                                            let vnPhoneRegex = /^(0[3|5|7|8|9])[0-9]{8}$/;
                                            if (isBlank(phone) || !vnPhoneRegex.test(phone)) {
                                                errors.push("Số điện thoại không hợp lệ (phải là số Việt Nam).");
                                            }

                                            // Validate email
                                            let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                            if (isBlank(email) || !emailRegex.test(email)) {
                                                errors.push("Email không hợp lệ.");
                                            }

                                            // Validate dob
                                            if (isBlank(dob)) {
                                                errors.push("Ngày sinh là bắt buộc.");
                                            }

                                            // Validate address
                                            if (isBlank(address)) {
                                                errors.push("Địa chỉ là bắt buộc.");
                                            }

                                            // Validate selects
                                            if (isBlank(city)) {
                                                errors.push("Vui lòng chọn thành phố.");
                                            }
                                            if (isBlank(ward)) {
                                                errors.push("Vui lòng chọn phường.");
                                            }
                                            if (isBlank(gender)) {
                                                errors.push("Vui lòng chọn giới tính.");
                                            }

                                            // Show errors
                                            if (errors.length > 0) {
                                                valid = false;
                                                errors.forEach(err => showToast(err, "error"));
                                            }

                                            return valid;
                                        }


                                        // AJAX submit form
                                        $("#editProfileForm").on("submit", function (e) {
                                            e.preventDefault();

                                            if (!validateForm()) {
                                                return; // Stop if validation fails
                                            }

                                            let formData = new FormData(this);

                                            $.ajax({
                                                url: "${pageContext.request.contextPath}/profile/edit",
                                                type: "POST",
                                                data: formData,
                                                processData: false,
                                                contentType: false,
                                                success: function (res) {
                                                    if (res.ok) {
                                                        showToast(res.message, 'success');
                                                    } else {
                                                        showToast(res.message, 'error');
                                                    }
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