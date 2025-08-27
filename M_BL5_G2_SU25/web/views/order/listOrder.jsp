<%-- 
    Document   : listOrder (refined)
    Created on : Aug 13, 2025
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết hoá đơn</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            html, body {
                height: 100%;
            }
            body {
                font-family: "Inter", sans-serif;
                background-color: #f0f0f0;
                color: #374151;
                margin: 0;
                padding: 0;
            }
            .layout-wrapper {
                display: flex;
                min-height: 100vh;
                background-color: #f8f9fa;
            }
            .main-panel {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                padding: 1.5rem;
            }
            .content-wrapper {
                flex: 1;
            }
            .card {
                border: none;
                margin-bottom: 1rem;
            }
            .card-title {
                color: #2d3748;
                font-weight: 600;
            }
            .table th {
                font-weight: 600;
                color: #4a5568;
            }
            .table td {
                padding: 0.75rem;
            }
            .filter-section {
                background: #f8fafc;
                padding: 15px;
                border-radius: 6px;
                margin-bottom: 20px;
            }
            .table {
                background: white;
                border-radius: 8px;
                overflow: hidden;
            }
            .table th {
                background: #f8fafc;
                color: #4a5568;
                font-weight: 600;
                border-bottom: 2px solid #e2e8f0;
            }
            .table td {
                vertical-align: middle;
            }
            .status-dot {
                display: inline-block;
                width: 8px;
                height: 8px;
                border-radius: 50%;
                margin-right: 6px;
            }
            .status-warning { background-color: #fbd38d; }
            .status-success { background-color: #68d391; }
            .status-danger { background-color: #fc8181; }
            .status-text {
                font-weight: 500;
            }
            .pagination {
                margin-top: 1rem;
                justify-content: center;
            }
            .page-link {
                color: #4a5568;
                border: 1px solid #e2e8f0;
            }
            .page-link:hover {
                background-color: #f7fafc;
                color: #2d3748;
            }
            .page-item.active .page-link {
                background-color: #4299e1;
                border-color: #4299e1;
            }
            .filter-group {
                margin-bottom: 1rem;
            }
            .filter-group label {
                font-weight: 500;
                color: #4a5568;
            }
            .form-control {
                border-radius: 6px;
                border: 1px solid #e2e8f0;
            }
            .form-control:focus {
                border-color: #4299e1;
                box-shadow: 0 0 0 2px rgba(66, 153, 225, 0.2);
            }
        </style>
    </head>
    <body>
        <div class="layout-wrapper flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel">
                <jsp:include page="/views/common/header.jsp"/>
                <div class="content-wrapper">

        <div class="container-fluid">
            <div class="row g-3">
                <!-- Sidebar filters -->
                <aside class="col-lg-3">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title mb-3">Trạng thái đơn hàng</h5>
                            <div class="d-flex flex-column gap-2">
                                <div class="form-check">
                                    <input class="form-check-input" name="status" type="radio" id="statusAll" checked>
                                    <label class="form-check-label" for="statusAll">Tất cả</label>
                                </div>
                            <div class="form-check">
                                <input class="form-check-input" name="status" type="radio" id="statusPending">
                                <label class="form-check-label" for="statusPending">Đang xử lý</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" name="status" type="radio" id="statusPaid">
                                <label class="form-check-label" for="statusPaid">Đã thanh toán</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" name="status" type="radio" id="statusCanceled">
                                <label class="form-check-label" for="statusCanceled">Đã huỷ</label>
                            </div>
                        </div>

                            <hr class="my-3">

                            <h5 class="card-title mb-3">Chi nhánh</h5>
                            <select class="form-select form-select-sm" id="branchSelect">
                                <option value="">Tất cả chi nhánh</option>
                                <c:forEach var="s" items="${stores}">
                                    <option value="${s.storeName}">${s.storeName} (${s.storeId})</option>
                                </c:forEach>
                            </select>

                            <hr class="my-3">

                            <h5 class="card-title mb-3">Khoảng giá</h5>
                            <div class="row g-2">
                                <div class="col-6">
                                    <input type="number" class="form-control form-control-sm" placeholder="Từ">
                                </div>
                                <div class="col-6">
                                    <input type="number" class="form-control form-control-sm" placeholder="Đến">
                                </div>
                            </div>

                            <div class="d-grid mt-3">
                                <button class="btn btn-primary btn-sm">
                                    <i class="bi bi-funnel me-1"></i>Áp dụng bộ lọc
                                </button>
                            </div>
                        </div>
                    </div>
                </aside>

                <!-- Main content -->
                <main class="col-lg-9">
                    <!-- Header tools -->
                    <div class="card shadow-sm mb-3">
                        <div class="card-body">
                            <div class="d-flex flex-wrap justify-content-between gap-3">
                                <h4 class="card-title mb-0">Danh sách đơn hàng</h4>
                                <div class="d-flex flex-wrap gap-2">
                                    <div class="input-group" style="width: 300px;">
                                        <span class="input-group-text bg-white border-end-0">
                                            <i class="bi bi-search text-muted"></i>
                                        </span>
                                        <input type="text" class="form-control border-start-0" 
                                               placeholder="Tìm theo tên khách / mã đơn...">
                                    </div>
                                    <button class="btn btn-light" onclick="window.location.href = window.location.href;">
                                        <i class="bi bi-arrow-clockwise me-1"></i>Tải lại
                                    </button>

                            <div class="btn-group">
                                <button class="btn btn-primary" onclick="window.location.href = '${pageContext.request.contextPath}/order/create'"><i class="bi bi-plus-lg me-1"></i>Tạo đơn</button>
<!--                                <button class="btn btn-outline-primary"><i class="bi bi-upload me-1"></i>Nhập</button>
                                <button class="btn btn-outline-primary"><i class="bi bi-download me-1"></i>Xuất</button>-->
                            </div>
                        </div>
                    </div>

                    <!-- Table -->
                    <div class="card shadow-sm">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light">
                                    <tr class="text-nowrap">
                                        <th class="px-3" style="width: 110px;">Mã đơn</th>
                                        <th>Tên khách</th>
                                        <th>Người tạo</th>
                                        <th>Nhân viên bán</th>
                                        <th>Chi nhánh</th>
                                        <th style="width: 140px;">Trạng thái</th>
                                        <th class="text-end" style="width: 100px;">Số lượng</th>
                                        <th class="text-end" style="width: 140px;">Tổng tiền</th>
        
                                        <th class="text-center" style="width: 160px;">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Debug output -->
                                    <c:if test="${not empty orders}">
                                        <tr>
                                            <td colspan="10">
                                                Total orders: ${orders.size()}
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:if test="${empty orders}">
                                        <tr>
                                            <td colspan="10">
                                                No orders found in the request attribute
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td>#ORD-${order.orderId}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.customer != null}">
                                                        ${order.customer.fullName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${order.customerId}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.createdBy != null}">
                                                        ${order.createdBy.fullName}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.saleBy != null}">
                                                        ${order.saleBy.fullName}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.store != null}">
                                                        ${order.store.storeName}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge rounded-pill badge-status
                                                      <c:choose>
                                                          <c:when test="${order.status eq 'Completed'}">text-bg-success</c:when>
                                                          <c:when test="${order.status eq 'Pending'}">text-bg-warning</c:when>
                                                          <c:when test="${order.status eq 'Cancelled'}">text-bg-secondary</c:when>
                                                          <c:otherwise>text-bg-light</c:otherwise>
                                                      </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${order.status eq 'Completed'}"><i class="bi bi-check2-circle me-1"></i>Đã thanh toán</c:when>
                                                        <c:when test="${order.status eq 'Pending'}"><i class="bi bi-hourglass-split me-1"></i>Đang xử lý</c:when>
                                                        <c:when test="${order.status eq 'Cancelled'}"><i class="bi bi-x-circle me-1"></i>Đã huỷ</c:when>
                                                        <c:otherwise>${order.status}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <c:out value="${order.orderDetails != null ? order.orderDetails.size() : 0}" />
                                            </td>
                                            <td class="text-end">
    <c:set var="total" value="0" />
    <c:forEach var="detail" items="${order.orderDetails}">
        <c:set var="total" value="${total + detail.totalAmount}" />
    </c:forEach>

    <c:set var="discount" value="0" />
    <c:forEach var="oc" items="${orderCoupons}">
        <c:if test="${oc.orderId == order.orderId}">
            <c:set var="discount" value="${discount + oc.appliedAmount}" />
        </c:if>
    </c:forEach>

    <span class="fw-medium">
        <fmt:formatNumber value="${total - discount}" type="number" pattern="#,##0"/>₫
    </span>

    <c:if test="${discount > 0}">
        <br/>
        <small class="text-success">- Giảm giá:
            <fmt:formatNumber value="${discount}" type="number" pattern="#,##0"/>₫
        </small>
    </c:if>
</td>
                                          <td class="text-center">
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary"
                                                            onclick="window.location.href = '${pageContext.request.contextPath}/order/view?id=${order.orderId}'">
                                                        <i class="bi bi-eye me-1"></i>Chi tiết
                                                    </button>
                                                    <button class="btn btn-outline-secondary"
                                                            onclick="window.location.href = '${pageContext.request.contextPath}/order/edit?id=${order.orderId}'">
                                                        <i class="bi bi-pencil-square me-1"></i>Sửa
                                                    </button>
                                                    <c:if test="${order.status eq 'Pending'}">
                                                        <button class="btn btn-success"
                                                                onclick="window.location.href = '${pageContext.request.contextPath}/checkoutInfo?orderId=${order.orderId}'">
                                                            <i class="bi bi-cash-coin me-1"></i>Thanh toán
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <div class="card shadow-sm">
                        <div class="card-body py-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="text-muted small">
                                    Hiển thị <span id="startIndex">0</span> - <span id="endIndex">0</span> 
                                    trong tổng số <span id="totalItems">0</span> đơn hàng
                                </div>
                                <nav aria-label="Pagination">
                                    <ul class="pagination pagination-sm mb-0">
                                        <li class="page-item">
                                            <button class="page-link px-2 fw-bold" onclick="goToPage(1)" title="Trang đầu">
                                                <i class="bi bi-chevron-bar-left"></i>
                                            </button>
                                        </li>
                                        <li class="page-item">
                                            <button class="page-link px-2 fw-bold" onclick="goToPage(currentPage - 1)" title="Trang trước">
                                                <i class="bi bi-chevron-left"></i>
                                            </button>
                                        </li>
                                        <li class="page-item mx-2">
                                            <div class="input-group input-group-sm">
                                                <input type="number" class="form-control text-center" id="pageInput" 
                                                       style="width: 50px;" min="1" onchange="goToPage(this.value)">
                                                <span class="input-group-text border-start-0 bg-light">
                                                    /<span id="totalPages" class="mx-1">0</span>
                                                </span>
                                            </div>
                                        </li>
                                        <li class="page-item">
                                            <button class="page-link px-2 fw-bold" onclick="goToPage(currentPage + 1)" title="Trang sau">
                                                <i class="bi bi-chevron-right"></i>
                                            </button>
                                        </li>
                                        <li class="page-item">
                                            <button class="page-link px-2 fw-bold" onclick="goToPage(totalPages)" title="Trang cuối">
                                                <i class="bi bi-chevron-bar-right"></i>
                                            </button>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


        <!-- JS filter & pagination client-side -->
        <script>
                                                                    const PAGE_SIZE = 3; // Số item trên mỗi trang
                                                                    let currentPage = 1;
                                                                    let allRows = [];
                                                                    
                                                                    // Khởi tạo danh sách các hàng khi trang load
                                                                    function initializeRows() {
                                                                        allRows = Array.from(document.querySelectorAll('tbody > tr')).filter(row => {
                                                                            return row.querySelector('td') && !row.querySelector('td[colspan]');
                                                                        });
                                                                    }

                                                                    function getFilterValues() {
                                                                        return {
                                                                            search: document.querySelector('input[placeholder*="Tìm"]').value.trim().toLowerCase(),
                                                                            status: document.querySelector('input[name="status"]:checked')?.nextElementSibling?.textContent.trim(),
                                                                            branch: document.querySelector('.form-select').value,
                                                                            priceFrom: document.querySelectorAll('.form-control-sm')[0].value,
                                                                            priceTo: document.querySelectorAll('.form-control-sm')[1].value
                                                                        };
                                                                    }

                                                                    function filterRows() {
                                                                        const {search, status, branch, priceFrom, priceTo} = getFilterValues();
                                                                        return allRows.filter(row => {
                                                                            const cells = row.querySelectorAll('td');
                                                                            let match = true;
                                                                            // Search by customer name or order code
                                                                            if (search) {
                                                                                const text = row.textContent.toLowerCase();
                                                                                match = match && text.includes(search);
                                                                            }
                                                                            // Status
                                                                            if (status && status !== 'Tất cả') {
                                                                                match = match && row.querySelector('.badge-status')?.textContent.includes(status);
                                                                            }
                                                                            // Branch
                                                                            if (branch) {
                                                                                match = match && cells[4]?.textContent.includes(branch);
                                                                            }
                                                                            // Price range
                                                                            if (priceFrom || priceTo) {
                                                                                let price = 0;
                                                                                const priceCell = cells[7]?.textContent.replace(/[^\d.]/g, '');
                                                                                if (priceCell)
                                                                                    price = parseFloat(priceCell);
                                                                                if (priceFrom && price < parseFloat(priceFrom))
                                                                                    match = false;
                                                                                if (priceTo && price > parseFloat(priceTo))
                                                                                    match = false;
                                                                            }
                                                                            return match;
                                                                        });
                                                                    }

                                                                    function renderTable(page = 1) {
                                                                        const filtered = filterRows();
                                                                        const totalItems = filtered.length;
                                                                        const totalPages = Math.ceil(totalItems / PAGE_SIZE);
                                                                        
                                                                        // Đảm bảo trang hiện tại hợp lệ
                                                                        page = Math.max(1, Math.min(page, totalPages));
                                                                        currentPage = page;
                                                                        
                                                                        // Tính toán phạm vi hiển thị
                                                                        const start = (page - 1) * PAGE_SIZE;
                                                                        const end = Math.min(start + PAGE_SIZE, totalItems);
                                                                        
                                                                        // Ẩn tất cả các hàng
                                                                        allRows.forEach(row => row.style.display = 'none');
                                                                        
                                                                        // Hiển thị các hàng của trang hiện tại
                                                                        filtered.slice(start, end).forEach(row => row.style.display = '');
                                                                        
                                                                        // Cập nhật thông tin phân trang
                                                                        updatePaginationInfo(start + 1, end, totalItems, page, totalPages);
                                                                        
                                                                        // Cập nhật trạng thái nút phân trang
                                                                        updatePaginationButtons(page, totalPages);
                                                                    }

                                                                    function updatePaginationInfo(start, end, total, currentPage, totalPages) {
                                                                        document.getElementById('startIndex').textContent = start;
                                                                        document.getElementById('endIndex').textContent = end;
                                                                        document.getElementById('totalItems').textContent = total;
                                                                        document.getElementById('pageInput').value = currentPage;
                                                                        document.getElementById('totalPages').textContent = totalPages;
                                                                        // Cập nhật min/max cho input
                                                                        document.getElementById('pageInput').min = 1;
                                                                        document.getElementById('pageInput').max = totalPages;
                                                                    }

                                                                    function updatePaginationButtons(page, totalPages) {
                                                                        const firstPageBtn = document.querySelector('.page-item:first-child');
                                                                        const prevPageBtn = document.querySelector('.page-item:nth-child(2)');
                                                                        const nextPageBtn = document.querySelector('.page-item:nth-last-child(2)');
                                                                        const lastPageBtn = document.querySelector('.page-item:last-child');
                                                                        
                                                                        // Cập nhật trạng thái disabled cho các nút
                                                                        firstPageBtn.classList.toggle('disabled', page === 1);
                                                                        prevPageBtn.classList.toggle('disabled', page === 1);
                                                                        nextPageBtn.classList.toggle('disabled', page === totalPages);
                                                                        lastPageBtn.classList.toggle('disabled', page === totalPages);
                                                                    }

                                                                    window.goToPage = function (page) {
                                                                        renderTable(page);
                                                                    }

                                                                    // Xử lý sự kiện
                                                                    document.addEventListener('DOMContentLoaded', function() {
                                                                        // Khởi tạo danh sách hàng
                                                                        initializeRows();
                                                                        
                                                                        // Gắn sự kiện cho các điều khiển lọc
                                                                        const searchInput = document.querySelector('input[placeholder*="Tìm"]');
                                                                        if (searchInput) {
                                                                            searchInput.addEventListener('input', () => renderTable(1));
                                                                        }
                                                                        
                                                                        document.querySelectorAll('input[name="status"]').forEach(radio => {
                                                                            radio.addEventListener('change', () => renderTable(1));
                                                                        });
                                                                        
                                                                        const branchSelect = document.querySelector('.form-select');
                                                                        if (branchSelect) {
                                                                            branchSelect.addEventListener('change', () => renderTable(1));
                                                                        }
                                                                        
                                                                        document.querySelectorAll('.form-control-sm').forEach(input => {
                                                                            input.addEventListener('input', () => renderTable(1));
                                                                        });
                                                                        
                                                                        const filterButton = document.querySelector('.btn-primary.btn-sm');
                                                                        if (filterButton) {
                                                                            filterButton.addEventListener('click', (e) => {
                                                                                e.preventDefault();
                                                                                renderTable(1);
                                                                            });
                                                                        }
                                                                        
                                                                        // Render bảng lần đầu
                                                                        renderTable(1);
                                                                    });
        </script>

    </body>
</html>
