<%-- 
    Document   : viewReceipt
    Created on : Aug 24, 2025, 3:55:51 PM
    Author     : hoang
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết hoá đơn</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <style>
            body {
                font-family: "Inter", sans-serif;
                background-color: #f8fafc;
                color: #374151;
            }
            /* In: chỉ hiện phần #print-area, ẩn .no-print */
            @media print {
                .no-print {
                    display: none !important;
                }
                body * {
                    visibility: hidden;
                }
                #print-area, #print-area * {
                    visibility: visible;
                }
                #print-area {
                    position: absolute;
                    left: 0;
                    top: 0;
                    width: 100%;
                }
            }
        </style>
    </head>
    <body class="bg-slate-50">
        <div class="layout-wrapper flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen">
                <jsp:include page="/views/common/header.jsp"/>

                <main class="content grid grid-cols-3 gap-6 p-6">
                    <!-- Danh sách order -->
                    <div class="col-span-1 bg-white rounded-lg shadow p-4 overflow-y-auto">
                        <h2 class="font-bold text-lg mb-4">Đơn hàng đã hoàn thành</h2>
                        <input type="text" placeholder="Tìm đơn hàng..."
                               class="w-full mb-4 p-2 border rounded">

                        <table class="w-full text-sm">
                            <thead>
                                <tr class="text-left border-b">
                                    <th class="p-2">Mã</th>
                                    <th class="p-2">Khách</th>
                                    <th class="p-2">Ngày</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orderList}">
                                    <tr class="cursor-pointer hover:bg-gray-100"
                                        onclick="loadReceipt(${order.id})">
                                        <td class="p-2">#${order.id}</td>
                                        <td class="p-2">${order.customerName}</td>
                                        <td class="p-2"><fmt:formatDate value="${order.date}" pattern="dd/MM/yyyy"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Preview hóa đơn -->
                    <div class="col-span-2 flex flex-col items-center">
                        <div class="w-full max-w-3xl bg-white shadow-lg rounded-lg p-8" id="print-area">
                            <!-- Header -->
                            <div class="text-center border-b pb-4 mb-6">
                                <h1 class="text-2xl font-bold uppercase">HÓA ĐƠN BÁN HÀNG</h1>
                                <p class="text-gray-600">Công ty TNHH ABC</p>
                                <p class="text-gray-600">Ngày lập: ${receipt.date}</p>
                            </div>

                            <!-- Thông tin khách hàng -->
                            <div class="grid grid-cols-2 gap-6 mb-6">
                                <div>
                                    <h2 class="font-semibold mb-1">Khách hàng</h2>
                                    <p>${receipt.customerName}</p>
                                    <p>SĐT: ${receipt.customerPhone}</p>
                                    <p>Email: ${receipt.customerEmail}</p>
                                </div>
                                <div class="text-right">
                                    <h2 class="font-semibold mb-1">Mã hóa đơn</h2>
                                    <p class="font-mono text-lg">#${receipt.id}</p>
                                    <span class="inline-block mt-2 px-3 py-1 rounded-full text-sm 
                                          ${receipt.paid ? 'bg-green-100 text-green-600' : 'bg-red-100 text-red-600'}">
                                        ${receipt.paid ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                    </span>
                                </div>
                            </div>

                            <!-- Chi tiết sản phẩm -->
                            <table class="w-full border-collapse text-sm mb-6">
                                <thead>
                                    <tr class="bg-gray-100 border-b">
                                        <th class="p-2 text-left">Sản phẩm</th>
                                        <th class="p-2 text-center">SL</th>
                                        <th class="p-2 text-right">Đơn giá</th>
                                        <th class="p-2 text-right">Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${receipt.items}">
                                        <tr class="border-b hover:bg-gray-50">
                                            <td class="p-2">${item.productName}</td>
                                            <td class="p-2 text-center">${item.quantity}</td>
                                            <td class="p-2 text-right">
                                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td class="p-2 text-right">
                                                <fmt:formatNumber value="${item.total}" type="currency" currencySymbol="₫"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Tổng cộng -->
                            <div class="flex justify-end mb-6">
                                <div class="w-1/2">
                                    <div class="flex justify-between py-1">
                                        <span>Tạm tính:</span>
                                        <span><fmt:formatNumber value="${receipt.subtotal}" type="currency" currencySymbol="₫"/></span>
                                    </div>
                                    <div class="flex justify-between py-1">
                                        <span>VAT (10%):</span>
                                        <span><fmt:formatNumber value="${receipt.vat}" type="currency" currencySymbol="₫"/></span>
                                    </div>
                                    <div class="flex justify-between py-2 border-t font-bold text-lg">
                                        <span>Tổng cộng:</span>
                                        <span><fmt:formatNumber value="${receipt.total}" type="currency" currencySymbol="₫"/></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Nút thao tác -->
                        <div class="flex justify-center space-x-3 mt-4 no-print">
                            <button onclick="printReceipt()" 
                                    class="px-4 py-2 bg-blue-600 text-white rounded-lg shadow hover:bg-blue-700">
                                In hóa đơn
                            </button>
                            <button class="px-4 py-2 bg-green-600 text-white rounded-lg shadow hover:bg-green-700">
                                Xuất PDF
                            </button>
                            <button class="px-4 py-2 bg-gray-600 text-white rounded-lg shadow hover:bg-gray-700">
                                Gửi Email
                            </button>
                        </div>
                    </div>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>

        <script>
            function printReceipt() {
                window.print();
            }

            function loadReceipt(orderId) {
                // Gọi AJAX đến servlet để lấy chi tiết hóa đơn và thay nội dung #print-area
                $.get("/receipt/detail?id=" + orderId, function (html) {
                    $("#print-area").html(html);
                });
            }
        </script>
    </body>
</html>
