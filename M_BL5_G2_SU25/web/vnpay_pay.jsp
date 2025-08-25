<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nạp tiền</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
        <link rel="stylesheet" href="assets/css/main.css" />
        <style>
            body {
                background-color: #f8f9fa;
                font-family: Arial, sans-serif;
                color: #333;
            }
            .container {
                max-width: 500px;
                margin-top: 50px;
                padding: 30px;
                background: #ffffff;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }
            .header h3 {
                color: #007bff;
                font-weight: bold;
                margin-bottom: 20px;
            }
            .form-group label {
                font-weight: 600;
            }
            .form-control {
                border-radius: 5px;
                padding: 10px;
                margin-bottom: 15px;
            }
            .btn-default {
                background-color: #007bff;
                color: #fff;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                transition: background 0.3s;
            }
            .btn-default:hover {
                background-color: #0056b3;
            }
            .btn {
                color: #007bff;
                padding: 8px 20px;
                text-decoration: none;
                transition: color 0.3s;
            }
            .btn:hover {
                color: #0056b3;
            }
            h4 {
                font-size: 1.2em;
                color: #555;
                margin-top: 20px;
                font-weight: 600;
            }
            input[type="radio"] {
                margin-right: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header clearfix row d-flex justify-content-center align-items-center">
                <div class="col-lg-6 align-middle">
                    <h3 class="text-muted">Thanh Toán</h3>
                </div>
                <div class="col-lg-6 text-end">
                    <a href="homecustomer">
                        <img src="assets/images/logo/newlogo.png" alt="Logo" style="width: 100%">
                    </a>
                </div>
            </div>
            <form action="payment" id="frmCreateOrder" method="post">
                <div class="form-group">
                    <label for="amount">Số tiền</label>
                    <input class="form-control" id="amount" name="amount" type="number" value="${price}" readonly />
                </div>
                <input type="hidden" id="cartId" name="cartId" value="${requestScope.cartId}" />
                <input type="hidden" id="name" name="id" value="${sessionScope.user.getUserID()}" />
                <input type="hidden" id="date" name="date" value="${requestScope.date}" />
                <input type="hidden" id="address" name="address" value="${requestScope.address}" />
                <input type="hidden" id="products" name="products" value="${requestScope.products}" />
                <input type="hidden" id="quantity" name="quantity" value="${requestScope.quantity}" />
                <input type="hidden" id="prices" name="prices" value="${requestScope.prices}" />
                <h4>Chọn phương thức thanh toán</h4>
                <div class="form-group">
                    <input type="radio" name="bankCode" value="" checked /> Cổng thanh toán VNPAYQR <br>
                    <input type="radio" name="bankCode" value="VNPAYQR" /> Ứng dụng hỗ trợ VNPAYQR <br>
                    <input type="radio" name="bankCode" value="VNBANK" /> Thẻ ATM/Tài khoản nội địa <br>
                    <input type="radio" name="bankCode" value="INTCARD" /> Thẻ quốc tế <br>
                </div>
                <h4>Chọn ngôn ngữ</h4>
                <div class="form-group">
                    <input type="radio" name="language" value="vn" checked /> Tiếng Việt <br>
                    <input type="radio" name="language" value="en" /> English <br>
                </div>

                <button type="submit" class="btn btn-primary text-white">Thanh toán</button>
                <a href="homecustomer" class="btn">Quay lại trang chủ</a>
            </form>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script type="text/javascript">
            $("#frmCreateOrder").submit(function (e) {
                e.preventDefault();
                const postData = $(this).serialize();
                $.ajax({
                    type: "POST",
                    url: $(this).attr("action"),
                    data: postData,
                    dataType: 'json',
                    success: function (response) {
                        if (response.code === '00') {
                            if (window.vnpay) {
                                vnpay.open({width: 768, height: 600, url: response.data});
                            } else {
                                window.location.href = response.data;
                            }
                        } else {
                            alert(response.message);
                        }
                    }
                });
            });
        </script>
    </body>
</html>
