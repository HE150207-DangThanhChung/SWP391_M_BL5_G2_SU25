<%-- 
    Document   : addCategory
    Created on : Aug 16, 2025
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lí danh mục</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <style>
            html, body {
                height: 100%;
            }
            body {
                font-family: "Inter", sans-serif;
                background-color: #f9fafb;
                color: #374151;
                margin: 0;
                padding: 0;
            }
            .layout-wrapper {
                display: flex;
                min-height: 100vh;
            }
            .main-panel {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            .content {
                width: 100%;
                margin: 0;
                padding-left: 10px;
                padding-top: 0;
                display: flex;
                flex-direction: column;
                flex: 1 1 auto;
            }
            .main-panel > .footer, .main-panel > footer.footer {
                margin-top: auto;
            }
            .error-border {
                border-color: #ef4444 !important;
                box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1) !important;
            }
            .error-text {
                color: #ef4444;
                font-size: 0.875rem;
                margin-top: 0.25rem;
                display: block;
            }
            .loading {
                opacity: 0.6;
                pointer-events: none;
            }
        </style>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <div class="layout-wrapper d-flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen">
                <jsp:include page="/views/common/header.jsp"/>
                <main class="content flex-1 p-6 bg-gray-50">

                    <!-- Header -->
                    <div class="mb-8 pt-2 pl-2">
                        <div class="flex items-center justify-between">
                            <div>
                                <h1 class="text-3xl font-bold text-gray-900">Quản lí danh mục</h1>
                                <p class="text-gray-600 mt-1">Add new categories to your system</p>
                            </div>
                            <button onclick="history.back()" class="inline-flex items-center px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white font-medium rounded-lg transition-colors duration-200">
                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                                </svg>
                                Back
                            </button>
                        </div>
                    </div>

                    <!-- Form -->
                    <div class="max-w-4xl mx-auto">
                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                            <div class="p-6" id="categoryForm">
                                <div class="grid grid-cols-1 gap-6">
                                    <!-- Category Name -->
                                    <div>
                                        <label for="categoryName" class="block text-sm font-medium text-gray-700 mb-2">
                                            Category Name *
                                        </label>
                                        <input id="categoryName" type="text"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                               placeholder="Enter category name">
                                        <span id="categoryNameError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Description -->
                                    <div>
                                        <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                                            Description *
                                        </label>
                                        <textarea id="description"
                                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                                  placeholder="Enter category description"></textarea>
                                        <span id="descriptionError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Status -->
                                    <div>
                                        <label for="categoryStatus" class="block text-sm font-medium text-gray-700 mb-2">
                                            Status *
                                        </label>
                                        <select id="categoryStatus"
                                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 bg-white">
                                            <option value="">-- Select Status --</option>
                                            <option value="Active">Active</option>
                                            <option value="Deactive">Inactive</option>
                                        </select>
                                        <span id="categoryStatusError" class="error-text" style="display: none;"></span>
                                    </div>
                                </div>

                                <!-- Actions -->
                                <div class="flex flex-col sm:flex-row gap-4 mt-8 pt-6 border-t border-gray-200">
                                    <button type="button" id="addCategoryBtn" onclick="addCategory()"
                                            class="inline-flex items-center justify-center px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg transition-colors duration-200 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                                        </svg>
                                        <span id="btnText">Add Category</span>
                                    </button>
                                    <button type="button" onclick="clearForm()"
                                            class="inline-flex items-center justify-center px-6 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium rounded-lg transition-colors duration-200 focus:ring-2 focus:ring-gray-500 focus:ring-offset-2">
                                        Clear Form
                                    </button>
                                    <button type="button" onclick="history.back()"
                                            class="inline-flex items-center justify-center px-6 py-3 bg-white hover:bg-gray-50 text-gray-600 font-medium rounded-lg border border-gray-300 transition-colors duration-200 focus:ring-2 focus:ring-gray-500 focus:ring-offset-2">
                                        Cancel
                                    </button>
                                </div>
                                <p class="text-sm text-gray-500 mt-4">
                                    <span class="text-red-500">*</span> Required fields
                                </p>
                            </div>
                        </div>
                    </div>

                </main>
                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <script>
                                        function showToast(message, type = 'success') {
                                            let backgroundColor;
                                            if (type === "success")
                                                backgroundColor = "linear-gradient(to right, #00b09b, #96c93d)";
                                            else if (type === "error")
                                                backgroundColor = "linear-gradient(to right, #ff416c, #ff4b2b)";
                                            else if (type === "warning")
                                                backgroundColor = "linear-gradient(to right, #ffa502, #ff6348)";
                                            else if (type === "info")
                                                backgroundColor = "linear-gradient(to right, #1e90ff, #3742fa)";
                                            else
                                                backgroundColor = "#333";

                                            Toastify({text: message, duration: 2000, close: true, gravity: "top", position: "right", backgroundColor, stopOnFocus: true}).showToast();
                                        }

                                        function validateCategoryName(name) {
                                            const trimmed = name.trim();
                                            return trimmed ? null : 'Category name is required';
                                        }

                                        function validateDescription(desc) {
                                            const trimmed = desc.trim();
                                            return trimmed ? null : 'Description is required';
                                        }

                                        function validateStatus(status) {
                                            return status ? null : 'Please select a status';
                                        }

                                        function showFieldError(id, message) {
                                            const field = document.getElementById(id);
                                            const errorSpan = document.getElementById(id + 'Error');
                                            field.classList.add('error-border');
                                            errorSpan.textContent = message;
                                            errorSpan.style.display = 'block';
                                        }

                                        function clearFieldError(id) {
                                            const field = document.getElementById(id);
                                            const errorSpan = document.getElementById(id + 'Error');
                                            field.classList.remove('error-border');
                                            errorSpan.style.display = 'none';
                                            errorSpan.textContent = '';
                                        }

                                        function clearAllErrors() {
                                            ['categoryName', 'description', 'categoryStatus'].forEach(clearFieldError);
                                        }

                                        function validateForm() {
                                            clearAllErrors();
                                            let isValid = true;

                                            const name = document.getElementById('categoryName').value;
                                            const desc = document.getElementById('description').value;
                                            const status = document.getElementById('categoryStatus').value;

                                            const nameError = validateCategoryName(name);
                                            if (nameError) {
                                                showFieldError('categoryName', nameError);
                                                isValid = false;
                                            }

                                            const descError = validateDescription(desc);
                                            if (descError) {
                                                showFieldError('description', descError);
                                                isValid = false;
                                            }

                                            const statusError = validateStatus(status);
                                            if (statusError) {
                                                showFieldError('categoryStatus', statusError);
                                                isValid = false;
                                            }

                                            return isValid;
                                        }

                                        function addCategory() {
                                            if (!validateForm()) {
                                                showToast('Please fix the validation errors before submitting', 'error');
                                                return;
                                            }

                                            const addBtn = document.getElementById('addCategoryBtn');
                                            const btnText = document.getElementById('btnText');
                                            const form = document.getElementById('categoryForm');

                                            addBtn.disabled = true;
                                            btnText.textContent = 'Adding...';
                                            form.classList.add('loading');

                                            $.ajax({
                                                url: '${pageContext.request.contextPath}/management/category/add',
                                                method: 'POST',
                                                data: {
                                                    name: document.getElementById('categoryName').value.trim(),
                                                    description: document.getElementById('description').value.trim(),
                                                    status: document.getElementById('categoryStatus').value
                                                },
                                                success: function (response) {
                                                    if (response.ok === true) {
                                                        showToast(response.message);
                                                        clearForm();
                                                    } else {
                                                        showToast(response.message, 'error');
                                                    }
                                                },
                                                error: function (xhr) {
                                                    let msg = 'An error occurred while adding the category';
                                                    if (xhr.responseJSON?.message)
                                                        msg = xhr.responseJSON.message;
                                                    else if (xhr.responseText)
                                                        msg = xhr.responseText;
                                                    showToast(msg, 'error');
                                                },
                                                complete: function () {
                                                    addBtn.disabled = false;
                                                    btnText.textContent = 'Add Category';
                                                    form.classList.remove('loading');
                                                }
                                            });
                                        }

                                        function clearForm() {
                                            document.getElementById('categoryName').value = '';
                                            document.getElementById('description').value = '';
                                            document.getElementById('categoryStatus').value = '';
                                            clearAllErrors();
                                        }

                                        $(document).ready(function () {
                                            $('#categoryName').blur(function () {
                                                const error = validateCategoryName(this.value);
                                                error ? showFieldError('categoryName', error) : clearFieldError('categoryName');
                                            });
                                            $('#description').blur(function () {
                                                const error = validateDescription(this.value);
                                                error ? showFieldError('description', error) : clearFieldError('description');
                                            });
                                            $('#categoryStatus').change(function () {
                                                const error = validateStatus(this.value);
                                                error ? showFieldError('categoryStatus', error) : clearFieldError('categoryStatus');
                                            });
                                        });
        </script>
    </body>
</html>
