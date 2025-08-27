<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Store</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- (Tuỳ chọn) CSS riêng của bạn -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">

    <style>
        :root{
            --header-h: 64px;
            --sidebar-w: 260px;
            --radius: 12px;
            --bg: #f5f7fb;
            --card: #ffffff;
            --line: #e9edf3;
        }
        * { box-sizing: border-box; }
        html, body { height: 100%; }
        body{
            margin: 0;
            font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
            background: var(--bg);
        }

        /* ==== LAYOUT GRID ==== */
        .layout{
            min-height: 100vh;
            display: grid;
            grid-template-columns: var(--sidebar-w) 1fr;
            grid-template-rows: var(--header-h) 1fr auto;
            grid-template-areas:
                "header header"
                "sidebar main"
                "footer footer";
        }
        .app-header{ grid-area: header; position: sticky; top: 0; z-index: 50; background: var(--card); border-bottom: 1px solid var(--line); }
        .app-sidebar{ grid-area: sidebar; background: var(--card); border-right: 1px solid var(--line); overflow-y: auto; }
        .app-main{ grid-area: main; padding: 24px; width: 100%; max-width: 1200px; margin: 0 auto; }
        .app-footer{ grid-area: footer; background: var(--card); border-top: 1px solid var(--line); padding: 16px 24px; text-align: center; }

        .card-elevate{
            background: var(--card);
            border: 1px solid var(--line);
            border-radius: var(--radius);
        }

        @media (max-width: 992px){
            .layout{
                grid-template-columns: 1fr;
                grid-template-rows: var(--header-h) auto 1fr auto;
                grid-template-areas:
                    "header"
                    "sidebar"
                    "main"
                    "footer";
            }
            .app-sidebar{ border-right: none; border-bottom: 1px solid var(--line); }
        }
    </style>
</head>
<body>

<div class="layout">
    <!-- Header -->
    <header class="app-header">
        <jsp:include page="/views/common/header.jsp"/>
    </header>

    <!-- Sidebar -->
    <aside class="app-sidebar">
        <jsp:include page="/views/common/sidebar.jsp"/>
    </aside>

    <!-- Main -->
    <main class="app-main">
        <div class="container-fluid px-0">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <h1 class="h3 mb-0">Chỉnh sửa cửa hàng</h1>
                <a href="${pageContext.request.contextPath}/stores" class="btn btn-outline-secondary btn-sm">← Quay lại</a>
            </div>

            <div class="card-elevate p-4">
                <div class="row">
                    <div class="col-lg-7 col-md-9">
                        <form action="${pageContext.request.contextPath}/stores/edit" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="storeId" value="${store.storeId}"/>

                            <div class="mb-3">
                                <label for="storeName" class="form-label">Tên cửa hàng</label>
                                <input type="text" class="form-control" id="storeName" name="storeName"
                                       value="${store.storeName}" required>
                                <div class="invalid-feedback">Vui lòng nhập tên cửa hàng.</div>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="address" name="address"
                                       value="${store.address}" required>
                                <div class="invalid-feedback">Vui lòng nhập địa chỉ.</div>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone"
                                       value="${store.phone}" pattern="^[0-9+()\-.\s]{6,}$" required>
                                <div class="form-text">Accepts digits, space, +, -, () and .</div>
                                <div class="invalid-feedback">Vui lòng nhập số điện thoại hợp lệ.</div>
                            </div>

                            <div class="mb-4">
                                <label for="status" class="form-label">Trạng thái</label>
                                <!-- LƯU Ý: đồng bộ với listStore.jsp: dùng 'Active' / 'Deactive' -->
                                <select class="form-select" id="status" name="status" required>
                                    <option value="Active"   ${store.status == 'Active'   ? 'selected' : ''}>Hoạt động</option>
                                    <option value="Deactive" ${store.status == 'Deactive' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                                <div class="invalid-feedback">Please select status.</div>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">Update Store</button>
                                <a href="${pageContext.request.contextPath}/stores" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div><!-- /card -->
        </div>
    </main>

    <!-- Footer -->
    <footer class="app-footer">
        <jsp:include page="/views/common/footer.jsp"/>
    </footer>
</div>

<!-- Bootstrap JS (validation demo) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Bootstrap client-side validation
    (function () {
        'use strict';
        var forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) { event.preventDefault(); event.stopPropagation(); }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html>
