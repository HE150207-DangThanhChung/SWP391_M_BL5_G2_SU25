<%-- 
    Document   : viewEmployeeReport
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
    </head>
    <body class="bg-gray-100 flex">
        <jsp:include page="/views/common/sidebar.jsp"></jsp:include>

            <div class="flex-1 ml-64">
            <jsp:include page="/views/common/header.jsp"></jsp:include>

                <div class="p-6 max-w-6xl mx-auto">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-2xl font-bold text-gray-800">
                        <c:choose>
                            <c:when test="${isAllReportsView}">Báo cáo tất cả nhân viên</c:when>
                            <c:otherwise>Báo cáo nhân viên</c:otherwise>
                        </c:choose>
                    </h2>
                    <a href="${pageContext.request.contextPath}/management/employees"
                       class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300 text-sm">
                        ← Quay lại
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty e}">
                        <!-- Thông tin nhân viên -->
                        <div class="bg-white p-4 rounded-lg shadow mb-6 flex items-center space-x-4">
                            <c:choose>
                                <c:when test="${not empty e.avatar}">
                                    <img class="w-16 h-16 rounded-full object-cover border" src="${pageContext.request.contextPath}/${e.avatar}">
                                </c:when>
                                <c:otherwise>
                                    <div class="w-16 h-16 rounded-full bg-blue-100 flex items-center justify-center text-blue-500 text-2xl font-bold">
                                        ${fn:substring(e.firstName,0,1)}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div>
                                <h3 class="text-lg font-bold">${e.firstName} ${e.middleName} ${e.lastName}</h3>
                                <p class="text-gray-600">${e.email}</p>
                                <p class="text-sm text-gray-500">ID: <span class="font-semibold">${e.employeeId}</span></p>
                            </div>
                        </div>

                        <!-- Bộ lọc trạng thái -->
                        <form method="get" class="flex items-center space-x-3 bg-white p-4 rounded-lg shadow mb-4"
                              action="${pageContext.request.contextPath}/management/employees/report">
                            <c:if test="${not isAllReportsView}">
                                <input type="hidden" name="id" value="${e.employeeId}">
                            </c:if>
                            <label class="text-sm">Trạng thái:</label>
                            <select name="status" onchange="this.form.submit()" class="border rounded px-2 py-1">
                                <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>Tất cả (${totalReports})</option>
                                <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Đang chờ (${pendingReports})</option>
                                <option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Đã duyệt (${approvedReports})</option>
                                <option value="Rejected" ${statusFilter == 'Rejected' ? 'selected' : ''}>Từ chối (${rejectedReports})</option>
                            </select>
                        </form>

                        <!-- Danh sách báo cáo -->
                        <c:choose>
                            <c:when test="${not empty employeeReports}">
                                <c:forEach items="${employeeReports}" var="report">
                                    <div class="bg-white p-4 rounded-lg shadow mb-3">
                                        <div class="flex justify-between items-center">
                                            <span class="font-semibold">${report.employeeName}</span>
                                            <span class="text-xs px-2 py-1 rounded-full
                                                  ${report.status == 'Pending'  ? 'bg-yellow-100 text-yellow-800' :
                                                    report.status == 'Approved' ? 'bg-green-100 text-green-800'  :
                                                    report.status == 'Cancelled' ? 'bg-red-100 text-red-800'     : ''}">
                                                  <c:choose>
                                                      <c:when test="${report.status == 'Pending'}">Đang chờ</c:when>
                                                      <c:when test="${report.status == 'Approved'}">Đã duyệt</c:when>
                                                      <c:when test="${report.status == 'Cancelled'}">Từ chối</c:when>
                                                      <c:otherwise>Không xác định</c:otherwise>
                                                  </c:choose>
                                            </span>
                                        </div>
                                        <p class="mt-2 text-gray-700">${report.description}</p>
                                        <p class="text-xs text-gray-500 mt-2">
                                            Ngày: <fmt:formatDate value="${report.createdAt}" pattern="dd/MM/yyyy"/>
                                        </p>
                                    </div>
                                </c:forEach>

                            </c:when>
                            <c:otherwise>
                                <div class="bg-white p-6 rounded-lg shadow text-center text-gray-500">
                                    Chưa có báo cáo nào.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <!-- Hiển thị danh sách nhân viên -->
                        <div class="bg-white rounded-lg shadow overflow-hidden">
                            <table class="w-full text-sm">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-4 py-2 text-left">Nhân viên</th>
                                        <th class="px-4 py-2">ID</th>
                                        <th class="px-4 py-2">Vai trò</th>
                                        <th class="px-4 py-2">Cửa hàng</th>
                                        <th class="px-4 py-2">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${employees}" var="emp">
                                        <tr class="border-t">
                                            <td class="px-4 py-2">${emp.firstName} ${emp.lastName}</td>
                                            <td class="px-4 py-2">${emp.employeeId}</td>
                                            <td class="px-4 py-2">
                                                <c:choose>
                                                    <c:when test="${emp.roleId == 1}">Quản lý</c:when>
                                                    <c:when test="${emp.roleId == 2}">Bán hàng</c:when>
                                                    <c:when test="${emp.roleId == 3}">Kho</c:when>
                                                    <c:otherwise>Nhân viên</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-4 py-2">Cửa hàng ${emp.storeId}</td>
                                            <td class="px-4 py-2">
                                                <a href="${pageContext.request.contextPath}/management/employees/report?id=${emp.employeeId}"
                                                   class="text-blue-600 hover:underline">Xem báo cáo</a>
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
    </body>
</html>
