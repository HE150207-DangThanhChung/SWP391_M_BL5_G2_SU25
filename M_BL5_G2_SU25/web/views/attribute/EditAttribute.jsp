<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chỉnh sửa thuộc tính</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Add your existing styles here for a consistent look */
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
        h3 {
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
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
                <h2 class="mb-4">Chỉnh sửa thuộc tính</h2>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/attribute/edit" method="post">
                    <input type="hidden" name="attributeId" value="${attribute.attributeId}">

                    <div class="form-group">
                        <label for="attributeName">Tên thuộc tính:</label>
                        <input type="text" class="form-control" id="attributeName" name="attributeName" value="${attribute.attributeName}" required>
                    </div>

                    <h3>Các giá trị hiện tại</h3>
                    <div id="existing-options">
                        <c:forEach var="option" items="${options}">
                            <div class="form-group row gx-2 align-items-center">
                                <div class="col-sm-10">
                                    <input type="hidden" name="existingOptionId[]" value="${option.attributeOptionId}">
                                    <input type="text" class="form-control" name="existingOptionValue[]" value="${option.value}" required>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <hr>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    <a href="${pageContext.request.contextPath}/attribute/list" class="btn btn-light">Hủy</a>
                </form>
            </div>
        </main>
        <jsp:include page="/views/common/footer.jsp" />
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script>
    function addNewOptionField() {
        const container = document.getElementById('new-options');
        const div = document.createElement('div');
        div.className = 'form-group';
        div.innerHTML = `
            <input type="text" class="form-control" name="newOptionValue[]" placeholder="Nhập giá trị mới">
        `;
        container.appendChild(div);
    }
    
    function removeOption(button) {
        button.closest('.form-group').remove();
    }
</script>
</body>
</html>