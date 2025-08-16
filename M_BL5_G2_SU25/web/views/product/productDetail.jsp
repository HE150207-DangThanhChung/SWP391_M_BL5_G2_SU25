<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
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
                                <c:forEach var="spec" items="${variant.specifications}">
                                    <c:set var="specName" value="" />
                                    <c:forEach var="specDef" items="${specifications}">
                                        <c:if test="${specDef.specificationId == spec.specificationId}">
                                            <c:set var="specName" value="${specDef.attributeName}" />
                                        </c:if>
                                    </c:forEach>
                                    <li>${specName}: ${spec.value}</li>
                                </c:forEach>
                                <c:if test="${empty variant.specifications}">
                                    <li class="text-muted">No specifications</li>
                                </c:if>
                            </ul>

                            <!-- Serials -->
                            <p><strong>Serials:</strong></p>
                            <ul class="serial-list">
                                <c:forEach var="serial" items="${variant.serials}">
                                    <li>Số serial: ${serial.serialNumber}, Cửa hàng: ${serial.storeId}, Tạo: ${serial.createdAt}, Cập nhật: ${serial.updatedAt}</li>
                                </c:forEach>
                                <c:if test="${empty variant.serials}">
                                    <li class="text-muted">No serials</li>
                                </c:if>
                            </ul>
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