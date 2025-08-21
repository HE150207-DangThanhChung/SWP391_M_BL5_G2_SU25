<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chi tiết đơn hàng</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background: #f2f2f2; }
    </style>
</head>
<body>
    <h2>Chi tiết đơn hàng</h2>
    <c:if test="${not empty error}">
        <div style="color:red;">${error}</div>
    </c:if>
    <c:if test="${not empty order}">
        <table>
            <tr><th>Mã đơn hàng</th><td>${order.orderId}</td></tr>
            <tr><th>Ngày đặt</th><td>${order.orderDate}</td></tr>
            <tr><th>Trạng thái</th><td>${order.status}</td></tr>
            <tr><th>Khách hàng</th><td>${order.customer != null ? order.customer.fullName : order.customerId}</td></tr>
            <tr><th>Người tạo</th><td>${order.createdBy != null ? order.createdBy.fullName : order.createdById}</td></tr>
            <tr><th>Người bán</th><td>${order.saleBy != null ? order.saleBy.fullName : order.saleById}</td></tr>
            <tr><th>Cửa hàng</th><td>${order.store != null ? order.store.storeName : order.storeId}</td></tr>
        </table>
        <h3>Danh sách sản phẩm</h3>
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
                    <td>${detail.price}</td>
                    <td>${detail.quantity}</td>
                    <td>${detail.discount}</td>
                    <td>${detail.taxRate}</td>
                    <td>${detail.totalAmount}</td>
                    <td>${detail.status}</td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <a href="${pageContext.request.contextPath}/orders">Quay lại danh sách đơn hàng</a>
</body>
</html>
