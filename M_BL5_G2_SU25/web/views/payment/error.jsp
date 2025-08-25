<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 text-center">
                <div class="card shadow-sm">
                    <div class="card-body p-5">
                        <i class="bi bi-x-circle-fill error-icon mb-4"></i>
                        <h2 class="mb-4">Lỗi thanh toán!</h2>
                        <p class="lead mb-4">
                            ${error != null ? error : 'Đã xảy ra lỗi trong quá trình thanh toán. Vui lòng thử lại sau.'}
                        </p>
                        <div class="d-grid gap-2">
                            <button onclick="history.back()" class="btn btn-primary">
                                <i class="bi bi-arrow-left me-2"></i>Quay lại
                            </button>
                            <a href="${pageContext.request.contextPath}/orders" 
                               class="btn btn-outline-secondary">
                                Về trang đơn hàng
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
