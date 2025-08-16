<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    .table-hover tbody tr:hover {
        background-color: #f8f9fa;
    }
    .search-bar {
        flex: 1;
        min-width: 200px;
    }
    .table td a {
        text-decoration: none;
        color: #0d6efd;
    }
    .table td a:hover {
        text-decoration: underline;
    }
    .product-img {
        width: 60px;
        height: 60px;
        object-fit: cover;
        border-radius: 4px;
    }
</style>

<div class="container mt-4">
    <!-- Page Title -->
    <h2 class="mb-4">Danh sách sản phẩm</h2>

    <!-- Search & Filters -->
    <div class="d-flex flex-wrap mb-3 align-items-center gap-2">
        <a href="${pageContext.request.contextPath}/product/add" class="btn btn-success">Thêm sản phẩm</a>
        <input type="text" class="form-control search-bar" placeholder="Tìm kiếm theo tên, thương hiệu, danh mục..." />
        <button class="btn btn-primary"><i class="bi bi-search"></i> Tìm kiếm</button>
        <button class="btn btn-info">Filter 1</button>
        <button class="btn btn-info">Filter 2</button>
        <button class="btn btn-info">Filter 3</button>
        <button class="btn btn-warning">Lọc</button>
        <button class="btn btn-secondary">Reset</button>
        <button class="btn btn-success">Action 1</button>
        <button class="btn btn-success">Action 2</button>
    </div>

    <!-- Data Table -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover text-center align-middle">
            <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Hình ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Thương hiệu</th>
                    <th>Danh mục</th>
                    <th>Nhà cung cấp</th>
                    <th>Số biến thể</th>
                    <th>Giá (Khoảng)</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.productId}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty product.variants and not empty product.variants[0].images and not empty product.variants[0].images[0].src}">
                                    <img src="${pageContext.request.contextPath}/${product.variants[0].images[0].src}" alt="${product.productName}" class="product-img">
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">No image</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/product/detail?productId=${product.productId}">
                                ${product.productName}
                            </a>
                        </td>
                        <td>${product.brandName}</td>
                        <td>${product.categoryName}</td>
                        <td>${product.supplierName}</td>
                        <td>${product.variants != null ? product.variants.size() : 0}</td>
                        <td>
                            <c:if test="${not empty product.variants}">
                                ${minPrice = product.variants[0].price}
                                ${maxPrice = product.variants[0].price}
                                <c:forEach var="variant" items="${product.variants}">
                                    <c:if test="${variant.price < minPrice}">${minPrice = variant.price}</c:if>
                                    <c:if test="${variant.price > maxPrice}">${maxPrice = variant.price}</c:if>
                                </c:forEach>
                                ${minPrice} - ${maxPrice}
                            </c:if>
                        </td>
                        <td>
                            <span class="badge ${product.status == 'Active' ? 'bg-success' : 'bg-danger'}">
                                ${product.status}
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/product/edit?productId=${product.productId}" 
                               class="btn btn-sm btn-warning">Sửa</a>
                            <a href="${pageContext.request.contextPath}/product/delete?productId=${product.productId}" 
                               class="btn btn-sm btn-danger">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Footer & Pagination -->
    <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap gap-2">
        <div>Tổng có <strong>${totalCount}</strong> dữ liệu</div>
        <div>Hiển thị <strong>${pageSize}</strong> mỗi trang</div>
        <nav>
            <ul class="pagination pagination-sm mb-0">
                <li class="page-item"><a class="page-link" href="#">&laquo;</a></li>
                <li class="page-item"><a class="page-link" href="#">&lt;</a></li>
                <c:forEach begin="1" end="${totalPages}" var="page">
                    <li class="page-item ${page == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${page}">${page}</a>
                    </li>
                </c:forEach>
                <li class="page-item"><a class="page-link" href="#">&gt;</a></li>
                <li class="page-item"><a class="page-link" href="#">&raquo;</a></li>
            </ul>
        </nav>
    </div>
</div>