<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Thêm Biến thể Sản phẩm Mới</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                font-family: "Inter", sans-serif;
                background-color: #f0f0f0;
                color: #374151;
                margin: 0;
                padding: 0;
            }
            .container {
                max-width: 800px;
                margin-top: 50px;
                background: #fff;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .form-group {
                margin-bottom: 1.5rem;
            }
            h1, h3 {
                color: #1a202c;
                border-bottom: 2px solid #e2e8f0;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }
            .btn {
                margin-right: 10px;
            }
            #image-upload-container, #serial-container {
                border: 1px dashed #ccc;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 5px;
            }
            .image-upload, .serial-input {
                padding: 10px 0;
            }
            .image-upload:not(:last-child), .serial-input:not(:last-child) {
                border-bottom: 1px dashed #e2e8f0;
            }
            .error-message {
                color: red;
                font-size: 0.875rem;
                margin-top: 0.25rem;
                display: none;
            }
            .error-border {
                border: 2px solid red !important;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Thêm Biến thể mới cho ${product.productName}</h1>
            <p>ID sản phẩm: ${product.productId}</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/editVariant?action=add" method="post" enctype="multipart/form-data">
                <input type="hidden" name="productId" value="${product.productId}">

                <div class="form-group">
                    <label for="productCode">Mã sản phẩm:</label>
                    <input type="text" class="form-control" id="productCode" name="productCode" required>
                    <div class="error-message">Vui lòng nhập mã sản phẩm</div>
                </div>
                <div class="form-group">
                    <label for="price">Giá:</label>
                    <input type="number" class="form-control" id="price" name="price" step="0.01" required>
                    <div class="error-message">Giá phải lớn hơn 0</div>
                </div>
                <div class="form-group">
                    <label for="warrantyDurationMonth">Thời gian bảo hành (Tháng):</label>
                    <input type="number" class="form-control" id="warrantyDurationMonth" name="warrantyDurationMonth" required>
                    <div class="error-message">Thời gian bảo hành không được âm</div>
                </div>

                <h3>Thông số sản phẩm</h3>
                <c:forEach var="attribute" items="${allAttributes}">
                    <div class="form-group">
                        <label>${attribute.attributeName}:</label>
                        <select class="form-control" name="attributeOptionId[]" required>
                            <option value="">Chọn một tùy chọn...</option>
                            <c:forEach var="option" items="${attributeOptions[attribute.attributeId]}">
                                <option value="${option.attributeOptionId}">${option.value}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Vui lòng chọn ${attribute.attributeName.toLowerCase()}</div>
                    </div>
                </c:forEach>

                <h3>Hình ảnh sản phẩm</h3>
                <div id="image-upload-container">
                    <div class="image-upload">
                        <label>Hình ảnh 1:</label>
                        <input type="file" class="form-control-file" name="imageFile" accept="image/*" required>
                        <div class="error-message">Vui lòng chọn hình ảnh</div>
                    </div>
                </div>
                <button type="button" class="btn btn-secondary" onclick="addImageField()">Thêm hình ảnh khác</button>

                <h3>Serial sản phẩm</h3>
                <div id="serial-container">
                    <div class="serial-input row gx-2 align-items-end">
                        <div class="col">
                            <label>Serial 1:</label>
                            <input type="text" class="form-control" name="serialNumber[]" placeholder="Serial Number" required>
                            <div class="error-message">Vui lòng nhập serial</div>
                        </div>
                        <div class="col">
                            <label>Cửa hàng:</label>
                            <select class="form-control" name="storeId[]" required>
                                <option value="">Chọn cửa hàng...</option>
                                <c:forEach var="store" items="${stores}">
                                    <option value="${store.storeId}">${store.storeName}</option>
                                </c:forEach>
                            </select>
                            <div class="error-message">Vui lòng chọn cửa hàng</div>
                        </div>
                    </div>
                </div>
                <button type="button" class="btn btn-secondary" onclick="addSerialField()">Thêm Serial khác</button>

                <hr>
                <button type="submit" class="btn btn-success">Thêm Biến thể mới</button>
                <a href="${pageContext.request.contextPath}/product/detail?productId=${product.productId}" class="btn btn-light">Hủy</a>
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
                    <label>Hình ảnh ${imageCount}:</label>
                    <input type="file" class="form-control-file" name="imageFile" accept="image/*">
                    <div class="error-message">Vui lòng chọn hình ảnh</div>
                    <button type="button" class="btn btn-danger btn-sm" onclick="removeField(this)">Xóa</button>
                `;
                container.appendChild(div);
            }

            let serialCount = 1;
            function addSerialField() {
                serialCount++;
                const container = document.getElementById('serial-container');
                const div = document.createElement('div');
                div.className = 'serial-input row gx-2 align-items-end';
                div.innerHTML = `
                    <div class="col">
                        <label>Serial ${serialCount}:</label>
                        <input type="text" class="form-control" name="serialNumber[]" placeholder="Serial Number">
                        <div class="error-message">Vui lòng nhập serial</div>
                    </div>
                    <div class="col">
                        <label>Cửa hàng:</label>
                        <select class="form-control" name="storeId[]">
                            <option value="">Chọn cửa hàng...</option>
                            <c:forEach var="store" items="${stores}">
                                <option value="${store.storeId}">${store.storeName}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Vui lòng chọn cửa hàng</div>
                    </div>
                    <div class="col-auto">
                        <button type="button" class="btn btn-danger btn-sm" onclick="removeField(this)">Xóa</button>
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

                    // Validate attribute options
                    const attributeOptions = document.querySelectorAll('select[name="attributeOptionId[]"]');
                    const selectedOptions = new Set();
                    attributeOptions.forEach(select => {
                        if (select.value === '') {
                            select.classList.add('error-border');
                            select.nextElementSibling.style.display = 'block';
                            hasError = true;
                        } else if (selectedOptions.has(select.value)) {
                            select.classList.add('error-border');
                            select.nextElementSibling.textContent = 'Giá trị thuộc tính đã được chọn';
                            select.nextElementSibling.style.display = 'block';
                            hasError = true;
                        } else {
                            selectedOptions.add(select.value);
                        }
                    });

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