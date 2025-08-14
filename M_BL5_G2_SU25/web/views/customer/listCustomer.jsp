<%-- 
    Document   : listCustomer
    Created on : Aug 13, 2025, 8:46:45 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            :root{
                --page:#f7fafc;
                --panel:#e6f3ff;
                --chip:#a7f6ff;
                --ink:#0f172a;
                --accent:#ff0e7a;
                --stroke:#2b6777;
                --head:#bcd9ff;
                --shadow:0 8px 20px rgba(0,0,0,.06);
                --radius:12px;
            }
            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                padding:28px;
                background:var(--page);
                color:var(--ink);
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif
            }

            .toolbar{
                background:var(--panel);
                border:2px solid #b9d6ff;
                border-radius:16px;
                padding:12px;
                display:flex;
                flex-wrap:wrap;
                gap:12px;
                align-items:center;
                box-shadow:var(--shadow)
            }
            .toolbar input[type=text]{
                flex:1 1 380px;
                min-width:240px;
                padding:10px 14px;
                border:2px solid var(--stroke);
                border-radius:12px;
                background:var(--chip);
                font-weight:600
            }
            .btn{
                background:var(--chip);
                border:2px solid var(--stroke);
                border-radius:12px;
                padding:10px 16px;
                font-weight:700;
                cursor:pointer
            }
            .btn:hover{
                box-shadow:var(--shadow)
            }
            .btn-ghost{
                background:#fff
            }

            .table-wrap{
                margin-top:14px;
                background:#fff;
                border:2px solid #c9d7e3;
                border-radius:10px;
                overflow:hidden
            }
            table{
                width:100%;
                border-collapse:collapse
            }
            thead th{
                background:var(--head);
                text-align:left;
                padding:10px;
                border-bottom:2px solid #a8c6e8
            }
            tbody td{
                padding:12px 10px;
                border-bottom:1px solid #e6eef6
            }

            .col-actions{
                width:140px
            }
            .act{
                display:inline-block;
                min-width:70px;
                text-align:center;
                padding:8px 12px;
                border:2px solid var(--stroke);
                border-radius:10px;
                background:var(--chip);
                margin-right:8px
            }
            .act--danger{
                background:#ffd7e2
            }

            .footer-bar{
                display:flex;
                justify-content:space-between;
                align-items:center;
                gap:14px;
                background:var(--panel);
                border:2px solid #b9d6ff;
                border-radius:12px;
                padding:12px 16px;
                margin-top:18px
            }
            .summary{
                font-weight:700
            }

            .pager{
                display:flex;
                align-items:center;
                gap:8px
            }
            .page{
                display:inline-block;
                min-width:32px;
                text-align:center;
                padding:6px 10px;
                border:2px solid var(--stroke);
                border-radius:8px;
                background:#fff;
                text-decoration:none;
                color:inherit
            }
            .page--current{
                background:var(--chip);
                font-weight:800
            }

            /* Responsive */
            @media (max-width: 960px){
                .col-hide-md{
                    display:none
                }
            }
            @media (max-width: 720px){
                .col-hide-sm{
                    display:none
                }
                .toolbar{
                    padding:10px
                }
            }
        </style>
    </head>
    <body>
        <!-- Toolbar / Search & Filters -->
        <div class="toolbar">
            <input type="text" placeholder="Tìm kiếm theo trường 1, trường 2, trường 3" />
            <button class="btn">Tìm kiếm</button>

            <button class="btn">Filter 1</button>
            <button class="btn">Filter 2</button>
            <button class="btn">Filter 3</button>
            <button class="btn">Lọc</button>

            <button class="btn btn-ghost">Reset</button>
            <button class="btn">Action 1</button>
            <button class="btn">Action 2</button>
        </div>

        <!-- Data table -->
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Trường dữ liệu 1</th>
                        <th>Trường dữ liệu 2</th>
                        <th>Trường dữ liệu 3</th>
                        <th class="col-hide-sm">Trường dữ liệu 4</th>
                        <th class="col-hide-sm col-hide-md">Trường dữ liệu 5</th>
                        <th class="col-hide-md">Trường dữ liệu 6</th>
                        <th class="col-hide-sm">Trường dữ liệu 7</th>
                        <th class="col-actions">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>...</td><td>...</td><td>...</td><td class="col-hide-sm">...</td><td class="col-hide-sm col-hide-md">...</td><td class="col-hide-md">...</td><td class="col-hide-sm">...</td>
                        <td>
                            <a href="#" class="act">Sửa</a>
                            <a href="#" class="act act--danger">Xóa</a>
                        </td>
                    </tr>
                    <tr>
                        <td>...</td><td>...</td><td>...</td><td class="col-hide-sm">...</td><td class="col-hide-sm col-hide-md">...</td><td class="col-hide-md">...</td><td class="col-hide-sm">...</td>
                        <td>
                            <a href="#" class="act">Sửa</a>
                            <a href="#" class="act act--danger">Xóa</a>
                        </td>
                    </tr>
                    <!-- add more rows here -->
                </tbody>
            </table>
        </div>

        <!-- Footer: summary & pagination -->
        <div class="footer-bar">
            <div class="summary">Tổng có <span id="total">xxx</span> dữ liệu</div>
            <div>Hiển thị <strong>xxx</strong> mỗi trang</div>
            <nav class="pager" aria-label="Pagination">
                <a href="#" class="page" aria-label="Trang đầu">≪</a>
                <a href="#" class="page" aria-label="Trước">≪</a>
                <a href="#" class="page page--current">1</a>
                <a href="#" class="page">2</a>
                <a href="#" class="page">3</a>
                <a href="#" class="page" aria-label="Sau">≫</a>
                <a href="#" class="page" aria-label="Cuối">≫</a>
            </nav>
        </div>
    </body>
</html>
