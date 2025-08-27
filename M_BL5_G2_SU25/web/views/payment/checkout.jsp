<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .payment-method-card {
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .payment-method-card:hover {
            border-color: #0d6efd;
        }
        .payment-method-card.selected {
            border-color: #0d6efd;
            background-color: #f8f9fa;
        }
        .order-summary {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h3 class="card-title mb-4">Thanh toán đơn hàng #${order.orderId}</h3>
                        
                        <!-- Thông tin đơn hàng -->
                        <div class="order-summary mb-4">
                            <h5>Thông tin đơn hàng</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Khách hàng:</strong> ${order.customer.fullName}</p>
                                    <p><strong>Ngày đặt:</strong> ${order.orderDate}</p>
                                    <p><strong>Chi nhánh:</strong> ${order.store.storeName}</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Tổng tiền gốc:</strong> ${originalAmount} VNĐ</p>
                                    <c:if test="${not empty appliedCoupons}">
                                        <p class="text-success"><strong>Giảm giá:</strong> -${discountAmount} VNĐ</p>
                                        <div class="small mb-2">
                                            <strong>Mã giảm giá đã áp dụng:</strong>
                                            <ul class="list-unstyled">
                                                <c:forEach items="${appliedCoupons}" var="coupon">
                                                    <li class="text-success">
                                                        <i class="bi bi-ticket-perforated"></i>
                                                        Mã ${coupon.coupon.couponCode}: -${coupon.appliedAmount} VNĐ
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </c:if>
                                    <p class="fw-bold text-primary"><strong>Thành tiền:</strong> ${totalAmount} VNĐ</p>
                                    <p><strong>Trạng thái:</strong> 
                                        <c:choose>
                                            <c:when test="${order.status eq 'Pending'}">
                                                <span class="badge bg-warning">Chờ thanh toán</span>
                                            </c:when>
                                            <c:when test="${order.status eq 'Completed'}">
                                                <span class="badge bg-success">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${order.status eq 'Cancelled'}">
                                                <span class="badge bg-danger">Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${order.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Form thanh toán -->
                        <form action="${pageContext.request.contextPath}/checkoutInfo" method="POST">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            
                            <h5 class="mb-3">Chọn phương thức thanh toán</h5>
                            
                            <!-- COD -->
                            <div class="payment-method-card" onclick="selectPaymentMethod('COD')">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           id="codPayment" value="COD" checked>
                                    <label class="form-check-label" for="codPayment">
                                        <i class="bi bi-cash-coin me-2"></i>
                                        Thanh toán khi nhận hàng (COD)
                                    </label>
                                </div>
                            </div>

                            <!-- VNPAY -->
                            <div class="payment-method-card" onclick="selectPaymentMethod('VNPAY')">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           id="vnpayPayment" value="VNPAY">
                                    <label class="form-check-label" for="vnpayPayment">
                                        <i class="bi bi-credit-card me-2"></i>
                                        Thanh toán qua VNPAY
                                    </label>
                                </div>
                            </div>

                            <div class="d-grid gap-2 mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle me-2"></i>Xác nhận thanh toán
                                </button>
                                <a href="${pageContext.request.contextPath}/orders" 
                                   class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-2"></i>Quay lại
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function selectPaymentMethod(method) {
            document.querySelectorAll('.payment-method-card').forEach(card => {
                card.classList.remove('selected');
            });
            document.querySelector(`#${method.toLowerCase()}Payment`)
                    .closest('.payment-method-card')
                    .classList.add('selected');
        }
        // Chọn COD mặc định
        selectPaymentMethod('COD');
    </script>
</body>
</html>
