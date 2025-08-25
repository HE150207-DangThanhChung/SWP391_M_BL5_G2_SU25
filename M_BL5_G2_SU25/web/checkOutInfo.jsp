<%-- 
    Document   : checkOutInfo
    Created on : Oct 29, 2024, 10:39:52 AM
    Author     : Hello
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="no-js" lang="zxx">

    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="x-ua-compatible" content="ie=edge" />
        <title>Checkout</title>
        <meta name="description" content="" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />

        <!-- ========================= CSS here ========================= -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
        <link rel="stylesheet" href="assets/css/LineIcons.3.0.css" />
        <link rel="stylesheet" href="assets/css/tiny-slider.css" />
        <link rel="stylesheet" href="assets/css/glightbox.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <script src="https://esgoo.net/scripts/jquery.js"></script>
        <link rel="stylesheet" href="assets/css/main.css" />
        <link rel="stylesheet" href="assets/css/homecss.css" />

        <style>

            .nested-menu {
                display: none; /* Hide by default */
                position: absolute; /* Position the submenu absolutely */
                left: 100%; /* Align to the right of the parent */
                top: 0; /* Align with the top of the parent */
                width: 100%; /* Set width to 100% of the parent */
                background-color: #fff; /* Optional: set a background color */
                z-index: 1000; /* Ensure it's above other elements */
            }

            .nested-menu.show {
                display: block; /* Show when toggled */
            }

            .nav-item:hover > .nested-menu {
                display: block; /* Show on hover */
            }

            /* Style for the tabs */
            .nav-tabs .nav-link {
                border: 1px solid #ddd !important;
                padding: 10px 15px;
                margin-right: 5px;
                background-color: #f8f9fa !important; /* Light grey background */
                color: #333; /* Darker text color */
                font-weight: 500;
                transition: background-color 0.3s, color 0.3s;
            }

            .nav-tabs .nav-link:hover {
                background-color: #e9ecef; /* Slightly darker on hover */
            }

            .nav-tabs .nav-link.active {
                background-color: #007bff !important;
                color: white !important;
                border: 1px solid white !important;
            }

            /* Style for tab content */
            .tab-pane {
                padding: 20px;
                background-color: #fff;
                border: 1px solid #ddd;
                border-top: none;
                box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
                border-radius: 0 0 5px 5px;
            }

            /* Form inputs styling */
            input[type="text"], input[type="file"], input[type="email"], input[type="password"] {
                width: 100%;
                padding: 10px;
                border-radius: 4px;
                border: 1px solid #ddd;
                box-shadow: none;
            }

            button[type="submit"] {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                font-size: 16px;
                cursor: pointer;
            }

            button[type="submit"]:hover {
                background-color: #0056b3;
            }

            .profile-info {
                margin-bottom: 15px;
            }

            .profile-info label {
                font-weight: bold;
                margin-bottom: 5px;
                display: block;
                text-align: left;
            }

            .profile-info .form-control {
                width: 100%;
                padding: 10px;
                border-radius: 4px;
                border: 1px solid #ddd;
            }
            .payment-method {
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 8px;
                background-color: #f9f9f9;
            }

            .payment-method:hover {
                background-color: #e9ecef;
            }

            .payment-method img {
                margin-bottom: 8px;
            }
            .checkinfo{
                text-align: center;
            }
            main {
                max-width: 800px; /* Điều chỉnh theo kích thước mong muốn */
                margin: 0 auto; /* Canh giữa trang */
                padding: 20px; /* Giảm padding để tiết kiệm không gian */
            }

            .css_select_div{
            }
            .css_select{
                width: 28%;
                padding: 5px;
                margin: 5px 2%;
                border: solid 1px #686868;
                border-radius: 5px;
            }
            .modal-body{
                text-align: start

            }
        </style>
    </head>

    <body>
        <!--[if lte IE 9]>
          <p class="browserupgrade">
            You are using an <strong>outdated</strong> browser. Please
            <a href="https://browsehappy.com/">upgrade your browser</a> to improve
            your experience and security.
          </p>
        <![endif]-->

        <div class="preloader">
            <div class="preloader-inner">
                <div class="preloader-icon">
                    <span></span>
                    <span></span>
                </div>
            </div>
        </div>
        <!-- Start Header Area -->
        <header class="header navbar-area container">
            <jsp:include page="header.jsp"></jsp:include>
            <jsp:include page="menu.jsp"></jsp:include>
            </header>
            <!-- Profile 1 - Bootstrap Brain Component -->

            <main class="bg-light py-3 py-md-5 py-xl-8 ">
                <div class="container text-center ">
                    <form action="checkoutInfo" method="post" >
                        <input type="hidden" name="price" value="${price}">
                    <div class="">
                        <div class="card widget-card border-light shadow-sm">
                            <div class="card-body p-4">
                                <ul class="nav nav-tabs" id="profileTab" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview-tab-pane" type="button" role="tab" aria-controls="overview-tab-pane" aria-selected="true" onclick="return validateTab(1)">
                                            Đơn hàng của bạn
                                        </button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="technique-tab" data-bs-toggle="tab" data-bs-target="#technique-tab-pane" type="button" role="tab" aria-controls="technique-tab-pane" aria-selected="false" onclick="return validateTab(2)">
                                            Thông tin nhận hàng
                                        </button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="confirm-tab" data-bs-toggle="tab" data-bs-target="#confirm-tab-pane" type="button" role="tab" aria-controls="confirm-tab-pane" aria-selected="false" onclick="return validateTab(3)">
                                            Phương thức thanh toán
                                        </button>
                                    </li>
                                </ul>
                                <div class="tab-content" id="overiewTabContent">
                                    <div class="tab-pane fade show active" id="overview-tab-pane" role="tabpanel" aria-labelledby="overview-tab" tabindex="0">
                                        <c:forEach items="${listCI}" var="liCI">
                                            <div class="row border-top border-bottom">
                                                <div class="row main align-items-center">
                                                    <c:forEach items="${listP}" var="liP">
                                                        <c:if test="${liCI.getProductID() == liP.getProductID()}">
                                                            <c:set var="quatity" value="${liCI.getQuatity()}" />
                                                            <c:set var="priceString" value="${liP.getPrice()}" />
                                                            <c:set var="cleanedPrice" value="${fn:replace(priceString, '.', '')}" />
                                                            <c:set var="totalPrice" value="${(cleanedPrice != null) ? (cleanedPrice * quatity) : 0}" />
                                                            <div class="col-2"><img class="img-fluid" src="${liP.getImageLink()}"></div>
                                                            <div class="col-5 product-name" data-product-id="${liP.getProductID()}">
                                                                <div class="row text-primary">${liP.getProductName()}</div>
                                                            </div>
                                                            <div class="col">
                                                                <span class="border p-2">${quatity}</span>  
                                                            </div>
                                                            <div class="col text-end">

                                                                <fmt:formatNumber value="${totalPrice}" type="number" pattern="#,##0"/>
                                                                <c:set var="grandTotal" value="${grandTotal + totalPrice}"  />
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        <div class="total-price mt-3" style="text-align: right; padding-right: 24px">
                                            <strong>Tổng tiền: </strong> <fmt:formatNumber value="${price}" type="number" pattern="#,##0"/>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="technique-tab-pane" role="tabpanel" aria-labelledby="technique-tab" tabindex="0">
                                        <div class="profile-info">

                                            <input type="hidden" id="billoflading" name="billoflading" value="${billoflading}" class="form-control" readonly>
                                        </div>
                                        <div class="profile-info">
                                            <label for="firstName" class="form-label">Họ và tên:</label>
                                            <input type="text" id="firstName" name="firstName" value="${u.getFirstName()} ${u.getLastName()}" class="form-control"  readonly>
                                        </div>
                                        <div class="profile-info">
                                            <label for="email" class="form-label">Email:</label>
                                            <input type="email" id="email" name="email" value="${u.getEmail()}" class="form-control" readonly>
                                        </div>
                                        <div class="profile-info">
                                            <label for="phone" class="form-label">Số điện thoại:</label>
                                            <input type="text" id="phone" name="phone" value="${u.getPhoneNumber()}" class="form-control"  readonly>
                                        </div>
                                        <div class="profile-info">
                                            <label for="address" class="form-label">Địa chỉ:</label>
                                            <div class="input-group">
                                                <input id="address" name="address" class="form-control" value="${u.getAddress()}" required readonly>
                                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#changeAddressModal">
                                                    Thay đổi địa chỉ
                                                </button>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="modal fade" id="changeAddressModal" tabindex="-1" aria-labelledby="changeAddressModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="changeAddressModalLabel">Thay đổi địa chỉ giao hàng</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label for="newAddress" class="form-label">Địa chỉ mới:</label>
                                                        <div class="css_select_div mb-1">
                                                            <select class="css_select" id="tinh" name="tinh" title="Chọn Tỉnh Thành">
                                                                <option value="0">Tỉnh Thành</option>
                                                            </select> 
                                                            <select class="css_select" id="quan" name="quan" title="Chọn Quận Huyện">
                                                                <option value="0">Quận Huyện</option>
                                                            </select> 
                                                            <select class="css_select" id="phuong" name="phuong" title="Chọn Phường Xã">
                                                                <option value="0">Phường Xã</option>
                                                            </select>
                                                        </div>
                                                        <label class="form-label">Địa chỉ cụ thể (Số nhà/Ngõ):</label>
                                                        <input type="text" id="specificAddress" class="form-control">
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                    <button type="button" class="btn btn-primary" onclick="updateAddress()">Cập nhật</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Tab 3:  -->
                                    <div class="tab-pane fade" id="confirm-tab-pane" role="tabpanel" aria-labelledby="email-tab" tabindex="0">
                                        <div class="row justify-content-center">
                                            <!-- Column for COD payment method -->
                                            <div class="col-md-5 text-center">
                                                <div class="payment-method">
                                                    <input type="radio" id="cod" name="paymentMethod" value="COD" class="form-check-input d-flex " checked>
                                                    <label for="cod" class="payment-label">
                                                        <img src="assets/images/logo/shopping-cart.png" alt="COD" class="payment-icon">
                                                        <span class="payment-text">Thanh toán khi nhận hàng (COD)</span>
                                                    </label>
                                                </div>
                                            </div>

                                            <!-- Column for VNPAY payment method -->
                                            <div class="col-md-5 text-center">
                                                <div class="payment-method">
                                                    <input type="radio" id="vnpay" name="paymentMethod" value="VNPAY" class="form-check-input d-flex" >
                                                    <label for="vnpay" class="payment-label">
                                                        <img src="assets/images/logo/vnpay-logo.png" alt="VNPAY" class="payment-icon">
                                                        <span class="payment-text">Thanh toán qua VNPAY</span>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-between">
                                            <input type="hidden" name="uid" value="${sessionScope.user.getUserID()}">
                                            <input type="hidden" value="${cart.getCartID()}" name="cartId"/>
                                            <button type="button" class="btn btn-danger mt-4 p-2 w-100 me-2" onclick="history.back()">Quay lại</button>
                                            <button type="submit" class="btn btn-primary mt-4 w-100">Thanh toán</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </main>
        <!-- Start Footer Area -->
        <jsp:include page="footer.jsp"></jsp:include>
        <!--/ End Footer Area -->

        <!-- ========================= scroll-top ========================= -->
        <a href="#" class="scroll-top">
            <i class="lni lni-chevron-up"></i>
        </a>

        <!-- ========================= JS here ========================= -->
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/tiny-slider.js"></script>
        <script src="assets/js/glightbox.min.js"></script>
        <script src="assets/js/main.js"></script>
        <script type="text/javascript"></script>
        <script>
                                            $(document).ready(function () {
                                                //Lấy tỉnh thành
                                                $.getJSON('https://esgoo.net/api-tinhthanh/1/0.htm', function (data_tinh) {
                                                    if (data_tinh.error == 0) {
                                                        $.each(data_tinh.data, function (key_tinh, val_tinh) {
                                                            $("#tinh").append('<option value="' + val_tinh.id + '">' + val_tinh.full_name + '</option>');
                                                        });
                                                        $("#tinh").change(function (e) {
                                                            var idtinh = $(this).val();
                                                            //Lấy quận huyện
                                                            $.getJSON('https://esgoo.net/api-tinhthanh/2/' + idtinh + '.htm', function (data_quan) {
                                                                if (data_quan.error == 0) {
                                                                    $("#quan").html('<option value="0">Quận Huyện</option>');
                                                                    $("#phuong").html('<option value="0">Phường Xã</option>');
                                                                    $.each(data_quan.data, function (key_quan, val_quan) {
                                                                        $("#quan").append('<option value="' + val_quan.id + '">' + val_quan.full_name + '</option>');
                                                                    });
                                                                    //Lấy phường xã  
                                                                    $("#quan").change(function (e) {
                                                                        var idquan = $(this).val();
                                                                        $.getJSON('https://esgoo.net/api-tinhthanh/3/' + idquan + '.htm', function (data_phuong) {
                                                                            if (data_phuong.error == 0) {
                                                                                $("#phuong").html('<option value="0">Phường Xã</option>');
                                                                                $.each(data_phuong.data, function (key_phuong, val_phuong) {
                                                                                    $("#phuong").append('<option value="' + val_phuong.id + '">' + val_phuong.full_name + '</option>');
                                                                                });
                                                                            }
                                                                        });
                                                                    });

                                                                }
                                                            });
                                                        });

                                                    }
                                                });
                                            });

                                            function updateAddress() {
                                                const tinhVal = $('#tinh option:selected').text();
                                                const quanVal = $('#quan option:selected').text();
                                                const phuongVal = $('#phuong option:selected').text();
                                                const specificAddress = $('#specificAddress').val().trim();

                                                // Kiểm tra dữ liệu đầu vào
                                                if (!specificAddress) {
                                                    alert('Vui lòng nhập địa chỉ cụ thể!');
                                                    return;
                                                }

                                                if (tinhVal === 'Tỉnh Thành' || quanVal === 'Quận Huyện' || phuongVal === 'Phường Xã') {
                                                    alert('Vui lòng chọn đầy đủ Phường/Xã, Quận/Huyện và Tỉnh/Thành phố!');
                                                    return;
                                                }

                                                // Cộng chuỗi địa chỉ
                                                const fullAddress = specificAddress + ', ' + phuongVal + ', ' + quanVal + ', ' + tinhVal;

                                                // Cập nhật giá trị vào input address
                                                $('#address').val(fullAddress);

                                                // Đóng modal
                                                $('#changeAddressModal').modal('hide');
                                            }
        </script>
    </body>

</html>
