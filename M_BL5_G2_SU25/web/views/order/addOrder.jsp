
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tạo đơn hàng mới</title>
    <style>
        table { border-collapse: collapse; width: 100%; margin-bottom: 16px; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background: #f2f2f2; text-align: left; }
        input[type=text], input[type=number], input[type=date] { width: 100%; padding: 6px; border-radius: 4px; border: 1px solid #bbb; }
        select { width: 100%; padding: 6px; border-radius: 4px; border: 1px solid #bbb; }
    </style>
</head>
<body>
    <h2>Tạo đơn hàng mới</h2>
    <c:if test="${not empty error}">
        <div style="color:red;">${error}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/order/create" method="post">
        <table>
            <tr><th>Ngày đặt</th><td><input type="date" name="orderDate" required /></td></tr>
            <tr><th>Trạng thái</th>
                <td>
                    <select name="status" required>
                        <option value="Pending">Pending</option>
                        <option value="Completed">Completed</option>
                        <option value="Cancelled">Cancelled</option>
                    </select>
                </td>
            </tr>
            <tr><th>Khách hàng</th>
                <td>
                    <select name="customerId" required>
                        <option value="">-- Chọn khách hàng --</option>
                        <c:forEach var="c" items="${customers}">
                            <option value="${c.customerId}">
                                ${c.lastName} ${c.middleName} ${c.firstName} (${c.customerId})
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr><th>Người tạo (ID)</th><td><input type="number" name="createdById" required /></td></tr>
            <tr><th>Người bán (ID)</th><td><input type="number" name="saleById" required /></td></tr>
            <tr><th>Cửa hàng</th>
                <td>
                    <select name="storeId" required>
                        <option value="">-- Chọn cửa hàng --</option>
                        <c:forEach var="s" items="${stores}">
                            <option value="${s.storeId}">${s.storeName} (${s.storeId})</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
        </table>
        <h3>Chi tiết sản phẩm</h3>
        <table id="productTable">
            <thead>
            <tr>
                <th>Mã biến thể</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Giảm giá</th>
                <th>Thuế</th>
                <th>Thành tiền</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>
                    <select name="productVariantId" required onchange="fillProductDetails(this)">
                        <option value="">-- Chọn sản phẩm --</option>
                        <c:forEach var="p" items="${products}">
                            <c:forEach var="v" items="${p.variants}">
                                <option value="${v.productVariantId}" 
                                    data-name="${p.productName}"
                                    data-price="${v.price}"
                                    data-code="${v.productCode}">
                                    ${p.productName} - ${v.productCode}
                                </option>
                            </c:forEach>
                        </c:forEach>
                    </select>
                </td>
                <td><input type="text" name="productName" required readonly /></td>
                <td><input type="number" step="0.01" name="price" required readonly /></td>
                <td><input type="number" name="quantity" required /></td>
                <td><input type="number" step="0.01" name="discount" /></td>
                <td><input type="number" step="0.01" name="taxRate" /></td>
                <td><input type="number" step="0.01" name="totalAmount" required /></td>
                <td><input type="text" name="detailStatus" readonly /></td>
                <td><button type="button" onclick="removeRow(this)">Xóa</button></td>
            </tr>
            </tbody>
        </table>
        <button type="button" onclick="addProductRow()">Thêm sản phẩm</button>
        <br>
        <script>
        function addProductRow() {
            var table = document.getElementById('productTable').getElementsByTagName('tbody')[0];
            var newRow = table.rows[0].cloneNode(true);
            // Xóa giá trị các input
            Array.from(newRow.querySelectorAll('input')).forEach(function(input) {
                input.value = '';
            });
            table.appendChild(newRow);
        }
        function removeRow(btn) {
            var table = document.getElementById('productTable').getElementsByTagName('tbody')[0];
            if (table.rows.length > 1) {
                btn.closest('tr').remove();
            } else {
                alert('Phải có ít nhất một sản phẩm!');
            }
        }

        function fillProductDetails(select) {
            var row = select.closest('tr');
            var option = select.options[select.selectedIndex];
            
            // Điền thông tin sản phẩm
            row.querySelector('input[name="productName"]').value = option.dataset.name || '';
            row.querySelector('input[name="price"]').value = option.dataset.price || '';
            
            // Reset các trường còn lại
            row.querySelector('input[name="quantity"]').value = '';
            row.querySelector('input[name="discount"]').value = '';
            row.querySelector('input[name="taxRate"]').value = '';
            row.querySelector('input[name="totalAmount"]').value = '';
            row.querySelector('input[name="detailStatus"]').value = 'Active';
            
            // Thêm sự kiện tính tổng tiền khi thay đổi số lượng hoặc giảm giá
            var quantityInput = row.querySelector('input[name="quantity"]');
            var discountInput = row.querySelector('input[name="discount"]');
            var taxRateInput = row.querySelector('input[name="taxRate"]');
            var totalInput = row.querySelector('input[name="totalAmount"]');
            
            function calculateTotal() {
                var price = parseFloat(row.querySelector('input[name="price"]').value) || 0;
                var quantity = parseInt(quantityInput.value) || 0;
                var discount = parseFloat(discountInput.value) || 0;
                var taxRate = parseFloat(taxRateInput.value) || 0;
                
                var subtotal = price * quantity;
                var discountAmount = subtotal * (discount / 100);
                var taxAmount = (subtotal - discountAmount) * (taxRate / 100);
                var total = subtotal - discountAmount + taxAmount;
                
                totalInput.value = total.toFixed(2);
            }
            
            quantityInput.oninput = calculateTotal;
            discountInput.oninput = calculateTotal;
            taxRateInput.oninput = calculateTotal;
        }
        </script>
        <button type="submit">Tạo đơn hàng</button>
        <a href="${pageContext.request.contextPath}/orders">Quay lại danh sách đơn hàng</a>
    </form>
</body>
</html>
