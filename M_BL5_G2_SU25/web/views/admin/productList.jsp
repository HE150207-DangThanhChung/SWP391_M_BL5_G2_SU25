<%-- 
    Document   : productList
    Created on : Aug 15, 2025, 4:03:56 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../admin-layout.jsp">
    <jsp:param name="title" value="Product List" />
    <jsp:param name="activePage" value="products" />
    <jsp:param name="content" value="/views/admin/productListContent.jsp" />
</jsp:include>

