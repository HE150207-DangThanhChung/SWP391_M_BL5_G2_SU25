
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo đơn hàng mới</title>
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
        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #4a5568;
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
                    <i class="bi bi-plus-circle me-2"></i>Tạo đơn hàng mới
                </h5>
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary btn-sm btn-icon">
                    <i class="bi bi-arrow-left"></i>
                    Quay lại danh sách
                </a>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-triangle me-2"></i>${error}
                    </div>
                </c:if>
                <form action="${pageContext.request.contextPath}/order/create" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Ngày đặt</label>
                                <input type="date" name="orderDate" class="form-control" required />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select" required>
                                    <option value="Pending">Đang xử lý</option>
                                    <option value="Completed">Đã hoàn thành</option>
                                    <option value="Cancelled">Đã hủy</option>
                                </select>
                            </div>
                        </div>
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
            <tr><th>Người tạo</th>
                <td>
                    <c:choose>
                        <c:when test="${not empty sessionScope.employeeId}">
                            <input type="hidden" name="createdById" value="${sessionScope.employeeId}" />
                            <input type="text" value="${sessionScope.employeeName}" readonly />
                        </c:when>
                        <c:otherwise>
                            <select name="createdById" required>
                                <option value="">-- Chọn người tạo --</option>
                                <c:forEach var="e" items="${employees}">
                                    <c:if test="${e.roleId == 2}">
                                        <option value="${e.employeeId}">
                                            ${e.lastName} ${e.middleName} ${e.firstName} (${e.employeeId})
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr><th>Người bán</th>
                <td>
                    <select name="saleById" required>
                        <option value="">-- Chọn người bán --</option>
                        <c:forEach var="e" items="${employees}">
                            <c:if test="${e.roleId == 3}">
                                <option value="${e.employeeId}">
                                    ${e.lastName} ${e.middleName} ${e.firstName} (${e.employeeId})
                                </option>
                            </c:if>
                        </c:forEach>
                    </select>
                </td>
            </tr>
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
        <div class="card mt-4">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title">
                        <i class="bi bi-cart me-2"></i>Chi tiết sản phẩm
                    </h5>
                    <button type="button" class="btn btn-primary btn-sm btn-icon" onclick="addProductRow()">
                        <i class="bi bi-plus-lg"></i>
                        Thêm sản phẩm
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="productTable" class="table table-bordered table-hover align-middle">
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
                                <th style="width: 80px;">Thao tác</th>
                            </tr>
                        </thead>
            <tbody>
            <tr>
                <td>
                    <select name="productVariantId" class="form-select form-select-sm" required onchange="fillProductDetails(this)">
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
                <td><input type="text" class="form-control form-control-sm" name="productName" required readonly /></td>
                <td>
                    <input type="hidden" name="price" />
                    <input type="text" class="form-control form-control-sm" readonly />
                </td>
                <td><input type="number" class="form-control form-control-sm" name="quantity" required /></td>
                <td><input type="number" class="form-control form-control-sm" step="0.01" name="discount" /></td>
                <td><input type="number" class="form-control form-control-sm" step="0.01" name="taxRate" /></td>
                <td><input type="number" class="form-control form-control-sm" step="0.01" name="totalAmount" required readonly /></td>
                <td>
                    <input type="hidden" name="detailStatus" value="Completed" />
                    <input type="text" class="form-control form-control-sm" readonly />
                </td>
                <td>
                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeRow(this)">
                        <i class="bi bi-trash"></i>
                    </button>
                </td>
            </tr>
            </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="d-flex gap-2 justify-content-end mt-4">
            <button type="submit" class="btn btn-primary btn-icon">
                <i class="bi bi-check-lg"></i> Tạo đơn hàng
            </button>
        </div>
    </form>
</div>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
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

            function formatCurrency(amount) {
                return new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND',
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 0
                }).format(amount);
            }

            function fillProductDetails(select) {
            var row = select.closest('tr');
            var option = select.options[select.selectedIndex];
            
            // Điền thông tin sản phẩm
            row.querySelector('input[name="productName"]').value = option.dataset.name || '';
            var price = option.dataset.price || 0;
            row.querySelector('input[name="price"]').value = price;
            row.querySelector('input[name="price"]').nextElementSibling.value = formatCurrency(price);            // Reset các trường còn lại
            row.querySelector('input[name="quantity"]').value = '';
            row.querySelector('input[name="discount"]').value = '';
            row.querySelector('input[name="taxRate"]').value = '';
            row.querySelector('input[name="totalAmount"]').value = '';
            // Cập nhật trạng thái
            var hiddenStatus = row.querySelector('input[name="detailStatus"]');
            var displayStatus = hiddenStatus.nextElementSibling;
            hiddenStatus.value = 'Completed';
            displayStatus.value = 'Đã hoàn thành';
            
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
