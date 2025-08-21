<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm thuộc tính mới</title>
    <style>
        /* Existing styles */
    </style>
</head>
<body>
<div class="layout-wrapper d-flex">
    <jsp:include page="/views/common/sidebar.jsp" />
    <div class="main-panel">
        <jsp:include page="/views/common/header.jsp" />
        <main class="content">
            <div class="container mt-4">
                <h2 class="mb-4">Thêm thuộc tính mới</h2>
                <form action="${pageContext.request.contextPath}/attribute/add" method="post">
                    <div class="mb-3">
                        <label class="form-label">Tên thuộc tính</label>
                        <input type="text" class="form-control" name="attributeName" required>
                        <div class="error-message">Vui lòng nhập tên thuộc tính</div>
                    </div>
                    <div id="options-container">
                        <div class="mb-3">
                            <label class="form-label">Giá trị</label>
                            <input type="text" class="form-control" name="optionValue[]" required>
                            <div class="error-message">Vui lòng nhập giá trị</div>
                        </div>
                    </div>
                    <button type="button" class="btn btn-secondary mb-3" onclick="addOption()">Thêm giá trị</button>
                    <button type="submit" class="btn btn-primary">Thêm thuộc tính</button>
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
    function addOption() {
        const container = document.getElementById('options-container');
        const newOption = document.createElement('div');
        newOption.className = 'mb-3';
        newOption.innerHTML = `
            <label class="form-label">Giá trị</label>
            <input type="text" class="form-control" name="optionValue[]" required>
            <div class="error-message">Vui lòng nhập giá trị</div>
        `;
        container.appendChild(newOption);
    }
</script>
</body>
</html>