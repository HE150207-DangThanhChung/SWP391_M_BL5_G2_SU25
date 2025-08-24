<%-- 
    Document   : editOrder
    Created on : Aug 13, 2025, 8:48:48 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Cập nhật đơn hàng</title>
    <style>
        table { border-collapse: collapse; width: 100%; margin-bottom: 16px; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background: #f2f2f2; text-align: left; }
        input[type=text], input[type=number], input[type=date] { width: 100%; padding: 6px; border-radius: 4px; border: 1px solid #bbb; }
        input[readonly] {
            background: #f9f9f9;
            color: #555;
            border: 1px solid #e0e0e0;
            font-weight: bold;
        }
        .readonly-label {
            color: #888;
            font-size: 0.95em;
            font-style: italic;
        }
    </style>
</head>
<body>
    <h2>Cập nhật đơn hàng</h2>
    <c:if test="${not empty error}">
        <div style="color:red;">${error}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/order/edit" method="post">
        <input type="hidden" name="orderId" value="${order.orderId}" />
        <table>
            <tr><th>Ngày đặt <span class="readonly-label">(chỉ xem)</span></th><td><input type="date" value="${order.orderDate}" readonly /></td></tr>
            <tr><th>Trạng thái</th>
                <td>
                    <select name="status" required>
                        <option value="Completed" ${order.status == 'Completed' ? 'selected' : ''}>Completed</option>
                        <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Pending</option>
                    </select>
                </td>
            </tr>
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
        <h3>Chi tiết sản phẩm</h3>
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
                    <td><input type="number" value="${detail.productVariantId}" readonly /></td>
                    <td><input type="text" value="${detail.productName}" readonly /></td>
                    <td><input type="number" step="0.01" value="${detail.price}" readonly /></td>
                    <td><input type="number" value="${detail.quantity}" readonly /></td>
                    <td><input type="number" step="0.01" value="${detail.discount}" readonly /></td>
                    <td><input type="number" step="0.01" value="${detail.taxRate}" readonly /></td>
                    <td><input type="number" step="0.01" value="${detail.totalAmount}" readonly /></td>
                    <td><input type="text" value="${detail.status}" readonly /></td>
                </tr>
            </c:forEach>
        </table>
        <br>
        <button type="submit">Cập nhật đơn hàng</button>
        <a href="${pageContext.request.contextPath}/orders">Quay lại danh sách đơn hàng</a>
    </form>
</body>
</html>
