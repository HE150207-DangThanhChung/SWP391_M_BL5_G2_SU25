<%-- 
    Document   : footer
    Created on : Aug 14, 2025, 9:12:56 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Footer Page</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f0f0f0;
                padding: 20px;
            }
            .footer {
                background-color: #cfe6ff;
                border-radius: 25px;
                padding: 20px;
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
            }
            .footer-left {
                flex: 1;
            }
            .footer-left h3 {
                color: #e91e63;
                margin-bottom: 10px;
            }
            .footer-left p {
                color: #e91e63;
                margin: 5px 0;
            }
            .footer-icons {
                margin-top: 15px;
                font-size: 30px;
                color: #2196f3;
            }
            .footer-icons span {
                margin-right: 15px;
                cursor: pointer;
            }
            .footer-right {
                flex: 2;
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 10px;
                align-items: start;
            }
            .footer-topic {
                position: relative;
            }
            .footer-topic > a {
                display: inline-block;
                background-color: #fff7b1;
                padding: 5px 10px;
                border-radius: 5px;
                text-decoration: none;
                color: #000;
                font-weight: bold;
            }
            .footer-topic:hover > a {
                background-color: orange;
                color: white;
            }
            .footer-topic ul {
                list-style: none;
                padding: 0;
                margin: 10px 0 0 0;
            }
            .footer-topic ul li a {
                text-decoration: none;
                color: #000;
                display: block;
                padding: 3px 0;
            }
            .footer-topic ul li a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <footer class="footer">
            <div class="footer-left">
                <h3>Happy Sale</h3>
                <p><strong>Credit</strong> This page is created by Group 2</p>
                <p><strong>About</strong> This page is created by Group 2</p>
                <div class="footer-icons">
                    <span>☕</span>
                    <span>📦</span>
                    <span>💼</span>
                </div>
            </div>
            <div class="footer-right">
                <div class="footer-topic">
                    <a href="#">Sản phẩm</a>
                    <ul>
                        <li><a href="#">Laptop</a></li>
                        <li><a href="#">Điện thoại</a></li>
                        <li><a href="#">Linh kiện</a></li>
                    </ul>
                </div>
                <div class="footer-topic">
                    <a href="#">Cửa hàng</a>
                    <ul>
                        <li><a href="#">Hà Nội</a></li>
                        <li><a href="#">TP Hồ Chí Minh</a></li>
                        <li><a href="#">Đà Nẵng</a></li>
                    </ul>
                </div>
                <div class="footer-topic">
                    <a href="#">Thông tin</a>
                    <ul>
                        <li><a href="#">Nhân viên</a></li>
                        <li><a href="#">Doanh thu</a></li>
                        <li><a href="#">Liên lạc</a></li>
                    </ul>
                </div>
            </div>
        </footer>

    </body>
</html>
