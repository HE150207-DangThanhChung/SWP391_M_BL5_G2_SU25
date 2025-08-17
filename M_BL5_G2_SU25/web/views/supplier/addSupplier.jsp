<%-- 
    Document   : addCoupon
    Created on : Aug 14, 2025, 8:39:55 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Supplier</title>
    </head>
    <body>
        <h2>Add New Supplier</h2>
        <form action="AddSupplierServlet" method="post">
            Supplier Name: <input type="text" name="supplierName" required><br><br>
            Address: <textarea name="address" required></textarea><br><br>
            Phone: <input type="text" name="phone" required><br><br>
            Email: <input type="email" name="email" required><br><br>
            Status:
            <select name="status">
                <option value="Active">Active</option>
                <option value="Deactive">Deactive</option>
            </select><br><br>
            Notes: <textarea name="notes"></textarea><br><br>

            <input type="submit" value="Add Supplier">
            <input type="reset" value="Reset">
        </form>
</html>
