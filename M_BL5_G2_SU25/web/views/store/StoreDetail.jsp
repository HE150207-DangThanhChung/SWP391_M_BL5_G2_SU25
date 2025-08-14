<%-- 
    Document   : StoreDetail.jsp
    Created on : 14 thg 8, 2025, 08:57:18
    Author     : truon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết của hàng</title>
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

            .content{
                display: grid;
                grid-template-columns: 1.5fr 3fr;
                background-color: white;
                margin: 25px 0;
                width: 70%;
                justify-self:  center;
                border-radius: 30px;
                padding-bottom: 3%;
                margin-bottom: 6.5%;
            }

            /*Left*/
            .left {
                display: flex;
                flex-direction: column; /* xếp dọc */
                align-items: center;    /* căn giữa ngang */
                justify-content: center;/* căn giữa dọc */
                margin: 10% 0;
                height: 95%;
                width: 100%;
                border-right: 2px solid #ccc;
            }

            .left img {
                border-radius: 15%;
                border: 4px solid #2bb6f0;
                margin-bottom: 1%;
            }

            /*Right*/
            .right h2{
                margin-top: 7%;
            }
            .right table {
                width: 68%;
                border-spacing: 15px;
                justify-self: center
            }

            .right button{
                background-color: #28a745;
                color: #fff;
                border-radius: 15px;
                padding: 8px 24px;
                border:none;
            }

            .right table td:first-child {
                /*width: 10%;*/
                font-size: 17px;
                white-space: nowrap; /* tránh bị xuống dòng label */
            }

            .right table td:last-child {
                width: 70%;
            }

            .right input[type="text"], .right input[type="date"]  {
                height: 35px;
                border: 3px solid black;
                border-radius: 15px;
                width: 100%;
                font-size: 16px;
                padding: 0 10px
            }

            .btn{
                margin-top: 1%;
            }
            .right h2,.btn  {
                text-align: center;
            }

            .right select {
                height: 41px;
                border: 3px solid black;
                border-radius: 16px;
                width: 108%;
                padding: 0 10px;
                font-size: 16px;
                background-color: white;
            }

            @media only screen and (max-width: 768px){
                .content {
                    grid-template-columns: 1fr;
                    width: 90%;
                }

                .left {
                    border-right: none;
                    border-bottom: 2px solid #ccc;
                    margin: 0;
                }

                .right{
                    height: 100%;
                }

                .right table {
                    width: 100%;
                }

                .right input[type="text"], .right input[type="date"]  {
                    width: 90%;
                }

                .right select {
                    width: 98%;
                }

            }


        </style>
    </head>
    <body>
        <div class="content">
            <div class="left">
                <img height="150" width="150" src="image/logo2.jpg" />
                <h2>
                </h2>
            </div>
            <div class="right ">
                <h2> Hồ sơ của </h2>
                <table>
                    <tr> 
                        <td> ID cửa hàng</td> 
                        <td> <input type="text"/> </td> 
                    </tr>
                    <tr> 
                        <td> Tên cửa hàng</td> 
                        <td> <input type="text"/> </td> 
                    </tr>
                    <tr> 
                        <td> Địa chỉ cửa hàng </td> 
                        <td> <input type="text"/> </td> 
                    </tr>
                    <tr> 
                        <td>Số điện thoại cửa hàng </td> 
                        <td> <input type="text"/> </td> 
                    </tr>
<!--                    <tr> 
                        <td>Ngày đăng kí cửa hàng </td> 
                        <td></i> <input type="date"/> </td> 
                    </tr>-->
                    
                </table>
                <div class="btn">
                    <button>Lưu</button> <button>Hủy bỏ</button>
                </div>
            </div>
        </div>


    </body>
</html>
