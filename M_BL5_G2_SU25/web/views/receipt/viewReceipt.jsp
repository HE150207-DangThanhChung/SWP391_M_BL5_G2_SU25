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
            html, body {
                height: 100%;
            }
            body {
                font-family: "Inter", sans-serif;
                background-color: #f0f0f0;
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
            .main-panel > .footer,
            .main-panel > footer.footer {
                margin-top: auto;
            }

            /* Khi in: chỉ hiện phần #print-area, ẩn tất cả .no-print */
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
                    top: 0;
                    left: 0;
                    width: 100%;
                    padding: 0;
                    margin: 0;
                    background: #fff;
                    font-size: 14pt;
                    line-height: 1.5;
                }
            }
        </style>
    </head>
    <body>
        <div class="layout-wrapper flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen">
                <jsp:include page="/views/common/header.jsp"/>

                <a class="text-center mt-3" href="${pageContext.request.contextPath}/receipt/edit"><button class="bg-blue-600 hover:bg-blue-900 transition text-white p-2 rounded">Chỉnh sửa giao diện hoá đơn</button></a>

                <main class="content grid grid-cols-3 gap-4 p-6">
                    <div class="col-span-1 bg-white rounded-lg shadow p-4 overflow-y-auto">
                        <h2 class="font-bold text-lg mb-4">Đơn hàng đã hoàn thành</h2>

                        <!-- Search -->
                        <form action="receipt" method="GET" class="mb-4">
                            <input type="text" placeholder="Tìm đơn hàng..." name="searchKey" value="${searchKey}"
                                   class="w-full p-2 border rounded focus:ring focus:ring-blue-200">
                            <input type="hidden" name="page" value="1"/> <!-- Reset to page 1 when searching -->
                        </form>

                        <!-- Orders Table -->
                        <table class="w-full text-sm border-collapse">
                            <thead>
                                <tr class="border-b text-gray-600">
                                    <th class="p-2 text-left">Mã</th>
                                    <th class="p-2 text-left">Khách</th>
                                    <th class="p-2 text-left">Ngày</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${odList}">
                                    <tr class="cursor-pointer hover:bg-gray-100"
                                        onclick="loadReceipt(${order.orderId})">
                                        <td class="p-2">#${order.orderId}</td>
                                        <td class="p-2">${order.customer.getFullName()}</td>
                                        <td class="p-2">
                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <div class="flex justify-between items-center mt-4 text-sm text-gray-600">
                            <span>Hiển thị ${startItem} - ${endItem} trên tổng ${totalItems} đơn</span>

                            <div class="flex space-x-1">
                                <!-- Previous Page -->
                                <c:if test="${currentPage > 1}">
                                    <a href="receipt?page=${currentPage - 1}&searchKey=${searchKey}"
                                       class="px-3 py-1 border rounded hover:bg-gray-100">«</a>
                                </c:if>

                                <!-- Page Numbers -->
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a href="receipt?page=${i}&searchKey=${searchKey}"
                                       class="px-3 py-1 border rounded 
                                       ${i == currentPage ? 'bg-blue-500 text-white' : 'hover:bg-gray-100'}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <!-- Next Page -->
                                <c:if test="${currentPage < totalPages}">
                                    <a href="receipt?page=${currentPage + 1}&searchKey=${searchKey}"
                                       class="px-3 py-1 border rounded hover:bg-gray-100">»</a>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="col-span-2 flex flex-col items-center">
                        <div id="print-area" class="w-full bg-white rounded-lg p-8">
                            <c:choose>
                                <c:when test="${not empty receipt}">
                                    <div class="text-center border-b pb-4 mb-6">
                                        <h1 class="text-2xl font-bold uppercase">HÓA ĐƠN BÁN HÀNG</h1>
                                        <p class="text-gray-600">Công ty TNHH ABC</p>
                                        <p class="text-gray-600">Ngày lập: ${receipt.date}</p>
                                    </div>

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
                                </c:when>
                                <c:otherwise>
                                    <p class="text-gray-500 text-center">Vui lòng chọn một đơn hàng để xem chi tiết hóa đơn.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="flex justify-center space-x-3 mt-4 no-print">
                            <c:if test="${not empty receipt}">
                                <button onclick="printReceipt()" 
                                        class="px-4 py-2 bg-blue-600 text-white rounded transition shadow hover:bg-blue-700">
                                    In hóa đơn
                                </button>
                            </c:if>
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
                let thue = 0;
                let tamtinh = 0;
                let tongcong = 0;
                let giamgia = 0;
                
                $.get("${pageContext.request.contextPath}/receipt/detail?id=" + orderId, function (res) {
                    console.log(res);
                    if (res.success) {
                        const r = res.order;
                        const items = res.orderDetails;

                        // Build HTML for receipt dynamically
                        let html = `
                    <div class="text-center border-b pb-4 mb-6">
                        <h1 class="text-2xl font-bold uppercase">HÓA ĐƠN BÁN HÀNG</h1>
                        <p class="text-gray-600">Công ty TNHH ABC</p>
                        <p class="text-gray-600">Ngày lập: ` + r.orderDate + `</p>
                    </div>

                    <div class="grid grid-cols-2 gap-6 mb-6">
                        <div>
                            <h2 class="font-semibold mb-1">Khách hàng</h2>
                            <p>` + r.customer.firstName + ' ' + r.customer.middleName + ' ' + r.customer.lastName + `</p>
                            <p>SĐT: ` + r.customer.phone + `</p>
                            <p>Email: ` + r.customer.email + `</p>
                        </div>
                        <div class="text-right">
                            <h2 class="font-semibold mb-1">Mã hóa đơn</h2>
                            <p class="font-mono text-lg">#` + r.orderId + `</p>
                            <span class="inline-block mt-2 px-3 py-1 rounded-full text-sm bg-green-100 text-green-600">
                                Đã thanh toán
                            </span>
                        </div>
                    </div>

                    <table class="w-full border-collapse text-sm mb-6">
                        <thead>
                            <tr class="bg-gray-100 border-b">
                                <th class="p-2 text-left">Sản phẩm</th>
                                <th class="p-2 text-center">SL</th>
                                <th class="p-2 text-center">Đơn giá</th>
                                <th class="p-2 text-center">Giảm giá</th>
                                <th class="p-2 text-center">Thuế</th>
                                <th class="p-2 text-center">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                `;

                        items.forEach(item => {
                            html += `
                        <tr class="border-b hover:bg-gray-50">
                            <td class="p-2">` + item.productName + `</td>
                            <td class="p-2 text-center">` + item.quantity + `</td>
                            <td class="p-2 text-right">` + item.price + `</td>
                            <td class="p-2 text-right">` + item.discount + `</td>
                            <td class="p-2 text-right">` + ((item.price*item.quantity)/100)*10 + `</td>
                            <td class="p-2 text-right">` + item.totalAmount + `</td>
                        </tr>
                    `;
                        
                        thue += ((item.price*item.quantity)/100)*10;
                        tamtinh += item.totalAmount;
                        giamgia += item.discount;
                        tongcong += item.totalAmount;
                    
                        });

                        html += `
                        </tbody>
                    </table>

                    <div class="flex justify-end mb-6">
                        <div class="w-1/2">
                            <div class="flex justify-between py-1">
                                <span>Tạm tính:</span>
                                <span>` + tamtinh + `</span>
                            </div>
                            <div class="flex justify-between py-1">
                                <span>Giảm giá:</span>
                                <span>` + giamgia + `</span>
                            </div>
                            <div class="flex justify-between py-1">
                                <span>Thuế:</span>
                                <span>` + thue + `</span>
                            </div>
                            <div class="flex justify-between py-2 border-t font-bold text-lg">
                                <span>Tổng cộng:</span>
                                <span>` + tongcong + `</span>
                            </div>
                        </div>
                    </div>
                `;

                        // Replace content inside print-area
                        $("#print-area").html(html);
                    } else {
                        $("#print-area").html(
                                `<p class="text-gray-500 text-center">Không tìm thấy hóa đơn.</p>`
                                );
                    }
                });
            }
        </script>
    </body>
</html>
