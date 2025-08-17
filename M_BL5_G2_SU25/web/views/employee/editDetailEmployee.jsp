<%-- 
    Document   : editDetailEmployee
    Created on : Aug 13, 2025, 8:47:36 AM
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
        <title>Chỉnh sửa nhân viên</title>
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

            /* Error styles for validation */
            .error-border {
                border-color: #ef4444 !important;
                box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1) !important;
            }

            .error-text {
                color: #ef4444;
                font-size: 0.875rem;
                margin-top: 0.25rem;
                display: block;
            }

            /* Loading state */
            .loading {
                opacity: 0.6;
                pointer-events: none;
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
                border: none;
                cursor: pointer;
            }
            
            .action-btn svg {
                width: 1rem;
                height: 1rem;
            }
            
            /* Primary button */
            .btn-primary {
                background-color: #2563eb; /* blue-600 */
                color: white;
            }
            
            .btn-primary:hover {
                background-color: #1d4ed8; /* blue-700 */
            }
            
            /* Cancel button */
            .btn-cancel {
                background-color: #ffffff;
                color: #4b5563; /* gray-600 */
                border: 1px solid #d1d5db; /* gray-300 */
            }
            
            .btn-cancel:hover {
                background-color: #f9fafb; /* gray-50 */
            }
            
            /* Back button */
            .btn-back {
                background-color: #4b5563; /* gray-600 */
                color: white;
            }
            
            .btn-back:hover {
                background-color: #374151; /* gray-700 */
            }
            
            /* Button container */
            .action-buttons-container {
                display: flex;
                gap: 0.75rem;
            }
            
            @media (max-width: 640px) {
                .action-buttons-container {
                    flex-direction: column;
                }
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
                                <h1 class="text-3xl font-bold text-gray-900">Chỉnh sửa nhân viên</h1>
                                <p class="text-gray-600 mt-1">Cập nhật thông tin nhân viên</p>
                            </div>
                            <button onclick="history.back()"
                                    class="action-btn btn-back">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                                </svg>
                                Quay lại
                            </button>
                        </div>
                    </div>

                    <!-- Form Container -->
                    <div class="max-w-4xl mx-auto">
                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">

                            <!-- Form Body -->
                            <div class="p-6" id="employeeForm">
                                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                                    <!-- Employee ID (hidden) -->
                                    <input type="hidden" id="employeeId" value="${e.employeeId}">
                                    
                                    <!-- Username -->
                                    <div>
                                        <label for="username" class="block text-sm font-medium text-gray-700 mb-2">
                                            Tên đăng nhập 
                                        </label>
                                        <input id="username" 
                                               type="text" 
                                               value="${e.userName}"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="Nhập tên đăng nhập" readonly>
                                        <span id="usernameError" class="error-text" style="display: none;" ></span>
                                    </div>

                                    <!-- Last Name (Họ) -->
                                    <div>
                                        <label for="lastName" class="block text-sm font-medium text-gray-700 mb-2">
                                            Họ *
                                        </label>
                                        <input id="lastName" 
                                               type="text" 
                                               value="${e.lastName}"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="Nhập họ">
                                        <span id="lastNameError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Middle Name (Tên đệm) -->
                                    <div>
                                        <label for="middleName" class="block text-sm font-medium text-gray-700 mb-2">
                                            Tên đệm
                                        </label>
                                        <input id="middleName" 
                                               type="text" 
                                               value="${e.middleName}"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="Nhập tên đệm (nếu có)">
                                    </div>

                                    <!-- First Name (Tên) -->
                                    <div>
                                        <label for="firstName" class="block text-sm font-medium text-gray-700 mb-2">
                                            Tên *
                                        </label>
                                        <input id="firstName" 
                                               type="text" 
                                               value="${e.firstName}"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="Nhập tên">
                                        <span id="firstNameError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Phone -->
                                    <div>
                                        <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">
                                            Số điện thoại *
                                        </label>
                                        <input id="phone" 
                                               type="tel" 
                                               value="${e.phone}"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="0123456789 hoặc +84123456789">
                                        <span id="phoneError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Email -->
                                    <div>
                                        <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                                            Địa chỉ email *
                                        </label>
                                        <input id="email" 
                                               type="email" 
                                               value="${e.email}"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="employee@example.com">
                                        <span id="emailError" class="error-text" style="display: none;"></span>
                                    </div>
                                    
                                    <!-- CCCD (Citizen ID) -->
                                    <div>
                                        <label for="cccd" class="block text-sm font-medium text-gray-700 mb-2">
                                            CCCD/CMND
                                        </label>
                                        <input id="cccd" 
                                               type="text" 
                                               value="${e.cccd}"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="Nhập số CCCD/CMND">
                                    </div>
                                    
                                    <!-- Date of Birth -->
                                    <div>
                                        <label for="dob" class="block text-sm font-medium text-gray-700 mb-2">
                                            Ngày sinh
                                        </label>
                                        <input id="dob" 
                                               type="date" 
                                               value="<fmt:formatDate value="${e.dob}" pattern="yyyy-MM-dd"/>"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400">
                                    </div>
                                    
                                    <!-- Address -->
                                    <div>
                                        <label for="address" class="block text-sm font-medium text-gray-700 mb-2">
                                            Địa chỉ
                                        </label>
                                        <input id="address" 
                                               type="text" 
                                               value="${e.address}"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="Nhập địa chỉ">
                                    </div>

                                    <!-- Gender -->
                                    <div>
                                        <label for="gender" class="block text-sm font-medium text-gray-700 mb-2">
                                            Giới tính *
                                        </label>
                                        <select id="gender" 
                                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 bg-white">
                                            <option value="">-- Chọn giới tính --</option>
                                            <option value="Male" ${e.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                            <option value="Female" ${e.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                            <option value="Other" ${e.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                        </select>
                                        <span id="genderError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Status -->
                                    <div>
                                        <label for="status" class="block text-sm font-medium text-gray-700 mb-2">
                                            Trạng thái *
                                        </label>
                                        <select id="status" 
                                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 bg-white">
                                            <option value="">-- Chọn trạng thái --</option>
                                            <option value="Active" ${e.status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="Deactive" ${e.status == 'Deactive' ? 'selected' : ''}>Không hoạt động</option>
                                        </select>
                                        <span id="statusError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Avatar Upload -->
                                    <div>
                                        <label for="avatar" class="block text-sm font-medium text-gray-700 mb-2">
                                            Ảnh đại diện
                                        </label>
                                        <input id="avatar" 
                                               type="file" 
                                               accept="image/*"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200">
                                        <span class="text-xs text-gray-500 mt-1">Định dạng hỗ trợ: JPG, PNG, GIF. Kích thước tối đa: 2MB</span>
                                        <c:if test="${not empty e.avatar}">
                                            <div class="mt-2">
                                                <p class="text-sm text-gray-500">Ảnh hiện tại:</p>
                                                <img src="${pageContext.request.contextPath}/${e.avatar}" alt="Avatar" class="w-16 h-16 object-cover rounded-full mt-1 border border-gray-300">
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Form Actions -->
                                <div class="flex flex-col sm:flex-row gap-4 mt-8 pt-6 border-t border-gray-200">
                                    <button type="button" 
                                            id="saveEmployeeBtn"
                                            onclick="saveEmployee()"
                                            class="action-btn btn-primary">
                                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                                        </svg>
                                        <span id="btnText">Lưu</span>
                                    </button>
                                </div>

                                <!-- Required Fields Note -->
                                <p class="text-sm text-gray-500 mt-4">
                                    <span class="text-red-500">*</span> Trương thông tin bắt buộc
                                </p>
                            </div>
                        </div>
                    </div>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function showNotification(message, type = 'success') {
                const icon = type == 'success' ? 'success' : 'error';
                
                Swal.fire({
                    title: type == 'success' ? 'Thành công!' : 'Lỗi!',
                    text: message,
                    icon: icon,
                    confirmButtonColor: '#3b82f6',
                    timer: 2000,
                    timerProgressBar: true
                });
            }

            function validateUsername(username) {
                const trimmedUsername = username.trim();
                if (!trimmedUsername || trimmedUsername === '') {
                    return 'Tên đăng nhập không được để trống';
                }
                return null;
            }

            function validateName(name, fieldName) {
                const trimmedName = name.trim();
                if (!trimmedName || trimmedName === '') {
                    return fieldName + ' không được để trống';
                }
                return null;
            }

            function validateVietnamesePhone(phone) {
                const trimmedPhone = phone.trim();

                if (!trimmedPhone) {
                    return 'Số điện thoại không được để trống';
                }

                const vietnamesePhoneRegex =
                        /^(\+84|84|0)(3[2-9]|5[689]|7[06-9]|8[1-9]|9[0-46-9])[0-9]{7}$|^(\+84|84|0)(2[0-9])[0-9]{8}$/;

                if (!vietnamesePhoneRegex.test(trimmedPhone)) {
                    return 'Vui lòng nhập số điện thoại Việt Nam hợp lệ (VD: 0912345678, +84912345678)';
                }
                return null;
            }

            function validateEmail(email) {
                const trimmedEmail = email.trim();
                if (!trimmedEmail || trimmedEmail === '') {
                    return 'Email không được để trống';
                }

                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(trimmedEmail)) {
                    return 'Vui lòng nhập địa chỉ email hợp lệ';
                }
                return null;
            }

            function validateSelect(value, fieldName) {
                if (!value || value === '') {
                    return 'Vui lòng chọn ' + fieldName;
                }
                return null;
            }

            function clearFieldError(fieldId) {
                const field = document.getElementById(fieldId);
                const errorSpan = document.getElementById(fieldId + 'Error');

                field.classList.remove('error-border');
                errorSpan.style.display = 'none';
                errorSpan.textContent = '';
            }

            function showFieldError(fieldId, message) {
                const field = document.getElementById(fieldId);
                const errorSpan = document.getElementById(fieldId + 'Error');

                field.classList.add('error-border');
                errorSpan.textContent = message;
                errorSpan.style.display = 'block';
            }

            function clearAllErrors() {
                const fields = ['username', 'firstName', 'lastName', 'phone', 'email', 'gender', 'status'];
                fields.forEach(fieldId => clearFieldError(fieldId));
            }

            function validateForm() {
                clearAllErrors();

                const username = document.getElementById('username').value;
                const firstName = document.getElementById('firstName').value;
                const lastName = document.getElementById('lastName').value;
                const phone = document.getElementById('phone').value;
                const email = document.getElementById('email').value;
                const gender = document.getElementById('gender').value;
                const status = document.getElementById('status').value;

                let isValid = true;

                const usernameError = validateUsername(username);
                if (usernameError) {
                    showFieldError('username', usernameError);
                    isValid = false;
                }

                const firstNameError = validateName(firstName, 'Tên');
                if (firstNameError) {
                    showFieldError('firstName', firstNameError);
                    isValid = false;
                }

                const lastNameError = validateName(lastName, 'Họ');
                if (lastNameError) {
                    showFieldError('lastName', lastNameError);
                    isValid = false;
                }

                const phoneError = validateVietnamesePhone(phone);
                if (phoneError) {
                    showFieldError('phone', phoneError);
                    isValid = false;
                }

                const emailError = validateEmail(email);
                if (emailError) {
                    showFieldError('email', emailError);
                    isValid = false;
                }

                const genderError = validateSelect(gender, 'giới tính');
                if (genderError) {
                    showFieldError('gender', genderError);
                    isValid = false;
                }

                const statusError = validateSelect(status, 'trạng thái');
                if (statusError) {
                    showFieldError('status', statusError);
                    isValid = false;
                }

                return isValid;
            }

            function saveEmployee() {
                if (!validateForm()) {
                    showNotification('Vui lòng sửa các lỗi trước khi gửi', 'error');
                    return;
                }

                const saveBtn = document.getElementById('saveEmployeeBtn');
                const btnText = document.getElementById('btnText');
                const form = document.getElementById('employeeForm');

                saveBtn.disabled = true;
                btnText.textContent = 'Đang lưu...';
                form.classList.add('loading');

                // Check if avatar is selected
                const avatarInput = document.getElementById('avatar');
                if (avatarInput.files.length > 0) {
                    // Upload avatar first
                    uploadAvatar(function(avatarPath) {
                        // Then submit employee data with avatar path
                        submitEmployeeData(avatarPath);
                    });
                } else {
                    // No avatar selected, submit without avatar
                    submitEmployeeData(null);
                }
            }

            function uploadAvatar(callback) {
                const avatarInput = document.getElementById('avatar');
                const formData = new FormData();
                formData.append('avatar', avatarInput.files[0]);

                $.ajax({
                    url: '${pageContext.request.contextPath}/management/employees/upload-avatar',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        if (response.ok) {
                            callback(response.filePath);
                        } else {
                            showNotification('Lỗi khi tải lên ảnh: ' + response.message, 'error');
                            resetFormState();
                        }
                    },
                    error: function() {
                        showNotification('Lỗi khi tải lên ảnh. Vui lòng thử lại sau.', 'error');
                        resetFormState();
                    }
                });
            }

            function resetFormState() {
                const saveBtn = document.getElementById('saveEmployeeBtn');
                const btnText = document.getElementById('btnText');
                const form = document.getElementById('employeeForm');
                
                saveBtn.disabled = false;
                btnText.textContent = 'Lưu';
                form.classList.remove('loading');
            }

            function submitEmployeeData(avatarPath) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/management/employees/edit',
                    method: 'POST',
                    data: {
                        id: document.getElementById('employeeId').value,
                        username: document.getElementById('username').value.trim(),
                        firstName: document.getElementById('firstName').value.trim(),
                        middleName: document.getElementById('middleName').value.trim(),
                        lastName: document.getElementById('lastName').value.trim(),
                        phone: document.getElementById('phone').value.trim(),
                        email: document.getElementById('email').value.trim(),
                        gender: document.getElementById('gender').value,
                        status: document.getElementById('status').value,
                        cccd: document.getElementById('cccd').value,
                        dob: document.getElementById('dob').value,
                        address: document.getElementById('address').value,
                        avatar: avatarPath
                    },
                    success: function (response) {
                        if (response.ok == true) {
                            Swal.fire({
                                title: 'Thành công!',
                                text: response.message,
                                icon: 'success',
                                confirmButtonColor: '#3b82f6'
                            }).then(() => {
                                window.location.href = '${pageContext.request.contextPath}/management/employees';
                            });
                        } else {
                            Swal.fire({
                                title: 'Lỗi!',
                                text: response.message,
                                icon: 'error',
                                confirmButtonColor: '#3b82f6'
                            });
                            resetFormState();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Error:', error);
                        let errorMessage = 'Đã xảy ra lỗi khi lưu thông tin nhân viên';

                        if (xhr.responseJSON && xhr.responseJSON.message) {
                            errorMessage = xhr.responseJSON.message;
                        } else if (xhr.responseText) {
                            errorMessage = xhr.responseText;
                        }

                        Swal.fire({
                            title: 'Lỗi!',
                            text: errorMessage,
                            icon: 'error',
                            confirmButtonColor: '#3b82f6'
                        });
                        resetFormState();
                    }
                });
            }

            // Add real-time validation on blur
            $(document).ready(function () {
                $('#username').blur(function () {
                    const error = validateUsername(this.value);
                    if (error) {
                        showFieldError('username', error);
                    } else {
                        clearFieldError('username');
                    }
                });

                $('#firstName').blur(function () {
                    const error = validateName(this.value, 'Tên');
                    if (error) {
                        showFieldError('firstName', error);
                    } else {
                        clearFieldError('firstName');
                    }
                });

                $('#lastName').blur(function () {
                    const error = validateName(this.value, 'Họ');
                    if (error) {
                        showFieldError('lastName', error);
                    } else {
                        clearFieldError('lastName');
                    }
                });

                $('#phone').blur(function () {
                    const error = validateVietnamesePhone(this.value);
                    if (error) {
                        showFieldError('phone', error);
                    } else {
                        clearFieldError('phone');
                    }
                });

                $('#email').blur(function () {
                    const error = validateEmail(this.value);
                    if (error) {
                        showFieldError('email', error);
                    } else {
                        clearFieldError('email');
                    }
                });

                $('#gender').change(function () {
                    const error = validateSelect(this.value, 'giới tính');
                    if (error) {
                        showFieldError('gender', error);
                    } else {
                        clearFieldError('gender');
                    }
                });

                $('#status').change(function () {
                    const error = validateSelect(this.value, 'trạng thái');
                    if (error) {
                        showFieldError('status', error);
                    } else {
                        clearFieldError('status');
                    }
                });
            });
        </script>
    </body>
</html>
