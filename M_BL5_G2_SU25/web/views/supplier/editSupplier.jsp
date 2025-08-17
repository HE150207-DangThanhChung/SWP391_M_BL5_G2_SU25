<%-- 
    Document   : editSupplier
    Created on : Aug 14, 2025, 8:40:18 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Supplier</title>
    </head>
    <body>
        <h2>Edit Supplier</h2>
        <form action="EditSupplierServlet" method="post">
            <input type="hidden" name="supplierId" value="<%= supplier.getSupplierId() %>">

            Supplier Name: 
            <input type="text" name="supplierName" value="<%= supplier.getSupplierName() %>" required><br><br>

            Address: 
            <textarea name="address" required><%= supplier.getAddress() %></textarea><br><br>

            Phone: 
            <input type="text" name="phone" value="<%= supplier.getPhone() %>" required><br><br>

            Email: 
            <input type="email" name="email" value="<%= supplier.getEmail() %>" required><br><br>

            Status:
            <select name="status">
                <option value="Active" <%= "Active".equals(supplier.getStatus()) ? "selected" : "" %>>Active</option>
                <option value="Deactive" <%= "Deactive".equals(supplier.getStatus()) ? "selected" : "" %>>Deactive</option>
            </select><br><br>

            Notes:
            <textarea name="notes"><%= supplier.getNotes() %></textarea><br><br>

            <input type="submit" value="Update Supplier">
            <input type="reset" value="Reset">
        </form>
    </body>
</html>
