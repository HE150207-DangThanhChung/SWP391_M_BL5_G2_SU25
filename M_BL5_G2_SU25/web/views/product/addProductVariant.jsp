<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Thêm Biến thể Sản phẩm Mới</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #4CAF50;
                --primary-color-hover: #45a049;
                --secondary-color: #6c757d;
                --background-color: #f8f9fa;
                --card-background: #ffffff;
                --text-color: #333333;
                --heading-color: #1a202c;
                --border-color: #e2e8f0;
                --error-color: #dc3545;
            }

            body {
                font-family: 'Roboto', sans-serif;
                background-color: var(--background-color);
                color: var(--text-color);
            }

            .container {
                max-width: 900px;
                margin-top: 50px;
                margin-bottom: 50px;
                background: var(--card-background);
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            }

            .card-header {
                font-weight: 700;
                padding-bottom: 20px;
                margin-bottom: 20px;
                border-bottom: 2px solid var(--border-color);
            }

            .form-group {
                margin-bottom: 24px;
            }

            .form-label {
                font-weight: 500;
                margin-bottom: 8px;
            }

            .form-control, .form-select, .form-control-file {
                border-radius: 8px;
                border: 1px solid #ced4da;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(76, 175, 80, 0.25);
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
                font-weight: 500;
                border-radius: 8px;
            }

            .btn-primary:hover {
                background-color: var(--primary-color-hover);
                border-color: var(--primary-color-hover);
            }

            .btn-secondary {
                background-color: var(--secondary-color);
                border-color: var(--secondary-color);
                border-radius: 8px;
            }

            .btn-secondary:hover {
                background-color: #5a6268;
                border-color: #545b62;
            }
            
            .btn-light {
                border-color: var(--border-color);
                border-radius: 8px;
            }

            #image-upload-container, #serial-container {
                border: 2px dashed #e9ecef;
                padding: 30px;
                margin-bottom: 30px;
                border-radius: 12px;
                background-color: #f1f3f5;
            }

            .image-upload, .serial-input {
                padding: 15px 0;
            }

            .image-upload:not(:last-child), .serial-input:not(:last-child) {
                border-bottom: 1px dashed #ced4da;
            }
            
            .row.gx-2 .col, .row.gx-2 .col-auto {
                padding-right: 0.5rem !important;
                padding-left: 0.5rem !important;
            }
            
            .alert {
                border-radius: 8px;
            }

            .error-message {
                color: var(--error-color);
                font-size: 0.875rem;
                margin-top: 0.5rem;
                display: none;
                font-weight: 500;
            }
            
            .error-border {
                border: 1px solid var(--error-color) !important;
            }
            
            .delete-btn {
                background-color: var(--error-color);
                border-color: var(--error-color);
                border-radius: 8px;
                padding: 6px 12px;
                font-size: 0.875rem;
            }
            
            .delete-btn:hover {
                background-color: #c82333;
                border-color: #bd2130;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <header class="card-header d-flex justify-content-between align-items-center">
                <h1 class="mb-0">Thêm Biến thể mới</h1>
                <p class="mb-0 text-muted">Sản phẩm: ${product.productName} (ID: ${product.productId})</p>
            </header>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/editVariant?action=add" method="post" enctype="multipart/form-data">
                <input type="hidden" name="productId" value="${product.productId}">

                <div class="form-group">
                    <label for="productCode" class="form-label">Mã sản phẩm:</label>
                    <input type="text" class="form-control" id="productCode" name="productCode">
                    <div class="error-message">Vui lòng nhập mã sản phẩm</div>
                </div>
                <div class="form-group">
                    <label for="price" class="form-label">Giá:</label>
                    <input type="number" class="form-control" id="price" name="price" step="0.01">
                    <div class="error-message">Giá phải lớn hơn 0</div>
                </div>
                <div class="form-group">
                    <label for="warrantyDurationMonth" class="form-label">Thời gian bảo hành (Tháng):</label>
                    <input type="number" class="form-control" id="warrantyDurationMonth" name="warrantyDurationMonth">
                    <div class="error-message">Thời gian bảo hành không được âm</div>
                </div>

                <h3 class="card-header mt-4">Thông số sản phẩm</h3>
                <div class="attributes-section">
                    <c:forEach var="attribute" items="${allAttributes}">
                        <div class="form-group">
                            <label for="attr-${attribute.attributeId}" class="form-label">${attribute.attributeName}:</label>
                            <select class="form-select" id="attr-${attribute.attributeId}" name="attributeOptionId[]">
                                <option value="">Chọn một tùy chọn...</option>
                                <c:forEach var="option" items="${attributeOptions[attribute.attributeId]}">
                                    <option value="${option.attributeOptionId}">${option.value}</option>
                                </c:forEach>
                            </select>
                            </div>
                    </c:forEach>
                </div>

                <h3 class="card-header mt-4">Hình ảnh sản phẩm</h3>
                <div id="image-upload-container">
                    <div class="image-upload">
                        <label for="image-1" class="form-label">Hình ảnh 1:</label>
                        <div class="d-flex align-items-center">
                            <input type="file" class="form-control-file me-2" id="image-1" name="imageFile" accept="image/*">
                        </div>
                        <div class="error-message">Vui lòng chọn hình ảnh</div>
                    </div>
                </div>
                <button type="button" class="btn btn-secondary mt-2" onclick="addImageField()">+ Thêm hình ảnh</button>

                <h3 class="card-header mt-4">Serial sản phẩm</h3>
                <div id="serial-container">
                    <div class="serial-input row g-3 align-items-end">
                        <div class="col-md-6">
                            <label for="serial-1" class="form-label">Serial 1:</label>
                            <input type="text" class="form-control" id="serial-1" name="serialNumber[]" placeholder="Nhập Serial Number">
                            <div class="error-message">Vui lòng nhập serial</div>
                        </div>
                        <div class="col-md-5">
                            <label for="store-1" class="form-label">Cửa hàng:</label>
                            <select class="form-select" id="store-1" name="storeId[]">
                                <option value="">Chọn cửa hàng...</option>
                                <c:forEach var="store" items="${stores}">
                                    <option value="${store.storeId}">${store.storeName}</option>
                                </c:forEach>
                            </select>
                            <div class="error-message">Vui lòng chọn cửa hàng</div>
                        </div>
                        <div class="col-md-1 d-flex justify-content-end">
                            </div>
                    </div>
                </div>
                <button type="button" class="btn btn-secondary mt-2" onclick="addSerialField()">+ Thêm Serial</button>

                <hr class="my-5">
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary me-2">Thêm Biến thể</button>
                    <a href="${pageContext.request.contextPath}/product/detail?productId=${product.productId}" class="btn btn-light">Hủy</a>
                </div>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            let imageCount = 1;
            function addImageField() {
                imageCount++;
                const container = document.getElementById('image-upload-container');
                const div = document.createElement('div');
                div.className = 'image-upload';
                div.innerHTML = `
                    <label for="image-\${imageCount}" class="form-label">Hình ảnh \${imageCount}:</label>
                    <div class="d-flex align-items-center">
                        <input type="file" class="form-control-file me-2" id="image-\${imageCount}" name="imageFile" accept="image/*">
                        <button type="button" class="btn delete-btn btn-sm" onclick="removeField(this)">Xóa</button>
                    </div>
                    <div class="error-message">Vui lòng chọn hình ảnh</div>
                `;
                container.appendChild(div);
            }

            let serialCount = 1;
            function addSerialField() {
                serialCount++;
                const container = document.getElementById('serial-container');
                const div = document.createElement('div');
                div.className = 'serial-input row g-3 align-items-end';
                div.innerHTML = `
                    <div class="col-md-6">
                        <label for="serial-\${serialCount}" class="form-label">Serial \${serialCount}:</label>
                        <input type="text" class="form-control" id="serial-\${serialCount}" name="serialNumber[]" placeholder="Nhập Serial Number">
                        <div class="error-message">Vui lòng nhập serial</div>
                    </div>
                    <div class="col-md-5">
                        <label for="store-\${serialCount}" class="form-label">Cửa hàng:</label>
                        <select class="form-select" id="store-\${serialCount}" name="storeId[]">
                            <option value="">Chọn cửa hàng...</option>
                            <c:forEach var="store" items="${stores}">
                                <option value="\${store.storeId}">\${store.storeName}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Vui lòng chọn cửa hàng</div>
                    </div>
                    <div class="col-md-1 d-flex justify-content-end">
                        <button type="button" class="btn delete-btn btn-sm" onclick="removeField(this)">Xóa</button>
                    </div>
                `;
                container.appendChild(div);
            }

            function removeField(button) {
                const parentDiv = button.closest('.image-upload, .serial-input');
                parentDiv.remove();
            }

            document.addEventListener('DOMContentLoaded', function() {
                const form = document.querySelector('form');
                form.addEventListener('submit', function(event) {
                    let hasError = false;

                    // Reset error states
                    document.querySelectorAll('.error-border').forEach(el => el.classList.remove('error-border'));
                    document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');

                    // Validate main fields
                    const productCode = document.getElementById('productCode');
                    if (productCode.value.trim() === '') {
                        productCode.classList.add('error-border');
                        productCode.nextElementSibling.style.display = 'block';
                        hasError = true;
                    }

                    const price = document.getElementById('price');
                    if (parseFloat(price.value) <= 0 || price.value.trim() === '') {
                        price.classList.add('error-border');
                        price.nextElementSibling.style.display = 'block';
                        hasError = true;
                    }

                    const warranty = document.getElementById('warrantyDurationMonth');
                    if (parseInt(warranty.value) < 0 || warranty.value.trim() === '') {
                        warranty.classList.add('error-border');
                        warranty.nextElementSibling.style.display = 'block';
                        hasError = true;
                    }
                    
                    // The validation for attribute dropdowns is intentionally removed as requested.

                    // Validate images
                    const imageFiles = document.querySelectorAll('input[name="imageFile"]');
                    let hasImage = false;
                    imageFiles.forEach(fileInput => {
                        if (fileInput.files.length > 0) {
                            hasImage = true;
                        }
                    });
                    if (!hasImage) {
                        document.querySelector('#image-upload-container .error-message').style.display = 'block';
                        hasError = true;
                    }

                    // Validate serials
                    const serialInputs = document.querySelectorAll('#serial-container .serial-input');
                    serialInputs.forEach(serialGroup => {
                        const serialNumberInput = serialGroup.querySelector('input[name="serialNumber[]"]');
                        const storeIdSelect = serialGroup.querySelector('select[name="storeId[]"]');

                        let serialHasError = false;
                        if (serialNumberInput.value.trim() === '') {
                            serialNumberInput.classList.add('error-border');
                            serialNumberInput.nextElementSibling.style.display = 'block';
                            serialHasError = true;
                        }

                        if (storeIdSelect.value.trim() === '') {
                            storeIdSelect.classList.add('error-border');
                            storeIdSelect.nextElementSibling.style.display = 'block';
                            serialHasError = true;
                        }

                        if (serialHasError) {
                            hasError = true;
                        }
                    });

                    if (hasError) {
                        event.preventDefault();
                        alert('Vui lòng điền đầy đủ và chính xác tất cả các trường.');
                    }
                });
            });
        </script>
    </body>
</html>