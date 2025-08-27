<%-- 
    Document   : editOrder
    Created on : Aug 13, 2025, 8:48:48 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            border: none;
        }
        .card-header {
            background-color: #fff;
            border-bottom: 1px solid #e3e6f0;
            padding: 1rem 1.25rem;
        }
        .card-title {
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 0;
        }
        .form-label {
            font-weight: 500;
            color: #4a5568;
        }
        .form-control[readonly] {
            background-color: #f8f9fa;
            font-weight: 500;
            color: #6c757d;
        }
        .badge {
            padding: 0.5em 0.8em;
            font-weight: 500;
        }
        .table td {
            vertical-align: middle;
        }
        .readonly-label {
            color: #6c757d;
            font-size: 0.875em;
            margin-left: 0.5rem;
        }
        .btn-icon {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="card-title">
                    <i class="bi bi-pencil-square me-2"></i>Cập nhật đơn hàng #${order.orderId}
                </h5>
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary btn-sm btn-icon">
                    <i class="bi bi-arrow-left"></i>
                    Quay lại danh sách
                </a>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <div>${error}</div>
                    </div>
                </c:if>
                <form action="${pageContext.request.contextPath}/order/edit" method="post">
                    <input type="hidden" name="orderId" value="${order.orderId}" />
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">
                                    Ngày đặt
                                    <span class="readonly-label">(chỉ xem)</span>
                                </label>
                                <input type="date" class="form-control" value="${order.orderDate}" readonly />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select" required>
                                    <option value="Completed" ${order.status == 'Completed' ? 'selected' : ''}>Đã hoàn thành</option>
                                    <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                    <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Đang xử lý</option>
                                </select>
                            </div>
                        </div>
            <tr><th>Khách hàng <span class="readonly-label">(chỉ xem)</span></th>
                <td>
                    <input type="text" value="${order.customer != null ? order.customer.fullName : 'Không có thông tin khách hàng'}" readonly />
                </td>
            </tr>
            <tr><th>Người tạo <span class="readonly-label">(chỉ xem)</span></th>
                <td>
                    <input type="text" value="${order.createdBy != null ? order.createdBy.fullName : 'Không có thông tin người tạo'}" readonly />
                </td>
            </tr>
            <tr><th>Người bán <span class="readonly-label">(chỉ xem)</span></th>
                <td>
                    <input type="text" value="${order.saleBy != null ? order.saleBy.fullName : 'Không có thông tin người bán'}" readonly />
                </td>
            </tr>
            <tr><th>Cửa hàng <span class="readonly-label">(chỉ xem)</span></th>
                <td>
                    <input type="text" value="${order.store != null ? order.store.storeName : 'Không có thông tin cửa hàng'}" readonly />
                </td>
            </tr>
        </table>
        <div class="card mt-4">
            <div class="card-header">
                <h5 class="card-title">
                    <i class="bi bi-cart me-2"></i>Chi tiết sản phẩm
                </h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Mã biến thể</th>
                                <th>Tên sản phẩm</th>
                                <th style="width: 120px;">Giá</th>
                                <th style="width: 100px;">Số lượng</th>
                                <th style="width: 100px;">Giảm giá</th>
                                <th style="width: 100px;">Thuế</th>
                                <th style="width: 140px;">Thành tiền</th>
                                <th style="width: 120px;">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="detail" items="${order.orderDetails}">
                                <tr>
                                    <td>${detail.productVariantId}</td>
                                    <td>${detail.productName}</td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${detail.price}" type="number" pattern="#,##0"/>₫
                                    </td>
                                    <td class="text-center">${detail.quantity}</td>
                                    <td class="text-end">${detail.discount}%</td>
                                    <td class="text-end">${detail.taxRate}%</td>
                                    <td class="text-end fw-medium">
                                        <fmt:formatNumber value="${detail.totalAmount}" type="number" pattern="#,##0"/>₫
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-${detail.status == 'Completed' ? 'success' : 
                                                              detail.status == 'Pending' ? 'warning' : 'secondary'}">
                                            ${detail.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot class="table-light">
                            <tr>
                                <td colspan="6" class="text-end fw-medium">Tổng cộng:</td>
                                <td class="text-end fw-bold">
                                    <c:set var="total" value="0" />
                                    <c:forEach var="detail" items="${order.orderDetails}">
                                        <c:set var="total" value="${total + detail.totalAmount}" />
                                    </c:forEach>
                                    <fmt:formatNumber value="${total}" type="number" pattern="#,##0"/>₫
                                </td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                  <div class="card mt-4">
                    <div class="card-header">
                        <h5 class="card-title">
                            <i class="bi bi-ticket-perforated me-2"></i>Mã giảm giá áp dụng
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã Coupon</th>
                                        <th>Phần trăm giảm</th>
                                        <th>Số tiền giảm</th>
                                        <th>Ngày áp dụng</th>
                                        <th>Yêu cầu tối thiểu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="hasCoupon" value="false"/>
                                    <c:forEach var="oc" items="${orderCoupons}">
                                        <c:if test="${oc.orderId == order.orderId}">
                                            <c:set var="hasCoupon" value="true"/>
                                            <tr>
                                                <td>${oc.coupon != null ? oc.coupon.couponCode : oc.couponId}</td>
                                                <td>
                                                    <c:if test="${oc.coupon != null}">
                                                        <span class="badge bg-info">
                                                            <fmt:formatNumber value="${oc.coupon.discountPercent}" type="number" maxFractionDigits="1"/>%
                                                        </span>
                                                        <c:if test="${oc.coupon.maxDiscount > 0}">
                                                            <br>
                                                            <small class="text-muted">
                                                                Tối đa: <fmt:formatNumber value="${oc.coupon.maxDiscount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                            </small>
                                                        </c:if>
                                                    </c:if>
                                                </td>
                                                <td class="text-end">
                                                    <span class="fw-medium text-success">
                                                        -<fmt:formatNumber value="${oc.appliedAmount}" type="number" pattern="#,##0"/>₫
                                                    </span>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${oc.appliedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td>
                                                    <c:if test="${oc.coupon != null}">
                                                        <c:if test="${oc.coupon.minTotal > 0}">
                                                            <small class="d-block">
                                                                <i class="bi bi-cash me-1"></i>Đơn tối thiểu: 
                                                                <fmt:formatNumber value="${oc.coupon.minTotal}" type="number" pattern="#,##0"/>₫
                                                            </small>
                                                        </c:if>
                                                        <c:if test="${oc.coupon.minProduct > 0}">
                                                            <small class="d-block">
                                                                <i class="bi bi-box me-1"></i>Số sản phẩm tối thiểu: ${oc.coupon.minProduct}
                                                            </small>
                                                        </c:if>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${!hasCoupon}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted">
                                                <i class="bi bi-info-circle me-2"></i>Không có mã giảm giá nào được áp dụng
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>              
            </div>
                                
        </div>
        <div class="d-flex gap-2 justify-content-end mt-4">
            <button type="submit" class="btn btn-primary btn-icon">
                <i class="bi bi-check-lg"></i> Cập nhật đơn hàng
            </button>
        </div>
    </form>
</div>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
