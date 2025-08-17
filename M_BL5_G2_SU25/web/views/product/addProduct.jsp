<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                <form action="${pageContext.request.contextPath}/product/add" method="post" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label">Tên sản phẩm</label>
                        <input type="text" class="form-control" name="productName" required>
                        <div class="error-message">Please Input</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" name="categoryId" required>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}">${category.categoryName}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Please Input</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Thương hiệu</label>
                        <select class="form-select" name="brandId" required>
                            <c:forEach var="brand" items="${brands}">
                                <option value="${brand.brandId}">${brand.brandName}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Please Input</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nhà cung cấp</label>
                        <select class="form-select" name="supplierId" required>
                            <c:forEach var="supplier" items="${suppliers}">
                                <option value="${supplier.supplierId}">${supplier.supplierName}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Please Input</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" name="status" required>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                        <div class="error-message">Please Input</div>
                    </div>

                    <!-- Variants -->
                    <h5 class="mt-4">Biến thể</h5>
                    <div id="variants-container">
                        <div class="card mb-3">
                            <div class="card-body">
                                <h6>Biến thể 1</h6>
                                <div class="mb-3">
                                    <label class="form-label">Mã sản phẩm</label>
                                    <input type="text" class="form-control" name="variantProductCode[0]" required>
                                    <div class="error-message">Please Input</div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Giá</label>
                                    <input type="number" step="0.01" class="form-control" name="variantPrice[0]" required>
                                    <div class="error-message">Please Input</div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Bảo hành (Tháng)</label>
                                    <input type="number" class="form-control" name="variantWarranty[0]" required>
                                    <div class="error-message">Please Input</div>
                                </div>

                                <!-- Specifications -->
                                <div class="mb-3">
                                    <label class="form-label">Thông số kỹ thuật</label>
                                    <c:forEach var="specDef" items="${specifications}">
                                        <div class="mb-2">
                                            <label class="form-label">${specDef.attributeName}</label>
                                            <input type="text" class="form-control" name="specValue[${specDef.specificationId}][0]" placeholder="Nhập ${specDef.attributeName.toLowerCase()}" required>
                                            <div class="error-message">Please Input</div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Serials -->
                                <div class="mb-3">
                                    <label class="form-label">Serials</label>
                                    <div class="input-group mb-2">
                                        <input type="text" class="form-control" name="variantSerial[0][0]" required>
                                        <div class="error-message">Please Input</div>
                                        <select class="form-control" name="variantStoreId[0][0]" required>
                                            <c:forEach var="store" items="${stores}">
                                                <option value="${store.storeId}">${store.storeName}</option>
                                            </c:forEach>
                                        </select>
                                        <div class="error-message">Please Input</div>
                                    </div>
                                </div>

                                <!-- Images -->
                                <div class="mb-3">
                                    <label class="form-label">Hình ảnh</label>
                                    <input type="file" class="form-control" name="variantImage[0][]">
                                    <div class="error-message">Please Input</div>
                                    <input type="text" class="form-control" name="variantImageUrl[0][]" placeholder="URL (optional)">
                                    <div class="error-message">Please Input</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <button type="button" class="btn btn-secondary mb-3" onclick="addVariant()">Thêm biến thể</button>
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
    let variantCount = 1;

    // Add new variant block
    function addVariant() {
        variantCount++;
        const container = document.getElementById('variants-container');
        const newVariant = document.createElement('div');
        newVariant.className = 'card mb-3';
        newVariant.innerHTML = `
            <div class="card-body">
                <h6>Biến thể ${variantCount}</h6>
                <div class="mb-3">
                    <label class="form-label">Mã sản phẩm</label>
                    <input type="text" class="form-control" name="variantProductCode[${variantCount - 1}]" required>
                    <div class="error-message">Please Input</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Giá</label>
                    <input type="number" step="0.01" class="form-control" name="variantPrice[${variantCount - 1}]" required>
                    <div class="error-message">Please Input</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Bảo hành (Tháng)</label>
                    <input type="number" class="form-control" name="variantWarranty[${variantCount - 1}]" required>
                    <div class="error-message">Please Input</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thông số kỹ thuật</label>
                    <c:forEach var="specDef" items="${specifications}">
                        <div class="mb-2">
                            <label class="form-label">${specDef.attributeName}</label>
                            <input type="text" class="form-control" name="specValue[${specDef.specificationId}][${variantCount - 1}]" placeholder="Nhập ${specDef.attributeName.toLowerCase()}" required>
                            <div class="error-message">Please Input</div>
                        </div>
                    </c:forEach>
                </div>
                <div class="mb-3">
                    <label class="form-label">Serials</label>
                    <div class="input-group mb-2">
                        <input type="text" class="form-control" name="variantSerial[${variantCount - 1}][0]" required>
                        <div class="error-message">Please Input</div>
                        <select class="form-control" name="variantStoreId[${variantCount - 1}][0]" required>
                            <c:forEach var="store" items="${stores}">
                                <option value="${store.storeId}">${store.storeName}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Please Input</div>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Hình ảnh</label>
                    <input type="file" class="form-control" name="variantImage[${variantCount - 1}][]">
                    <div class="error-message">Please Input</div>
                    <input type="text" class="form-control" name="variantImageUrl[${variantCount - 1}][]" placeholder="URL (optional)">
                    <div class="error-message">Please Input</div>
                </div>
            </div>
        `;
        container.appendChild(newVariant);
    }

    // Validate form before submit
    function validateForm(event) {
        event.preventDefault(); // Prevent default submission
        const form = event.target;

        // Reset all previous error states
        const allFields = form.querySelectorAll("input[required], select[required], input[type='file']");
        allFields.forEach(field => {
            field.classList.remove("error-border");
            const errorMessage = field.nextElementSibling;
            if (errorMessage && errorMessage.classList.contains("error-message")) {
                errorMessage.style.display = "none";
            }
        });

        // Validate all required fields
        let firstInvalid = null;
        let valid = true;

        allFields.forEach(field => {
            let isInvalid = false;

            if (field.type === "file") {
                // Check if file input is empty
                if (!field.files.length) {
                    isInvalid = true;
                }
            } else {
                // Check if other inputs/selects are empty
                if (!field.value.trim()) {
                    isInvalid = true;
                }
            }

            if (isInvalid) {
                valid = false;
                field.classList.add("error-border");
                const errorMessage = field.nextElementSibling;
                if (errorMessage && errorMessage.classList.contains("error-message")) {
                    errorMessage.style.display = "block";
                }
                if (!firstInvalid) {
                    firstInvalid = field;
                }
            }
        });

        if (!valid) {
            if (firstInvalid) {
                firstInvalid.scrollIntoView({ behavior: "smooth", block: "center" });
                firstInvalid.focus();
            }
            alert("Vui lòng nhập đầy đủ các trường bắt buộc!");
        } else {
            form.submit(); // Submit form if valid
        }
    }

    // Attach validation on form submit
    document.addEventListener("DOMContentLoaded", function() {
        const form = document.querySelector("form[action$='/product/add']");
        if (form) {
            form.addEventListener("submit", validateForm);
        }
    });
</script>
</body>
</html>