<%-- 
    Document   : ownerDashboard
    Created on : Aug 14, 2025, 8:39:00 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lí nhà cung cấp</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <style>
            /* 1) Make the page span the viewport height */
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

            /* 2) Ensure the outer wrapper and right panel are full-height flex columns */
            .layout-wrapper {
                display: flex;
                min-height: 100vh;       /* key */
            }

            .main-panel {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;  /* header | main | footer stacked */
                min-height: 100vh;       /* key */
            }

            /* 3) Let main content grow to fill available space */
            .content {
                width: 100%;
                margin: 0;
                padding-left: 10px;
                padding-top: 0;
                display: flex;
                flex-direction: column;
                flex: 1 1 auto;          /* key: pushes footer down */
            }

            /* 4) Footer sits at the bottom by taking remaining space above it */
            .main-panel > .footer,
            .main-panel > footer.footer {
                margin-top: auto;        /* key */
            }

            /* Error styles for validation */
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

            /* Loading state */
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
                    <!-- Header Section -->
                    <div class="mb-8">
                        <div class="flex items-center justify-between">
                            <div>
                                <h1 class="text-3xl font-bold text-gray-900">Quản lí nhà cung cấp</h1>
                                <p class="text-gray-600 mt-1">Add new suppliers to your system</p>
                            </div>
                            <button onclick="history.back()"
                                    class="inline-flex items-center px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white font-medium rounded-lg transition-colors duration-200">
                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                                </svg>
                                Back
                            </button>
                        </div>
                    </div>

                    <!-- Form Container -->
                    <div class="max-w-4xl mx-auto">
                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">

                            <!-- Form Body -->
                            <div class="p-6" id="supplierForm">
                                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                                    <!-- Supplier Name -->
                                    <div class="lg:col-span-2">
                                        <label for="supplierName" class="block text-sm font-medium text-gray-700 mb-2">
                                            Supplier Name *
                                        </label>
                                        <input id="supplierName" 
                                               type="text" 
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="Enter supplier company name">
                                        <span id="supplierNameError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Supplier Phone -->
                                    <div>
                                        <label for="supplierPhone" class="block text-sm font-medium text-gray-700 mb-2">
                                            Phone Number *
                                        </label>
                                        <input id="supplierPhone" 
                                               type="tel" 
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="0123456789 or +84123456789">
                                        <span id="supplierPhoneError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Supplier Email -->
                                    <div>
                                        <label for="supplierEmail" class="block text-sm font-medium text-gray-700 mb-2">
                                            Email Address *
                                        </label>
                                        <input id="supplierEmail" 
                                               type="email" 
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="supplier@company.com">
                                        <span id="supplierEmailError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Supplier Tax Code -->
                                    <div>
                                        <label for="supplierTaxCode" class="block text-sm font-medium text-gray-700 mb-2">
                                            Tax Code *
                                        </label>
                                        <input id="supplierTaxCode" 
                                               type="text" 
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 placeholder-gray-400"
                                               placeholder="Enter tax identification number">
                                        <span id="supplierTaxCodeError" class="error-text" style="display: none;"></span>
                                    </div>

                                    <!-- Supplier Status -->
                                    <div>
                                        <label for="supplierStatus" class="block text-sm font-medium text-gray-700 mb-2">
                                            Status *
                                        </label>
                                        <select id="supplierStatus" 
                                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200 bg-white">
                                            <option value="">-- Select Status --</option>
                                            <option value="active">Active</option>
                                            <option value="inactive">Inactive</option>
                                        </select>
                                        <span id="supplierStatusError" class="error-text" style="display: none;"></span>
                                    </div>
                                </div>

                                <!-- Form Actions -->
                                <div class="flex flex-col sm:flex-row gap-4 mt-8 pt-6 border-t border-gray-200">
                                    <button type="button" 
                                            id="addSupplierBtn"
                                            onclick="addSupplier()"
                                            class="inline-flex items-center justify-center px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg transition-colors duration-200 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                                        </svg>
                                        <span id="btnText">Add Supplier</span>
                                    </button>

                                    <button type="button" 
                                            onclick="clearForm()"
                                            class="inline-flex items-center justify-center px-6 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium rounded-lg transition-colors duration-200 focus:ring-2 focus:ring-gray-500 focus:ring-offset-2">
                                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
                                        </svg>
                                        Clear Form
                                    </button>

                                    <button type="button" 
                                            onclick="history.back()"
                                            class="inline-flex items-center justify-center px-6 py-3 bg-white hover:bg-gray-50 text-gray-600 font-medium rounded-lg border border-gray-300 transition-colors duration-200 focus:ring-2 focus:ring-gray-500 focus:ring-offset-2">
                                        Cancel
                                    </button>
                                </div>

                                <!-- Required Fields Note -->
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

                                                    if (type === "success") {
                                                        backgroundColor = "linear-gradient(to right, #00b09b, #96c93d)"; // Green
                                                    } else if (type === "error") {
                                                        backgroundColor = "linear-gradient(to right, #ff416c, #ff4b2b)"; // Red
                                                    } else if (type === "warning") {
                                                        backgroundColor = "linear-gradient(to right, #ffa502, #ff6348)"; // Orange
                                                    } else if (type === "info") {
                                                        backgroundColor = "linear-gradient(to right, #1e90ff, #3742fa)"; // Blue
                                                    } else {
                                                        backgroundColor = "#333";
                                                    }

                                                    Toastify({
                                                        text: message,
                                                        duration: 2000,
                                                        close: true,
                                                        gravity: "top",
                                                        position: "right",
                                                        backgroundColor: backgroundColor,
                                                        stopOnFocus: true
                                                    }).showToast();
                                                }

                                                function validateSupplierName(name) {
                                                    const trimmedName = name.trim();
                                                    if (!trimmedName || trimmedName === '') {
                                                        return 'Supplier name is required and cannot be empty or just spaces';
                                                    }
                                                    return null;
                                                }

                                                function validateVietnamesePhone(phone) {
                                                    const trimmedPhone = phone.trim();

                                                    if (!trimmedPhone) {
                                                        return 'Phone number is required and cannot be empty or just spaces';
                                                    }

                                                    const vietnamesePhoneRegex =
                                                            /^(\+84|84|0)(3[2-9]|5[689]|7[06-9]|8[1-9]|9[0-46-9])[0-9]{7}$|^(\+84|84|0)(2[0-9])[0-9]{8}$/;

                                                    if (!vietnamesePhoneRegex.test(trimmedPhone)) {
                                                        return 'Please enter a valid Vietnamese phone number (e.g., 0912345678, +84912345678)';
                                                    }
                                                    return null;
                                                }

                                                function validateEmail(email) {
                                                    const trimmedEmail = email.trim();
                                                    if (!trimmedEmail || trimmedEmail === '') {
                                                        return 'Email address is required and cannot be empty or just spaces';
                                                    }

                                                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                                    if (!emailRegex.test(trimmedEmail)) {
                                                        return 'Please enter a valid email address';
                                                    }
                                                    return null;
                                                }

                                                function validateTaxCode(taxCode) {
                                                    const trimmedTaxCode = taxCode.trim();
                                                    if (!trimmedTaxCode || trimmedTaxCode === '') {
                                                        return 'Tax code is required and cannot be empty or just spaces';
                                                    }
                                                    return null;
                                                }

                                                function validateStatus(status) {
                                                    if (!status || status === '') {
                                                        return 'Please select a status';
                                                    }
                                                    return null;
                                                }

                                                function clearFieldError(fieldId) {
                                                    const field = document.getElementById(fieldId);
                                                    const errorSpan = document.getElementById(fieldId + 'Error');

                                                    field.classList.remove('error-border');
                                                    errorSpan.style.display = 'none';
                                                    errorSpan.textContent = '';
                                                }

                                                function showFieldError(fieldId, message) {
                                                    const field = document.getElementById(fieldId);
                                                    const errorSpan = document.getElementById(fieldId + 'Error');

                                                    field.classList.add('error-border');
                                                    errorSpan.textContent = message;
                                                    errorSpan.style.display = 'block';
                                                }

                                                function clearAllErrors() {
                                                    const fields = ['supplierName', 'supplierPhone', 'supplierEmail', 'supplierTaxCode', 'supplierStatus'];
                                                    fields.forEach(fieldId => clearFieldError(fieldId));
                                                }

                                                function validateForm() {
                                                    clearAllErrors();

                                                    const name = document.getElementById('supplierName').value;
                                                    const phone = document.getElementById('supplierPhone').value;
                                                    const email = document.getElementById('supplierEmail').value;
                                                    const taxCode = document.getElementById('supplierTaxCode').value;
                                                    const status = document.getElementById('supplierStatus').value;

                                                    let isValid = true;

                                                    const nameError = validateSupplierName(name);
                                                    if (nameError) {
                                                        showFieldError('supplierName', nameError);
                                                        isValid = false;
                                                    }

                                                    const phoneError = validateVietnamesePhone(phone);
                                                    if (phoneError) {
                                                        showFieldError('supplierPhone', phoneError);
                                                        isValid = false;
                                                    }

                                                    const emailError = validateEmail(email);
                                                    if (emailError) {
                                                        showFieldError('supplierEmail', emailError);
                                                        isValid = false;
                                                    }

                                                    const taxCodeError = validateTaxCode(taxCode);
                                                    if (taxCodeError) {
                                                        showFieldError('supplierTaxCode', taxCodeError);
                                                        isValid = false;
                                                    }

                                                    const statusError = validateStatus(status);
                                                    if (statusError) {
                                                        showFieldError('supplierStatus', statusError);
                                                        isValid = false;
                                                    }

                                                    return isValid;
                                                }

                                                function addSupplier() {
                                                    if (!validateForm()) {
                                                        showToast('Please fix the validation errors before submitting', 'error');
                                                        return;
                                                    }

                                                    const addBtn = document.getElementById('addSupplierBtn');
                                                    const btnText = document.getElementById('btnText');
                                                    const form = document.getElementById('supplierForm');

                                                    addBtn.disabled = true;
                                                    btnText.textContent = 'Adding...';
                                                    form.classList.add('loading');

                                                    const supplierData = {
                                                        name: document.getElementById('supplierName').value.trim(),
                                                        phone: document.getElementById('supplierPhone').value.trim(),
                                                        email: document.getElementById('supplierEmail').value.trim(),
                                                        taxCode: document.getElementById('supplierTaxCode').value.trim(),
                                                        status: document.getElementById('supplierStatus').value
                                                    };

                                                    $.ajax({
                                                        url: '${pageContext.request.contextPath}/management/suppliers/add', 
                                                        method: 'POST',
                                                        data: JSON.stringify(supplierData),
                                                        contentType: 'application/json',
                                                        success: function (response) {
                                                            showToast('Supplier added successfully!', 'success');
                                                            clearForm();
                                                        },
                                                        error: function (xhr, status, error) {
                                                            console.error('Error:', error);
                                                            let errorMessage = 'An error occurred while adding the supplier';

                                                            if (xhr.responseJSON && xhr.responseJSON.message) {
                                                                errorMessage = xhr.responseJSON.message;
                                                            } else if (xhr.responseText) {
                                                                errorMessage = xhr.responseText;
                                                            }

                                                            showToast(errorMessage, 'error');
                                                        },
                                                        complete: function () {
                                                            addBtn.disabled = false;
                                                            btnText.textContent = 'Add Supplier';
                                                            form.classList.remove('loading');
                                                        }
                                                    });
                                                }

                                                // Clear form function
                                                function clearForm() {
                                                    document.getElementById('supplierName').value = '';
                                                    document.getElementById('supplierPhone').value = '';
                                                    document.getElementById('supplierEmail').value = '';
                                                    document.getElementById('supplierTaxCode').value = '';
                                                    document.getElementById('supplierStatus').value = '';
                                                    clearAllErrors();
                                                }

                                                // Add real-time validation on blur
                                                $(document).ready(function () {
                                                    $('#supplierName').blur(function () {
                                                        const error = validateSupplierName(this.value);
                                                        if (error) {
                                                            showFieldError('supplierName', error);
                                                        } else {
                                                            clearFieldError('supplierName');
                                                        }
                                                    });

                                                    $('#supplierPhone').blur(function () {
                                                        const error = validateVietnamesePhone(this.value);
                                                        if (error) {
                                                            showFieldError('supplierPhone', error);
                                                        } else {
                                                            clearFieldError('supplierPhone');
                                                        }
                                                    });

                                                    $('#supplierEmail').blur(function () {
                                                        const error = validateEmail(this.value);
                                                        if (error) {
                                                            showFieldError('supplierEmail', error);
                                                        } else {
                                                            clearFieldError('supplierEmail');
                                                        }
                                                    });

                                                    $('#supplierTaxCode').blur(function () {
                                                        const error = validateTaxCode(this.value);
                                                        if (error) {
                                                            showFieldError('supplierTaxCode', error);
                                                        } else {
                                                            clearFieldError('supplierTaxCode');
                                                        }
                                                    });

                                                    $('#supplierStatus').change(function () {
                                                        const error = validateStatus(this.value);
                                                        if (error) {
                                                            showFieldError('supplierStatus', error);
                                                        } else {
                                                            clearFieldError('supplierStatus');
                                                        }
                                                    });
                                                });
        </script>
    </body>
</html>