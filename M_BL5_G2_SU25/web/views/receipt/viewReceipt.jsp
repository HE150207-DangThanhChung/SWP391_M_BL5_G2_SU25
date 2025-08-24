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
        <style>
            html, body {
                height: 100%;
            }
            body {
                font-family: "Inter", sans-serif;
                background-color: #f8fafc;
                color: #374151;
                margin: 0;
                padding: 0;
            }
            .layout-wrapper {
                display: flex;
                min-height: 100vh;
            }
            .main-panel {
                flex: 1;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            .content {
                flex: 1;
                padding: 16px;
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                overflow-y: auto;
                max-height: calc(100vh - 120px); /* Account for header/footer */
            }

            /* In: chỉ hiển thị #print-area, ẩn .no-print */
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

                <main class="content flex justify-center">
                    <!-- Khung hóa đơn cần in -->
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
                    <div class="flex flex-col justify-start ml-6 space-y-3 no-print">
                        <button onclick="printReceipt()" 
                                class="px-4 py-2 bg-blue-600 text-white rounded shadow hover:bg-blue-700">
                            In hóa đơn
                        </button>
                    </div>
                </main>

                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>

        <script>
            function printReceipt() {
                window.print();
            }
        </script>
    </body>
</html>
