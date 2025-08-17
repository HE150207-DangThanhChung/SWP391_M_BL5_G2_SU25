<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sửa ${isVariantEdit ? 'Biến thể sản phẩm' : 'Sản phẩm'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        .main-panel > .footer, .main-panel > footer.footer {
            margin-top: auto;
        }
        .product-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
        }
        .variant-section {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="layout-wrapper d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>
    <div class="main-panel">
        <jsp:include page="/views/common/header.jsp"/>
        <main class="content">
            <div class="container mt-4">
                <h2 class="mb-4">Sửa ${isVariantEdit ? 'biến thể của ' + product.productName : 'sản phẩm'}</h2>
                <c:if test="${product != null}">
                    <form id="productForm" action="${pageContext.request.contextPath}/product/edit" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <c:if test="${not isVariantEdit}">
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
                        </c:if>
                        <c:if test="${isVariantEdit}">
                            <div class="mb-3">
                                <label class="form-label">Tên sản phẩm</label>
                                <input type="text" class="form-control" value="${product.productName}" disabled>
                                <input type="hidden" name="productName" value="${product.productName}">
                                <input type="hidden" name="categoryId" value="${product.categoryId}">
                                <input type="hidden" name="brandId" value="${product.brandId}">
                                <input type="hidden" name="supplierId" value="${product.supplierId}">
                                <input type="hidden" name="status" value="${product.status}">
                            </div>
                        </c:if>
                        <h5 class="mt-4">Biến thể</h5>
                        <div id="variantsContainer">
                            <c:forEach var="variant" items="${product.variants}" varStatus="loop">
                                <div class="card mb-3 variant-section" data-variant-index="${loop.index}">
                                    <div class="card-body">
                                        <h6>Biến thể ${loop.count} <c:if test="${not isVariantEdit}"><button type="button" class="btn btn-danger btn-sm float-end remove-variant">Xóa</button></c:if></h6>
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
                                            <c:forEach var="specDef" items="${specifications}">
                                                <c:set var="specValue" value=""/>
                                                <c:forEach var="spec" items="${variant.specifications}">
                                                    <c:if test="${spec.specificationId == specDef.specificationId}">
                                                        <c:set var="specValue" value="${spec.value}"/>
                                                    </c:if>
                                                </c:forEach>
                                                <div class="mb-2">
                                                    <label class="form-label">${specDef.attributeName}</label>
                                                    <input type="text"
                                                           class="form-control"
                                                           name="specValue[${specDef.specificationId}][${loop.index}]"
                                                           value="${specValue}"
                                                           placeholder="Nhập ${specDef.attributeName.toLowerCase()}">
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <!-- Serials -->
                                        <div class="mb-3">
                                            <label class="form-label">Serials</label>
                                            <div class="serials-container">
                                                <c:forEach var="serial" items="${variant.serials}" varStatus="serialLoop">
                                                    <div class="input-group mb-2 serial-group">
                                                        <input type="hidden" name="variantSerialId[${loop.index}][${serialLoop.index}]" value="${serial.productSerialId}">
                                                        <input type="text" class="form-control" name="variantSerial[${loop.index}][${serialLoop.index}]" value="${serial.serialNumber}" required>
                                                        <select class="form-select" name="variantStoreId[${loop.index}][${serialLoop.index}]" required>
                                                            <c:forEach var="store" items="${stores}">
                                                                <option value="${store.storeId}" ${store.storeId == serial.storeId ? 'selected' : ''}>${store.storeName}</option>
                                                            </c:forEach>
                                                        </select>
                                                        <button type="button" class="btn btn-danger btn-sm remove-serial">Xóa</button>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <button type="button" class="btn btn-secondary btn-sm mt-2 add-serial">Thêm Serial</button>
                                        </div>
                                        <!-- Images -->
                                        <div class="mb-3">
                                            <label class="form-label">Hình ảnh hiện tại</label>
                                            <c:if test="${not empty variant.images}">
                                                <c:forEach var="image" items="${variant.images}" varStatus="imageLoop">
                                                    <div class="mb-2 image-group">
                                                        <img src="${pageContext.request.contextPath}/${image.src}" alt="${image.alt}" class="product-img">
                                                        <input type="hidden" name="variantImageId[${loop.index}][${imageLoop.index}]" value="${image.productImageId}">
                                                        <input type="file" class="form-control" name="variantImage[${loop.index}][${imageLoop.index}]">
                                                        <input type="text" class="form-control" name="variantImageUrl[${loop.index}][${imageLoop.index}]" value="${image.src}" placeholder="URL (optional)">
                                                        <button type="button" class="btn btn-danger btn-sm remove-image">Xóa</button>
                                                    </div>
                                                </c:forEach>
                                            </c:if>
                                            <div class="new-images-container">
                                                <div class="mb-2">
                                                    <label class="form-label">Thêm hình ảnh mới</label>
                                                    <input type="file" class="form-control" name="variantImage[${loop.index}][]">
                                                    <input type="text" class="form-control" name="variantImageUrl[${loop.index}][]" placeholder="URL (optional)">
                                                </div>
                                            </div>
                                            <button type="button" class="btn btn-secondary btn-sm mt-2 add-image">Thêm Hình ảnh</button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <c:if test="${not isVariantEdit}">
                            <button type="button" class="btn btn-primary mt-3" id="addVariant">Thêm biến thể</button>
                        </c:if>
                        <button type="submit" class="btn btn-primary mt-3">Lưu thay đổi</button>
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
        </main>
        <jsp:include page="/views/common/footer.jsp"/>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script>
    let variantIndex = ${product.variants.size()};
    <c:if test="${isVariantEdit}">
        variantIndex = 1; // Lock to single variant
    </c:if>
    // Add new variant
    <c:if test="${not isVariantEdit}">
    document.getElementById('addVariant').addEventListener('click', function () {
        const container = document.getElementById('variantsContainer');
        const variantDiv = document.createElement('div');
        variantDiv.className = 'card mb-3 variant-section';
        variantDiv.dataset.variantIndex = variantIndex;
        variantDiv.innerHTML = `
            <div class="card-body">
                <h6>Biến thể ${variantIndex + 1} <button type="button" class="btn btn-danger btn-sm float-end remove-variant">Xóa</button></h6>
                <input type="hidden" name="variantId[${variantIndex}]" value="0">
                <div class="mb-3">
                    <label class="form-label">Mã sản phẩm</label>
                    <input type="text" class="form-control" name="variantProductCode[${variantIndex}]" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Giá</label>
                    <input type="number" step="0.01" class="form-control" name="variantPrice[${variantIndex}]" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Bảo hành (Tháng)</label>
                    <input type="number" class="form-control" name="variantWarranty[${variantIndex}]" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thông số kỹ thuật</label>
                    <c:forEach var="specDef" items="${specifications}">
                        <div class="mb-2">
                            <label class="form-label">${specDef.attributeName}</label>
                            <input type="text"
                                   class="form-control"
                                   name="specValue[${specDef.specificationId}][${variantIndex}]"
                                   placeholder="Nhập ${specDef.attributeName.toLowerCase()}">
                        </div>
                    </c:forEach>
                </div>
                <div class="mb-3">
                    <label class="form-label">Serials</label>
                    <div class="serials-container">
                        <div class="input-group mb-2 serial-group">
                            <input type="hidden" name="variantSerialId[${variantIndex}][0]" value="0">
                            <input type="text" class="form-control" name="variantSerial[${variantIndex}][0]" required>
                            <select class="form-select" name="variantStoreId[${variantIndex}][0]" required>
                                <c:forEach var="store" items="${stores}">
                                    <option value="${store.storeId}">${store.storeName}</option>
                                </c:forEach>
                            </select>
                            <button type="button" class="btn btn-danger btn-sm remove-serial">Xóa</button>
                        </div>
                    </div>
                    <button type="button" class="btn btn-secondary btn-sm mt-2 add-serial">Thêm Serial</button>
                </div>
                <div class="mb-3">
                    <label class="form-label">Hình ảnh</label>
                    <div class="new-images-container">
                        <div class="mb-2">
                            <input type="file" class="form-control" name="variantImage[${variantIndex}][]">
                            <input type="text" class="form-control" name="variantImageUrl[${variantIndex}][]" placeholder="URL (optional)">
                        </div>
                    </div>
                    <button type="button" class="btn btn-secondary btn-sm mt-2 add-image">Thêm Hình ảnh</button>
                </div>
            </div>
        `;
        container.appendChild(variantDiv);
        variantIndex++;
    });
    </c:if>
    // Remove variant
    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('remove-variant')) {
            <c:if test="${not isVariantEdit}">
                e.target.closest('.variant-section').remove();
                reindexVariants();
            </c:if>
        }
    });
    // Add new serial
    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('add-serial')) {
            const serialsContainer = e.target.closest('.variant-section').querySelector('.serials-container');
            const variantIndex = e.target.closest('.variant-section').dataset.variantIndex;
            const serialIndex = serialsContainer.querySelectorAll('.serial-group').length;
            const serialDiv = document.createElement('div');
            serialDiv.className = 'input-group mb-2 serial-group';
            serialDiv.innerHTML = `
                <input type="hidden" name="variantSerialId[${variantIndex}][${serialIndex}]" value="0">
                <input type="text" class="form-control" name="variantSerial[${variantIndex}][${serialIndex}]" required>
                <select class="form-select" name="variantStoreId[${variantIndex}][${serialIndex}]" required>
                    <c:forEach var="store" items="${stores}">
                        <option value="${store.storeId}">${store.storeName}</option>
                    </c:forEach>
                </select>
                <button type="button" class="btn btn-danger btn-sm remove-serial">Xóa</button>
            `;
            serialsContainer.appendChild(serialDiv);
        }
    });
    // Remove serial
    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('remove-serial')) {
            e.target.closest('.serial-group').remove();
            const variantSection = e.target.closest('.variant-section');
            reindexSerials(variantSection);
        }
    });
    // Add new image
    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('add-image')) {
            const imagesContainer = e.target.closest('.variant-section').querySelector('.new-images-container');
            const variantIndex = e.target.closest('.variant-section').dataset.variantIndex;
            const imageDiv = document.createElement('div');
            imageDiv.className = 'mb-2';
            imageDiv.innerHTML = `
                <input type="file" class="form-control" name="variantImage[${variantIndex}][]">
                <input type="text" class="form-control" name="variantImageUrl[${variantIndex}][]" placeholder="URL (optional)">
            `;
            imagesContainer.appendChild(imageDiv);
        }
    });
    // Remove image
    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('remove-image')) {
            e.target.closest('.image-group').remove();
        }
    });
    // Reindex variants to maintain consistent indices
    function reindexVariants() {
        const variants = document.querySelectorAll('.variant-section');
        variants.forEach((variant, index) => {
            variant.dataset.variantIndex = index;
            variant.querySelector('h6').textContent = `Biến thể ${index + 1} `;
            const inputs = variant.querySelectorAll('input, select');
            inputs.forEach(input => {
                if (input.name) {
                    input.name = input.name.replace(/\[\d+\]/, `[${index}]`);
                }
            });
            // Reindex serials and images within this variant
            reindexSerials(variant);
        });
        variantIndex = variants.length;
    }
    // Reindex serials within a variant
    function reindexSerials(variantSection) {
        const serials = variantSection.querySelectorAll('.serial-group');
        const variantIndex = variantSection.dataset.variantIndex;
        serials.forEach((serial, index) => {
            const inputs = serial.querySelectorAll('input, select');
            inputs.forEach(input => {
                if (input.name) {
                    input.name = input.name.replace(/\[\d+\]\[\d+\]/, `[${variantIndex}][${index}]`);
                }
            });
        });
    }
    // Form validation
    document.getElementById('productForm').addEventListener('submit', function (e) {
        const variants = document.querySelectorAll('.variant-section');
        if (variants.length === 0) {
            alert('Vui lòng thêm ít nhất một biến thể.');
            e.preventDefault();
            return;
        }
        let isValid = true;
        variants.forEach(variant => {
            const productCode = variant.querySelector('input[name^="variantProductCode"]');
            const price = variant.querySelector('input[name^="variantPrice"]');
            const warranty = variant.querySelector('input[name^="variantWarranty"]');
            if (!productCode.value.trim()) {
                alert('Mã sản phẩm không được để trống.');
                isValid = false;
                return;
            }
            if (!price.value || price.value <= 0) {
                alert('Giá sản phẩm phải lớn hơn 0.');
                isValid = false;
                return;
            }
            if (!warranty.value || warranty.value < 0) {
                alert('Thời gian bảo hành không được âm.');
                isValid = false;
                return;
            }
            const serials = variant.querySelectorAll('.serial-group');
            serials.forEach(serial => {
                const serialNumber = serial.querySelector('input[name^="variantSerial["]');
                const storeId = serial.querySelector('select[name^="variantStoreId["]');
                if (!serialNumber.value.trim()) {
                    alert('Số serial không được để trống.');
                    isValid = false;
                    return;
                }
                if (!storeId.value) {
                    alert('Vui lòng chọn cửa hàng cho serial.');
                    isValid = false;
                    return;
                }
            });
        });
        if (!isValid) {
            e.preventDefault();
        }
    });
</script>
</body>
</html>