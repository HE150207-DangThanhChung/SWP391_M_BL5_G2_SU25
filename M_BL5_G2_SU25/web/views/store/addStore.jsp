<%-- 
    Document   : addStore
    Created on : Aug 13, 2025, 8:49:35 AM
    Author     : tayho
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm mới cửa hàng</title>

        <style>
            :root{
                --header-h: 64px;
                --sidebar-w: 260px;
                --radius: 12px;
                --bg: #f5f7fb;
                --card: #ffffff;
                --line:#e9edf3;
                --brand:#F28705;
                --success:#28a745;
            }
            *{
                box-sizing: border-box;
            }
            html,body{
                height:100%;
            }
            body{
                margin:0;
                font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, Arial, "Noto Sans", sans-serif;
                background: var(--bg);
                color:#111;
                line-height:1.5;
            }
            a{
                color:inherit;
                text-decoration:none;
            }

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
            .app-header{
                grid-area: header;
                position: sticky;
                top:0;
                z-index:50;
                background:var(--card);
                border-bottom:1px solid var(--line);
            }
            .app-sidebar{
                grid-area: sidebar;
                background:var(--card);
                border-right:1px solid var(--line);
                overflow-y:auto;
            }
            .app-main{
                grid-area: main;
                padding:24px;
                width:100%;
                max-width:1100px;
                margin:0 auto;
            }
            .app-footer{
                grid-area: footer;
                background:var(--card);
                border-top:1px solid var(--line);
                padding:16px 24px;
                text-align:center;
            }

            /* ===== Card + Form ===== */
            .page-title{
                margin:0 0 16px;
                font-size:24px;
                font-weight:700;
            }
            .card{
                background:var(--card);
                border:1px solid var(--line);
                border-radius: var(--radius);
                padding:24px;
            }

            .form-two-col{
                display:grid;
                grid-template-columns: 320px 1fr;
                gap:24px;
                align-items:start;
            }

            .media-box{
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:12px;
                padding:16px;
                border:1px dashed var(--line);
                border-radius:12px;
                background:#fff;
            }
            .store-image{
                width:160px;
                height:160px;
                object-fit:cover;
                border-radius:12px;
                border:1px solid var(--line);
            }

            .form-grid{
                display:grid;
                grid-template-columns: 1fr;
                gap:16px;
            }
            .form-row{
                display:grid;
                gap:8px;
            }
            label{
                font-weight:600;
            }
            input[type="text"], input[type="tel"], select{
                height:42px;
                padding:0 12px;
                border:1px solid #cdd6e1;
                border-radius:10px;
                background:#fff;
                font-size:14px;
            }

            .actions{
                display:flex;
                gap:12px;
                justify-content:center;
                margin-top:12px;
            }
            .btn{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                gap:6px;
                height:42px;
                padding:0 16px;
                border-radius:10px;
                border:1px solid transparent;
                cursor:pointer;
            }
            .btn-primary{
                background: var(--success);
                color:#fff;
            }
            .btn-secondary{
                background:#fff;
                border-color:#cdd6e1;
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
                .form-two-col{
                    grid-template-columns: 1fr;
                }
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
                <h1 class="page-title">Thêm cửa hàng</h1>

                <form action="${pageContext.request.contextPath}/stores/add" method="post" class="card" novalidate>
                    <div class="form-two-col">
                        <!-- Left: Ảnh/logo -->
                        <div class="media-box">
                            <img class="store-image" src="${pageContext.request.contextPath}/img/logo2.jpg" alt="Logo Store"/>
                            <div style="font-size:13px; color:#555;">Ảnh minh họa cửa hàng</div>
                        </div>

                        <!-- Right: Thông tin -->
                        <div class="form-grid">
                            <div class="form-row">
                                <label for="storeName">Tên cửa hàng</label>
                                <input id="storeName" name="storeName" type="text" required>
                            </div>

                            <div class="form-row">
                                <label for="address">Địa chỉ cửa hàng</label>
                                <input id="address" name="address" type="text" required>
                            </div>

                            <div class="form-row">
                                <label for="phone">Số điện thoại cửa hàng</label>
                                <!-- Linh hoạt: chấp nhận số, khoảng trắng, +, -, (), .  (đồng bộ với trang Edit) -->
                                <input id="phone" name="phone" type="tel" required
                                       pattern="^[0-9+()\-.\s]{6,}$"
                                       title="Nhập số điện thoại hợp lệ (cho phép số, khoảng trắng, +, -, (), .)">
                            </div>

                            <div class="form-row">
                                <label for="status">Trạng thái</label>
                                <!-- Đồng bộ giá trị với list/edit: Active / Deactive -->
                                <select id="status" name="status" required>
                                    <option value="Active">Hoạt động</option>
                                    <option value="Deactive">Ngừng hoạt động</option>
                                </select>
                            </div>

                            <div class="actions">
                                <button type="submit" class="btn btn-primary">➕ Thêm mới</button>
                                <button type="button" class="btn btn-secondary"
                                        onclick="window.location.href = '${pageContext.request.contextPath}/stores'">Hủy bỏ</button>
                            </div>
                        </div>
                    </div>
                </form>
            </main>

            <!-- Footer -->
            <footer class="app-footer">
                <jsp:include page="/views/common/footer.jsp"/>
            </footer>
        </div>

    </body>
</html>
