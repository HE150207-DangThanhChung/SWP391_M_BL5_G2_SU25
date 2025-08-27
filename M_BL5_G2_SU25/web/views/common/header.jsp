<%-- 
    Document   : header
    Created on : Aug 14, 2025, 9:12:51 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Header Page</title>
        <style>
            :root{
                --bar-bg:#cfe6ff;         /* light blue */
                --chip-bg:#fff7b1;        /* pale yellow */
                --chip-text:#1b1c1d;
                --btn-bg:#9b5cf1;         /* purple */
                --btn-text:#ffffff;
                --ring:#8bb7ff;           /* outline ring */
                --radius:16px;
                --shadow:0 8px 20px rgba(0,0,0,.08);
            }

            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                padding:32px;
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif;
                color:#222;
                background:#f7fafc;
            }

            /* Wrapper just for demo spacing */
            .demo{
                display:grid;
                gap:40px
            }

            /* NAVBAR */
            .navbar{
                background:var(--bar-bg);
                /*border-radius:22px;  slightly rounder than inside chips */
                padding:14px 20px;
                box-shadow:var(--shadow);
                border:2px solid #b9d6ff;
                display:flex;
                align-items:center;
                gap:20px;
            }

            .brand{
                font-weight:700;
                font-size:20px;
                padding:8px 12px;
                background:var(--chip-bg);
                color:var(--chip-text);
                border-radius:10px;
                white-space:nowrap;
            }

            /* centered menu */
            .menu{
                list-style:none;
                margin:0;
                padding:0;
                display:flex;
                gap:28px;
                align-items:center;
                flex:1;
                justify-content:center;
            }

            .menu > li{
                position:relative;
            }

            .chip{
                display:inline-block;
                padding:10px 14px;
                background:var(--chip-bg);
                color:var(--chip-text);
                border-radius:8px;
                font-weight:500;
                text-decoration:none;
                transition:transform .15s ease;
            }
            .chip:hover{
                transform:translateY(-1px);
            }

            /* dropdown under a top-level item */
            .submenu{
                position:absolute;
                left:0;
                top:100%;
                margin-top:8px;
                min-width:160px;
                background:var(--chip-bg);
                border-radius:10px;
                border:1px solid #efe39a;
                box-shadow:var(--shadow);
                display:grid;
                gap:6px;
                padding:10px;
                opacity:0;
                pointer-events:none;
                transform:translateY(6px);
                transition:opacity .15s ease, transform .15s ease;
                z-index:10;
            }
            .menu > li:hover > .submenu{
                opacity:1;
                pointer-events:auto;
                transform:translateY(0);
            }

            .submenu a{
                text-decoration:none;
                color:#222;
                padding:8px 10px;
                border-radius:8px;
                display:block;
            }
            .submenu a:hover{
                background:#fff3a1;
            }

            /* Right action button with stacked dropdown */
            .action{
                margin-left:auto;
                position:relative;
            }
            .btn{
                background:var(--btn-bg);
                color:var(--btn-text);
                border:none;
                cursor:pointer;
                font-weight:700;
                padding:14px 24px;
                border-radius:20px;
                outline:2px solid #7f49e8;
                outline-offset:0;
                box-shadow:var(--shadow);
            }

            .action-menu{
                position:absolute;
                right:0;
                top:100%;
                margin-top:10px;
                display:flex;
                flex-direction:column;
                gap:10px;
                opacity:0;
                pointer-events:none;
                transform:translateY(6px);
                transition:opacity .15s ease, transform .15s ease;
                z-index:12;
            }

            .action:has(:hover), .action:hover{
                isolation:isolate;
            }
            .action:hover .action-menu{
                opacity:1;
                pointer-events:auto;
                transform:translateY(0);
            }

            .action-item{
                background:var(--btn-bg);
                color:var(--btn-text);
                border-radius:18px;
                padding:14px 22px;
                min-width:180px;
                text-align:center;
                box-shadow:var(--shadow);
            }

            /* Make each successive item align like a stacked popover under the button */
            .action-menu .action-item:nth-child(1){
                margin-right:0;
            }
            .action-menu .action-item:nth-child(2){
            }
            .action-menu .action-item:nth-child(3){
            }

            /* Responsive tweaks */
            @media (max-width: 900px){
                .menu{
                    gap:16px;
                }
            }
            @media (max-width: 720px){
                .navbar{
                    flex-wrap:wrap;
                    row-gap:12px;
                }
                .menu{
                    order:3;
                    flex:1 1 100%;
                    justify-content:flex-start;
                }
                .action{
                    order:2;
                    margin-left:0;
                }
            }
            .dropbtn {
                background-color: blue;
                color: white;
                padding: 16px;
                font-size: 16px;
                border: none;
                cursor: pointer;
            }

            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #f9f9f9;
                min-width: 160px;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                z-index: 1;
            }

            .dropdown-content a {
                color: black;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
            }

            .dropdown-content a:hover {
                background-color: #f1f1f1
            }

            .dropdown:hover .dropdown-content {
                display: block;
            }

            .dropdown:hover .dropbtn {
                background-color: #B266FF;
            }
        </style>
    </head>
    <body>
        <div class="demo">

            <nav class="navbar">
                <div class="dropdown">
                    <h4><%
                        // Lay username tu trong session
                        String username = (String) session.getAttribute("tendangnhap");
                        if (session != null) {
                            out.print("Xin chào " + username);
                        } else {
                            // Neu chua dang nhap thi se la khach
                            out.print("Xin chào quý khách");
                        }
                        %>
                    </h4>                           
                </div>
                <div style="margin-left:auto; display:flex; align-items:center; gap:24px;">
                </div>
                <ul class="menu">
                    <li>
                        <div class="dropdown">
                            <button class="dropbtn">Cửa Hàng</button>
                            <div class="dropdown-content">
                                <a href="#">Chi Nhánh</a>
                                <a href="#">Doanh Thu</a>
                                <a href="#">Phản Hồi</a>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="dropdown">
                            <button class="dropbtn">Sản Phẩm</button>
                            <div class="dropdown-content">
                                <a href="#">Nhãn Hàng</a>
                                <a href="#">Danh Mục</a>
                                <a href="#">Nhà Phân Phối</a>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="dropdown">
                            <button class="dropbtn">Nhân Viên</button>
                            <div class="dropdown-content">
                                <a href="#">Hồ Sơ</a>
                                <a href="#">Tiến Độ</a>

                            </div>
                        </div>
                    </li>

                </ul>
                <div class="dropdown">
                    <button class="dropbtn">Hồ Sơ</button>
                    <div class="dropdown-content">
                        <a href="${pageContext.request.contextPath}/profile">Cá Nhân</a>
                        <a href="#">Cài Đặt</a>
                        <c:url var="logoutUrl" value="/logout"/>
                        <a href="${logoutUrl}">Đăng Xuất</a>

                    </div>
                </div>
            </nav>
        </div>
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        </script>
    </body>
</html>
