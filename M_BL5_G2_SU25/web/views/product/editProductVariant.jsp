<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chỉnh sửa biến thể</title>
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
        .form-group {
            margin-bottom: 15px;
        }
        .spec-container, .serial-container, .image-container {
            margin-bottom: 20px;
        }
        .product-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 10px;
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
                <h2 class="mb-4">Chỉnh sửa biến thể</h2>
                <c:if test="${variant != null}">
                    <form action="${pageContext.request.contextPath}/editVariant" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="productVariantId" value="${variant.productVariantId}">
                        <input type="hidden" name="productId" value="${variant.productId}">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">Thông tin biến thể</h5>
                                <div class="form-group">
                                    <label for="productCode">Mã sản phẩm</label>
                                    <input type="text" class="form-control" id="productCode" name="productCode" value="${variant.productCode}" required>
                                </div>
                                <div class="form-group">
                                    <label for="price">Giá</label>
                                    <input type="number" step="0.01" class="form-control" id="price" name="price" value="${variant.price}" required>
                                </div>
                                <div class="form-group">
                                    <label for="warrantyDurationMonth">Thời gian bảo hành (tháng)</label>
                                    <input type="number" class="form-control" id="warrantyDurationMonth" name="warrantyDurationMonth" value="${variant.warrantyDurationMonth}" required>
                                </div>
                                <!-- Specifications -->
                                <h6 class="mt-4">Thông số kỹ thuật</h6>
                                <div class="spec-container">
                                    <c:forEach var="spec" items="${allSpecifications}">
                                        <div class="form-group">
                                            <label>${spec.attributeName}</label>
                                            <c:set var="specValue" value="" />
                                            <c:forEach var="variantSpec" items="${variant.specifications}">
                                                <c:if test="${variantSpec.specificationId == spec.specificationId}">
                                                    <c:set var="specValue" value="${variantSpec.value}" />
                                                </c:if>
                                            </c:forEach>
                                            <input type="text" class="form-control" name="spec_${spec.specificationId}" value="${specValue}">
                                        </div>
                                    </c:forEach>
                                </div>
                                <!-- Images -->
                                <h6 class="mt-4">Hình ảnh</h6>
                                <div class="image-container">
                                    <c:forEach var="image" items="${variant.images}">
                                        <div class="form-group">
                                            <img src="${pageContext.request.contextPath}/${image.src}" alt="${image.alt}" class="product-img">
                                            <input type="hidden" name="imageId_${image.productImageId}" value="${image.productImageId}">
                                            <input type="text" class="form-control d-inline-block w-auto" name="imageUrl_${image.productImageId}" value="${image.src}" placeholder="URL hình ảnh">
                                            <input type="file" class="form-control-file d-inline-block" name="imageFile_${image.productImageId}" accept="image/*">
                                            <button type="button" class="btn btn-danger btn-sm" onclick="this.parentElement.remove()">Xóa</button>
                                        </div>
                                    </c:forEach>
                                    <div class="form-group">
                                        <label>Thêm hình ảnh mới</label>
                                        <input type="file" class="form-control-file" name="newImageFile" accept="image/*" multiple>
                                        <input type="text" class="form-control" name="newImageUrl" placeholder="Hoặc nhập URL hình ảnh">
                                    </div>
                                </div>
                                <!-- Serials -->
                                <h6 class="mt-4">Serials</h6>
                                <div class="serial-container">
                                    <c:forEach var="serial" items="${variant.serials}">
                                        <div class="form-group">
                                            <input type="hidden" name="serialId_${serial.productSerialId}" value="${serial.productSerialId}">
                                            <input type="text" class="form-control d-inline-block w-auto" name="serialNumber_${serial.productSerialId}" value="${serial.serialNumber}" placeholder="Số serial" required>
                                            <select class="form-control d-inline-block w-auto" name="storeId_${serial.productSerialId}" required>
                                                <c:forEach var="store" items="${stores}">
                                                    <option value="${store.storeId}" ${serial.storeId == store.storeId ? 'selected' : ''}>${store.storeName}</option>
                                                </c:forEach>
                                            </select>
                                            <button type="button" class="btn btn-danger btn-sm" onclick="this.parentElement.remove()">Xóa</button>
                                        </div>
                                    </c:forEach>
                                    <div class="form-group">
                                        <label>Thêm serial mới</label>
                                        <input type="text" class="form-control d-inline-block w-auto" name="newSerialNumber" placeholder="Số serial">
                                        <select class="form-control d-inline-block w-auto" name="newStoreId">
                                            <option value="">Chọn cửa hàng</option>
                                            <c:forEach var="store" items="${stores}">
                                                <option value="${store.storeId}">${store.storeName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary mt-3">Lưu thay đổi</button>
                                <a href="${pageContext.request.contextPath}/product/productDetail?productId=${variant.productId}" class="btn btn-secondary mt-3">Hủy</a>
                            </div>
                        </div>
                    </form>
                </c:if>
                <c:if test="${variant == null}">
                    <div class="alert alert-danger">Không tìm thấy biến thể.</div>
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