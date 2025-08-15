<%-- 
    Document   : layout
    Created on : Aug 15, 2025
    Author     : hoang
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>RSPS - ${title}</title>
        
        <!-- Toastify -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        
        <!-- Tailwind -->
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        
        <!-- JQuery -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        
        <!-- SweetAlert -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body class="bg-gray-100 min-h-screen flex flex-col">

        <!-- Shared Header -->
        <header class="bg-white shadow p-4">
            <h1 class="text-2xl font-bold">RSPS System</h1>
        </header>

        <div class="flex flex-1">
            <!-- Sidebar -->
            <aside class="w-64 bg-gray-800 text-white p-4">
                <nav class="space-y-2">
                    <a href="home" class="block py-2 px-3 rounded hover:bg-gray-700">Home</a>
                    <a href="${pageContext.request.contextPath}/management/category" class="block py-2 px-3 rounded hover:bg-gray-700">Category Management</a>
                </nav>
            </aside>

            <!-- Main Content -->
            <main class="flex-1 p-6">
                <jsp:include page="${contentPage}" />
            </main>
        </div>

        <!-- Shared Footer -->
        <footer class="bg-white shadow p-4 text-center">
            <p>&copy; 2025 RSPS. All rights reserved.</p>
        </footer>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    </body>
</html>
