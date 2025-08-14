<%-- 
    Document   : listStore
    Created on : Aug 13, 2025, 8:49:14 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                display: grid;
                grid-template-columns: 3fr 1.6fr;
                margin-bottom: 2%;

            }

            .search i{
                position: absolute;
                left: 12px;
                top: 35%;
                font-size: 18px;
                color: #000;
            }

            .search input {
                width: 60%;
                padding: 8px 16px 8px 36px;
                border-radius: 12px;
                border: none;
                font-size: 17px;
                font-weight: 400;
                color: #000;
                background-color: #fff;
                height: 45px;
            }

            .feature{
                display: grid;
                grid-template-columns: 1.4fr 1fr 1fr;
                gap: 10px;
            }
            .feature button{
                background-color: #F28705;
                color: #fff;
                width: 90%;
                border-radius: 10px;
                height: 45px;
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
                    <div>
                        <i class="fa fa-search" ></i>
                        <input type="search" placeholder="Theo tên cửa hàng"/>
                    </div>
                    <div class="feature">
                        <button onclick="window.location.href = 'addStore.jsp'">➕ Thêm cửa hàng</button>
                        <button>📤 Nhập file</button>
                        <button>📥 Xuất file</button>
                    </div>


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
                                <th>Thông tin chi tiết</th>

                            </tr>
                        </thead>
                        <tbody>
                            <!--Note: 10 row 1 trang-->
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><img height="50" width=50" src="/img/logo2.jpg"/> </td>
                                <td>1</td>
                                <td>Iphone</td>
                                <td>0123456789</td>

                                <td>Thạch Hòa</td>
                                <td><button onclick="window.location.href = 'StoreDetail.jsp'">Chi tiết</button></td>


                            </tr>

                            <tr><td colspan="8"></td></tr>
                            <tr><td colspan="8"></td></tr>
                            <tr><td colspan="8"></td></tr>
                            <tr><td colspan="8"></td></tr>
                            <tr><td colspan="8"></td></tr>
                            <tr><td colspan="8"></td></tr>
                            <tr><td colspan="8"></td></tr>
                            <tr><td colspan="8"></td></tr>
                            <tr><td colspan="8"></td></tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <nav class="pagination" aria-label="Pagination">
                    <button class="fa fa-angle-double-left"></button>
                    <button class="fa fa-angle-left"></button>
                    <button class="page-num " >1</button>
                    <button class="page-num">2</button>
                    <button class="page-num">3</button>
                    <button title="Next page" class="fa fa-angle-right"></button>
                    <button title="Last page" class="fa fa-angle-double-right"></button>
                </nav>
            </div>
        </div>


    </body>
</html>
