<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chuyển hướng thanh toán VNPAY</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .loading-spinner {
            width: 3rem;
            height: 3rem;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 text-center">
                <div class="card shadow-sm">
                    <div class="card-body p-5">
                        <div class="spinner-border loading-spinner text-primary mb-4" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <h3 class="mb-4">Đang chuyển hướng đến VNPAY...</h3>
                        <p class="mb-4">Vui lòng không đóng trình duyệt trong quá trình xử lý.</p>
                        
                        <form id="vnpayForm" action="https://sandbox.vnpayment.vn/paymentv2/vpcpay.html" method="POST">
                            <input type="hidden" name="vnp_Version" value="2.1.0">
                            <input type="hidden" name="vnp_Command" value="pay">
                            <input type="hidden" name="vnp_TmnCode" value="${vnpTmnCode}">
                            <input type="hidden" name="vnp_Amount" value="${amount}">
                            <input type="hidden" name="vnp_CurrCode" value="VND">
                            <input type="hidden" name="vnp_TxnRef" value="${orderId}">
                            <input type="hidden" name="vnp_OrderInfo" value="${orderInfo}">
                            <input type="hidden" name="vnp_ReturnUrl" value="${returnUrl}">
                            <input type="hidden" name="vnp_IpAddr" value="${ipAddr}">
                            <input type="hidden" name="vnp_CreateDate" value="${createDate}">
                            <input type="hidden" name="vnp_SecureHash" value="${secureHash}">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Tự động submit form sau 2 giây
        setTimeout(function() {
            document.getElementById('vnpayForm').submit();
        }, 2000);
    </script>
</body>
</html>
