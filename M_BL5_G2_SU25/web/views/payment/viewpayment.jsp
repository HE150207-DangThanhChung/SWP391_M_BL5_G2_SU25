<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Payments"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- 
    Document   : viewReceipt
    Created on : Aug 24, 2025, 3:55:51 PM
    Author     : hoang
--%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết hoá đơn</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            html, body {
                height: 100%;
            }
            body {
                font-family: "Inter", sans-serif;
                background-color: #f0f0f0;
                color: #374151;
                margin: 0;
                padding: 0;
            }
            .layout-wrapper {
                display: flex;
                min-height: 100vh;
            }
            .main-panel {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                padding: 20px;
            }
            .content-wrapper {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            .page-title {
                color: #2d3748;
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 1.5rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid #e2e8f0;
            }
            .filter-section {
                background: #f8fafc;
                padding: 15px;
                border-radius: 6px;
                margin-bottom: 20px;
            }
            .table {
                background: white;
                border-radius: 8px;
                overflow: hidden;
            }
            .table th {
                background: #f8fafc;
                color: #4a5568;
                font-weight: 600;
                border-bottom: 2px solid #e2e8f0;
            }
            .table td {
                vertical-align: middle;
            }
            .status-dot {
                display: inline-block;
                width: 8px;
                height: 8px;
                border-radius: 50%;
                margin-right: 6px;
            }
            .status-warning { background-color: #fbd38d; }
            .status-success { background-color: #68d391; }
            .status-danger { background-color: #fc8181; }
            .status-text {
                font-weight: 500;
            }
            .pagination {
                margin-top: 1rem;
                justify-content: center;
            }
            .page-link {
                color: #4a5568;
                border: 1px solid #e2e8f0;
            }
            .page-link:hover {
                background-color: #f7fafc;
                color: #2d3748;
            }
            .page-item.active .page-link {
                background-color: #4299e1;
                border-color: #4299e1;
            }
            .filter-group {
                margin-bottom: 1rem;
            }
            .filter-group label {
                font-weight: 500;
                color: #4a5568;
            }
            .form-control {
                border-radius: 6px;
                border: 1px solid #e2e8f0;
            }
            .form-control:focus {
                border-color: #4299e1;
                box-shadow: 0 0 0 2px rgba(66, 153, 225, 0.2);
            }
        </style>
    </head>
    <body>
        <div class="layout-wrapper flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel">
                <jsp:include page="/views/common/header.jsp"/>
                <div class="content-wrapper">
                    <h2 class="page-title">Lịch sử giao dịch</h2>
                    <div class="filter-section">
                        <div class="row">
                                <!-- Name filter -->

                                <!-- Sort by filter -->
                                <form action="viewpayments" method="get" id = "status" class="col-lg-4 d-flex align-items-center filter-group">
                                    <input type="hidden" name="action" value="status">
                                    <input type="hidden" name="sid" value="${sessionScope.employeeId}">
                                <div >
                                    <label for="status" class="mr-2 mb-0">Trạng thái:</label>
                                    <select name="status" class="form-control" id="status" onchange="this.form.submit();">
                                        <option value="" >Tất cả</option>
                                        <c:forEach items="${listPs}" var="p">
                                            <option value="${p.getPaymentStatus()}" 
                                                    <c:if test="${param.status eq p.getPaymentStatus()}">selected</c:if>>
                                                ${p.getPaymentStatus()}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </form>
                            <!-- Payment method filter -->
                            <form action="viewpayments" method="get" id="paymentmethod" class="col-lg-4 d-flex align-items-center filter-group">
                                <input type="hidden" name="action" value="paymentmethod">
                                <input type="hidden" name="sid" value="${sessionScope.employeeId}">
                                <div >
                                    <label for="method" class="mr-2 mb-0">Cách thức thanh toán:</label>
                                    <select name="method" class="form-control" id="method" onchange="this.form.submit();">
                                        <option value="">Tất cả</option>
                                        <c:forEach items="${listPm}" var="p">
                                            <option value="${p.getPaymentMethod()}" 
                                                    <c:if test="${param.method eq p.getPaymentMethod()}">selected</c:if>>
                                                ${p.getPaymentMethod()}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </form>
                            <form action="viewpayments" method="get" class="col-lg-4 d-flex align-items-center filter-group">
                                <input type="hidden" name="action" value="displayName">
                                <input type="hidden" name="sid" value="${sessionScope.user.getUserID()}">
                               
                            </form>
                        </div>
                    </div>
                </div>
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            
                            <th>Order ID</th>
                        
                            <th>Customer Name</th>
                            <th>Payment Method</th>
                            <th>Price</th>
                            <th>Payment Date</th>
                            <th>Payment Status</th>
                            <th>Transaction Code</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:if test="${not empty listP}">
                            <c:forEach items="${listP}" var="payment">
                                <tr>
                                    
                                    <td>${payment.getOrderID()}</td>
                                    
                                    <td>${payment.getFirstName()} ${payment.getMiddleName()} ${payment.getLastName()}</td>
                                    <td>${payment.getPaymentMethod()}</td>
                                    <td><fmt:formatNumber value="${payment.getPrice()}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    <td><fmt:formatDate value="${payment.getPaymentDate()}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${payment.getPaymentStatus() eq 'Chờ thanh toán'}">
                                                <span class="status-dot status-warning"></span>
                                                <span class="status-text text-warning">Chờ thanh toán</span>
                                            </c:when>
                                            <c:when test="${payment.getPaymentStatus() eq 'Đang xử lý'}">
                                                <span class="status-dot status-warning"></span>
                                                <span class="status-text text-warning">Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${payment.getPaymentStatus() eq 'Đã thanh toán'}">
                                                <span class="status-dot status-success"></span>
                                                <span class="status-text text-success">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${payment.getPaymentStatus() eq 'Đã bị hủy'}">
                                                <span class="status-dot status-danger"></span>
                                                <span class="status-text text-danger">Đã bị hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${payment.getPaymentStatus()}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${payment.getTransactionCode()}</td>
                                </tr>
                            </c:forEach>

                        </c:if>
                        <c:if test="${empty listP}">
                            <tr>
                                <td colspan="7" class="text-center">Không có thanh toán nào trùng khớp.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- Pagination (Optional) -->
                <nav aria-label="Page navigation" class="d-flex justify-content-center mt-3">
                    <ul class="pagination">
                        <!-- Previous button -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?sid=${param.sid}&action=${param.action}&name=${param.name}&status=${param.status}&method=${param.method}&page=${currentPage - 1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>

                        <!-- Page number buttons -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="?sid=${param.sid}&action=${param.action}&name=${param.name}&status=${param.status}&method=${param.method}&page=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <!-- Next button -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?sid=${param.sid}&action=${param.action}&name=${param.name}&status=${param.status}&method=${param.method}&page=${currentPage + 1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>

    </div>
</body>
<script>
    function confirmDelete(event, paymentId) {
        event.preventDefault(); // Ngăn chặn hành động mặc định của nút

        // Hiển thị cửa sổ xác nhận
        const confirmAction = confirm("Bạn có chắc chắn muốn xóa thanh toán này không?");

        if (confirmAction) {
            // Nếu người dùng nhấn "OK", gửi form
            const form = event.target.closest('form');
            form.submit();
        }
    }
</script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script src="assets/js/tiny-slider.js"></script>
<script src="assets/js/glightbox.min.js"></script>
<script src="assets/js/main.js"></script>
<script type="text/javascript"></script>
</html>
