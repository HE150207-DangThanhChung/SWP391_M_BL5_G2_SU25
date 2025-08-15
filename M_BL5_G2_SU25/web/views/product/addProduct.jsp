<%-- 
    Document   : addProduct
    Created on : Aug 13, 2025, 8:48:59 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<div class="container mt-4">
    <h2 class="mb-4">Thêm sản phẩm mới</h2>
    <form action="${pageContext.request.contextPath}/product/add" method="post" enctype="multipart/form-data">
        <div class="row">
            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label">Tên sản phẩm</label>
                    <input type="text" class="form-control" name="productName" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Danh mục</label>
                    <select class="form-select" name="categoryId" required>
                        <option value="">Chọn danh mục</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}">${category.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thương hiệu</label>
                    <select class="form-select" name="brandId" required>
                        <option value="">Chọn thương hiệu</option>
                        <c:forEach var="brand" items="${brands}">
                            <option value="${brand.brandId}">${brand.brandName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nhà cung cấp</label>
                    <select class="form-select" name="supplierId" required>
                        <option value="">Chọn nhà cung cấp</option>
                        <c:forEach var="supplier" items="${suppliers}">
                            <option value="${supplier.supplierId}">${supplier.supplierName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label">Mã sản phẩm</label>
                    <input type="text" class="form-control" name="productCode" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Giá</label>
                    <input type="number" step="0.01" class="form-control" name="price" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Bảo hành (tháng)</label>
                    <input type="number" class="form-control" name="warrantyDurationMonth" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status" required>
                        <option value="Active">Active</option>
                        <option value="Deactive">Deactive</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Hình ảnh (upload)</label>
                    <input type="file" class="form-control" name="image">
                </div>
                <div class="mb-3">
                    <label class="form-label">Hoặc URL hình ảnh</label>
                    <input type="url" class="form-control" name="imageUrl">
                    <small class="form-text text-muted">Để trống nếu upload file.</small>
                </div>
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
        <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary">Hủy</a>
    </form>
</div>
