<%-- 
    Document   : viewProfile
    Created on : Aug 14, 2025
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thông tin cá nhân</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
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
                max-height: calc(100vh - 120px);
            }

            .form-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(226, 232, 240, 0.8);
                max-height: calc(100vh - 140px);
                overflow-y: auto;
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

            .section-title {
                color: #1f2937;
                font-weight: 600;
                font-size: 1rem;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .info-field {
                background-color: #f9fafb;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                padding: 10px 12px;
                font-size: 14px;
                color: #374151;
                min-height: 42px;
                display: flex;
                align-items: center;
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

            .compact-header {
                padding: 12px 0;
            }

            .compact-grid {
                gap: 12px;
            }

            .compact-avatar {
                width: 80px;
                height: 80px;
            }

            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-active {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                color: white;
            }

            .status-inactive {
                background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                color: white;
            }

            .avatar-display {
                border: 3px solid white;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
                                <h1 class="text-2xl font-bold text-gray-900 mb-1">Hồ sơ cá nhân</h1>
                                <p class="text-gray-600 text-sm">Thông tin cá nhân và công việc</p>
                            </div>
                            <div class="flex gap-3">
                                <button onclick="location.href = '${pageContext.request.contextPath}/profile/edit'"
                                        class="btn-primary px-4 py-2 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all duration-200 text-sm">
                                    ✏️ Chỉnh sửa thông tin
                                </button>
                                <button onclick="history.back()"
                                        class="btn-secondary px-4 py-2 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all duration-200 text-sm">
                                    ← Quay lại
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Main Profile Container -->
                    <div class="max-w-6xl mx-auto">
                        <div class="form-card p-6">

                            <!-- Avatar Section -->
                            <div class="form-section">
                                <h2 class="section-title">
                                    <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                    </svg>
                                    Thông tin tài khoản
                                </h2>
                                <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
                                    <img src="${e.avatar}" alt="Avatar" 
                                         class="compact-avatar rounded-full avatar-display object-cover">
                                    <div class="flex-1">
                                        <h3 class="text-xl font-bold text-gray-900 mb-1">${e.firstName} ${e.middleName} ${e.lastName}</h3>
                                        <p class="text-gray-500 mb-2">@${e.userName}</p>
                                        <div class="flex items-center gap-3">
                                            <c:choose>
                                                <c:when test="${e.status == 'Active'}">
                                                    <span class="status-badge status-active">
                                                        <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                                                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
                                                        </svg>
                                                        Đang hoạt động
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-inactive">
                                                        <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                                                        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                                                        </svg>
                                                        Ngừng hoạt động
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="text-sm text-gray-600">• ${r.name}</span>
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
                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Họ</label>
                                            <div class="info-field">${e.firstName}</div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Tên đệm</label>
                                            <div class="info-field">${e.middleName}</div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Tên</label>
                                            <div class="info-field">${e.lastName}</div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">CCCD</label>
                                            <div class="info-field">${e.cccd}</div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Giới tính</label>
                                            <div class="info-field">
                                                <c:choose>
                                                    <c:when test="${e.gender == 'Male'}">Nam</c:when>
                                                    <c:otherwise>Nữ</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Ngày sinh</label>
                                            <div class="info-field">${e.dob}</div>
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
                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Số điện thoại</label>
                                            <div class="info-field">${e.phone}</div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Email</label>
                                            <div class="info-field">${e.email}</div>
                                        </div>

                                        <div class="md:col-span-2">
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Địa chỉ</label>
                                            <div class="info-field">${e.address}</div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Thành phố</label>
                                            <div class="info-field">${c.cityName}</div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Phường/Xã</label>
                                            <div class="info-field">${w.wardName}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Work Information Section -->
                            <div class="form-section">
                                <h2 class="section-title">
                                    <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
                                    </svg>
                                    Thông tin công việc
                                </h2>
                                <div class="compact-grid grid grid-cols-1 md:grid-cols-3 gap-3">
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-700 mb-1">Vai trò</label>
                                        <div class="info-field">${r.name}</div>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-semibold text-gray-700 mb-1">Cửa hàng</label>
                                        <div class="info-field">${s.storeName}</div>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-semibold text-gray-700 mb-1">Ngày bắt đầu</label>
                                        <div class="info-field">${e.startAt}</div>
                                    </div>
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