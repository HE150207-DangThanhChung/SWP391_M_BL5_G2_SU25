<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi tiết đơn hàng</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: #f9f9fb;
            color: #333;
            margin: 0;
            padding: 20px;
        }

        h2, h3 {
            text-align: center;
            color: #444;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            background: #fff;
            border-radius: 12px;
            padding: 20px 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin: 15px 0;
            border-radius: 8px;
            overflow: hidden;
        }

        th {
            background: #4CAF50;
            color: white;
            text-align: left;
            padding: 10px;
        }

        td {
            padding: 10px;
            border-bottom: 1px solid #eee;
        }

        tr:hover td {
            background: #f1f9f1;
        }

        .error {
            color: #d9534f;
            font-weight: bold;
            text-align: center;
            margin-bottom: 15px;
        }

        .back-btn {
            display: inline-block;
            padding: 10px 18px;
            background: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: 0.3s;
            margin-top: 15px;
        }

        .back-btn:hover {
            background: #45a049;
        }

        .info-table th {
            width: 25%;
            background: #f0f0f0;
            color: #333;
        }

        .section-title {
            margin-top: 25px;
            font-size: 18px;
            font-weight: bold;
            border-left: 4px solid #4CAF50;
            padding-left: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Chi tiết đơn hàng</h2>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <c:if test="${not empty order}">
        <!-- Thông tin chung -->
        <div class="section-title">Thông tin chung</div>
        <table class="info-table">
            <tr><th>Mã đơn hàng</th><td>${order.orderId}</td></tr>
            <tr><th>Ngày đặt</th><td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td></tr>
            <tr><th>Trạng thái</th><td>${order.status}</td></tr>
            <tr><th>Khách hàng</th><td>${order.customer != null ? order.customer.fullName : order.customerId}</td></tr>
            <tr><th>Người tạo</th><td>${order.createdBy != null ? order.createdBy.fullName : order.createdById}</td></tr>
            <tr><th>Người bán</th><td>${order.saleBy != null ? order.saleBy.fullName : order.saleById}</td></tr>
            <tr><th>Cửa hàng</th><td>${order.store != null ? order.store.storeName : order.storeId}</td></tr>
        </table>

        <!-- Danh sách sản phẩm -->
        <div class="section-title">Danh sách sản phẩm</div>
        <table>
            <tr>
                <th>Mã biến thể</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Giảm giá</th>
                <th>Thuế</th>
                <th>Thành tiền</th>
                <th>Trạng thái</th>
            </tr>
            <c:forEach var="detail" items="${order.orderDetails}">
                <tr>
                    <td>${detail.productVariantId}</td>
                    <td>${detail.productName}</td>
                    <td><fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                    <td>${detail.quantity}</td>
                    <td><fmt:formatNumber value="${detail.discount}" type="number" maxFractionDigits="2"/>%</td>
                    <td><fmt:formatNumber value="${detail.taxRate}" type="number" maxFractionDigits="2"/>%</td>
                    <td><fmt:formatNumber value="${detail.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${detail.status eq 'Completed'}">Đã hoàn thành</c:when>
                            <c:otherwise>${detail.status}</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </table>

        <!-- Danh sách Coupon áp dụng -->
        <div class="section-title">Mã giảm giá áp dụng</div>
        <table>
            <tr>
                <th>Mã Coupon</th>
                <th>Phần trăm giảm</th>
                <th>Số tiền giảm</th>
                <th>Ngày áp dụng</th>
                <th>Yêu cầu tối thiểu</th>
            </tr>
            <c:set var="hasCoupon" value="false"/>
            <c:forEach var="oc" items="${orderCoupons}">
                <c:if test="${oc.orderId == order.orderId}">
                    <c:set var="hasCoupon" value="true"/>
                    <tr>
                        <td>${oc.coupon != null ? oc.coupon.couponCode : oc.couponId}</td>
                        <td>
                            <c:if test="${oc.coupon != null}">
                                <fmt:formatNumber value="${oc.coupon.discountPercent}" type="number" maxFractionDigits="1"/>%
                                <c:if test="${oc.coupon.maxDiscount > 0}">
                                    <br>
                                    <small class="text-muted">(Tối đa: <fmt:formatNumber value="${oc.coupon.maxDiscount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>)</small>
                                </c:if>
                            </c:if>
                        </td>
                        <td><fmt:formatNumber value="${oc.appliedAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                        <td><fmt:formatDate value="${oc.appliedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td>
                            <c:if test="${oc.coupon != null}">
                                <c:if test="${oc.coupon.minTotal > 0}">
                                    Đơn tối thiểu: <fmt:formatNumber value="${oc.coupon.minTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/><br>
                                </c:if>
                                <c:if test="${oc.coupon.minProduct > 0}">
                                    Số sản phẩm tối thiểu: ${oc.coupon.minProduct}
                                </c:if>
                            </c:if>
                        </td>
                    </tr>
                </c:if>
            </c:forEach>
            <c:if test="${!hasCoupon}">
                <tr><td colspan="5" style="text-align:center;color:#888;">Không có mã giảm giá nào được áp dụng</td></tr>
            </c:if>
        </table>
    </c:if>

    <div style="text-align:center;">
        <a href="${pageContext.request.contextPath}/orders" class="back-btn">⬅ Quay lại danh sách</a>
    </div>
</div>
</body>
</html>
