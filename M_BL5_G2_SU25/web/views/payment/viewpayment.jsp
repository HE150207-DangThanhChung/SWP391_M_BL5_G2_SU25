<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Payments"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payment List</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/main.css" />
        <style>
            body {
                color: #566787;
                background: #f5f5f5;
                font-family: 'Varela Round', sans-serif;
                font-size: 13px;
            }

            .table-wrapper {
                min-width: 1000px;
                background: #fff;
                padding: 20px 25px;
                border-radius: 3px;
                box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
                margin-top: 20px
            }

            .table-title {
                color: white;
                background: #4b5366;
                padding: 16px 25px;
                margin: -20px -25px 10px;
                border-radius: 3px 3px 0 0;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .table-title h2 {
                margin: 0;
                font-size: 24px;
                color: white;
            }

            table.table th {
                background-color: #f8f9fa;
                font-weight: bold;
                border-bottom: 2px solid #dee2e6;
            }

            table.table tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            table.table tr:hover {
                background: #e9ecef;
            }

            .btn-danger {
                color: #fff;
                background-color: #dc3545;
                text-align: center;
            }

            .btn-danger:hover {
                background-color: #c82333;
            }

            .status {
                font-size: 16px;
                margin-right: 5px;
            }

            .text-success {
                color: #10c469;
            }

            .text-warning {
                color: #FFC107;
            }

            .text-danger {
                color: #ff5b5b;
            }

            .pagination {
                float: right;
                margin: 0 0 5px;
            }

            .pagination li a {
                border: none;
                font-size: 13px;
                color: #999;
                margin: 0 2px;
                text-align: center;
                padding: 6px 12px;
            }

            .pagination li.active a {
                background: #03A9F4;
                color: white;
            }

            .pagination li.disabled a {
                color: #ccc;
            }
            .filter-group{
                margin-top: 5px;
            }
        </style>
    </head>
    <body>
        <div class="preloader">
            <div class="preloader-inner">
                <div class="preloader-icon">
                    <span></span>
                    <span></span>
                </div>
            </div>
        </div>
        <div class="container-fluid">
      

                <div class="container-xl">
                    <div class="table-wrapper">
                        <div class="table-title">
                            <h2>Lịch sử giao dịch</h2>
                        </div>
                        <div class="row mb-3 filter-group">
                            <div class="col-lg-3">

                            </div>
                            <div class="row col-lg-9">
                                <!-- Name filter -->

                                <!-- Sort by filter -->
                                <form action="viewpayments" method="get" id = "status" class="col-lg-4 d-flex align-items-center filter-group">
                                    <input type="hidden" name="action" value="status">
                                    <input type="hidden" name="sid" value="${sessionScope.employee.employeeId}">
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
                                <input type="hidden" name="sid" value="${sessionScope.employee.employeeId}">
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
                                <div >
                                    <label for="name" class="mr-2 mb-0">Họ tên:</label>
                                    <div class="input-group">
                                        <input type="hidden" name="action" value="displaybyname">
                                        
                                        <div class="input-group-append">
                                            <button type="submit" class="btn btn-primary"><i class="fa fa-search"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Payment ID</th>
                            <th>Order ID</th>
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
                                    <td>${payment.getPaymentID()}</td>
                                    <td>${payment.getOrderID()}</td>
                                    <td>${payment.getPaymentMethod()}</td>
                                    <td><fmt:formatNumber value="${payment.getPrice()}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    <td><fmt:formatDate value="${payment.getPaymentDate()}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${payment.getPaymentStatus() eq 'Chờ thanh toán'}">
                                                <span class="status text-warning">&bull;</span> Chờ thanh toán
                                            </c:when>
                                            <c:when test="${payment.getPaymentStatus() eq 'Đang xử lý'}">
                                                <span class="status text-warning">&bull;</span> Đang xử lý
                                            </c:when>
                                            <c:when test="${payment.getPaymentStatus() eq 'Đã thanh toán'}">
                                                <span class="status text-success">&bull;</span> Đã thanh toán
                                            </c:when>
                                            <c:when test="${payment.getPaymentStatus() eq 'Đã bị hủy'}">
                                                <span class="status text-danger">&bull;</span> Đã bị hủy
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
