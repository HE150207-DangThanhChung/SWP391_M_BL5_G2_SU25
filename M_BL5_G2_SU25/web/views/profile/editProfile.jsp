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
                        <button onclick="location.href = '${pageContext.request.contextPath}/profile'" 
                                class="px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded">
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
                                    <input type="text" name="middleName" value="${e.middleName}"
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
                                    <label class="block text-sm font-medium">Thành Phố</label>
                                    <select name="city" class="w-full px-4 py-2 border rounded-lg">
                                        <c:forEach items="${cList}" var="c">
                                            <option value="${c.cityId}" ${c.cityId == w.cityId ? 'selected' : ''}>
                                                ${c.cityName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium">Phường</label>
                                    <select name="ward" class="w-full px-4 py-2 border rounded-lg">

                                    </select>
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
                                        class="px-6 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded">
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
