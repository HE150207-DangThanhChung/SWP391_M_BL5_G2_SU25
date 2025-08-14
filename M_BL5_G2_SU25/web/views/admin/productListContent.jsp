<%-- 
    Document   : productListContent
    Created on : Aug 15, 2025, 4:10:05 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-4">

    <!-- Search & Filters -->
    <div class="d-flex flex-wrap mb-3 align-items-center gap-2">
        <input type="text" class="form-control w-auto" 
               placeholder="Tìm kiếm theo trường 1, trường 2, trường 3" />
        <button class="btn btn-primary">Tìm kiếm</button>
        <button class="btn btn-info">Filter 1</button>
        <button class="btn btn-info">Filter 2</button>
        <button class="btn btn-info">Filter 3</button>
        <button class="btn btn-warning">Lọc</button>
        <button class="btn btn-secondary">Reset</button>
        <button class="btn btn-success">Action 1</button>
        <button class="btn btn-success">Action 2</button>
    </div>

    <!-- Data Table -->
    <table class="table table-bordered text-center">
        <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Tên sản phẩm</th>
                <th>Thương hiệu</th>
                <th>Danh mục</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="product" items="${products}">
                <tr>
                    <td>${product.productId}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/products/detail?productId=${product.productId}">
                            ${product.productName}
                        </a>
                    </td>
                    <td>${product.brandName}</td>
                    <td>${product.categoryName}</td>
                    <td>${product.price}</td>
                    <td>${product.quantity}</td>
                    <td>${product.status}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/products/edit?productId=${product.productId}" 
                           class="btn btn-sm btn-warning">Sửa</a>
                        <a href="${pageContext.request.contextPath}/admin/products/delete?productId=${product.productId}" 
                           class="btn btn-sm btn-danger">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Footer & Pagination -->
    <div class="d-flex justify-content-between align-items-center mt-2">
        <div>Tổng có ${totalCount} dữ liệu</div>
        <div>Hiển thị ${pageSize} mỗi trang</div>
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

