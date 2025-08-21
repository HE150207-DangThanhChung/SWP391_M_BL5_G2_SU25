<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết sản phẩm</title>
        <style>
            html, body {
                height: 100%;
            }
            body {
                font-family: "Inter", sans-serif;
                background-color: #f0f0f0;
                color: #374151;
                margin: 0;
                padding: 0;
            }
            .layout-wrapper {
                display: flex;
                min-height: 100vh;
            }
            .main-panel {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            .content {
                width: 100%;
                margin: 0;
                padding-left: 10px;
                padding-top: 0;
                display: flex;
                flex-direction: column;
                flex: 1 1 auto;
            }
            .main-panel > .footer,
            .main-panel > footer.footer {
                margin-top: auto;
            }
            .product-img {
                width: 150px;
                height: 150px;
                object-fit: cover;
                border-radius: 4px;
                margin-right: 10px;
            }
            .variant-card {
                margin-bottom: 20px;
            }
            .spec-list, .serial-list {
                list-style: none;
                padding-left: 0;
            }
            .spec-list li, .serial-list li {
                margin-bottom: 5px;
            }
        </style>
    </head>
    <body>
        <div class="layout-wrapper d-flex">
            <jsp:include page="/views/common/sidebar.jsp" />
            <div class="main-panel">
                <jsp:include page="/views/common/header.jsp" />
                <main class="content">
                    <div class="container mt-4">
                        <h2 class="mb-4">Chi tiết sản phẩm</h2>
                        <c:if test="${product != null}">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <h5 class="card-title">${product.productName}</h5>
                                    <p><strong>ID:</strong> ${product.productId}</p>
                                    <p><strong>Thương hiệu:</strong> ${product.brandName}</p>
                                    <p><strong>Danh mục:</strong> ${product.categoryName}</p>
                                    <p><strong>Nhà cung cấp:</strong> ${product.supplierName}</p>
                                    <p><strong>Trạng thái:</strong> 
                                        <span class="badge ${product.status == 'Active' ? 'bg-success' : 'bg-danger'}">
                                            ${product.status}
                                        </span>
                                    </p>

                                    <!-- Variants -->
                                    <h6 class="mt-4">Biến thể (${product.variants != null ? product.variants.size() : 0})</h6>
                                    <c:forEach var="variant" items="${product.variants}" varStatus="loop">
                                        <div class="card variant-card">
                                            <div class="card-body">
                                                <h6>Biến thể ${loop.count}</h6>
                                                <p><strong>Mã sản phẩm:</strong> ${variant.productCode}</p>
                                                <p><strong>Giá:</strong> ${variant.price}</p>
                                                <p><strong>Bảo hành:</strong> ${variant.warrantyDurationMonth} tháng</p>
                                                <!-- Images -->
                                                <p><strong>Hình ảnh:</strong></p>
                                                <div class="d-flex flex-wrap">
                                                    <c:forEach var="image" items="${variant.images}">
                                                        <img src="${pageContext.request.contextPath}/${image.src}" alt="${image.alt}" class="product-img">
                                                    </c:forEach>
                                                    <c:if test="${empty variant.images}">
                                                        <span class="text-muted">No images</span>
                                                    </c:if>
                                                </div>
                                                <!-- Specifications -->
                                                <p><strong>Thông số kỹ thuật:</strong></p>
                                                <ul class="spec-list">
                                                    <c:forEach var="attrOption" items="${variant.attributes}">
                                                        <li>${attrOption.attribute.attributeName}: ${attrOption.value}</li>
                                                    </c:forEach>
                                                    <c:if test="${empty variant.attributes}">
                                                        <li class="text-muted">No specifications</li>
                                                    </c:if>
                                                </ul>
                                                <!-- Serials -->
                                                <p><strong>Serials:</strong></p>
                                                <ul class="serial-list">
                                                    <c:forEach var="serial" items="${variant.serials}">
                                                        <li>Số serial: ${serial.serialNumber}, Cửa hàng: ${serial.storeName}, Tạo: ${serial.createdAt}, Cập nhật: ${serial.updatedAt}</li>
                                                    </c:forEach>
                                                    <c:if test="${empty variant.serials}">
                                                        <li class="text-muted">No serials</li>
                                                    </c:if>
                                                </ul>
                                                <!-- Edit Button -->
                                                <a href="${pageContext.request.contextPath}/editVariant?productId=${product.productId}&productVariantId=${variant.productVariantId}" 
                                                   class="btn btn-primary mt-2">Chỉnh sửa biến thể</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary mt-3">⬅ Quay lại danh sách</a>
                        </c:if>

                        <c:if test="${product == null}">
                            <div class="alert alert-danger">Không tìm thấy sản phẩm.</div>
                            <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary">⬅ Quay lại danh sách</a>
                        </c:if>
                    </div>
                </main>
                <jsp:include page="/views/common/footer.jsp" />
            </div>
        </div>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>