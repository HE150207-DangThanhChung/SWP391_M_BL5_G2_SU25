<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Tạo mới đơn hàng</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background: #f2f2f2; }
        input[type=text], input[type=number], input[type=date] { width: 100%; }
    </style>
</head>
<body>
    <h2>Tạo mới đơn hàng</h2>
    <c:if test="${not empty error}">
        <div style="color:red;">${error}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/order/create" method="post">
        <table>
            <tr><th>Ngày đặt</th><td><input type="date" name="orderDate" required /></td></tr>
            <tr><th>Trạng thái</th><td><input type="text" name="status" required /></td></tr>
            <tr><th>Khách hàng</th><td><input type="number" name="customerId" required /></td></tr>
            <tr><th>Người tạo</th><td><input type="number" name="createdById" required /></td></tr>
            <tr><th>Người bán</th><td><input type="number" name="saleById" required /></td></tr>
            <tr><th>Cửa hàng</th><td><input type="number" name="storeId" required /></td></tr>
        </table>
        <h3>Chi tiết sản phẩm</h3>
        <table id="orderDetailsTable">
            <tr>
                <th>Mã biến thể</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Giảm giá</th>
                <th>Thuế</th>
                <th>Thành tiền</th>
                <th>Trạng thái</th>
                <th></th>
            </tr>
        </table>
        <button type="button" onclick="addDetailRow()">Thêm sản phẩm</button>
        <br><br>
        <button type="submit">Tạo đơn hàng</button>
        <a href="${pageContext.request.contextPath}/orders">Quay lại danh sách đơn hàng</a>
    </form>
    <script>
        function addDetailRow() {
            var table = document.getElementById('orderDetailsTable');
            var row = table.insertRow(-1);
            row.innerHTML = `
                <td><input type="number" name="productVariantId" required /></td>
                <td><input type="text" name="productName" required /></td>
                <td><input type="number" step="0.01" name="price" required /></td>
                <td><input type="number" name="quantity" required /></td>
                <td><input type="number" step="0.01" name="discount" /></td>
                <td><input type="number" step="0.01" name="taxRate" /></td>
                <td><input type="number" step="0.01" name="totalAmount" required /></td>
                <td><input type="text" name="detailStatus" required /></td>
                <td><button type="button" onclick="removeDetailRow(this)">Xóa</button></td>
            `;
        }
        function removeDetailRow(btn) {
            var row = btn.parentNode.parentNode;
            row.parentNode.removeChild(row);
        }
    </script>
</body>
</html>
