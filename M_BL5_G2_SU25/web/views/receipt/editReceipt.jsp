<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Receipt</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
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

            @media print {
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
                .no-print {
                    display: none !important;
                }
            }
        </style>
    </head>
    <body class="bg-gray-100 p-6">
        <div class="layout-wrapper flex">
            <jsp:include page="/views/common/sidebar.jsp"/>
            <div class="main-panel flex flex-col min-h-screen">
                <jsp:include page="/views/common/header.jsp"/>

                <a class="text-center mt-3" href="${pageContext.request.contextPath}/receipt"><button class="bg-gray-600 hover:bg-gray-900 transition text-white p-2 rounded">Quay lại</button></a>

                <main class="grid grid-cols-2 gap-6 p-3">
                    <section class="bg-white shadow rounded-lg p-4">
                        <h2 class="text-lg font-semibold mb-4">Chỉnh sửa giao diện hóa đơn</h2>

                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium">Tiêu đề hóa đơn</label>
                                <input type="text" id="receipt-title" value="${title}"
                                       class="w-full border rounded p-2" oninput="updatePreview()">
                            </div>

                            <div>
                                <label class="block text-sm font-medium">Font chữ</label>
                                <select id="receipt-font" class="w-full border rounded p-2" onchange="updatePreview()">
                                    <option value="'Inter', sans-serif" ${font == "'Inter', sans-serif" ? "selected" : ""}>Inter</option>
                                    <option value="'Times New Roman', serif" ${font == "'Times New Roman', serif" ? "selected" : ""}>Times New Roman</option>
                                    <option value="'Courier New', monospace" ${font == "'Courier New', monospace" ? "selected" : ""}>Courier New</option>
                                </select>
                            </div>

                            <div>
                                <label class="block text-sm font-medium">Màu tiêu đề</label>
                                <input type="color" id="receipt-color" value="${color}" onchange="updatePreview()">
                            </div>

                            <div>
                                <label class="block text-sm font-medium">Logo cửa hàng</label>
                                <input type="file" id="receipt-logo" accept="image/*" onchange="previewLogo(event)">
                            </div>

                            <div>
                                <button id="save-receipt" 
                                        class="bg-green-600 hover:bg-green-900 transition text-white p-2 rounded">
                                    Lưu
                                </button>
                                <button class="bg-red-600 hover:bg-red-900 transition text-white p-2 rounded">Huỷ</button>
                            </div>
                        </div>
                    </section>

                    <section>
                        <div id="print-area" class="bg-white shadow rounded-lg p-6">
                            <div class="flex justify-center mb-2">
                                <img id="preview-logo" src="" alt="" class="max-h-16 hidden">
                            </div>

                            <h1 id="preview-title" class="text-2xl font-bold text-center text-blue-900">
                                HÓA ĐƠN BÁN HÀNG
                            </h1>
                            <p class="text-sm text-center">Ngày: 24/08/2025</p>
                            <hr class="my-4">

                            <table class="w-full text-sm">
                                <thead>
                                    <tr class="border-b">
                                        <th class="text-left py-2">Sản phẩm</th>
                                        <th class="text-right py-2">Số lượng</th>
                                        <th class="text-right py-2">Giá</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Áo thun</td>
                                        <td class="text-right">2</td>
                                        <td class="text-right">200.000đ</td>
                                    </tr>
                                    <tr>
                                        <td>Quần jeans</td>
                                        <td class="text-right">1</td>
                                        <td class="text-right">400.000đ</td>
                                    </tr>
                                </tbody>
                            </table>

                            <hr class="my-4">
                            <p class="text-right font-bold">Tổng: 600.000đ</p>
                        </div>

                        <div class="flex justify-center mt-4 no-print">
                            <button onclick="window.print()" 
                                    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                In thử
                            </button>
                        </div>
                    </section>
                </main>
                <jsp:include page="/views/common/footer.jsp"/>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <script>
                                $(document).ready(function () {
                                    const title = document.getElementById("receipt-title").value;
                                    document.getElementById("preview-title").innerText = '${title}';

                                    const font = document.getElementById("receipt-font").value;
                                    document.getElementById("print-area").style.fontFamily = `${font}`;

                                    const color = document.getElementById("receipt-color").value;
                                    document.getElementById("preview-title").style.color = `${color}`;

                                    if ('${logo}' !== '') {
                                        const logo = document.getElementById("preview-logo");
                                        logo.src = '${pageContext.request.contextPath}/${logo}';
                                        logo.classList.remove("hidden");
                                    }
                                });

                                document.getElementById("save-receipt").addEventListener("click", function () {
                                    const title = document.getElementById("receipt-title").value;
                                    const font = document.getElementById("receipt-font").value;
                                    const color = document.getElementById("receipt-color").value;
                                    const logoFile = document.getElementById("receipt-logo").files[0];

                                    const formData = new FormData();
                                    formData.append('title', title);
                                    formData.append('font', font);
                                    formData.append('color', color);

                                    if (logoFile) {
                                        formData.append('logo', logoFile);
                                    }

                                    $.ajax({
                                        url: "${pageContext.request.contextPath}/receipt/edit",
                                        type: "POST",
                                        data: formData,
                                        processData: false,
                                        contentType: false,
                                        success: function (response) {
                                            if (response.success) {
                                                showToast(response.message);
                                            } else {
                                                showToast(response.message, "error");
                                            }
                                        },
                                        error: function (xhr, status, error) {
                                            console.error("AJAX Error:", status, error);
                                            showToast("Không thể kết nối server.", "error");
                                        }
                                    });
                                });

                                function updatePreview() {
                                    const title = document.getElementById("receipt-title").value;
                                    document.getElementById("preview-title").innerText = title;

                                    const font = document.getElementById("receipt-font").value;
                                    document.getElementById("print-area").style.fontFamily = font;

                                    const color = document.getElementById("receipt-color").value;
                                    document.getElementById("preview-title").style.color = color;

                                    console.log(title + font + color)
                                }

                                function previewLogo(event) {
                                    const file = event.target.files[0];
                                    if (file) {
                                        const reader = new FileReader();
                                        reader.onload = function (e) {
                                            const logo = document.getElementById("preview-logo");
                                            logo.src = e.target.result;
                                            logo.classList.remove("hidden");
                                        };
                                        reader.readAsDataURL(file);
                                    }
                                }

                                function showToast(message, type) {
                                    let colors = {
                                        success: "linear-gradient(to right, #00b09b, #96c93d)",
                                        error: "linear-gradient(to right, #ff416c, #ff4b2b)"
                                    };
                                    Toastify({
                                        text: message,
                                        duration: 2000,
                                        close: true,
                                        gravity: "top",
                                        position: "right",
                                        backgroundColor: colors[type] || "#333"
                                    }).showToast();
                                }
        </script>

    </body>
</html>
