<%-- 
    Document   : editProduct
    Created on : Aug 13, 2025, 8:49:06 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<div class="container mt-4">
    <h2 class="mb-4">Sửa sản phẩm</h2>
    <form action="${pageContext.request.contextPath}/product/edit" method="post" enctype="multipart/form-data">
        <input type="hidden" name="productId" value="${product.productId}">
        <div class="row">
            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label">Tên sản phẩm</label>
                    <input type="text" class="form-control" name="productName" value="${product.productName}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Danh mục</label>
                    <select class="form-select" name="categoryId" required>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}" ${category.categoryId == product.categoryId ? 'selected' : ''}>${category.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thương hiệu</label>
                    <select class="form-select" name="brandId" required>
                        <c:forEach var="brand" items="${brands}">
                            <option value="${brand.brandId}" ${brand.brandId == product.brandId ? 'selected' : ''}>${brand.brandName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nhà cung cấp</label>
                    <select class="form-select" name="supplierId" required>
                        <c:forEach var="supplier" items="${suppliers}">
                            <option value="${supplier.supplierId}" ${supplier.supplierId == product.supplierId ? 'selected' : ''}>${supplier.supplierName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label">Mã sản phẩm</label>
                    <input type="text" class="form-control" name="productCode" value="${product.productCode}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Giá</label>
                    <input type="number" step="0.01" class="form-control" name="price" value="${product.price}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Bảo hành (tháng)</label>
                    <input type="number" class="form-control" name="warrantyDurationMonth" value="${product.warrantyDurationMonth}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status" required>
                        <option value="Active" ${product.status == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Deactive" ${product.status == 'Deactive' ? 'selected' : ''}>Deactive</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Hình ảnh hiện tại</label>
                    <c:if test="${not empty product.imageUrl}">
                        <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.productName}" class="product-img">
                    </c:if>
                    <small class="form-text text-muted">Để giữ hình cũ, để trống.</small>
                </div>
                <div class="mb-3">
                    <label class="form-label">Upload hình mới</label>
                    <input type="file" class="form-control" name="image">
                </div>
                <div class="mb-3">
                    <label class="form-label">Hoặc URL hình mới</label>
                    <input type="url" class="form-control" name="imageUrl">
                </div>
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
        <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary">Hủy</a>
    </form>
</div>
