<%-- 
    Document   : listOrder (refined)
    Created on : Aug 13, 2025
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                <select class="form-select">
                    <option value="">Tất cả</option>
                    <option value="1">Chi nhánh 1</option>
                    <option value="2">Chi nhánh 2</option>
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
                    <button class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-clockwise me-1"></i>Tải lại
                    </button>
                    <div class="btn-group">
                        <button class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Tạo đơn</button>
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
                            <th style="width: 140px;">Trạng thái</th>
                            <th class="text-end" style="width: 100px;">Số lượng</th>
                            <th class="text-end" style="width: 140px;">Tổng tiền</th>
                            <th>Mô tả</th>
                            <th class="text-center" style="width: 160px;">Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%-- Row mẫu: thay bằng forEach JSTL khi đổ dữ liệu --%>
                        <tr>
                            <td>#ORD-0001</td>
                            <td>Nam</td>
                            <td>
                                <span class="badge rounded-pill text-bg-success badge-status">
                                    <i class="bi bi-check2-circle me-1"></i>Đã thanh toán
                                </span>
                            </td>
                            <td class="text-end">3</td>
                            <td class="text-end">1.250.000&nbsp;₫</td>
                            <td class="text-truncate" style="max-width: 260px;">Giao trong ngày, thanh toán VNPay.</td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary"
                                            onclick="window.location.href='orderDetail.jsp?id=1'">
                                        <i class="bi bi-eye me-1"></i>Chi tiết
                                    </button>
                                    <button class="btn btn-outline-secondary"
                                            onclick="window.location.href='editOrder.jsp?id=1'">
                                        <i class="bi bi-pencil-square me-1"></i>Sửa
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td>#ORD-0002</td>
                            <td>Lan</td>
                            <td>
                                <span class="badge rounded-pill text-bg-warning badge-status">
                                    <i class="bi bi-hourglass-split me-1"></i>Đang xử lý
                                </span>
                            </td>
                            <td class="text-end">1</td>
                            <td class="text-end">350.000&nbsp;₫</td>
                            <td class="text-truncate" style="max-width: 260px;">Giao tiết kiệm, COD.</td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary"
                                            onclick="window.location.href='orderDetail.jsp?id=2'">
                                        <i class="bi bi-eye me-1"></i>Chi tiết
                                    </button>
                                    <button class="btn btn-outline-secondary"
                                            onclick="window.location.href='editOrder.jsp?id=2'">
                                        <i class="bi bi-pencil-square me-1"></i>Sửa
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td>#ORD-0003</td>
                            <td>Bình</td>
                            <td>
                                <span class="badge rounded-pill text-bg-secondary badge-status">
                                    <i class="bi bi-x-circle me-1"></i>Đã huỷ
                                </span>
                            </td>
                            <td class="text-end">2</td>
                            <td class="text-end">0&nbsp;₫</td>
                            <td class="text-truncate" style="max-width: 260px;">Khách huỷ do đổi lịch.</td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary"
                                            onclick="window.location.href='orderDetail.jsp?id=3'">
                                        <i class="bi bi-eye me-1"></i>Chi tiết
                                    </button>
                                    <button class="btn btn-outline-secondary"
                                            onclick="window.location.href='editOrder.jsp?id=3'">
                                        <i class="bi bi-pencil-square me-1"></i>Sửa
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <%-- /Row mẫu --%>
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

<!-- (Optional) JS mẫu: bắt sự kiện tìm kiếm / lọc -->
<script>
    // TODO: gắn handler thật khi có backend
    // document.querySelector('input[placeholder*="Tìm"]').addEventListener('input', (e) => { ... });
</script>

</body>
</html>
