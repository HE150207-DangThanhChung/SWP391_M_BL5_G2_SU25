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
                </div>
                <div class="form-group">
                    <label for="price">Giá:</label>
                    <input type="number" class="form-control" id="price" name="price" step="0.01" required>
                </div>
                <div class="form-group">
                    <label for="warrantyDurationMonth">Thời gian bảo hành (Tháng):</label>
                    <input type="number" class="form-control" id="warrantyDurationMonth" name="warrantyDurationMonth" required>
                </div>

                <h3>Thông số sản phẩm</h3>
                <c:forEach var="attribute" items="${allAttributes}">
                    <div class="form-group">
                        <label>${attribute.attributeName}:</label>
                        <select class="form-control" name="attributeOptionId[]" required>
                            <option value="">Chọn một tùy chọn...</option>
                            <c:forEach var="option" items="${attributeOptions.get(attribute.attributeId)}">
                                <option value="${option.attributeOptionId}">${option.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </c:forEach>

                <h3>Hình ảnh sản phẩm</h3>
                <div id="image-upload-container">
                    <div class="image-upload">
                        <label>Hình ảnh 1:</label>
                        <input type="file" class="form-control-file" name="imageFile" accept="image/*" required>
                    </div>
                </div>
                <button type="button" class="btn btn-secondary" onclick="addImageField()">Thêm hình ảnh khác</button>

                <h3>Serial sản phẩm</h3>
                <div id="serial-container">
                    <div class="serial-input row gx-2 align-items-end">
                        <div class="col">
                            <label>Serial 1:</label>
                            <input type="text" class="form-control" name="serialNumber[]" placeholder="Serial Number" required>
                        </div>
                        <div class="col">
                            <label>Cửa hàng:</label>
                            <select class="form-control" name="storeId[]" required>
                                <option value="">Chọn cửa hàng...</option>
                                <c:forEach var="store" items="${stores}">
                                    <option value="${store.storeId}">${store.storeName}</option>
                                </c:forEach>
                            </select>
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
                    </div>
                    <div class="col">
                        <label>Cửa hàng:</label>
                        <select class="form-control" name="storeId[]">
                            <option value="">Chọn cửa hàng...</option>
                            <c:forEach var="store" items="${stores}">
                                <option value="${store.storeId}">${store.storeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                `;
                container.appendChild(div);
            }
        </script>
    </body>
</html>