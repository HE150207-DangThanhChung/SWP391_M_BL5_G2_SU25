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
                          
                </div>
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Họ tên</th>
                            <th>Phương thức thanh toán</th>
                            <th>Tổng tiền</th>
                            <th>Ngày đặt</th>
                            <th>Trạng thái</th>
                            <th >Mã thanh toán</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:if test="${not empty listP}">
                         
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${payment.paymentMethod}</td>
                                    <td><fmt:formatNumber value="${payment.price}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0" /></td>
                                    <td><fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy" /></td>
                                   
                                    <td>
                                        ${payment.transactionCode}
                                    </td>
                                </tr>
                         

                        </c:if>
                  
                    </tbody>
                </table>
                <!-- Pagination (Optional) -->
             
             

                      

            </div>
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
