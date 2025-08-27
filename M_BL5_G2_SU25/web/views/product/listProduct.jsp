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
        .pagination {
            justify-content: flex-end;
        }
        .footer-info {
            display: flex;
            gap: 20px;
            align-items: center;
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
                        <option value="Active">Hoạt động</option>
                        <option value="Inactive">Không hoạt động</option>
                    </select>
                    <div class="position-relative">
                        <input type="number" step="0.01" class="form-control form-control-sm" id="minPrice" placeholder="Giá thấp nhất">
                        <div class="error-message">Giá tối thiểu phải lớn hơn hoặc bằng 0</div>
                    </div>
                    <div class="position-relative">
                        <input type="number" step="0.01" class="form-control form-control-sm" id="maxPrice" placeholder="Giá cao nhất">
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
                    <select class="form-select form-select-sm" id="pageSize">
                        <option value="10">10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
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
                            <!-- Data will be populated via JS -->
                        </tbody>
                    </table>
                </div>

                <!-- Footer & Pagination -->
                <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap gap-2">
                    <div class="footer-info">
                        <div>Tổng có <strong id="totalCount">0</strong> dữ liệu</div>
                        <div>Hiển thị <strong id="pageSizeDisplay">10</strong> mỗi trang</div>
                    </div>
                    <nav id="paginationNav">
                        <ul class="pagination pagination-sm mb-0">
                            <!-- Pagination links will be generated here -->
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
        let currentData = [];
        let currentPage = 1;
        let pageSize = parseInt($("#pageSize").val()) || 10;

        // Update page size display
        function updatePageSizeDisplay() {
            $("#pageSizeDisplay").text(pageSize);
        }

        // Load initial data
        fetchData();

        // Validate price inputs
        $("#minPrice, #maxPrice").on("input blur", function() {
            const input = $(this);
            const value = parseFloat(input.val());
            const errorMessage = input.next(".error-message");
            if (value < 0 || isNaN(value)) {
                input.addClass("error-border");
                errorMessage.show();
            } else {
                input.removeClass("error-border");
                errorMessage.hide();
            }
        });

        // Page size change handler
        $("#pageSize").on("change", function() {
            pageSize = parseInt($(this).val()) || 10;
            currentPage = 1;
            updatePageSizeDisplay();
            renderPage(currentData, currentPage);
            generatePagination(currentData.length, currentPage);
        });

        // Search functionality (server-side)
        $("#searchInput").on("keyup", function() {
            let searchTerm = $(this).val().trim();
            let categoryId = $("#categoryFilter").val();
            let brandId = $("#brandFilter").val();
            let status = $("#statusFilter").val();
            let minPrice = $("#minPrice").val() ? parseFloat($("#minPrice").val()) : "";
            let maxPrice = $("#maxPrice").val() ? parseFloat($("#maxPrice").val()) : "";
            let sortBy = $("#sortBy").val();
            let sortOrder = $("#sortOrder").val();
            fetchData(categoryId, brandId, status, minPrice, maxPrice, sortBy, sortOrder, searchTerm);
        });

        // Apply filters
        $("#applyFilters").on("click", function() {
            let minPriceInput = $("#minPrice");
            let maxPriceInput = $("#maxPrice");
            let minPrice = minPriceInput.val() ? parseFloat(minPriceInput.val()) : "";
            let maxPrice = maxPriceInput.val() ? parseFloat(maxPriceInput.val()) : "";

            if ((minPrice < 0 || isNaN(minPrice)) || (maxPrice < 0 || isNaN(maxPrice))) {
                alert("Giá tối thiểu và tối đa phải là số không âm!");
                if (minPrice < 0 || isNaN(minPrice)) {
                    minPriceInput.addClass("error-border").next(".error-message").show();
                }
                if (maxPrice < 0 || isNaN(maxPrice)) {
                    maxPriceInput.addClass("error-border").next(".error-message").show();
                }
                return;
            }

            let categoryId = $("#categoryFilter").val();
            let brandId = $("#brandFilter").val();
            let status = $("#statusFilter").val();
            let sortBy = $("#sortBy").val();
            let sortOrder = $("#sortOrder").val();
            let searchTerm = $("#searchInput").val().trim();

            fetchData(categoryId, brandId, status, minPrice, maxPrice, sortBy, sortOrder, searchTerm);
        });

        // Reset filters
        $("#resetFilters").on("click", function() {
            $("#categoryFilter").val("");
            $("#brandFilter").val("");
            $("#statusFilter").val("");
            $("#minPrice").val("").removeClass("error-border").next(".error-message").hide();
            $("#maxPrice").val("").removeClass("error-border").next(".error-message").hide();
            $("#sortBy").val("");
            $("#sortOrder").val("asc");
            $("#pageSize").val("10");
            $("#searchInput").val("");
            pageSize = 10;
            currentPage = 1;
            updatePageSizeDisplay();
            fetchData();
        });

        // Delete confirmation and refresh
        $("#productTableBody").on("click", ".btn-danger", function(e) {
            e.preventDefault();
            if (!confirm("Bạn có chắc muốn xóa sản phẩm này?")) {
                return;
            }
            let href = $(this).attr("href");
            $.ajax({
                url: href,
                type: "GET",
                success: function(response) {
                    fetchData(); // Refresh data after deletion
                },
                error: function(xhr) {
                    alert("Lỗi khi xóa sản phẩm: " + (xhr.responseJSON ? xhr.responseJSON.error : "Unknown error"));
                }
            });
        });

        // Pagination click handler
        $("#paginationNav").on("click", ".page-link", function(e) {
            e.preventDefault();
            if ($(this).parent().hasClass('disabled')) return;
            let page = parseInt($(this).data('page'));
            if (isNaN(page)) {
                let totalPages = Math.ceil(currentData.length / pageSize);
                if ($(this).text() === '«') {
                    page = 1;
                } else if ($(this).text() === '»') {
                    page = totalPages;
                } else if ($(this).text() === '<') {
                    page = currentPage - 1;
                } else if ($(this).text() === '>') {
                    page = currentPage + 1;
                }
            }
            currentPage = page;
            renderPage(currentData, currentPage);
            generatePagination(currentData.length, currentPage);
        });

        function fetchData(categoryId = '', brandId = '', status = '', minPrice = '', maxPrice = '', sortBy = '', sortOrder = '', searchTerm = '') {
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
                    sortOrder: sortOrder,
                    searchTerm: searchTerm
                },
                success: function(data) {
                    console.log("AJAX Success - Raw Data:", data);
                    if (data.error) {
                        alert(data.error);
                        $("#productTableBody").html('<tr><td colspan="10">' + data.error + '</td></tr>');
                        $("#totalCount").text(0);
                        $("#paginationNav ul").empty();
                    } else if (!data || !Array.isArray(data) || data.length === 0) {
                        $("#productTableBody").html('<tr><td colspan="10">Không có sản phẩm nào phù hợp</td></tr>');
                        $("#totalCount").text(0);
                        $("#paginationNav ul").empty();
                    } else {
                        currentData = data;
                        currentPage = 1;
                        renderPage(currentData, currentPage);
                        generatePagination(currentData.length, currentPage);
                        $("#totalCount").text(currentData.length);
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
                    $("#productTableBody").html(`<tr><td colspan="10">\${errorMessage}</td></tr>`);
                    $("#totalCount").text(0);
                    $("#paginationNav ul").empty();
                    alert(errorMessage);
                }
            });
        }

        function renderPage(data, page) {
            let tableBody = $("#productTableBody");
            tableBody.empty();
            if (!data || data.length === 0) {
                tableBody.html('<tr><td colspan="10">Không có sản phẩm nào phù hợp</td></tr>');
                return;
            }
            let start = (page - 1) * pageSize;
            let end = Math.min(start + pageSize, data.length);
            let pageData = data.slice(start, end);
            pageData.forEach(product => {
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
                
                // Determine Vietnamese status and badge color
                let statusText = '';
                let badgeClass = '';
                if (product.status === 'Active') {
                    statusText = 'Hoạt động';
                    badgeClass = 'bg-success';
                } else if (product.status === 'Inactive') {
                    statusText = 'Không hoạt động';
                    badgeClass = 'bg-danger';
                } else {
                    statusText = 'N/A';
                    badgeClass = 'bg-secondary';
                }

                tableBody.append(`
                    <tr>
                        <td>\${product.productId != undefined ? product.productId : 'N/A'}</td>
                        <td>
                            <img src="\${imageSrc}" alt="\${product.productName || 'No Name'}" class="product-img" \${imageSrc ? '' : 'style="display:none;"'}>
                            <span class="text-muted" \${imageSrc ? 'style="display:none;"' : ''}>Không có ảnh</span>
                        </td>
                        <td><a href="${pageContext.request.contextPath}/product/detail?productId=\${product.productId != undefined ? product.productId : ''}">\${product.productName || 'No Name'}</a></td>
                        <td>\${product.brandName != undefined ? product.brandName : 'N/A'}</td>
                        <td>\${product.categoryName != undefined ? product.categoryName : 'N/A'}</td>
                        <td>\${product.supplierName != undefined ? product.supplierName : 'N/A'}</td>
                        <td>\${product.variants ? product.variants.length : 0}</td>
                        <td>\${formattedMinPrice} - \${formattedMaxPrice}</td>
                        <td><span class="badge \${badgeClass}">\${statusText}</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/product/edit?productId=\${product.productId != undefined ? product.productId : ''}" class="btn btn-sm btn-warning">Sửa</a>
                        </td>
                    </tr>
                `);
            });
        }

        function generatePagination(totalItems, currentPage) {
            let totalPages = Math.ceil(totalItems / pageSize);
            let pagination = $("#paginationNav ul");
            pagination.empty();
            if (totalItems === 0) return;
            pagination.append(`
                <li class="page-item \${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="#" data-page="1">&laquo;</a>
                </li>
                <li class="page-item \${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="#" data-page="\${currentPage - 1}">&lt;</a>
                </li>
            `);
            let startPage = Math.max(1, currentPage - 2);
            let endPage = Math.min(totalPages, currentPage + 2);
            if (endPage - startPage < 4) {
                if (startPage === 1) {
                    endPage = Math.min(totalPages, startPage + 4);
                } else if (endPage === totalPages) {
                    startPage = Math.max(1, endPage - 4);
                }
            }
            for (let i = startPage; i <= endPage; i++) {
                pagination.append(`
                    <li class="page-item \${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="#" data-page="\${i}">\${i}</a>
                    </li>
                `);
            }
            pagination.append(`
                <li class="page-item \${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="#" data-page="\${currentPage + 1}">&gt;</a>
                </li>
                <li class="page-item \${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="#" data-page="\${totalPages}">&raquo;</a>
                </li>
            `);
        }
    });
</script>
</body>
</html>