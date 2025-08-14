<%-- 
    Document   : listCoupon
    Created on : Aug 14, 2025, 8:39:48 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>List of Suppliers</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        table, th, td {
            border: 1px solid black;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        a {
            text-decoration: none;
        }
    </style>
</head>
<body>
    <h2>Supplier List</h2>
    <a href="addSupplier.jsp">+ Add New Supplier</a>
    <br><br>
    <table>
        <tr>
            <th>ID</th>
            <th>Supplier Name</th>
            <th>Address</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Status</th>
            <th>Notes</th>
            <th>Actions</th>
        </tr>
        
        
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td>
                <a ><button>Edit</button></a> |
                <a >
                    <button>Delete</button>
                </a>
            </td>
        </tr>
        
    </table>
</body>
</html>
