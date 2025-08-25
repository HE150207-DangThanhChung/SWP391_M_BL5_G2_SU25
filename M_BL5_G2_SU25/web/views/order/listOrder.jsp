<%-- 
    Document   : listOrder (refined)
    Created on : Aug 13, 2025
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Danh sách đơn hàng</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- Optional common css -->
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" />

    <style>
        body {
            background-color: #f4f6f8;
        }
        .panel-card {
            border-radius: 12px;
            background: #fff;
            padding: 16px 18px;
            box-shadow: 0 2px 10px rgba(0,0,0,.04);
        }
        .table-container {
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,.04);
        }
        /* Khung bảng cuộn với header dính */
        .table-responsive {
            max-height: 60vh;
            overflow: auto;
        }
        thead th {
            position: sticky;
            top: 0;
            z-index: 2;
            background: #f1f3f5 !important;
        }
        .form-control-underline {
            border: none;
            border-bottom: 1px solid #000;
            border-radius: 0;
            background: transparent;
        }
        .sidebar-title {
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: .75rem;
        }
        .badge-status {
            font-weight: 600;
        }
        .toolbar {
            gap: 12px;
        }
        @media (max-width: 991.98px) {
            .toolbar {
                flex-direction: column;
                align-items: stretch !important;
                gap: 10px;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid py-4">
    <div class="row g-4">
        <!-- Sidebar filters -->
        <aside class="col-lg-3">
            <div class="panel-card">
                <div class="sidebar-title">Trạng thái đơn hàng</div>
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

                <hr class="my-4">

                <div class="sidebar-title">Chi nhánh</div>
                <select class="form-select" id="branchSelect">
    <option value="">Tất cả</option>
    <c:forEach var="s" items="${stores}">
        <option value="${s.storeName}">${s.storeName} (${s.storeId})</option>
    </c:forEach>
</select>

                <hr class="my-4">

                <div class="sidebar-title">Khoảng giá</div>
                <div class="row g-2">
                    <div class="col-6">
                        <input type="number" class="form-control form-control-sm" placeholder="Từ">
                    </div>
                    <div class="col-6">
                        <input type="number" class="form-control form-control-sm" placeholder="Đến">
                    </div>
                </div>

                <div class="d-grid mt-3">
                    <button class="btn btn-dark btn-sm"><i class="bi bi-funnel me-1"></i>Lọc</button>
                </div>
            </div>
        </aside>

        <!-- Main content -->
        <main class="col-lg-9">
            <!-- Header tools -->
            <div class="d-flex align-items-center justify-content-between toolbar mb-3">
                <h4 class="m-0">Đơn hàng</h4>
                <div class="d-flex align-items-center gap-2">
                    <div class="input-group" style="min-width: 320px;">
                        <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                        <input type="text" class="form-control" placeholder="Tìm theo tên khách / mã đơn...">
                    </div>
                   <button class="btn btn-outline-secondary" onclick="window.location.href=window.location.href;">
    <i class="bi bi-arrow-clockwise me-1"></i>Tải lại
</button>

                    <div class="btn-group">
                        <button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/order/create'"><i class="bi bi-plus-lg me-1"></i>Tạo đơn</button>
                        <button class="btn btn-outline-primary"><i class="bi bi-upload me-1"></i>Nhập</button>
                        <button class="btn btn-outline-primary"><i class="bi bi-download me-1"></i>Xuất</button>
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-sm table-striped table-hover align-middle mb-0">
                        <thead>
                        <tr class="text-nowrap">
                            <th style="width: 110px;">Mã đơn</th>
                            <th>Tên khách</th>
                            <th>Người tạo</th>
                            <th>Nhân viên bán</th>
                            <th>Chi nhánh</th>
                            <th style="width: 140px;">Trạng thái</th>
                            <th class="text-end" style="width: 100px;">Số lượng</th>
                            <th class="text-end" style="width: 140px;">Tổng tiền</th>
                            <th>Mô tả</th>
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
                                    <c:out value="${total}" />&nbsp;₫
                                </td>
                             
                                <td class="text-center">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-primary"
                                                onclick="window.location.href='${pageContext.request.contextPath}/order/view?id=${order.orderId}'">
                                            <i class="bi bi-eye me-1"></i>Chi tiết
                                        </button>
                                        <button class="btn btn-outline-secondary"
                                                onclick="window.location.href='${pageContext.request.contextPath}/order/edit?id=${order.orderId}'">
                                            <i class="bi bi-pencil-square me-1"></i>Sửa
                                        </button>
                                        <c:if test="${order.status eq 'Pending'}">
                                            <button class="btn btn-success"
                                                    onclick="window.location.href='${pageContext.request.contextPath}/checkoutInfo?orderId=${order.orderId}'">
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
            <nav class="mt-3 d-flex justify-content-center" aria-label="Pagination">
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item disabled">
                        <button class="page-link"><i class="bi bi-chevron-double-left"></i></button>
                    </li>
                    <li class="page-item disabled">
                        <button class="page-link"><i class="bi bi-chevron-left"></i></button>
                    </li>
                    <li class="page-item active"><button class="page-link">1</button></li>
                    <li class="page-item"><button class="page-link">2</button></li>
                    <li class="page-item"><button class="page-link">3</button></li>
                    <li class="page-item">
                        <button class="page-link"><i class="bi bi-chevron-right"></i></button>
                    </li>
                    <li class="page-item">
                        <button class="page-link"><i class="bi bi-chevron-double-right"></i></button>
                    </li>
                </ul>
            </nav>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


<!-- JS filter & pagination client-side -->
<script>
const PAGE_SIZE = 10;
let currentPage = 1;
let allRows = Array.from(document.querySelectorAll('tbody > tr')).filter(row => row.querySelector('td') && !row.querySelector('td[colspan]'));

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
            if (priceCell) price = parseFloat(priceCell);
            if (priceFrom && price < parseFloat(priceFrom)) match = false;
            if (priceTo && price > parseFloat(priceTo)) match = false;
        }
        return match;
    });
}

function renderTable(page = 1) {
    currentPage = page;
    const filtered = filterRows();
    const tbody = document.querySelector('tbody');
    // Hide all rows
    allRows.forEach(row => row.style.display = 'none');
    // Show only rows for current page
    const start = (page - 1) * PAGE_SIZE;
    const end = start + PAGE_SIZE;
    filtered.slice(start, end).forEach(row => row.style.display = '');
    renderPagination(filtered.length);
}

function renderPagination(total) {
    const nav = document.querySelector('nav[aria-label="Pagination"] ul');
    if (!nav) return;
    nav.innerHTML = '';
    const pageCount = Math.ceil(total / PAGE_SIZE);
    function pageBtn(page, label, active = false, disabled = false) {
        return `<li class="page-item${active ? ' active' : ''}${disabled ? ' disabled' : ''}"><button class="page-link" onclick="goToPage(${page})">${label}</button></li>`;
    }
    nav.innerHTML += pageBtn(1, '<i class="bi bi-chevron-double-left"></i>', false, currentPage === 1);
    nav.innerHTML += pageBtn(currentPage - 1, '<i class="bi bi-chevron-left"></i>', false, currentPage === 1);
    for (let i = 1; i <= pageCount; i++) {
        nav.innerHTML += pageBtn(i, i, currentPage === i);
    }
    nav.innerHTML += pageBtn(currentPage + 1, '<i class="bi bi-chevron-right"></i>', false, currentPage === pageCount);
    nav.innerHTML += pageBtn(pageCount, '<i class="bi bi-chevron-double-right"></i>', false, currentPage === pageCount);
}

window.goToPage = function(page) {
    renderTable(page);
}

// Event listeners
document.querySelector('input[placeholder*="Tìm"]').addEventListener('input', () => renderTable(1));
document.querySelectorAll('input[name="status"]').forEach(r => r.addEventListener('change', () => renderTable(1)));
document.querySelector('.form-select').addEventListener('change', () => renderTable(1));
document.querySelectorAll('.form-control-sm').forEach(inp => inp.addEventListener('input', () => renderTable(1)));
document.querySelector('.btn-dark.btn-sm').addEventListener('click', e => { e.preventDefault(); renderTable(1); });

// Initial render
renderTable(1);
</script>

</body>
</html>
