<%-- 
    Document   : productDetailContent
    Created on : Aug 15, 2025, 4:11:14 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="container mt-4">
    <h2>Product Details</h2>
    <c:if test="${product != null}">
        <div class="card">
            <div class="card-body">
                <p><strong>ID:</strong> ${product.productId}</p>
                <p><strong>Name:</strong> ${product.productName}</p>
                <p><strong>Brand:</strong> ${product.brandName}</p>
                <p><strong>Category:</strong> ${product.categoryName}</p>
                <p><strong>Product Code:</strong> ${product.productCode}</p>
                <p><strong>Price:</strong> ${product.price}</p>
                <p><strong>Quantity:</strong> ${product.quantity}</p>
                <p><strong>Status:</strong> ${product.status}</p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary mt-3">Back to List</a>
    </c:if>
    <c:if test="${product == null}">
        <p>Product not found.</p>
        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Back to List</a>
    </c:if>
</div>
