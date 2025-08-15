<%-- 
    Document   : productDetail
    Created on : Aug 15, 2025, 10:34:14 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<div class="container mt-4">
    <h2 class="mb-4">Chi tiết sản phẩm</h2>
    <c:if test="${product != null}">
        <div class="card shadow-sm">
            <div class="card-body">
                <p><strong>ID:</strong> ${product.productId}</p>
                <p><strong>Tên sản phẩm:</strong> ${product.productName}</p>
                <p><strong>Thương hiệu:</strong> ${product.brandName}</p>
                <p><strong>Danh mục:</strong> ${product.categoryName}</p>
                <p><strong>Mã sản phẩm:</strong> ${product.productCode}</p>
                <p><strong>Giá:</strong> ${product.price}</p>
                <p><strong>Số lượng:</strong> ${product.quantity}</p>
                <p><strong>Trạng thái:</strong> 
                    <span class="badge ${product.status == 'Available' ? 'bg-success' : 'bg-danger'}">
                        ${product.status}
                    </span>
                </p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary mt-3">⬅ Quay lại danh sách</a>
    </c:if>

    <c:if test="${product == null}">
        <div class="alert alert-danger">Không tìm thấy sản phẩm.</div>
        <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary">⬅ Quay lại danh sách</a>
    </c:if>
</div>

