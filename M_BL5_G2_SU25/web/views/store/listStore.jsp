<%-- 
    Document   : listStore
    Created on : Aug 13, 2025, 8:49:14 AM
    Author     : tayho
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Cửa hàng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Icons -->
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
            />

        <style>
            :root{
                --bg: #ccc;
                --white: #fff;
                --muted: #f0f0f3;
                --thead: #A9A9A9;
                --txt: #000;
                --brand: #F28705;
                --ok: #28a745;
                --border: #ccc;
            }

            html, body {
                height: 100%;
            }
            * {
                box-sizing: border-box;
            }

            body{
                margin: 0;
                font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont,
                    "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif,
                    "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
                background-color: var(--bg);
                color: var(--txt);
                font-weight: 400;
                font-size: 14px;
                line-height: 1.5;
            }

            a, button{
                background: none;
                border: none;
                cursor: pointer;
                padding: 0;
                font: inherit;
                color: inherit;
                text-decoration: none;
            }

            /* === Layout full screen === */
            .content{
                min-height: 100vh;   /* full screen height */
                padding: 16px;
                display: grid;
                grid-template-columns: 1fr; /* 1 column, no sidebar */
                gap: 16px;
            }

            .content-right{
                display: flex;
                flex-direction: column;
                min-height: 0; /* allow children to shrink */
            }

            /* Header title */
            .page-title{
                margin: 0 0 8px 0;
                font-weight: 700;
                font-size: 28px;
            }

            /* === Search & actions === */
            .search{
                position: relative;
                margin-bottom: 8px;
            }

            .search form{
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
            }

            .search-left{
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
            }

            .search-input-wrapper{
                position: relative;
            }

            .search i.fa-search{
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 16px;
                color: var(--txt);
            }

            .search input[type="search"]{
                width: 320px;
                max-width: 100%;
                padding: 10px 16px 10px 36px;
                border-radius: 10px;
                border: 1px solid var(--border);
                font-size: 16px;
                background-color: var(--white);
                height: 45px;
            }

            .search select{
                background-color: var(--white);
                color: var(--txt);
                border: 1px solid var(--border);
                border-radius: 10px;
                min-width: 150px;
                height: 45px;
                padding: 0 10px;
                font-size: 16px;
            }

            .btn-primary{
                background-color: var(--brand);
                color: var(--white);
                border-radius: 10px;
                padding: 0 16px;
                height: 45px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 135px;
            }

            .feature{
                display: flex;
                align-items: center;
                gap: 10px;
                margin-left: auto;
                flex-wrap: nowrap;
            }

            /* === Table wrapper (fills the screen) === */
            .table-container{
                flex: 1;          /* take remaining height */
                min-height: 0;    /* allow inner scroll */
                overflow: auto;
                background: var(--white);
                border-radius: 12px;
            }

            table{
                width: 100%;
                border-collapse: collapse;
                overflow: hidden;
            }

            thead tr{
                background-color: var(--thead);
                color: var(--txt);
                font-weight: 700;
                font-size: 14px;
            }

            thead th{
                padding: 10px 12px;
                font-size: 16px;
                height: 44px;
                position: sticky; /* sticky header on scroll */
                top: 0;
                z-index: 1;
                background-color: var(--thead);
            }

            tbody tr{
                font-weight: 400;
                font-size: 16px;
                color: var(--txt);
                height: 52px;
            }

            tbody tr:nth-child(odd){
                background-color: var(--white);
            }
            tbody tr:nth-child(even){
                background-color: var(--muted);
            }

            tbody td{
                padding: 8px 12px;
                vertical-align: middle;
            }

            .btn-detail{
                background-color: var(--ok);
                color: var(--white);
                border-radius: 10px;
                height: 40px;
                padding: 0 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
            }

            /* === Pagination === */
            .pagination{
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 700;
                font-size: 16px;
                margin-top: 10px;
                flex-wrap: wrap;
            }

            .pagination .page-num,
            .pagination .fa{
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 32px;
                height: 32px;
                border-radius: 6px;
                border: 1px solid var(--txt);
                background: var(--white);
                padding: 0 8px;
            }

            .pagination .page-num.active{
                background: var(--txt);
                color: var(--white);
                border-color: var(--txt);
            }

            /* === Images / checkbox === */
            input[type="checkbox"]{
                width: 16px;
                height: 16px;
            }

            .store-thumb{
                width: 50px;
                height: 50px;
                border-radius: 8px;
                object-fit: cover;
            }

            /* === Responsive === */
            @media (max-width: 768px){
                .content{
                    padding: 8px;
                }
                .feature{
                    width: 100%;
                    justify-content: flex-start;
                    margin-left: 0;
                    flex-wrap: wrap;
                }
                .search input[type="search"]{
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
            <jsp:include page="../common/header.jsp"/>
        <div class="content">
            <div class="content-right">
                <h2 class="page-title">Cửa hàng</h2>
                
                <!-- Search & Actions -->
                <div class="search">
                    <form action="${pageContext.request.contextPath}/stores" method="get">
                        <div class="search-left">
                            <div class="search-input-wrapper">
                                <i class="fa fa-search"></i>
                                <input
                                    type="search"
                                    name="search"
                                    value="${searchKeyword}"
                                    placeholder="Theo tên cửa hàng"
                                    aria-label="Tìm kiếm theo tên cửa hàng"
                                    />
                            </div>

                            <select name="status" aria-label="Lọc theo trạng thái">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Active"  ${filterStatus == 'Active'  ? 'selected' : ''}>Đang hoạt động</option>
                                <option value="Inactive"${filterStatus == 'Deactive'? 'selected' : ''}>Ngừng hoạt động</option>
                            </select>

                            <button type="submit" class="btn-primary"><i class="fa fa-search" style="margin-right:8px"></i>Tìm kiếm</button>
                        </div>

                        <div class="feature">
                            <a href="${pageContext.request.contextPath}/stores/add" class="btn-primary">
                                <i class="fa fa-plus" style="margin-right:8px"></i>Thêm cửa hàng
                            </a>
                            <button type="button" class="btn-primary">
                                <i class="fa fa-file-import" style="margin-right:8px"></i>Nhập file
                            </button>
                            <button type="button" class="btn-primary">
                                <i class="fa fa-file-export" style="margin-right:8px"></i>Xuất file
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Table -->
                <div class="table-container" role="region" aria-label="Bảng danh sách cửa hàng">
                    <table>
                        <thead>
                            <tr>
<!--                                <th><input type="checkbox" aria-label="Chọn tất cả"/></th>-->
                                <th>Ảnh cửa hàng</th>
                                <th>Mã cửa hàng</th>
                                <th>Tên cửa hàng</th>
                                <th>Số điện thoại</th>
                                <th>Địa chỉ</th>
                                <th>Trạng thái</th>
                                <th>Thông tin chi tiết</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty stores}">
                                <tr>
                                    <td colspan="8" style="text-align:center; padding:16px;">Không có dữ liệu cửa hàng.</td>
                                </tr>
                            </c:if>

                            <c:forEach var="s" items="${stores}">
                                <tr>
<!--                                    <td><input type="checkbox" aria-label="Chọn cửa hàng ${s.storeId}"/></td>-->
                                    <td>
                                        <img class="store-thumb" src="${pageContext.request.contextPath}/img/logo2.jpg" alt="logo"/>
                                    </td>
                                    <td>${s.storeId}</td>
                                    <td>${s.storeName}</td>
                                    <td>${s.phone}</td>
                                    <td>${s.address}</td>
                                    <td>${s.status == 'Active' ? 'Đang hoạt động' : 'Ngừng hoạt động'}</td>
                                    <td>
                                        <a class="btn-detail"
                                           href="${pageContext.request.contextPath}/stores/view/${s.storeId}">
                                            <i class="fa fa-info-circle"></i> Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <nav class="pagination" aria-label="Phân trang">
                    <c:if test="${currentPage > 1}">
                        <a class="fa fa-angle-double-left"
                           href="${pageContext.request.contextPath}/stores?page=1&search=${searchKeyword}&status=${filterStatus}"
                           title="Trang đầu"></a>
                        <a class="fa fa-angle-left"
                           href="${pageContext.request.contextPath}/stores?page=${currentPage-1}&search=${searchKeyword}&status=${filterStatus}"
                           title="Trang trước"></a>
                    </c:if>

                    <c:forEach begin="${currentPage-2 > 1 ? currentPage-2 : 1}"
                               end="${currentPage+2 < totalPages ? currentPage+2 : totalPages}" var="i">
                        <a class="page-num ${currentPage == i ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/stores?page=${i}&search=${searchKeyword}&status=${filterStatus}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a class="fa fa-angle-right"
                           href="${pageContext.request.contextPath}/stores?page=${currentPage+1}&search=${searchKeyword}&status=${filterStatus}"
                           title="Trang sau"></a>
                        <a class="fa fa-angle-double-right"
                           href="${pageContext.request.contextPath}/stores?page=${totalPages}&search=${searchKeyword}&status=${filterStatus}"
                           title="Trang cuối"></a>
                    </c:if>
                </nav>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp"/>
    </body>
</html>
