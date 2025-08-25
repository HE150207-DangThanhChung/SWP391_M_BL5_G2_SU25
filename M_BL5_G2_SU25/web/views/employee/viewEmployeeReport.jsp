<%-- 
    Document   : viewEmployeeReport
    Created on : Aug 14, 2025, 8:43:08 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Báo cáo nhân viên</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', 'Segoe UI', sans-serif;
                background: #f3f4f6;
                margin: 0;
                padding: 0;
                display: flex;
            }
            .main-panel {
                flex: 1;
                margin-left: 255px;
                width: calc(100% - 255px);
                position: relative;
            }
            .page-title {
                text-align: center;
                margin-bottom: 1.5rem;
                font-size: 1.5rem;
                font-weight: 700;
                color: #1f2937;
            }
            .employee-card, .report-card, .bg-white.rounded-lg.shadow-md, .container, .mb-6.bg-white.p-4.rounded-lg.shadow {
                background: #fff;
                border-radius: 0.75rem;
                box-shadow: 0 2px 8px rgba(0,0,0,0.07);
                overflow: hidden;
                margin-bottom: 1.5rem;
            }
            .card-header, .report-header {
                background-color: #f9fafb;
                padding: 1rem 1.5rem;
                border-bottom: 1px solid #e5e7eb;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .card-header h3, .report-header h3 {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin: 0;
            }
            .card-body, .report-content {
                padding: 1.5rem;
            }
            .report-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
            }
            .report-table th {
                background-color: #f9fafb;
                font-weight: 600;
                font-size: 0.95rem;
                color: #374151;
                padding: 0.85rem 1.1rem;
                text-align: left;
                border-bottom: 1px solid #e5e7eb;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }
            .report-table td {
                padding: 1.1rem;
                border-bottom: 1px solid #e5e7eb;
                color: #1f2937;
            }
            .report-table tr:hover {
                background-color: #f3f4f6;
            }
            .status-badge {
                display: inline-block;
                padding: 0.25rem 0.7rem;
                font-size: 0.8rem;
                font-weight: 600;
                border-radius: 0.3rem;
            }
            .status-pending { background-color: #fef3c7; color: #92400e; }
            .status-approved { background-color: #d1fae5; color: #065f46; }
            .status-rejected { background-color: #fee2e2; color: #b91c1c; }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem;
            }
            /* Pagination styles - improved */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 2rem;
                margin-bottom: 2rem;
                gap: 0.5rem;
            }
            .pagination-item, .pagination-arrow {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 2.5rem;
                height: 2.5rem;
                border-radius: 0.5rem;
                font-size: 1rem;
                font-weight: 500;
                color: #374151;
                background: #f3f4f6;
                border: 1.5px solid #e5e7eb;
                cursor: pointer;
                transition: all 0.18s;
                box-shadow: 0 1px 2px rgba(0,0,0,0.03);
            }
            .pagination-item:hover, .pagination-arrow:not(.disabled):hover {
                background: #2563eb;
                color: #fff;
                border-color: #2563eb;
            }
            .pagination-item.active {
                background: #2563eb;
                color: #fff;
                border-color: #2563eb;
                font-weight: 700;
                box-shadow: 0 2px 8px rgba(37,99,235,0.08);
            }
            .pagination-arrow.disabled {
                color: #9ca3af;
                background: #f3f4f6;
                border-color: #e5e7eb;
                cursor: not-allowed;
                pointer-events: none;
            }
            @media (max-width: 900px) {
                .main-panel {
                    margin-left: 0;
                    width: 100%;
                }
                .container {
                    padding: 1rem;
                }
                .pagination-item, .pagination-arrow {
                    width: 2rem;
                    height: 2rem;
                    font-size: 0.95rem;
                }
            }
            @media (max-width: 600px) {
                .main-panel, .container {
                    padding: 0.5rem;
                }
                .pagination {
                    gap: 0.2rem;
                }
                .pagination-item, .pagination-arrow {
                    width: 1.7rem;
                    height: 1.7rem;
                    font-size: 0.85rem;
                }
            }
        </style>
       
          
    </head>
    <body class="bg-gray-100">
        <jsp:include page="/views/common/sidebar.jsp"></jsp:include>
        
        <div class="main-panel">
            <jsp:include page="/views/common/header.jsp"></jsp:include>
            
            <div class="content p-6">
                <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between">
                    <h2 class="text-2xl font-bold text-gray-800">
                        <c:choose>
                            <c:when test="${isAllReportsView}">
                                Báo cáo tất cả nhân viên
                            </c:when>
                            <c:otherwise>
                                Báo cáo nhân viên
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <div class="mt-3 md:mt-0">
                        <a href="${pageContext.request.contextPath}/management/employees" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50">
                            <svg class="w-5 h-5 mr-2 -ml-1" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                            </svg>
                            Quay lại
                        </a>
                    </div>
                </div>
                
                
                
                <c:choose>
                    <c:when test="${not empty e}">
                        
                       
                        
                        <!-- Single employee report view -->
                        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                            <!-- Employee info header -->
                            <c:if test="${not isAllReportsView and not empty e}">
                                <div class="bg-white p-6 rounded-lg shadow-md mb-6">
                                    <div class="flex items-center space-x-4">
                                        <c:choose>
                                            <c:when test="${not empty e.avatar}">
                                                <img class="w-16 h-16 rounded-full object-cover border-2 border-blue-200" 
                                                     src="${pageContext.request.contextPath}/${e.avatar}" alt="Avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-16 h-16 rounded-full bg-blue-100 flex items-center justify-center border-2 border-blue-200">
                                                    <span class="text-blue-500 text-2xl font-bold">${fn:substring(e.firstName, 0, 1)}</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <h3 class="text-xl font-bold text-gray-800">${e.firstName} ${e.middleName} ${e.lastName}</h3>
                                        <p class="text-gray-600">${e.email}</p>
                                        <div class="flex items-center space-x-4 mt-2">
                                            <p class="text-gray-600">ID: <span class="font-semibold text-blue-600">${e.employeeId}</span></p>
                                            <p class="text-gray-600">Ngày bắt đầu: <fmt:formatDate value="${e.startAt}" pattern="dd/MM/yyyy" /></p>
                                            <c:choose>
                                                <c:when test="${e.roleId == 1}">
                                                    <span class="px-3 py-1 bg-purple-100 text-purple-800 rounded-full text-sm font-medium">Quản lý</span>
                                                </c:when>
                                                <c:when test="${e.roleId == 2}">
                                                    <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-medium">Nhân viên bán hàng</span>
                                                </c:when>
                                                <c:when test="${e.roleId == 3}">
                                                    <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">Nhân viên kho</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-3 py-1 bg-gray-100 text-gray-800 rounded-full text-sm font-medium">Nhân viên</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:if>                            <!-- Report tabs -->
                            <div class="mb-6">
                                <ul class="flex flex-wrap border-b border-gray-200">
                                    <li class="mr-2">
                                        <button class="inline-block py-2 px-4 text-sm font-medium text-center text-blue-600 border-b-2 border-blue-600 rounded-t-lg active" id="problems-tab" data-tabs-target="#problems" role="tab">
                                            Vấn đề tại cửa hàng
                                        </button>
                                    </li>
                                   
                                </ul>
                            </div>
                            
                            <div id="tab-content">
                                <div id="problems" class="active" role="tabpanel">
                                    <!-- Status filter for reports -->
                                    <div class="mb-4 bg-gray-50 p-4 rounded-lg">
                                        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                                            <div class="flex items-center space-x-4">
                                                <h4 class="text-lg font-semibold text-gray-800">
                                                    Báo cáo của nhân viên: <span class="text-blue-600">${e.firstName} ${e.lastName}</span>
                                                </h4>
                                                <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-medium">
                                                    ID: ${e.employeeId}
                                                </span>
                                            </div>
                                            <form method="get" action="${pageContext.request.contextPath}/management/employees/report" class="flex items-center gap-4">
                                                <c:if test="${not isAllReportsView}">
                                                    <input type="hidden" name="id" value="${e != null ? e.employeeId : ''}">
                                                </c:if>
                                                <label class="text-sm font-medium text-gray-700">Lọc theo trạng thái:</label>
                                                <select name="status" onchange="this.form.submit()" 
                                                        class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                                    <option value="all" ${statusFilter == null || statusFilter == 'all' ? 'selected' : ''}>Tất cả (${totalReports})</option>
                                                    <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Đang chờ (${pendingReports})</option>
                                                    <option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Đã duyệt (${approvedReports})</option>
                                                    <option value="Rejected" ${statusFilter == 'Rejected' ? 'selected' : ''}>Từ chối (${rejectedReports})</option>
                                                </select>
                                                <span class="text-sm text-gray-500">
                                                    Hiển thị ${fn:length(employeeReports)} báo cáo
                                                </span>
                                            </form>
                                        </div>
                                    </div>
                                    
                                    <!-- Problems tab content -->
                                    <div class="mb-4">
                                        <h4 class="text-lg font-semibold text-gray-800 mb-2">Vấn đề tại cửa hàng</h4>
                                        
                                        
                                        
                                        <c:choose>
                                            <c:when test="${not empty employeeReports}">
                                                <c:set var="reportsPerPage" value="5" />
                                                <c:set var="currentPage" value="${empty param.page ? 1 : param.page}" />
                                                <c:set var="totalPages" value="${Math.ceil(fn:length(employeeReports) / reportsPerPage)}" />
                                                <c:set var="startIndex" value="${(currentPage - 1) * reportsPerPage}" />
                                                <c:set var="endIndex" value="${startIndex + reportsPerPage - 1}" />
                                                <c:set var="displayStart" value="${startIndex + 1}" />
                                                <c:set var="displayEnd" value="${endIndex < fn:length(employeeReports) - 1 ? endIndex + 1 : fn:length(employeeReports)}" />
                                                
                                                <div class="mb-4 p-3 bg-green-50 border border-green-200 rounded-lg">
                                                    <p class="text-sm text-green-800">
                                                        <svg class="w-4 h-4 inline mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                                        </svg>
                                                        <c:choose>
                                                            <c:when test="${isAllReportsView}">
                                                                Hiển thị ${displayStart}-${displayEnd} của ${fn:length(employeeReports)} báo cáo từ tất cả nhân viên (Trang ${currentPage}/${totalPages})
                                                            </c:when>
                                                            <c:otherwise>
                                                                Hiển thị ${displayStart}-${displayEnd} của ${fn:length(employeeReports)} báo cáo của nhân viên <strong>${e.firstName} ${e.lastName}</strong> (ID: ${e.employeeId}) (Trang ${currentPage}/${totalPages})
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <c:forEach items="${employeeReports}" var="report" varStatus="status" begin="${startIndex}" end="${endIndex < fn:length(employeeReports) - 1 ? endIndex : fn:length(employeeReports) - 1}">
                                                    <div class="report-card">
                                                        <div class="report-header ${report.status == 'Pending' ? 'text-yellow-600' : report.status == 'Approved' ? 'text-green-600' : 'text-red-600'}">
                                                            <c:if test="${isAllReportsView}">
                                                                <span class="font-medium">${report.employeeName}</span> -
                                                            </c:if>
                                                            <span class="capitalize">${report.status}</span> - ID: ${report.formRequestId}
                                                        </div>
                                                        <div class="report-content">
                                                            <p class="text-gray-700 mb-2">${report.description}</p>
                                                            <c:if test="${not empty report.note}">
                                                                <div class="mt-2 p-2 bg-gray-50 rounded text-sm">
                                                                    <strong>Ghi chú:</strong> ${report.note}
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        <div class="report-footer">
                                                            Báo cáo ngày: <fmt:formatDate value="${report.createdAt}" pattern="dd/MM/yyyy" />
                                                            <span class="ml-4 px-2 py-1 text-xs rounded-full 
                                                                ${report.status == 'Pending' ? 'bg-yellow-100 text-yellow-800' : 
                                                                  report.status == 'Approved' ? 'bg-green-100 text-green-800' : 
                                                                  'bg-red-100 text-red-800'}">
                                                                ${report.status}
                                                            </span>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                                
                                                <!-- Pagination controls -->
                                                <c:if test="${totalPages > 1}">
                                                    <div class="pagination">
                                                        <!-- Previous page button -->
                                                        <a href="${pageContext.request.contextPath}/employee/reports?${not empty e ? 'employeeId='.concat(e.employeeId).concat('&') : ''}page=${currentPage > 1 ? currentPage - 1 : 1}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}" 
                                                           class="pagination-arrow ${currentPage == 1 ? 'disabled' : ''}">
                                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                                                            </svg>
                                                        </a>
                                                        
                                                        <!-- Page numbers -->
                                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                            <a href="${pageContext.request.contextPath}/employee/reports?${not empty e ? 'employeeId='.concat(e.employeeId).concat('&') : ''}page=${pageNum}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}" 
                                                               class="pagination-item ${pageNum == currentPage ? 'active' : ''}">
                                                                ${pageNum}
                                                            </a>
                                                        </c:forEach>
                                                        
                                                        <!-- Next page button -->
                                                        <a href="${pageContext.request.contextPath}/employee/reports?${not empty e ? 'employeeId='.concat(e.employeeId).concat('&') : ''}page=${currentPage < totalPages ? currentPage + 1 : totalPages}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}" 
                                                           class="pagination-arrow ${currentPage == totalPages ? 'disabled' : ''}">
                                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                                                            </svg>
                                                        </a>
                                                    </div>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="report-card">
                                                    <div class="report-content text-center py-8">
                                                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                                        </svg>
                                                        <p class="mt-2 text-sm text-gray-500">
                                                            <c:choose>
                                                                <c:when test="${noReports}">
                                                                    <div class="p-4 mb-4 text-yellow-700 bg-yellow-100 border-l-4 border-yellow-500 rounded-lg">
                                                                        <div class="flex items-center">
                                                                            <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                                                                                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2h-1V9z" clip-rule="evenodd"/>
                                                                            </svg>
                                                                            <strong>${message}</strong>
                                                                        </div>
                                                                        <div class="mt-3 text-center">
                                                                            <a href="${pageContext.request.contextPath}/management/employees" 
                                                                               class="inline-flex items-center px-4 py-2 bg-blue-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-blue-700 focus:outline-none focus:border-blue-700 focus:ring focus:ring-blue-200 active:bg-blue-600 transition">
                                                                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                                                                                </svg>
                                                                                Quay lại danh sách nhân viên
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <script>
                                                                        // Show notification and redirect when there are no reports
                                                                        document.addEventListener('DOMContentLoaded', function() {
                                                                            Swal.fire({
                                                                                title: 'Thông báo',
                                                                                text: '${message}',
                                                                                icon: 'info',
                                                                                confirmButtonColor: '#3085d6',
                                                                                confirmButtonText: 'Đã hiểu',
                                                                                timer: 3000,
                                                                                timerProgressBar: true
                                                                            }).then((result) => {
                                                                                // Redirect back to employee list
                                                                                window.location.href = '${pageContext.request.contextPath}/management/employees';
                                                                            });
                                                                        });
                                                                    </script>
                                                                </c:when>
                                                                <c:when test="${not empty statusFilter and statusFilter != 'all'}">
                                                                    Không có báo cáo nào với trạng thái "${statusFilter}"
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Nhân viên này chưa có báo cáo nào
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                        <c:if test="${not empty statusFilter and statusFilter != 'all'}">
                                                            <a href="${pageContext.request.contextPath}/management/employees/report?id=${e.employeeId}" 
                                                               class="mt-2 inline-block text-blue-600 hover:text-blue-800 text-sm">
                                                                Xem tất cả báo cáo
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <!-- Button to add new report -->
                                        <div class="mt-4">
                                            <a href="${pageContext.request.contextPath}/management/formrequest/add?employeeId=${e.employeeId}" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                                <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                                                </svg>
                                                Thêm báo cáo mới
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                
                                <div id="performance" class="hidden" role="tabpanel">
                                    <!-- Performance tab content -->
                                    <div class="mb-4">
                                        <h4 class="text-lg font-semibold text-gray-800 mb-2">Hiệu suất làm việc</h4>
                                        
                                        <c:choose>
                                            <c:when test="${noReports}">
                                                <!-- Show message when there are no reports -->
                                                <div class="bg-white p-6 rounded-lg shadow-md text-center">
                                                    <svg class="mx-auto h-12 w-12 text-yellow-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                    </svg>
                                                    <h3 class="mt-2 text-lg font-medium text-gray-900">${message}</h3>
                                                    <p class="mt-1 text-gray-500">Không có dữ liệu hiệu suất để hiển thị.</p>
                                                    <div class="mt-4">
                                                        <a href="${pageContext.request.contextPath}/management/formrequest/add?employeeId=${e.employeeId}" 
                                                           class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700">
                                                            <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                                                            </svg>
                                                            Thêm báo cáo mới
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Performance metrics based on reports -->
                                                <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                                                    <div class="bg-white p-4 rounded-lg shadow">
                                                        <h5 class="text-sm font-medium text-gray-500">Tổng số báo cáo</h5>
                                                        <p class="text-2xl font-bold text-blue-600">${totalReports != null ? totalReports : 0}</p>
                                                        <p class="text-xs text-gray-500">Tất cả báo cáo đã tạo</p>
                                                    </div>
                                            
                                            <div class="bg-white p-4 rounded-lg shadow">
                                                <h5 class="text-sm font-medium text-gray-500">Đang chờ xử lý</h5>
                                                <p class="text-2xl font-bold text-yellow-600">${pendingReports != null ? pendingReports : 0}</p>
                                                <p class="text-xs text-yellow-500">Báo cáo chưa được giải quyết</p>
                                            </div>
                                            
                                            <div class="bg-white p-4 rounded-lg shadow">
                                                <h5 class="text-sm font-medium text-gray-500">Đã duyệt</h5>
                                                <p class="text-2xl font-bold text-green-600">${approvedReports != null ? approvedReports : 0}</p>
                                                <p class="text-xs text-green-500">Báo cáo đã được duyệt</p>
                                            </div>
                                            
                                            <div class="bg-white p-4 rounded-lg shadow">
                                                <h5 class="text-sm font-medium text-gray-500">Từ chối</h5>
                                                <p class="text-2xl font-bold text-red-600">${rejectedReports != null ? rejectedReports : 0}</p>
                                                <p class="text-xs text-red-500">Báo cáo bị từ chối</p>
                                            </div>
                                        </div>
                                        
                                        <!-- Report summary chart -->
                                        <div class="bg-white p-4 rounded-lg shadow mb-4">
                                            <h5 class="text-sm font-medium text-gray-500 mb-4">Tổng quan báo cáo của nhân viên</h5>
                                            <div class="space-y-3">
                                                <c:choose>
                                                    <c:when test="${totalReports > 0}">
                                                        <div class="flex items-center justify-between">
                                                            <span class="text-sm text-gray-600">Tỷ lệ duyệt báo cáo</span>
                                                            <span class="text-sm font-semibold">
                                                                <fmt:formatNumber value="${approvalRate}" maxFractionDigits="1"/>%
                                                            </span>
                                                        </div>
                                                        <fmt:formatNumber var="formattedApprovalRate" value="${approvalRate}" pattern="#.#"/>
                                                        <div class="w-full bg-gray-200 rounded-full h-2">
                                                            <div class="bg-green-600 h-2 rounded-full" style="width: ${formattedApprovalRate}%"></div>
                                                        </div>
                                                        
                                                        <div class="mt-4 grid grid-cols-3 gap-4 text-sm">
                                                            <div class="text-center">
                                                                <div class="font-semibold text-yellow-600">${pendingReports}</div>
                                                                <div class="text-gray-500">Đang chờ</div>
                                                            </div>
                                                            <div class="text-center">
                                                                <div class="font-semibold text-green-600">${approvedReports}</div>
                                                                <div class="text-gray-500">Đã duyệt</div>
                                                            </div>
                                                            <div class="text-center">
                                                                <div class="font-semibold text-red-600">${rejectedReports}</div>
                                                                <div class="text-gray-500">Từ chối</div>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="text-center py-8">
                                                            <p class="text-gray-500">Chưa có dữ liệu báo cáo để hiển thị</p>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div id="attendance" class="hidden" role="tabpanel">
                                    <!-- Attendance tab content -->
                                    <div class="mb-4">
                                        <h4 class="text-lg font-semibold text-gray-800 mb-2">Điểm danh</h4>
                                        
                                        <!-- Attendance summary -->
                                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                                            <div class="bg-white p-4 rounded-lg shadow">
                                                <h5 class="text-sm font-medium text-gray-500">Tổng ngày làm việc</h5>
                                                <p class="text-2xl font-bold text-blue-600">22/25</p>
                                            </div>
                                            
                                            <div class="bg-white p-4 rounded-lg shadow">
                                                <h5 class="text-sm font-medium text-gray-500">Đúng giờ</h5>
                                                <p class="text-2xl font-bold text-green-600">18</p>
                                            </div>
                                            
                                            <div class="bg-white p-4 rounded-lg shadow">
                                                <h5 class="text-sm font-medium text-gray-500">Đi muộn</h5>
                                                <p class="text-2xl font-bold text-yellow-600">4</p>
                                            </div>
                                            
                                            <div class="bg-white p-4 rounded-lg shadow">
                                                <h5 class="text-sm font-medium text-gray-500">Vắng mặt</h5>
                                                <p class="text-2xl font-bold text-red-600">3</p>
                                            </div>
                                        </div>
                                        
                                        <!-- Attendance details -->
                                        <div class="bg-white rounded-lg shadow overflow-hidden">
                                            <table class="min-w-full divide-y divide-gray-200">
                                                <thead class="bg-gray-50">
                                                    <tr>
                                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ngày</th>
                                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Check in</th>
                                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Check out</th>
                                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trạng thái</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="bg-white divide-y divide-gray-200">
                                                    <!-- Sample data - replace with actual data -->
                                                    <tr>
                                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">25/08/2025</td>
                                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">08:05</td>
                                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">17:30</td>
                                                        <td class="px-6 py-4 whitespace-nowrap">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Đúng giờ</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">24/08/2025</td>
                                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">08:15</td>
                                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">17:35</td>
                                                        <td class="px-6 py-4 whitespace-nowrap">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">Đi muộn</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">23/08/2025</td>
                                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">--:--</td>
                                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">--:--</td>
                                                        <td class="px-6 py-4 whitespace-nowrap">
                                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">Vắng mặt</span>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Search and filter section for employee list -->
                        <div class="mb-6 bg-white p-4 rounded-lg shadow">
                            <form method="get" action="${pageContext.request.contextPath}/management/employees/report" class="flex flex-col md:flex-row gap-4">
                                <div class="flex-1">
                                    <input type="text" name="search" value="${search}" placeholder="Tìm kiếm nhân viên..." 
                                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                </div>
                                <div class="flex gap-2">
                                    <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
                                        <svg class="w-4 h-4 inline-block mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                                        </svg>
                                        Tìm kiếm
                                    </button>
                                    <c:if test="${not empty search}">
                                        <a href="${pageContext.request.contextPath}/management/employees/report" 
                                           class="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 focus:outline-none">
                                            Xóa bộ lọc
                                        </a>
                                    </c:if>
                                </div>
                            </form>
                        </div>
                        
                        <!-- List all employees for report selection -->
                        <div class="bg-white rounded-lg shadow-md overflow-hidden">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nhân viên</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Vị trí</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Cửa hàng</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach items="${employees}" var="emp">
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="flex items-center">
                                                    <div class="flex-shrink-0 h-10 w-10">
                                                        <c:choose>
                                                            <c:when test="${not empty emp.avatar}">
                                                                <img class="h-10 w-10 rounded-full object-cover" src="${pageContext.request.contextPath}/${emp.avatar}" alt="Avatar">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                                                                    <span class="text-blue-500 font-bold">${fn:substring(emp.firstName, 0, 1)}</span>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="ml-4">
                                                        <div class="text-sm font-medium text-gray-900">${emp.firstName} ${emp.middleName} ${emp.lastName}</div>
                                                        <div class="text-sm text-gray-500">${emp.email}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${emp.employeeId}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <c:choose>
                                                    <c:when test="${emp.roleId == 1}">Quản lý</c:when>
                                                    <c:when test="${emp.roleId == 2}">Nhân viên bán hàng</c:when>
                                                    <c:when test="${emp.roleId == 3}">Nhân viên kho</c:when>
                                                    <c:otherwise>Nhân viên</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Cửa hàng ${emp.storeId}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                <a href="${pageContext.request.contextPath}/management/employees/report?id=${emp.employeeId}" class="text-blue-600 hover:text-blue-900">Xem báo cáo</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            // Tab switching functionality
            document.addEventListener('DOMContentLoaded', function() {
                // Get all tab buttons
                const tabButtons = document.querySelectorAll('[data-tabs-target]');
                
                // Add click event to each button
                tabButtons.forEach(button => {
                    button.addEventListener('click', () => {
                        // Get target tab
                        const target = document.querySelector(button.dataset.tabsTarget);
                        
                        // Hide all tabs
                        document.querySelectorAll('#tab-content > div').forEach(tab => {
                            tab.classList.add('hidden');
                            tab.classList.remove('active');
                        });
                        
                        // Reset all buttons
                        tabButtons.forEach(btn => {
                            btn.classList.remove('text-blue-600', 'border-blue-600');
                            btn.classList.add('text-gray-500', 'border-transparent');
                        });
                        
                        // Show target tab
                        target.classList.remove('hidden');
                        target.classList.add('active');
                        
                        // Highlight active button
                        button.classList.remove('text-gray-500', 'border-transparent');
                        button.classList.add('text-blue-600', 'border-blue-600');
                    });
                });
            });
        </script>
    </body>
</html>
