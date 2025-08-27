<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm sản phẩm</title>
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
        .error-border {
            border: 2px solid red !important;
        }
        .error-message {
            color: red;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
        }
        .variant-card {
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
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
                <h2 class="mb-4">Thêm sản phẩm</h2>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3">${error}</div>
                </c:if>
                <form action="${pageContext.request.contextPath}/product/add" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label class="form-label">Tên sản phẩm</label>
                        <input type="text" class="form-control" name="productName" value="${product.productName}" required>
                        <div class="error-message">Vui lòng nhập tên sản phẩm</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" name="categoryId" required>
                            <option value="">Chọn danh mục</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}">${category.categoryName}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Vui lòng chọn danh mục</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Thương hiệu</label>
                        <select class="form-select" name="brandId" required>
                            <option value="">Chọn thương hiệu</option>
                            <c:forEach var="brand" items="${brands}">
                                <option value="${brand.brandId}">${brand.brandName}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Vui lòng chọn thương hiệu</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Nhà cung cấp</label>
                        <select class="form-select" name="supplierId" required>
                            <option value="">Chọn nhà cung cấp</option>
                            <c:forEach var="supplier" items="${suppliers}">
                                <option value="${supplier.supplierId}">${supplier.supplierName}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Vui lòng chọn nhà cung cấp</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" name="status" required>
                            <option value="">Chọn trạng thái</option>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                        <div class="error-message">Vui lòng chọn trạng thái</div>
                    </div>

                    <h5 class="mt-4">Biến thể</h5>
                    <div id="variants-container">
                        <div class="card mb-3 variant-card" data-variant-index="0">
                            <div class="card-body">
                                <h6>Biến thể 1</h6>
                                <div class="form-group">
                                    <label class="form-label">Mã sản phẩm</label>
                                    <input type="text" class="form-control" name="variantProductCode[0]" required>
                                    <div class="error-message">Vui lòng nhập mã sản phẩm</div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Giá</label>
                                    <input type="number" step="0.01" class="form-control" name="variantPrice[0]" required>
                                    <div class="error-message">Giá phải lớn hơn 0</div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Bảo hành (Tháng)</label>
                                    <input type="number" class="form-control" name="variantWarranty[0]" required>
                                    <div class="error-message">Thời gian bảo hành không được âm</div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Thông số kỹ thuật</label>
                                    <div class="attributes-container">
                                        <c:forEach var="attribute" items="${allAttributes}">
                                            <div class="form-group">
                                                <label>${attribute.attributeName}</label>
                                                <select class="form-control" name="attributeOptionId[0][]">
                                                    <option value="">Chọn ${attribute.attributeName}</option>
                                                    <c:forEach var="option" items="${attributeOptions[attribute.attributeId]}">
                                                        <option value="${option.attributeOptionId}">${option.value}</option>
                                                    </c:forEach>
                                                </select>
                                                <div class="error-message">Vui lòng chọn ${attribute.attributeName.toLowerCase()}</div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="form-group serials-container">
                                    <label class="form-label">Serials</label>
                                    <div class="input-group mb-2 serial-group">
                                        <input type="text" class="form-control" name="variantSerial[0][0]" placeholder="Số serial" required>
                                        <select class="form-control" name="variantStoreId[0][0]" required>
                                            <option value="">Chọn cửa hàng</option>
                                            <c:forEach var="store" items="${stores}">
                                                <option value="${store.storeId}">${store.storeName}</option>
                                            </c:forEach>
                                        </select>
                                        <button type="button" class="btn btn-outline-danger btn-remove-serial">Xóa</button>
                                    </div>
                                    <button type="button" class="btn btn-outline-secondary btn-add-serial">Thêm serial</button>
                                </div>
                                <div class="form-group images-container">
                                    <label class="form-label">Hình ảnh</label>
                                    <div class="input-group mb-2 image-group">
                                        <input type="file" class="form-control" name="variantImage[0][]" accept="image/*">
                                        <input type="text" class="form-control" name="variantImageUrl[0][]" placeholder="URL (optional)">
                                        <button type="button" class="btn btn-outline-danger btn-remove-image">Xóa</button>
                                    </div>
                                    <button type="button" class="btn btn-outline-secondary btn-add-image">Thêm hình ảnh</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <button type="button" class="btn btn-secondary mb-3" id="add-variant-btn">Thêm biến thể</button>
                    <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
                    <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary mt-3">⬅ Quay lại danh sách</a>
                </form>
                <c:if test="${not empty message}">
                    <div class="alert alert-success mt-3">${message}</div>
                </c:if>
            </div>
        </main>
        <jsp:include page="/views/common/footer.jsp" />
    </div>
</div>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script>
    let variantIndexCounter = 1; // Start with 1 as index 0 is already on the page

    // Pre-render store options to avoid JSTL in JavaScript
    const storeOptionsHtml = `<option value="">Chọn cửa hàng</option><c:forEach var="store" items="\${stores}"><option value="\${store.storeId}">\${fn:escapeXml(store.storeName)}</option></c:forEach>`;

    // Pre-render attribute options to avoid JSTL in JavaScript
    const attributeOptionsHtml = {};
    <c:forEach var="attribute" items="${allAttributes}">
        attributeOptionsHtml[${attribute.attributeId}] = `<option value="">Chọn \${attribute.attributeName}</option><c:forEach var="option" items="${attributeOptions[attribute.attributeId]}"><option value="\${option.attributeOptionId}">\${fn:escapeXml(option.value)}</option></c:forEach>`;
    </c:forEach>

    document.addEventListener("DOMContentLoaded", function () {
        const addVariantBtn = document.getElementById('add-variant-btn');
        const form = document.querySelector("form[action$='/product/add']");

        if (addVariantBtn) {
            addVariantBtn.addEventListener('click', addVariant);
        }
        if (form) {
            form.addEventListener("submit", validateForm);
        }
        document.getElementById('variants-container').addEventListener('click', handleVariantContainerClick);
    });

    function addVariant() {
        const container = document.getElementById('variants-container');
        const newVariant = document.createElement('div');
        newVariant.className = 'card mb-3 variant-card';
        const newVariantIndex = variantIndexCounter++;
        newVariant.dataset.variantIndex = newVariantIndex;

        let attributesHtml = '';
        <c:forEach var="attribute" items="${allAttributes}">
            attributesHtml += `
                <div class="form-group">
                    <label>\${attribute.attributeName}</label>
                    <select class="form-control" name="attributeOptionId[\${newVariantIndex}][]">
                        \${attributeOptionsHtml[\${attribute.attributeId}]}
                    </select>
                    <div class="error-message">Vui lòng chọn \${attribute.attributeName.toLowerCase()}</div>
                </div>
            `;
        </c:forEach>

        newVariant.innerHTML = `
            <div class="card-body">
                <h6>Biến thể \${newVariantIndex + 1}</h6>
                <div class="form-group">
                    <label class="form-label">Mã sản phẩm</label>
                    <input type="text" class="form-control" name="variantProductCode[\${newVariantIndex}]" required>
                    <div class="error-message">Vui lòng nhập mã sản phẩm</div>
                </div>
                <div class="form-group">
                    <label class="form-label">Giá</label>
                    <input type="number" step="0.01" class="form-control" name="variantPrice[\${newVariantIndex}]" required>
                    <div class="error-message">Giá phải lớn hơn 0</div>
                </div>
                <div class="form-group">
                    <label class="form-label">Bảo hành (Tháng)</label>
                    <input type="number" class="form-control" name="variantWarranty[\${newVariantIndex}]" required>
                    <div class="error-message">Thời gian bảo hành không được âm</div>
                </div>
                <div class="form-group">
                    <label class="form-label">Thông số kỹ thuật</label>
                    <div class="attributes-container">
                        \${attributesHtml}
                    </div>
                </div>
                <div class="form-group serials-container">
                    <label class="form-label">Serials</label>
                    <div class="input-group mb-2 serial-group">
                        <input type="text" class="form-control" name="variantSerial[\${newVariantIndex}][0]" placeholder="Số serial" required>
                        <select class="form-control" name="variantStoreId[\${newVariantIndex}][0]" required>\${storeOptionsHtml}</select>
                        <button type="button" class="btn btn-outline-danger btn-remove-serial">Xóa</button>
                    </div>
                    <button type="button" class="btn btn-outline-secondary btn-add-serial">Thêm serial</button>
                </div>
                <div class="form-group images-container">
                    <label class="form-label">Hình ảnh</label>
                    <div class="input-group mb-2 image-group">
                        <input type="file" class="form-control" name="variantImage[\${newVariantIndex}][]" accept="image/*">
                        <input type="text" class="form-control" name="variantImageUrl[\${newVariantIndex}][]" placeholder="URL (optional)">
                        <button type="button" class="btn btn-outline-danger btn-remove-image">Xóa</button>
                    </div>
                    <button type="button" class="btn btn-outline-secondary btn-add-image">Thêm hình ảnh</button>
                </div>
                <button type="button" class="btn btn-outline-danger btn-remove-variant">Xóa biến thể</button>
            </div>
        `;
        container.appendChild(newVariant);
    }

    function handleVariantContainerClick(event) {
        const target = event.target;
        if (target.classList.contains('btn-add-serial')) {
            const serialContainer = target.closest('.serials-container');
            const variantIndex = target.closest('.variant-card').dataset.variantIndex;
            const serialGroups = serialContainer.querySelectorAll('.serial-group');
            const serialIndex = serialGroups.length;
            const newSerial = document.createElement('div');
            newSerial.className = 'input-group mb-2 serial-group';
            newSerial.innerHTML = `
                <input type="text" class="form-control" name="variantSerial[\${variantIndex}][\${serialIndex}]" placeholder="Số serial" required>
                <select class="form-control" name="variantStoreId[\${variantIndex}][\${serialIndex}]" required>\${storeOptionsHtml}</select>
                <button type="button" class="btn btn-outline-danger btn-remove-serial">Xóa</button>
            `;
            serialContainer.insertBefore(newSerial, target);
        } else if (target.classList.contains('btn-add-image')) {
            const imageContainer = target.closest('.images-container');
            const variantIndex = target.closest('.variant-card').dataset.variantIndex;
            const imageGroups = imageContainer.querySelectorAll('.image-group');
            const imageIndex = imageGroups.length;
            const newImage = document.createElement('div');
            newImage.className = 'input-group mb-2 image-group';
            newImage.innerHTML = `
                <input type="file" class="form-control" name="variantImage[\${variantIndex}][\${imageIndex}]" accept="image/*">
                <input type="text" class="form-control" name="variantImageUrl[\${variantIndex}][\${imageIndex}]" placeholder="URL (optional)">
                <button type="button" class="btn btn-outline-danger btn-remove-image">Xóa</button>
            `;
            imageContainer.insertBefore(newImage, target);
        } else if (target.classList.contains('btn-remove-serial')) {
            const serialGroup = target.closest('.serial-group');
            if (serialGroup.parentElement.querySelectorAll('.serial-group').length > 1) {
                serialGroup.remove();
            } else {
                alert("Không thể xóa serial cuối cùng!");
            }
        } else if (target.classList.contains('btn-remove-image')) {
            const imageGroup = target.closest('.image-group');
            if (imageGroup.parentElement.querySelectorAll('.image-group').length > 1) {
                imageGroup.remove();
            } else {
                alert("Không thể xóa hình ảnh cuối cùng!");
            }
        } else if (target.classList.contains('btn-remove-variant')) {
            const variantCard = target.closest('.variant-card');
            if (document.querySelectorAll('.variant-card').length > 1) {
                variantCard.remove();
                updateVariantTitles();
            } else {
                alert("Không thể xóa biến thể cuối cùng!");
            }
        }
    }

    function updateVariantTitles() {
        const variantCards = document.querySelectorAll('.variant-card');
        variantCards.forEach((card, index) => {
            card.querySelector('h6').textContent = `Biến thể \${index + 1}`;
        });
    }

    function validateForm(event) {
        event.preventDefault();
        const form = event.target;
        const allFields = form.querySelectorAll(
            "input[required], select[required]"
        );
        let firstInvalid = null;
        let valid = true;

        // Reset error states
        allFields.forEach(field => {
            field.classList.remove("error-border");
            const errorMessage = field.nextElementSibling;
            if (errorMessage && errorMessage.classList.contains("error-message")) {
                errorMessage.style.display = "none";
            }
        });

        // Validate required fields
        allFields.forEach(field => {
            let isInvalid = false;
            let errorMessageText = field.nextElementSibling?.textContent || "Vui lòng nhập giá trị hợp lệ";

            if (field.type === "number") {
                if (field.name.includes("variantPrice") && (!field.value.trim() || parseFloat(field.value) <= 0)) {
                    isInvalid = true;
                    errorMessageText = "Giá phải lớn hơn 0";
                } else if (field.name.includes("variantWarranty") && (!field.value.trim() || parseInt(field.value) < 0)) {
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
                if (!firstInvalid) firstInvalid = field;
            }
        });

        // Validate at least one image per variant
        document.querySelectorAll('.variant-card').forEach(variant => {
            const imageInputs = variant.querySelectorAll('input[name^="variantImage["]');
            const imageUrls = variant.querySelectorAll('input[name^="variantImageUrl["]');
            let hasImage = false;
            imageInputs.forEach(input => {
                if (input.files && input.files.length > 0) hasImage = true;
            });
            imageUrls.forEach(input => {
                if (input.value.trim()) hasImage = true;
            });
            if (!hasImage) {
                valid = false;
                const errorMessage = variant.querySelector('.images-container .error-message');
                errorMessage.textContent = "Vui lòng cung cấp ít nhất một hình ảnh hoặc URL";
                errorMessage.style.display = "block";
                if (!firstInvalid) firstInvalid = variant.querySelector('input[name^="variantImage["]');
            }
        });

        // Validate serials
        document.querySelectorAll('.serial-group').forEach(serialGroup => {
            const serialInput = serialGroup.querySelector('input[name^="variantSerial["]');
            const storeSelect = serialGroup.querySelector('select[name^="variantStoreId["]');
            if (serialInput.value.trim() && !storeSelect.value) {
                valid = false;
                storeSelect.classList.add("error-border");
                const errorMessage = storeSelect.nextElementSibling;
                errorMessage.textContent = "Vui lòng chọn cửa hàng";
                errorMessage.style.display = "block";
                if (!firstInvalid) firstInvalid = storeSelect;
            } else if (!serialInput.value.trim() && storeSelect.value) {
                valid = false;
                serialInput.classList.add("error-border");
                const errorMessage = serialInput.nextElementSibling;
                errorMessage.textContent = "Vui lòng nhập số serial";
                errorMessage.style.display = "block";
                if (!firstInvalid) firstInvalid = serialInput;
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
</script>
</body>
</html>