<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.gson.Gson" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh sách sản phẩm</title>
    <style>
        html, body {
            height: 100%;
        }
        body {
            font-family: "Inter", sans-serif;
            background-color: #f9fafb;
            color: #374151;
            margin: 0;
            padding: 0;
        }
        .layout-wrapper {
            display: flex;
            min-height: 100vh;
        }
        .main-panel {
            flex: 1 1 auto;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .content {
            width: 100%;
            margin: 0;
            padding-left: 10px;
            padding-top: 0;
            display: flex;
            flex-direction: column;
            flex: 1 1 auto;
        }
        .main-panel > .footer,
        .main-panel > footer.footer {
            margin-top: auto;
        }
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
        .filter-row {
            display: flex;
            gap: 5px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-row .form-select-sm, .filter-row .form-control-sm {
            width: auto;
            min-width: 120px;
        }
    </style>
</head>
<body>
<div class="layout-wrapper d-flex">
    <jsp:include page="/views/common/sidebar.jsp" />
    <div class="main-panel">
        <jsp:include page="/views/common/header.jsp" />
        <main class="content">
            <div class="container mt-4">
                <!-- Page Title -->
                <h2 class="mb-4">Danh sách sản phẩm</h2>

                <!-- Search & Filters -->
                <div class="filter-row mb-3">
                    <a href="${pageContext.request.contextPath}/product/add" class="btn btn-success btn-sm">Thêm</a>
                    <input type="text" class="form-control form-control-sm search-bar" id="searchInput" placeholder="Tìm kiếm..." />
                    <select class="form-select form-select-sm" id="categoryFilter">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}">${category.categoryName}</option>
                        </c:forEach>
                    </select>
                    <select class="form-select form-select-sm" id="brandFilter">
                        <option value="">Tất cả thương hiệu</option>
                        <c:forEach var="brand" items="${brands}">
                            <option value="${brand.brandId}">${brand.brandName}</option>
                        </c:forEach>
                    </select>
                    <select class="form-select form-select-sm" id="statusFilter">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                    <input type="number" class="form-control form-control-sm" id="minPrice" placeholder="Giá min">
                    <input type="number" class="form-control form-control-sm" id="maxPrice" placeholder="Giá max">
                    <select class="form-select form-select-sm" id="sortBy">
                        <option value="">Sắp xếp</option>
                        <option value="name">Tên</option>
                        <option value="price">Giá</option>
                    </select>
                    <select class="form-select form-select-sm" id="sortOrder">
                        <option value="asc">Tăng</option>
                        <option value="desc">Giảm</option>
                    </select>
                    <button class="btn btn-primary btn-sm" id="applyFilters">Áp dụng</button>
                    <button class="btn btn-secondary btn-sm" id="resetFilters">Đặt lại</button>
                </div>

                <!-- Data Table -->
                <div class="table-responsive">
                    <table class="table table-bordered table-hover text-center align-middle" id="productTable">
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
                        <tbody id="productTableBody">
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
                    <div>Tổng có <strong id="totalCount">${fn:length(products)}</strong> dữ liệu</div>
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
        </main>
        <jsp:include page="/views/common/footer.jsp" />
    </div>
</div>
</body>
</html>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // Search functionality
        $("#searchInput").on("keyup", function() {
            let searchTerm = $(this).val().toLowerCase();
            $("#productTableBody tr").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(searchTerm) > -1);
            });
        });

        // Filter and sort with AJAX
        $("#applyFilters").on("click", function() {
            console.log("Apply Filters clicked"); // Debug log
            let categoryId = $("#categoryFilter").val();
            let brandId = $("#brandFilter").val();
            let status = $("#statusFilter").val();
            let minPrice = $("#minPrice").val() || "";
            let maxPrice = $("#maxPrice").val() || "";
            let sortBy = $("#sortBy").val();
            let sortOrder = $("#sortOrder").val();

            $.ajax({
                url: "${pageContext.request.contextPath}/product/filter",
                type: "GET",
                dataType: "json", // Explicitly specify JSON response
                data: {
                    categoryId: categoryId,
                    brandId: brandId,
                    status: status,
                    minPrice: minPrice,
                    maxPrice: maxPrice,
                    sortBy: sortBy,
                    sortOrder: sortOrder
                },
                success: function(data) {
                    console.log("AJAX Success - Raw Data:", data); // Detailed debug log
                    let tableBody = $("#productTableBody");
                    tableBody.empty();
                    if (data === false || data === null || (typeof data === 'object' && Object.keys(data).length === 0)) {
                        console.error("Invalid or empty response:", data);
                        tableBody.append('<tr><td colspan="10">No data or invalid response</td></tr>');
                    } else if (Array.isArray(data)) {
                        data.forEach(product => {
                            let minPrice = product.variants && product.variants.length > 0 ? product.variants[0].price : 0;
                            let maxPrice = product.variants && product.variants.length > 0 ? product.variants[0].price : 0;
                            if (product.variants) {
                                product.variants.forEach(variant => {
                                    if (variant.price < minPrice) minPrice = variant.price;
                                    if (variant.price > maxPrice) maxPrice = variant.price;
                                });
                            }
                            let imageSrc = product.variants && product.variants.length > 0 && product.variants[0].images.length > 0 
                                ? "${pageContext.request.contextPath}/" + product.variants[0].images[0].src 
                                : "";
                            // Format prices with commas using toLocaleString
                            let formattedMinPrice = minPrice.toLocaleString('vi-VN');
                            let formattedMaxPrice = maxPrice.toLocaleString('vi-VN');
                            tableBody.append(`
                                <tr>
                                    <td>\${product.productId !== undefined ? product.productId : 'N/A'}</td>
                                    <td>
                                        <img src="\${imageSrc}" alt="\${product.productName || 'No Name'}" class="product-img" \${imageSrc ? '' : 'style="display:none;"'}>
                                        <span class="text-muted" \${imageSrc ? 'style="display:none;"' : ''}>No image</span>
                                    </td>
                                    <td><a href="${pageContext.request.contextPath}/product/detail?productId=\${product.productId !== undefined ? product.productId : ''}">\${product.productName || 'No Name'}</a></td>
                                    <td>\${product.brandName !== undefined ? product.brandName : 'N/A'}</td>
                                    <td>\${product.categoryName !== undefined ? product.categoryName : 'N/A'}</td>
                                    <td>\${product.supplierName !== undefined ? product.supplierName : 'N/A'}</td>
                                    <td>\${product.variants ? product.variants.length : 0}</td>
                                    <td>\${formattedMinPrice} - \${formattedMaxPrice}</td>
                                    <td><span class="badge \${product.status == 'Active' ? 'bg-success' : 'bg-danger'}">\${product.status || 'N/A'}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/product/edit?productId=\${product.productId !== undefined ? product.productId : ''}" class="btn btn-sm btn-warning">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/product/delete?productId=\${product.productId !== undefined ? product.productId : ''}" class="btn btn-sm btn-danger">Xóa</a>
                                    </td>
                                </tr>
                            `);
                        });
                        $("#totalCount").text(data.length);
                    } else {
                        console.error("Unexpected data format:", data);
                        tableBody.append('<tr><td colspan="10">Unexpected data format</td></tr>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX Error", status, error, xhr.responseText); // Debug log with response
                    $("#productTableBody").html('<tr><td colspan="10">Error loading data</td></tr>');
                }
            });
        });

        // Reset filters
        $("#resetFilters").on("click", function() {
            console.log("Reset Filters clicked"); // Debug log
            $("#categoryFilter").val("");
            $("#brandFilter").val("");
            $("#statusFilter").val("");
            $("#minPrice").val("");
            $("#maxPrice").val("");
            $("#sortBy").val("");
            $("#sortOrder").val("asc");

            $.ajax({
                url: "${pageContext.request.contextPath}/product/",
                type: "GET",
                dataType: "json", // Expect JSON response
                success: function(data) {
                    console.log("Reset AJAX Success", data); // Debug log
                    let tableBody = $("#productTableBody");
                    tableBody.empty();
                    if (data === false || data === null || (typeof data === 'object' && Object.keys(data).length === 0)) {
                        console.error("Invalid or empty response on reset:", data);
                        tableBody.append('<tr><td colspan="10">No data or invalid response</td></tr>');
                    } else if (Array.isArray(data)) {
                        data.forEach(product => {
                            let minPrice = product.variants && product.variants.length > 0 ? product.variants[0].price : 0;
                            let maxPrice = product.variants && product.variants.length > 0 ? product.variants[0].price : 0;
                            if (product.variants) {
                                product.variants.forEach(variant => {
                                    if (variant.price < minPrice) minPrice = variant.price;
                                    if (variant.price > maxPrice) maxPrice = variant.price;
                                });
                            }
                            let imageSrc = product.variants && product.variants.length > 0 && product.variants[0].images.length > 0 
                                ? "${pageContext.request.contextPath}/" + product.variants[0].images[0].src 
                                : "";
                            // Format prices with commas using toLocaleString
                            let formattedMinPrice = minPrice.toLocaleString('vi-VN');
                            let formattedMaxPrice = maxPrice.toLocaleString('vi-VN');
                            tableBody.append(`
                                <tr>
                                    <td>\${product.productId !== undefined ? product.productId : 'N/A'}</td>
                                    <td>
                                        <img src="\${imageSrc}" alt="\${product.productName || 'No Name'}" class="product-img" \${imageSrc ? '' : 'style="display:none;"'}>
                                        <span class="text-muted" \${imageSrc ? 'style="display:none;"' : ''}>No image</span>
                                    </td>
                                    <td><a href="${pageContext.request.contextPath}/product/detail?productId=\${product.productId !== undefined ? product.productId : ''}">\${product.productName || 'No Name'}</a></td>
                                    <td>\${product.brandName !== undefined ? product.brandName : 'N/A'}</td>
                                    <td>\${product.categoryName !== undefined ? product.categoryName : 'N/A'}</td>
                                    <td>\${product.supplierName !== undefined ? product.supplierName : 'N/A'}</td>
                                    <td>\${product.variants ? product.variants.length : 0}</td>
                                    <td>\${formattedMinPrice} - \${formattedMaxPrice}</td>
                                    <td><span class="badge \${product.status == 'Active' ? 'bg-success' : 'bg-danger'}">\${product.status || 'N/A'}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/product/edit?productId=\${product.productId !== undefined ? product.productId : ''}" class="btn btn-sm btn-warning">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/product/delete?productId=\${product.productId !== undefined ? product.productId : ''}" class="btn btn-sm btn-danger">Xóa</a>
                                    </td>
                                </tr>
                            `);
                        });
                        $("#totalCount").text(data.length);
                    } else {
                        console.error("Unexpected data format on reset:", data);
                        tableBody.append('<tr><td colspan="10">Unexpected data format</td></tr>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Reset AJAX Error", status, error, xhr.responseText); // Debug log with response
                    $("#productTableBody").html('<tr><td colspan="10">Error loading data</td></tr>');
                }
            });
        });
    });
</script>