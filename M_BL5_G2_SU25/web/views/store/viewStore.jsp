<%-- 
    Document   : viewStore
    Created on : Aug 15, 2025, 10:12:03 AM
    Author     : tayho
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chi tiết Cửa hàng</title>

    <style>
        :root{
            --header-h: 64px;
            --sidebar-w: 260px;
            --radius: 12px;
            --bg: #f5f7fb;
            --card: #ffffff;
            --text: #111;
            --muted:#4a4a4a;
            --line:#e9edf3;
            --brand:#F28705;
            --danger:#dc3545;
            --success:#28a745;
        }
        *{ box-sizing: border-box; }
        html,body{ height:100%; }
        body{
            margin:0;
            font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, Arial, "Noto Sans", sans-serif;
            background: var(--bg);
            color: var(--text);
        }
        a{ color: inherit; text-decoration: none; }
        button{ font: inherit; }

        /* ===== Layout Grid ===== */
        .layout{
            min-height:100vh;
            display:grid;
            grid-template-columns: var(--sidebar-w) 1fr;
            grid-template-rows: var(--header-h) 1fr auto;
            grid-template-areas:
                "header header"
                "sidebar main"
                "footer footer";
        }
        .app-header{ grid-area: header; position: sticky; top:0; z-index:50; background:var(--card); border-bottom:1px solid var(--line); }
        .app-sidebar{ grid-area: sidebar; background:var(--card); border-right:1px solid var(--line); overflow-y:auto; }
        .app-main{ grid-area: main; padding:24px; width:100%; max-width:1000px; margin:0 auto; }
        .app-footer{ grid-area: footer; background:var(--card); border-top:1px solid var(--line); padding:16px 24px; text-align:center; }

        /* ===== Page content ===== */
        .page-title{ margin:0 0 16px; font-size:24px; font-weight:700; }

        .card{
            background:var(--card);
            border:1px solid var(--line);
            border-radius: var(--radius);
            padding:20px;
        }
        .header-row{
            display:flex; align-items:center; justify-content:space-between; gap:12px;
            padding-bottom:10px; border-bottom:2px solid var(--line); margin-bottom:16px;
        }
        .actions{ display:flex; gap:10px; flex-wrap:wrap; }
        .btn{
            display:inline-flex; align-items:center; justify-content:center; gap:6px;
            height:40px; padding:0 14px; border-radius:10px; border:1px solid transparent; cursor:pointer;
            background:#fff;
        }
        .btn-edit{ background: var(--brand); color:#fff; }
        .btn-delete{ background: var(--danger); color:#fff; }
        .btn-back{ border-color:#ccc; color:#333; background:#fff; }

        .store-top{
            display:flex; gap:20px; align-items:center; margin-bottom:12px;
        }
        .store-image{
            width:120px; height:120px; border-radius:10px; object-fit:cover; border:1px solid var(--line);
        }
        .meta{ color: var(--muted); }

        .detail-grid{
            display:grid;
            grid-template-columns: 180px 1fr;
            gap:10px 16px;
            margin-top:12px;
        }
        .label{ font-weight:700; color:#555; }
        .value{ color:#111; }

        .status-badge{
            display:inline-block; padding:6px 10px; border-radius:8px; color:#fff; font-weight:600; font-size:14px;
        }
        .status-active{ background: var(--success); }
        .status-inactive{ background: var(--danger); }

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
            .store-top{ flex-direction:column; align-items:flex-start; }
            .detail-grid{ grid-template-columns: 1fr; }
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
        <h1 class="page-title">Chi tiết Cửa hàng</h1>

        <div class="card">
            <div class="header-row">
                <div class="meta">Mã: <strong>${store.storeId}</strong></div>
                <div class="actions">
                    <a class="btn btn-edit" href="${pageContext.request.contextPath}/stores/edit/${store.storeId}">✏️ Chỉnh sửa</a>
                    <a class="btn btn-delete"
                       href="${pageContext.request.contextPath}/stores/delete/${store.storeId}"
                       onclick="return confirm('Bạn có chắc chắn muốn xóa cửa hàng này?');">🗑️ Xóa</a>
                    <a class="btn btn-back" href="${pageContext.request.contextPath}/stores">← Quay lại</a>
                </div>
            </div>

            <div class="store-top">
                <img src="${pageContext.request.contextPath}/img/logo2.jpg" alt="Store Image" class="store-image"/>
                <div>
                    <div style="font-size:20px; font-weight:700; margin-bottom:6px;">${store.storeName}</div>
                    
                </div>
            </div>

            <div class="detail-grid">
                <div class="label">Mã cửa hàng</div>
                <div class="value">${store.storeId}</div>

                <div class="label">Tên cửa hàng</div>
                <div class="value">${store.storeName}</div>

                <div class="label">Địa chỉ</div>
                <div class="value">${store.address}</div>

                <div class="label">Số điện thoại</div>
                <div class="value">${store.phone}</div>

                <div class="label">Trạng thái</div>
                <div class="value">
                    <c:choose>
                        <c:when test="${store.status == 'Active'}">
                            <span class="status-badge status-active">Hoạt động</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge status-inactive">Ngừng hoạt động</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="app-footer">
        <jsp:include page="/views/common/footer.jsp"/>
    </footer>
</div>

</body>
</html>
