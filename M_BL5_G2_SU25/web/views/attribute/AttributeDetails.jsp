<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chi tiết thuộc tính</title>
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
                <h2 class="mb-4">Chi tiết thuộc tính: ${attribute.attributeName}</h2>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Giá trị</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="option" items="${options}">
                            <tr>
                                <td>${option.attributeOptionId}</td>
                                <td>${option.value}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <h3 class="mt-4">Thêm giá trị mới</h3>
                <form action="${pageContext.request.contextPath}/attribute/addOption" method="post">
                    <input type="hidden" name="attributeId" value="${attribute.attributeId}">
                    <div class="mb-3">
                        <label class="form-label">Giá trị mới</label>
                        <input type="text" class="form-control" name="value" required>
                        <div class="error-message">Vui lòng nhập giá trị</div>
                    </div>
                    <button type="submit" class="btn btn-primary">Thêm giá trị</button>
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
</body>
</html>