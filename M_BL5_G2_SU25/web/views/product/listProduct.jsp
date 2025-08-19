<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        .error-border {
            border: 2px solid red !important;
        }
        .error-message {
            color: red;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
        }
        .alert {
            margin-top: 1rem;
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

                <!-- Error Display -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

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
                    <div class="position-relative">
                        <input type="number" step="0.01" class="form-control form-control-sm" id="minPrice" placeholder="Giá min">
                        <div class="error-message">Giá tối thiểu phải lớn hơn hoặc bằng 0</div>
                    </div>
                    <div class="position-relative">
                        <input type="number" step="0.01" class="form-control form-control-sm" id="maxPrice" placeholder="Giá max">
                        <div class="error-message">Giá tối đa phải lớn hơn hoặc bằng 0</div>
                    </div>
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
                                            <c:set var="minPrice" value="${product.variants[0].price}" />
                                            <c:set var="maxPrice" value="${product.variants[0].price}" />
                                            <c:forEach var="variant" items="${product.variants}">
                                                <c:if test="${variant.price < minPrice}"><c:set var="minPrice" value="${variant.price}" /></c:if>
                                                <c:if test="${variant.price > maxPrice}"><c:set var="maxPrice" value="${variant.price}" /></c:if>
                                            </c:forEach>
                                            <fmt:setLocale value="vi_VN" />
                                            <fmt:formatNumber value="${minPrice}" type="number" groupingUsed="true" minFractionDigits="0" maxFractionDigits="2" /> - 
                                            <fmt:formatNumber value="${maxPrice}" type="number" groupingUsed="true" minFractionDigits="0" maxFractionDigits="2" />
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
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=1">&laquo;</a>
                            </li>
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}">&lt;</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="page">
                                <li class="page-item ${page == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${page}">${page}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}">&gt;</a>
                            </li>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${totalPages}">&raquo;</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </main>
        <jsp:include page="/views/common/footer.jsp" />
    </div>
</div>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // Validate price inputs on input
        $("#minPrice, #maxPrice").on("input blur", function() {
            const input = $(this);
            const value = parseFloat(input.val());
            const errorMessage = input.next(".error-message");
            if (value < 0) {
                input.addClass("error-border");
                errorMessage.show();
            } else {
                input.removeClass("error-border");
                errorMessage.hide();
            }
        });

        // Search functionality (client-side)
        $("#searchInput").on("keyup", function() {
            let searchTerm = $(this).val().toLowerCase();
            $("#productTableBody tr").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(searchTerm) > -1);
            });
        });

        // Apply filters with AJAX
        $("#applyFilters").on("click", function() {
            // Validate price inputs
            let minPriceInput = $("#minPrice");
            let maxPriceInput = $("#maxPrice");
            let minPrice = minPriceInput.val() ? parseFloat(minPriceInput.val()) : "";
            let maxPrice = maxPriceInput.val() ? parseFloat(maxPriceInput.val()) : "";

            if (minPrice < 0 || maxPrice < 0) {
                alert("Giá tối thiểu và tối đa không được âm!");
                if (minPrice < 0) {
                    minPriceInput.addClass("error-border").next(".error-message").show();
                }
                if (maxPrice < 0) {
                    maxPriceInput.addClass("error-border").next(".error-message").show();
                }
                return;
            }

            let categoryId = $("#categoryFilter").val();
            let brandId = $("#brandFilter").val();
            let status = $("#statusFilter").val();
            let sortBy = $("#sortBy").val();
            let sortOrder = $("#sortOrder").val();

            $.ajax({
                url: "${pageContext.request.contextPath}/product/filter",
                type: "GET",
                dataType: "json",
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
                    console.log("AJAX Success - Raw Data:", data);
                    let tableBody = $("#productTableBody");
                    tableBody.empty();
                    if (data.error) {
                        alert(data.error);
                        tableBody.append('<tr><td colspan="10">' + data.error + '</td></tr>');
                    } else if (!data || !Array.isArray(data) || data.length === 0) {
                        tableBody.append('<tr><td colspan="10">Không có sản phẩm nào phù hợp</td></tr>');
                    } else {
                        data.forEach(product => {
                            let minPrice = product.variants && product.variants.length > 0 ? product.variants[0].price : 0;
                            let maxPrice = product.variants && product.variants.length > 0 ? product.variants[0].price : 0;
                            if (product.variants) {
                                product.variants.forEach(variant => {
                                    if (variant.price < minPrice) minPrice = variant.price;
                                    if (variant.price > maxPrice) maxPrice = variant.price;
                                });
                            }
                            let imageSrc = product.variants && product.variants.length > 0 && product.variants[0].images && product.variants[0].images.length > 0 
                                ? "${pageContext.request.contextPath}/" + product.variants[0].images[0].src 
                                : "";
                            let formattedMinPrice = minPrice.toLocaleString('vi-VN');
                            let formattedMaxPrice = maxPrice.toLocaleString('vi-VN');
                            tableBody.append(`
                                <tr>
                                    <td>\${product.productId != undefined ? product.productId : 'N/A'}</td>
                                    <td>
                                        <img src="${imageSrc}" alt="\${product.productName || 'No Name'}" class="product-img" ${imageSrc ? '' : 'style="display:none;"'}>
                                        <span class="text-muted" ${imageSrc ? 'style="display:none;"' : ''}>No image</span>
                                    </td>
                                    <td><a href="${pageContext.request.contextPath}/product/detail?productId=\${product.productId != undefined ? product.productId : ''}">\${product.productName || 'No Name'}</a></td>
                                    <td>\${product.brandName != undefined ? product.brandName : 'N/A'}</td>
                                    <td>\${product.categoryName != undefined ? product.categoryName : 'N/A'}</td>
                                    <td>\${product.supplierName != undefined ? product.supplierName : 'N/A'}</td>
                                    <td>\${product.variants ? product.variants.length : 0}</td>
                                    <td>\${formattedMinPrice} - \${formattedMaxPrice}</td>
                                    <td><span class="badge \${product.status == 'Active' ? 'bg-success' : 'bg-danger'}">\${product.status || 'N/A'}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/product/edit?productId=\${product.productId != undefined ? product.productId : ''}" class="btn btn-sm btn-warning">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/product/delete?productId=\${product.productId != undefined ? product.productId : ''}" class="btn btn-sm btn-danger">Xóa</a>
                                    </td>
                                </tr>
                            `);
                        });
                        $("#totalCount").text(data.length);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX Error", status, error, xhr.responseText);
                    let errorMessage = "Lỗi khi tải dữ liệu";
                    try {
                        let responseJson = JSON.parse(xhr.responseText);
                        if (responseJson.error) {
                            errorMessage = responseJson.error;
                        }
                    } catch (e) {
                        // Not JSON, use default message
                    }
                    $("#productTableBody").html(`<tr><td colspan="10">${errorMessage}</td></tr>`);
                    alert(errorMessage);
                }
            });
        });

        // Reset filters
        $("#resetFilters").on("click", function() {
            console.log("Reset Filters clicked");
            $("#categoryFilter").val("");
            $("#brandFilter").val("");
            $("#statusFilter").val("");
            $("#minPrice").val("").removeClass("error-border").next(".error-message").hide();
            $("#maxPrice").val("").removeClass("error-border").next(".error-message").hide();
            $("#sortBy").val("");
            $("#sortOrder").val("asc");

            $.ajax({
                url: "${pageContext.request.contextPath}/product/",
                type: "GET",
                dataType: "json",
                success: function(data) {
                    console.log("Reset AJAX Success", data);
                    let tableBody = $("#productTableBody");
                    tableBody.empty();
                    if (data.error) {
                        alert(data.error);
                        tableBody.append('<tr><td colspan="10">' + data.error + '</td></tr>');
                    } else if (!data || !Array.isArray(data) || data.length === 0) {
                        tableBody.append('<tr><td colspan="10">Không có sản phẩm nào</td></tr>');
                    } else {
                        data.forEach(product => {
                            let minPrice = product.variants && product.variants.length > 0 ? product.variants[0].price : 0;
                            let maxPrice = product.variants && product.variants.length > 0 ? product.variants[0].price : 0;
                            if (product.variants) {
                                product.variants.forEach(variant => {
                                    if (variant.price < minPrice) minPrice = variant.price;
                                    if (variant.price > maxPrice) maxPrice = variant.price;
                                });
                            }
                            let imageSrc = product.variants && product.variants.length > 0 && product.variants[0].images && product.variants[0].images.length > 0 
                                ? "${pageContext.request.contextPath}/" + product.variants[0].images[0].src 
                                : "";
                            let formattedMinPrice = minPrice.toLocaleString('vi-VN');
                            let formattedMaxPrice = maxPrice.toLocaleString('vi-VN');
                            tableBody.append(`
                                <tr>
                                    <td>\${product.productId != undefined ? product.productId : 'N/A'}</td>
                                    <td>
                                        <img src="${imageSrc}" alt="\${product.productName || 'No Name'}" class="product-img" ${imageSrc ? '' : 'style="display:none;"'}>
                                        <span class="text-muted" ${imageSrc ? 'style="display:none;"' : ''}>No image</span>
                                    </td>
                                    <td><a href="\${pageContext.request.contextPath}/product/detail?productId=\${product.productId != undefined ? product.productId : ''}">\${product.productName || 'No Name'}</a></td>
                                    <td>\${product.brandName != undefined ? product.brandName : 'N/A'}</td>
                                    <td>\${product.categoryName != undefined ? product.categoryName : 'N/A'}</td>
                                    <td>\${product.supplierName != undefined ? product.supplierName : 'N/A'}</td>
                                    <td>\${product.variants ? product.variants.length : 0}</td>
                                    <td>\${formattedMinPrice} - \${formattedMaxPrice}</td>
                                    <td><span class="badge \${product.status == 'Active' ? 'bg-success' : 'bg-danger'}">\${product.status || 'N/A'}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/product/edit?productId=\${product.productId != undefined ? product.productId : ''}" class="btn btn-sm btn-warning">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/product/delete?productId=\${product.productId != undefined ? product.productId : ''}" class="btn btn-sm btn-danger">Xóa</a>
                                    </td>
                                </tr>
                            `);
                        });
                        $("#totalCount").text(data.length);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Reset AJAX Error", status, error, xhr.responseText);
                    let errorMessage = "Lỗi khi tải dữ liệu";
                    try {
                        let responseJson = JSON.parse(xhr.responseText);
                        if (responseJson.error) {
                            errorMessage = responseJson.error;
                        }
                    } catch (e) {
                        // Not JSON, use default message
                    }
                    $("#productTableBody").html(`<tr><td colspan="10">${errorMessage}</td></tr>`);
                    alert(errorMessage);
                }
            });
        });

        // Add delete confirmation
        $("#productTableBody").on("click", ".btn-danger", function(e) {
            if (!confirm("Bạn có chắc muốn xóa sản phẩm này?")) {
                e.preventDefault();
            }
        });
    });
</script>
</body></html>
