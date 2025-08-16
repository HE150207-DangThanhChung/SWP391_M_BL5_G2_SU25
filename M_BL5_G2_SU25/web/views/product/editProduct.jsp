<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<div class="container mt-4">
    <h2 class="mb-4">Sửa sản phẩm</h2>
    <c:if test="${product != null}">
        <form action="${pageContext.request.contextPath}/product/edit" method="post" enctype="multipart/form-data">
            <input type="hidden" name="productId" value="${product.productId}">
            <div class="mb-3">
                <label class="form-label">Tên sản phẩm</label>
                <input type="text" class="form-control" name="productName" value="${product.productName}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Danh mục</label>
                <select class="form-select" name="categoryId" required>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryId}" ${category.categoryId == product.categoryId ? 'selected' : ''}>${category.categoryName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Thương hiệu</label>
                <select class="form-select" name="brandId" required>
                    <c:forEach var="brand" items="${brands}">
                        <option value="${brand.brandId}" ${brand.brandId == product.brandId ? 'selected' : ''}>${brand.brandName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Nhà cung cấp</label>
                <select class="form-select" name="supplierId" required>
                    <c:forEach var="supplier" items="${suppliers}">
                        <option value="${supplier.supplierId}" ${supplier.supplierId == product.supplierId ? 'selected' : ''}>${supplier.supplierName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Trạng thái</label>
                <select class="form-select" name="status" required>
                    <option value="Active" ${product.status == 'Active' ? 'selected' : ''}>Active</option>
                    <option value="Inactive" ${product.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                </select>
            </div>

            <!-- Variants -->
            <h5 class="mt-4">Biến thể</h5>
            <c:forEach var="variant" items="${product.variants}" varStatus="loop">
                <div class="card mb-3">
                    <div class="card-body">
                        <h6>Biến thể ${loop.count}</h6>
                        <input type="hidden" name="variantId[${loop.index}]" value="${variant.productVariantId}">
                        <div class="mb-3">
                            <label class="form-label">Mã sản phẩm</label>
                            <input type="text" class="form-control" name="variantProductCode[${loop.index}]" value="${variant.productCode}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Giá</label>
                            <input type="number" step="0.01" class="form-control" name="variantPrice[${loop.index}]" value="${variant.price}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Bảo hành (Tháng)</label>
                            <input type="number" class="form-control" name="variantWarranty[${loop.index}]" value="${variant.warrantyDurationMonth}" required>
                        </div>

                        <!-- Specifications -->
                        <div class="mb-3">
                            <label class="form-label">Thông số kỹ thuật</label>
                            <c:forEach var="spec" items="${variant.specifications}">
                                <div class="mb-2">
                                    <c:set var="specDef" value="${specifications.stream().filter(s -> s.specificationId == spec.specificationId).findFirst().orElse(null)}" />
                                    <select class="form-select" name="specValue[${spec.specificationId}][${loop.index}]">
                                        <c:choose>
                                            <c:when test="${specDef != null}">
                                                <option value="${spec.value}" selected>${spec.value} (${specDef.attributeName})</option>
                                                <c:if test="${specDef.attributeName == 'RAM'}">
                                                    <option value="4GB">4GB</option>
                                                    <option value="8GB">8GB</option>
                                                    <option value="16GB">16GB</option>
                                                </c:if>
                                                <c:if test="${specDef.attributeName == 'Storage'}">
                                                    <option value="128GB">128GB</option>
                                                    <option value="256GB">256GB</option>
                                                    <option value="512GB">512GB</option>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="">Chọn thông số</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </select>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Serials -->
                        <div class="mb-3">
                            <label class="form-label">Serials</label>
                            <c:forEach var="serial" items="${variant.serials}" varStatus="serialLoop">
                                <div class="input-group mb-2">
                                    <input type="hidden" name="variantSerialId[${loop.index}][${serialLoop.index}]" value="${serial.productSerialId}">
                                    <input type="text" class="form-control" name="variantSerial[${loop.index}][${serialLoop.index}]" value="${serial.serialNumber}" required>
                                    <input type="number" class="form-control" name="variantStoreId[${loop.index}][${serialLoop.index}]" value="${serial.storeId}" required>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Images -->
                        <div class="mb-3">
                            <label class="form-label">Hình ảnh</label>
                            <c:forEach var="image" items="${variant.images}" varStatus="imageLoop">
                                <div class="mb-2">
                                    <img src="${pageContext.request.contextPath}/${image.src}" alt="${image.alt}" class="product-img" style="width: 100px; height: 100px;">
                                    <input type="file" class="form-control" name="variantImage[${loop.index}][${imageLoop.index}]">
                                    <input type="text" class="form-control" name="variantImageUrl[${loop.index}][${imageLoop.index}]" value="${image.src}" placeholder="URL (optional)">
                                </div>
                            </c:forEach>
                            <input type="file" class="form-control" name="variantImage[${loop.index}][]">
                            <input type="text" class="form-control" name="variantImageUrl[${loop.index}][]" placeholder="URL (optional)">
                        </div>
                    </div>
                </div>
            </c:forEach>

            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
            <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary mt-3">⬅ Quay lại danh sách</a>
        </form>
        <c:if test="${not empty message}">
            <div class="alert alert-success mt-3">${message}</div>
        </c:if>
    </c:if>
    <c:if test="${product == null}">
        <div class="alert alert-danger">Không tìm thấy sản phẩm.</div>
        <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary">⬅ Quay lại danh sách</a>
    </c:if>
</div>