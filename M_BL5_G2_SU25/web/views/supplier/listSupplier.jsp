<%-- 
    Document   : ownerDashboard
    Created on : Aug 14, 2025, 8:39:00 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lí nhà cung cấp</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

        <style>
            /* 1) Make the page span the viewport height */
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

            /* 2) Ensure the outer wrapper and right panel are full-height flex columns */
            .layout-wrapper {
                display: flex;
                min-height: 100vh;       /* key */
            }

            .main-panel {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;  /* header | main | footer stacked */
                min-height: 100vh;       /* key */
            }

            /* 3) Let main content grow to fill available space */
            .content {
                width: 100%;
                margin: 0;
                padding-left: 10px;
                padding-top: 0;
                display: flex;
                flex-direction: column;
                flex: 1 1 auto;          /* key: pushes footer down */
            }

            /* 4) Footer sits at the bottom by taking remaining space above it */
            .main-panel > .footer,
            .main-panel > footer.footer {
                margin-top: auto;        /* key */
            }
        </style>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <div class="layout-wrapper d-flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen">
                <jsp:include page="/views/common/header.jsp"/>

                <main class="content flex-1 p-6">
                    <!-- Header Section -->
                    <div class="mb-6 flex items-center justify-between">
                        <div>
                            <h1 class="text-2xl font-bold">Quản lí nhà cung cấp</h1>
                            <p class="text-gray-500">Manage your suppliers efficiently</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/management/suppliers/add"
                           class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors">
                            Add Supplier
                        </a>
                    </div>

                    <!-- Search & Filter -->
                    <form method="get" action="${pageContext.request.contextPath}/management/suppliers" class="flex items-center gap-3 mb-4">
                        <input type="text" name="search" value="${param.search}" placeholder="Search..."
                               class="border border-gray-300 rounded-md px-3 py-2 w-64 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
                        <select name="status" class="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="">All Status</option>
                            <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Active</option>
                            <option value="Deactive" ${param.status == 'Deactive' ? 'selected' : ''}>Deactive</option>
                        </select>
                        <button type="submit" class="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded-md">Filter</button>
                        <a href="${pageContext.request.contextPath}/management/suppliers"><button type="button" class="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded-md">Clear Filter</button></a>
                    </form>

                    <!-- Table -->
                    <div class="overflow-x-auto bg-white rounded-lg border border-gray-200">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">ID</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Supplier Name</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Phone</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tax Code</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:choose>
                                    <c:when test="${not empty suppliers}">
                                        <c:forEach var="s" items="${suppliers}">
                                            <tr class="hover:bg-gray-50">
                                                <td class="px-6 py-4 whitespace-nowrap text-sm">${s.supplierId}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">${s.supplierName}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${s.supplierPhone}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${s.supplierEmail}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${s.supplierTaxCode}</td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full 
                                                          ${s.supplierStatus == 'Active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                                        ${s.supplierStatus}
                                                    </span>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                                                    <a href="${pageContext.request.contextPath}/management/suplliers/edit?id=${s.supplierId}"
                                                       class="text-blue-600 hover:text-blue-900">Edit</a>
                                                    <a href="${pageContext.request.contextPath}/management/suplliers/delete?id=${s.supplierId}"
                                                       class="text-red-600 hover:text-red-900"
                                                       onclick="return confirm('Are you sure you want to delete this supplier?');">Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="px-6 py-12 text-center text-gray-500">
                                                <div class="flex flex-col items-center">
                                                    <svg class="w-12 h-12 text-gray-300 mb-4" fill="none" stroke="currentColor"
                                                         viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                                    </svg>
                                                    <p class="text-sm text-gray-500">No suppliers found</p>
                                                    <p class="text-xs text-gray-400 mt-1">Add your first supplier to get started</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="flex items-center justify-between mt-6">
                            <!-- Left side info -->
                            <div class="text-sm text-gray-700">
                                Showing <span class="font-medium">${startItem}</span> to <span class="font-medium">${endItem}</span> of <span class="font-medium">${totalItems}</span> results
                            </div>

                            <!-- Right side pagination buttons -->
                            <div class="flex space-x-2">
                                <!-- Previous -->
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}&search=${param.search}&statusId=${param.statusId}"
                                       class="px-3 py-1 text-sm bg-white border border-gray-300 text-gray-500 rounded-md hover:bg-gray-50">
                                        Previous
                                    </a>
                                </c:if>

                                <!-- Numbered pages -->
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="?page=${i}&search=${param.search}&statusId=${param.statusId}"
                                       class="px-3 py-1 text-sm border rounded-md
                                       ${i == currentPage ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-500 border-gray-300 hover:bg-gray-50'}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <!-- Next -->
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}&search=${param.search}&statusId=${param.statusId}"
                                       class="px-3 py-1 text-sm bg-white border border-gray-300 text-gray-500 rounded-md hover:bg-gray-50">
                                        Next
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>
    </body>
</html>
