<%-- 
    Document   : listStore
    Created on : Aug 13, 2025, 8:49:14 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách Cửa hàng</title>

        <style>
            :root{
                --header-h: 64px;
                --sidebar-w: 260px;
                --radius: 12px;
                --bg: #f5f7fb;
                --card: #ffffff;
                --text: #111;
                --muted: #4a4a4a;
                --line: #e9edf3;
                --brand: #F28705;
            }

            * {
                box-sizing: border-box;
            }
            html, body {
                height: 100%;
            }
            body {
                margin: 0;
                font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont,
                    "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif,
                    "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
                background: var(--bg);
                color: var(--text);
                font-size: 14px;
                line-height: 1.5;
            }

            a {
                color: inherit;
                text-decoration: none;
            }
            button {
                background: none;
                border: none;
                cursor: pointer;
                padding: 0;
                font: inherit;
                color: inherit;
            }

            /* ======= LAYOUT (Grid 3 hàng x 2 cột) ======= */
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

            .app-header{
                grid-area: header;
                position: sticky;
                top: 0;
                z-index: 50;
                background: var(--card);
                border-bottom: 1px solid var(--line);
            }
            .app-sidebar{
                grid-area: sidebar;
                background: var(--card);
                border-right: 1px solid var(--line);
                overflow-y: auto;
            }
            .app-main{
                grid-area: main;
                padding: 24px;
                width: 100%;
                max-width: 1280px;
                margin: 0 auto;
            }
            .app-footer{
                grid-area: footer;
                background: var(--card);
                border-top: 1px solid var(--line);
                padding: 16px 24px;
                text-align: center;
            }

            /* ======= SEARCH + ACTIONS ======= */
            .page-title{
                margin: 0 0 16px;
                font-size: 24px;
                font-weight: 700;
            }

            .toolbar{
                display: flex;
                gap: 12px;
                align-items: center;
                flex-wrap: wrap;
                background: var(--card);
                padding: 16px;
                border: 1px solid var(--line);
                border-radius: var(--radius);
                margin-bottom: 16px;
            }
            .search-box{
                position: relative;
            }
            .search-box input{
                width: 320px;
                max-width: 100%;
                height: 42px;
                padding: 8px 14px 8px 36px;
                border-radius: 10px;
                border: 1px solid #ccc;
                background: #fff;
            }
            .search-box .icon{
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
            }
            .toolbar select{
                height: 42px;
                border-radius: 10px;
                border: 1px solid #ccc;
                background: #fff;
                padding: 0 10px;
                min-width: 180px;
            }
            .spacer{
                flex: 1 1 auto;
            }
            .btn{
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
                height: 42px;
                padding: 0 14px;
                border-radius: 10px;
                white-space: nowrap;
            }
            .btn-primary{
                background: var(--brand);
                color: #fff;
            }
            .btn-ghost{
                background: #fff;
                border: 1px solid #ccc;
            }

            /* ======= TABLE ======= */
            .card{
                background: var(--card);
                border: 1px solid var(--line);
                border-radius: var(--radius);
            }
            .table-container{
                overflow-x: auto;
            }
            table{
                width: 100%;
                border-collapse: collapse;
                min-width: 900px;
            }
            thead th{
                background: #eef2f8;
                color: #000;
                font-weight: 700;
                font-size: 14px;
                padding: 10px 12px;
                text-align: left;
                border-bottom: 1px solid var(--line);
            }
            tbody td{
                padding: 10px 12px;
                color: var(--text);
                border-bottom: 1px solid var(--line);
                vertical-align: middle;
            }
            tbody tr:nth-child(even){
                background: #fafbfe;
            }
            .td-center{
                text-align: center;
            }
            .store-thumb{
                width: 46px;
                height: 46px;
                border-radius: 8px;
                object-fit: cover;
                border: 1px solid var(--line);
            }
            .btn-view{
                background: #28a745;
                color: #fff;
                height: 36px;
                padding: 0 12px;
                border-radius: 8px;
            }

            /* ======= PAGINATION ======= */
            .pagination{
                display: flex;
                gap: 8px;
                align-items: center;
                justify-content: center;
                padding: 12px;
                flex-wrap: wrap;
            }
            .page-link{
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 36px;
                height: 36px;
                padding: 0 10px;
                border: 1px solid #ccc;
                border-radius: 8px;
                background: #fff;
                font-weight: 600;
            }
            .page-link.active{
                border-color: var(--brand);
                color: var(--brand);
            }
            .page-link[aria-disabled="true"]{
                opacity: .5;
                pointer-events: none;
            }

            /* ======= RESPONSIVE ======= */
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
                .app-sidebar{
                    border-right: none;
                    border-bottom: 1px solid var(--line);
                }
            }
        </style>
    </head>
    <body>

        <div class="layout">
            <!-- Header (sticky) -->
            <header class="app-header">
                <jsp:include page="/views/common/header.jsp"/>
            </header>

            <!-- Sidebar (scroll riêng) -->
            <aside class="app-sidebar">
                <jsp:include page="/views/common/sidebar.jsp"/>
            </aside>

            <!-- Main content -->
            <main class="app-main">
                <h1 class="page-title">Danh sách Cửa hàng</h1>

                <!-- Toolbar: Search + Status + Actions -->
                <div class="toolbar">
                    <form action="${pageContext.request.contextPath}/stores" method="get" style="display:flex; gap:12px; align-items:center; flex-wrap:wrap; width:100%;">
                        <div class="search-box">
                            <span class="icon">🔍</span>
                            <input type="search" name="search" value="${searchKeyword}" placeholder="Tìm theo tên cửa hàng"/>
                        </div>

                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Active"  ${filterStatus == 'Active'  ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="Deactive" ${filterStatus == 'Deactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>

                        <button type="submit" class="btn btn-ghost">Tìm kiếm</button>

                        <span class="spacer"></span>

                        <a href="${pageContext.request.contextPath}/stores/add" class="btn btn-primary">➕ Thêm cửa hàng</a>
                        <button type="button" class="btn btn-ghost">📤 Nhập file</button>
                        <button type="button" class="btn btn-ghost">📥 Xuất file</button>
                    </form>
                </div>

                <!-- Bảng Store -->
                <div class="card">
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th class="td-center"><input type="checkbox"/></th>
<!--                                    <th>Ảnh cửa hàng</th>-->
                                    <th>Mã cửa hàng</th>
                                    <th>Tên cửa hàng</th>
                                    <th>Số điện thoại</th>
                                    <th>Địa chỉ</th>
                                    <th>Trạng thái</th>
                                    <th class="td-center">Thông tin chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${stores}">
                                    <tr>
                                        <td class="td-center"><input type="checkbox"/></td>
<!--                                        <td>
                                            <img class="store-thumb" src="${pageContext.request.contextPath}/img/logo2.jpg" alt="logo"/>
                                        </td>-->
                                        <td>${s.storeId}</td>
                                        <td>${s.storeName}</td>
                                        <td>${s.phone}</td>
                                        <td>${s.address}</td>
                                        <td><c:out value="${s.status == 'Active' ? 'Đang hoạt động' : 'Ngừng hoạt động'}"/></td>
                                        <td class="td-center">
                                            <button class="btn-view" onclick="window.location.href = '${pageContext.request.contextPath}/stores/view/${s.storeId}'">Chi tiết</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <nav class="pagination" aria-label="Pagination">
                        <c:set var="ctx" value="${pageContext.request.contextPath}"/>
                        <c:if test="${currentPage > 1}">
                            <a class="page-link" href="${ctx}/stores?page=1&search=${searchKeyword}&status=${filterStatus}" title="Trang đầu">«</a>
                            <a class="page-link" href="${ctx}/stores?page=${currentPage-1}&search=${searchKeyword}&status=${filterStatus}" title="Trang trước">‹</a>
                        </c:if>

                        <c:forEach begin="${currentPage-2 > 1 ? currentPage-2 : 1}" end="${currentPage+2 < totalPages ? currentPage+2 : totalPages}" var="i">
                            <a class="page-link ${currentPage == i ? 'active' : ''}"
                               href="${ctx}/stores?page=${i}&search=${searchKeyword}&status=${filterStatus}">${i}</a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a class="page-link" href="${ctx}/stores?page=${currentPage+1}&search=${searchKeyword}&status=${filterStatus}" title="Trang sau">›</a>
                            <a class="page-link" href="${ctx}/stores?page=${totalPages}&search=${searchKeyword}&status=${filterStatus}" title="Trang cuối">»</a>
                        </c:if>
                    </nav>
                </div>
            </main>

            <!-- Footer -->
            <footer class="app-footer">
                <jsp:include page="/views/common/footer.jsp"/>
            </footer>
        </div>

    </body>
</html>
