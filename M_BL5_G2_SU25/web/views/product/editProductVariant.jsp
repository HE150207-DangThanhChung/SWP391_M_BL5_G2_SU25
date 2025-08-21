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
        .error-border {
            border: 2px solid red !important;
        }
        .error-message {
            color: red;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
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
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
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
                                    <div class="error-message">Vui lòng nhập mã sản phẩm</div>
                                </div>
                                <div class="form-group">
                                    <label for="price">Giá</label>
                                    <input type="number" step="0.01" class="form-control" id="price" name="price" value="${variant.price}" required>
                                    <div class="error-message">Giá phải lớn hơn 0</div>
                                </div>
                                <div class="form-group">
                                    <label for="warrantyDurationMonth">Thời gian bảo hành (tháng)</label>
                                    <input type="number" class="form-control" id="warrantyDurationMonth" name="warrantyDurationMonth" value="${variant.warrantyDurationMonth}" required>
                                    <div class="error-message">Thời gian bảo hành không được âm</div>
                                </div>
                                <!-- Attributes -->
                                <h6 class="mt-4">Thông số kỹ thuật</h6>
                                <div class="spec-container">
                                    <c:forEach var="attribute" items="${allAttributes}">
                                        <div class="form-group">
                                            <label>${attribute.attributeName}</label>
                                            <select class="form-control" name="attributeOptionId[]" required data-attribute-id="${attribute.attributeId}">
                                                <option value="">Chọn ${attribute.attributeName}</option>
                                                <c:forEach var="option" items="${attributeOptions[attribute.attributeId]}">
                                                    <c:set var="selected" value="" />
                                                    <c:forEach var="variantAttr" items="${variant.attributes}">
                                                        <c:if test="${variantAttr.attributeOptionId == option.attributeOptionId}">
                                                            <c:set var="selected" value="selected" />
                                                        </c:if>
                                                    </c:forEach>
                                                    <option value="${option.attributeOptionId}" ${selected}>${option.value}</option>
                                                </c:forEach>
                                            </select>
                                            <div class="error-message">Vui lòng chọn ${attribute.attributeName.toLowerCase()}</div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <!-- Images -->
                                <h6 class="mt-4">Hình ảnh</h6>
                                <div class="image-container">
                                    <c:forEach var="image" items="${variant.images}">
                                        <div class="form-group image-group">
                                            <img src="${pageContext.request.contextPath}/${image.src}" alt="${image.alt}" class="product-img">
                                            <input type="hidden" name="imageId_${image.productImageId}" value="${image.productImageId}">
                                            <input type="text" class="form-control d-inline-block w-auto" name="imageUrl_${image.productImageId}" value="${image.src}" placeholder="URL hình ảnh">
                                            <input type="file" class="form-control-file d-inline-block" name="imageFile_${image.productImageId}" accept="image/*">
                                            <button type="button" class="btn btn-danger btn-sm btn-remove-image">Xóa</button>
                                        </div>
                                    </c:forEach>
                                    <div class="form-group image-group">
                                        <label>Thêm hình ảnh mới</label>
                                        <input type="file" class="form-control-file" name="newImageFile[]" accept="image/*" multiple>
                                        <div class="error-message">Vui lòng chọn hình ảnh</div>
                                        <input type="text" class="form-control" name="newImageUrl[]" placeholder="Hoặc nhập URL hình ảnh">
                                        <div class="error-message">Vui lòng nhập URL hợp lệ</div>
                                        <button type="button" class="btn btn-danger btn-sm btn-remove-image">Xóa</button>
                                    </div>
                                    <button type="button" class="btn btn-outline-secondary btn-add-image">Thêm hình ảnh</button>
                                </div>
                                <!-- Serials -->
                                <h6 class="mt-4">Serials</h6>
                                <div class="serial-container">
                                    <c:forEach var="serial" items="${variant.serials}">
                                        <div class="form-group serial-group">
                                            <input type="hidden" name="serialId_${serial.productSerialId}" value="${serial.productSerialId}">
                                            <input type="text" class="form-control d-inline-block w-auto" name="serialNumber_${serial.productSerialId}" value="${serial.serialNumber}" placeholder="Số serial" required>
                                            <div class="error-message">Vui lòng nhập số serial</div>
                                            <select class="form-control d-inline-block w-auto" name="storeId_${serial.productSerialId}" required>
                                                <option value="">Chọn cửa hàng</option>
                                                <c:forEach var="store" items="${stores}">
                                                    <option value="${store.storeId}" ${serial.storeId == store.storeId ? 'selected' : ''}>${store.storeName}</option>
                                                </c:forEach>
                                            </select>
                                            <div class="error-message">Vui lòng chọn cửa hàng</div>
                                            <button type="button" class="btn btn-danger btn-sm btn-remove-serial">Xóa</button>
                                        </div>
                                    </c:forEach>
                                    <div class="form-group serial-group">
                                        <label>Thêm serial mới</label>
                                        <input type="text" class="form-control d-inline-block w-auto" name="newSerialNumber[]" placeholder="Số serial">
                                        <div class="error-message">Vui lòng nhập số serial</div>
                                        <select class="form-control d-inline-block w-auto" name="newStoreId[]">
                                            <option value="">Chọn cửa hàng</option>
                                            <c:forEach var="store" items="${stores}">
                                                <option value="${store.storeId}">${store.storeName}</option>
                                            </c:forEach>
                                        </select>
                                        <div class="error-message">Vui lòng chọn cửa hàng</div>
                                        <button type="button" class="btn btn-danger btn-sm btn-remove-serial">Xóa</button>
                                    </div>
                                    <button type="button" class="btn btn-outline-secondary btn-add-serial">Thêm serial</button>
                                </div>
                                <button type="submit" class="btn btn-primary mt-3">Lưu thay đổi</button>
                                <a href="${pageContext.request.contextPath}/product/detail?productId=${variant.productId}" class="btn btn-secondary mt-3">Hủy</a>
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
<script>
    // Add new serial input group
    function addSerial() {
        const serialContainer = document.querySelector('.serial-container');
        const newSerial = document.createElement('div');
        newSerial.className = 'form-group serial-group';
        newSerial.innerHTML = `
            <input type="text" class="form-control d-inline-block w-auto" name="newSerialNumber[]" placeholder="Số serial">
            <div class="error-message">Vui lòng nhập số serial</div>
            <select class="form-control d-inline-block w-auto" name="newStoreId[]">
                <option value="">Chọn cửa hàng</option>
                <c:forEach var="store" items="${stores}">
                    <option value="${store.storeId}">${store.storeName}</option>
                </c:forEach>
            </select>
            <div class="error-message">Vui lòng chọn cửa hàng</div>
            <button type="button" class="btn btn-danger btn-sm btn-remove-serial">Xóa</button>
        `;
        serialContainer.insertBefore(newSerial, serialContainer.querySelector('.btn-add-serial'));
    }

    // Add new image input group
    function addImage() {
        const imageContainer = document.querySelector('.image-container');
        const newImage = document.createElement('div');
        newImage.className = 'form-group image-group';
        newImage.innerHTML = `
            <input type="file" class="form-control-file" name="newImageFile[]" accept="image/*">
            <div class="error-message">Vui lòng chọn hình ảnh</div>
            <input type="text" class="form-control" name="newImageUrl[]" placeholder="Hoặc nhập URL hình ảnh">
            <div class="error-message">Vui lòng nhập URL hợp lệ</div>
            <button type="button" class="btn btn-danger btn-sm btn-remove-image">Xóa</button>
        `;
        imageContainer.insertBefore(newImage, imageContainer.querySelector('.btn-add-image'));
    }

    // Remove serial or image
    document.addEventListener('click', function(event) {
        if (event.target.classList.contains('btn-remove-serial')) {
            const serialGroup = event.target.closest('.serial-group');
            if (serialGroup.parentElement.querySelectorAll('.serial-group').length > 1) {
                serialGroup.remove();
            } else {
                alert("Không thể xóa serial cuối cùng!");
            }
        }
        if (event.target.classList.contains('btn-remove-image')) {
            const imageGroup = event.target.closest('.image-group');
            if (imageGroup.parentElement.querySelectorAll('.image-group').length > 1) {
                imageGroup.remove();
            } else {
                alert("Không thể xóa hình ảnh cuối cùng!");
            }
        }
    });

    // Attach event listeners for adding serials and images
    document.querySelector('.btn-add-serial')?.addEventListener('click', addSerial);
    document.querySelector('.btn-add-image')?.addEventListener('click', addImage);

    // Validate form before submit
    function validateForm(event) {
        event.preventDefault();
        const form = event.target;
        const allFields = form.querySelectorAll("input[required], select[required]");
        const optionIds = new Set();
        let firstInvalid = null;
        let valid = true;

        // Reset all previous error states
        allFields.forEach(field => {
            field.classList.remove("error-border");
            const errorMessage = field.nextElementSibling;
            if (errorMessage && errorMessage.classList.contains("error-message")) {
                errorMessage.style.display = "none";
            }
        });

        // Validate all required fields and negative values
        allFields.forEach(field => {
            let isInvalid = false;
            let errorMessageText = field.nextElementSibling?.textContent || "Vui lòng nhập giá trị hợp lệ";

            if (field.type === "number") {
                if (field.name === "price" && (!field.value.trim() || parseFloat(field.value) <= 0)) {
                    isInvalid = true;
                    errorMessageText = "Giá phải lớn hơn 0";
                } else if (field.name === "warrantyDurationMonth" && (!field.value.trim() || parseInt(field.value) < 0)) {
                    isInvalid = true;
                    errorMessageText = "Thời gian bảo hành không được âm";
                }
            } else if (!field.value.trim()) {
                isInvalid = true;
            }

            if (isInvalid) {
                valid = false;
                field.classList.add("error-border");
                const errorMessage = field.nextElementSibling;
                if (errorMessage && errorMessage.classList.contains("error-message")) {
                    errorMessage.textContent = errorMessageText;
                    errorMessage.style.display = "block";
                }
                if (!firstInvalid) {
                    firstInvalid = field;
                }
            }
        });

        // Validate attribute options (prevent duplicate AttributeOptionId)
        const selects = form.querySelectorAll('select[name="attributeOptionId[]"]');
        selects.forEach(select => {
            if (select.value && optionIds.has(select.value)) {
                valid = false;
                select.classList.add('error-border');
                const errorMessage = select.nextElementSibling;
                errorMessage.textContent = 'Không thể chọn cùng giá trị cho nhiều thông số';
                errorMessage.style.display = 'block';
                if (!firstInvalid) {
                    firstInvalid = select;
                }
            } else if (select.value) {
                optionIds.add(select.value);
            }
        });

        // Validate at least one image
        const imageInputs = form.querySelectorAll('input[name^="imageFile_"], input[name="newImageFile[]"]');
        const imageUrls = form.querySelectorAll('input[name^="imageUrl_"], input[name="newImageUrl[]"]');
        let hasImage = false;
        imageInputs.forEach(input => {
            if (input.files && input.files.length > 0) {
                hasImage = true;
            }
        });
        imageUrls.forEach(input => {
            if (input.value.trim()) {
                hasImage = true;
            }
        });
        if (!hasImage) {
            valid = false;
            const errorMessage = form.querySelector('.image-container .error-message');
            errorMessage.textContent = "Vui lòng cung cấp ít nhất một hình ảnh hoặc URL";
            errorMessage.style.display = "block";
            if (!firstInvalid) {
                firstInvalid = form.querySelector('input[name="newImageFile[]"]');
            }
        }

        // Validate new serials
        const newSerials = form.querySelectorAll('input[name="newSerialNumber[]"]');
        const newStores = form.querySelectorAll('select[name="newStoreId[]"]');
        newSerials.forEach((serialInput, index) => {
            const storeSelect = newStores[index];
            if (serialInput.value.trim() && !storeSelect.value) {
                valid = false;
                storeSelect.classList.add("error-border");
                const errorMessage = storeSelect.nextElementSibling;
                errorMessage.textContent = "Vui lòng chọn cửa hàng";
                errorMessage.style.display = "block";
                if (!firstInvalid) {
                    firstInvalid = storeSelect;
                }
            } else if (!serialInput.value.trim() && storeSelect.value) {
                valid = false;
                serialInput.classList.add("error-border");
                const errorMessage = serialInput.nextElementSibling;
                errorMessage.textContent = "Vui lòng nhập số serial";
                errorMessage.style.display = "block";
                if (!firstInvalid) {
                    firstInvalid = serialInput;
                }
            }
        });

        if (valid) {
            form.submit();
        } else {
            if (firstInvalid) {
                firstInvalid.scrollIntoView({ behavior: "smooth", block: "center" });
                firstInvalid.focus();
            }
            alert("Vui lòng nhập đầy đủ và đúng các trường bắt buộc!");
        }
    }

    // Attach validation on form submit
    document.addEventListener("DOMContentLoaded", function() {
        const form = document.querySelector("form[action$='/editVariant']");
        if (form) {
            form.addEventListener("submit", validateForm);
        }
    });
</script>
</body>
</html>