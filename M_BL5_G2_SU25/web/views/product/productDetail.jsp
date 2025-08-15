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
                <p><strong>Nhà cung cấp:</strong> ${product.supplierName}</p>
                <p><strong>Mã sản phẩm:</strong> ${product.productCode}</p>
                <p><strong>Giá:</strong> ${product.price}</p>
                <p><strong>Bảo hành:</strong> ${product.warrantyDurationMonth} tháng</p>
                <p><strong>Trạng thái:</strong> 
                    <span class="badge ${product.status == 'Active' ? 'bg-success' : 'bg-danger'}">
                        ${product.status}
                    </span>
                </p>
                <p><strong>Hình ảnh:</strong>
                    <c:choose>
                        <c:when test="${not empty product.imageUrl}">
                            <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.productName}" class="product-img" style="width: 150px; height: 150px;">
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted">No image</span>
                        </c:otherwise>
                    </c:choose>
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