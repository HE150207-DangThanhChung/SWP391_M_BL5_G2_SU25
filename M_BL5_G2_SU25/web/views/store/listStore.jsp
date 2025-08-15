<%-- 
    Document   : listStore
    Created on : Aug 13, 2025, 8:49:14 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách Cửa hàng</title>

        <!--        <link
                    rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
                    />-->

        <style>

            body {
                margin: 0;
                font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont,
                    "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif,
                    "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
                background-color: #ccc;
                color: #000;
                font-weight: 400;
                font-size: 14px;
                line-height: 1.5;
            }

            button {
                background: none;
                border: none;
                cursor: pointer;
                padding: 0;
                font: inherit;
                color: inherit;
            }

            input[type="checkbox"] {
                width: 16px;
                height: 16px;
            }


            .content{
                margin: 30px;
                display: grid;
                grid-template-columns: 1fr 4fr;
                gap: 5%;
            }

            /*Left filters*/
            .content-left {
                display: flex;
                flex-direction: column;
                gap: 25px;
                width: 100%;
                font-size: 16px
            }

            .content-left h2 {
                font-weight: 700;
                font-size: 28px;
                margin: 0;
            }

            .filter-box {
                background-color: #fff;
                border-radius: 12px;
                padding-top: 16px;
                width: 100%;
                min-height: 150px;
            }

            .filter-box header,.filter-box form{
                margin: 0 20px;
            }

            .filter-box span{
                font-weight: bold
            }

            .filter-box form input {
                width: 16px;
                height: 16px;
                margin-left:  16px;
            }

            .filter-box form label {
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 400;
                font-size: 15px;
                color: #4a4a4a;
            }

            /*Right content*/

            /*Search*/
            .search{
                position: relative;
                margin-bottom: 2%;
            }

            .search form {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 10px;
            }

            .search-left {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .search-input-wrapper {
                position: relative;
            }

            .search i{
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 18px;
                color: #000;
            }

            .search input {
                width: 320px;
                padding: 8px 16px 8px 36px;
                border-radius: 10px;
                border: 1px solid #ccc;
                font-size: 16px;
                font-weight: 400;
                color: #000;
                background-color: #fff;
                height: 45px;
            }

            .feature {
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: nowrap;
                margin-left: auto;
            }
            .feature button, .feature a, .feature select {
                height: 45px;
                border-radius: 10px;
                font-size: 16px;
                white-space: nowrap;
            }
            .feature button, .feature a {
                background-color: #F28705;
                color: #fff;
                border: none;
                padding: 0 16px;
                text-decoration: none;
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 135px;
            }
            .feature select {
                background-color: #fff;
                color: #000;
                border: 1px solid #ccc;
                padding: 0 10px;
                min-width: 150px;
            }

            /*Table container*/
            .table-container {
                /*overflow-x: auto;*/
                border-radius: 12px;
                text-align: center;
            }

            .table-container button {
                background-color: #28a745;
                color: #fff;
                width: 50%;
                border-radius: 10px;
                height: 45px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                border-radius: 12px;
                overflow: hidden;
            }
            thead tr {
                background-color: #A9A9A9;
                color: #000;
                font-weight: 700;
                font-size: 14px;
            }
            thead th {
                padding: 8px 12px;
                font-size: 16px;
                height: 40px
            }
            thead th:first-child {
                border-top-left-radius: 12px;
            }
            thead th:last-child {
                border-top-right-radius: 12px;
            }
            tbody tr {
                font-weight: 400;
                font-size: 16px;
                color: #000;
                height: 50px;
            }
            tbody tr:nth-child(odd) {
                background-color: #fff;
            }
            tbody tr:nth-child(even) {
                background-color: #f0f0f3;
            }
            tbody td {
                padding: 8px 12px;
            }

            /*Pagination*/
            .pagination {
                display: flex;
                align-items: center;
                gap: 12px;
                font-weight: 700;
                font-size: 18px;
                margin-top: 10px;
            }
            .pagination button {
                border: none;
                background: none;
                cursor: pointer;
                color: #000;
                font-weight: 700;
                font-size: 18px;
                padding: 0;
                height: 25px;
            }

            .pagination .page-num {
                border: 1px solid #000;
                border-radius: 6px;
                padding: 2px 8px;
                font-weight: 700;
                font-size: 14px;
                line-height: 1;
                cursor: pointer;
                background-color: #fff;
            }


            /*Responsive*/
            @media only screen and (max-width: 768px){
                .content{
                    display:flex;
                    flex-direction: column;
                }

                .filter-box {
                    width: 100%;
                }

                .feature {
                    grid-template-columns: 1fr;
                }

                .feature {
                    display: grid;
                    grid-template-columns: 1fr 1fr 1fr;
                }

                .search {
                    margin-top: 5%;
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .search input{
                    width: 100%
                }

                .search i {
                    top: 14%
                }

                .table-container {
                    overflow-x: auto;  /* Cho phép cuộn ngang trên mobile */
                }

                .pagination{
                    justify-self: center
                }
            }


        </style>
    </head>
    <body>



        <!-- Left Content -->
        <div class="content">
            <div class="content-left" >
                <h2>Cửa hàng</h2>

                <!-- Filter 1 -->
                <!--                <section class="filter-box" >
                                    <header>
                                        <span>Trạng thái cửa hàng</span>
                                        <i class="fa fa-chevron-down"></i>
                                    </header>
                
                                </section>
                
                                 Filter 2 
                                <section class="filter-box">
                                    <header>
                                        <span>Chi nhánh làm việc</span>
                                        <div style="display:flex; align-items:center; gap:8px;">
                                            <i class="fa fa-plus" ></i>
                                            <i class="fa fa-chevron-down" ></i>
                                        </div>
                                    </header>
                                </section>
                
                                 Filter 3 
                                <section class="filter-box">
                                    <header>
                                        <span>Chức danh</span>
                                        <i class="fa fa-chevron-down" ></i>
                                    </header>
                                </section>-->
            </div>

            <!-- Right Content -->
            <div class="">
                <!-- Search bar -->
                <div class="search">
                    <form action="${pageContext.request.contextPath}/stores" method="get">
                        <div class="search-left">
                            <div class="search-input-wrapper">
                                <i class="fa fa-search"></i>
                                <input type="search" name="search" value="${searchKeyword}" placeholder="Theo tên cửa hàng"/>
                            </div>
                            <select name="status" class="form-select">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Active" ${filterStatus == 'Active' ? 'selected' : ''}>Đang hoạt động</option>
                                <option value="Inactive" ${filterStatus == 'Inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                            </select>
                            <button type="submit">🔍 Tìm kiếm</button>
                        </div>
                        <div class="feature">
                            <a href="${pageContext.request.contextPath}/stores/add" class="btn-add">➕ Thêm cửa hàng</a>
                            <button type="button">📤 Nhập file</button>
                            <button type="button">📥 Xuất file</button>
                        </div>
                    </form>


                </div>



                <!-- Table container -->
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th><input type="checkbox"/></th>
                                <th>Ảnh của hàng</th>
                                <th>Mã cửa hàng</th>
                                <th>Tên cửa hàng</th>
                                <th>Số điện thoại</th>

                                <th>Địa chỉ</th>
                                <th>Trạng thái</th>
                                <th>Thông tin chi tiết</th>

                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${stores}">
                                <tr>
                                    <td><input type="checkbox"/></td>
                                    <td>
                                        <img height="50" width="50" src="${pageContext.request.contextPath}/img/logo2.jpg" alt="logo"/>
                                    </td>
                                    <td>${s.storeId}</td>
                                    <td>${s.storeName}</td>
                                    <td>${s.phone}</td>
                                    <td>${s.address}</td>
                                    <td>${s.status == 'Active' ? 'Đang hoạt động' : 'Ngừng hoạt động'}</td>
                                    <td>
                                        <button onclick="window.location.href = '${pageContext.request.contextPath}/stores/view/${s.storeId}'">Chi tiết</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->

                <nav class="pagination" aria-label="Pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/stores?page=1&search=${searchKeyword}&status=${filterStatus}" class="fa fa-angle-double-left"></a>
                        <a href="${pageContext.request.contextPath}/stores?page=${currentPage-1}&search=${searchKeyword}&status=${filterStatus}" class="fa fa-angle-left"></a>
                    </c:if>
                    <c:forEach begin="${currentPage-2 > 0 ? currentPage-2 : 1}" end="${currentPage+2 < totalPages ? currentPage+2 : totalPages}" var="i">
                        <a href="${pageContext.request.contextPath}/stores?page=${i}&search=${searchKeyword}&status=${filterStatus}" class="page-num ${currentPage == i ? 'active' : ''}">${i}</a>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/stores?page=${currentPage+1}&search=${searchKeyword}&status=${filterStatus}" class="fa fa-angle-right"></a>
                        <a href="${pageContext.request.contextPath}/stores?page=${totalPages}&search=${searchKeyword}&status=${filterStatus}" class="fa fa-angle-double-right"></a>
                    </c:if>
                </nav>

                </body>
                </html>
