<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh sách thuộc tính</title>
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
                <h2 class="mb-4">Danh sách thuộc tính</h2>
                <a href="${pageContext.request.contextPath}/attribute/add" class="btn btn-primary mb-3">Thêm thuộc tính mới</a>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên thuộc tính</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="attribute" items="${attributes}">
                            <tr>
                                <td>${attribute.attributeId}</td>
                                <td>${attribute.attributeName}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/attribute/detail?attributeId=${attribute.attributeId}" class="btn btn-info btn-sm">Chi tiết</a>
                                    <a href="${pageContext.request.contextPath}/attribute/edit?attributeId=${attribute.attributeId}" class="btn btn-warning btn-sm">Chỉnh sửa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
        <jsp:include page="/views/common/footer.jsp" />
    </div>
</div>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>