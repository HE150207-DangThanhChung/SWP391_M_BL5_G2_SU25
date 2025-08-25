<%-- 
    Document   : vnpay_return
    Created on : Oct 30, 2024, 8:44:17 AM
    Author     : Duc Long
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="controller.Config"%>
<%@ page import="java.util.Map, java.util.HashMap, java.util.Enumeration" %>
<%@ page import="java.text.DecimalFormat" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment Confirmation</title>
        <!-- FontAwesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .congratulation-wrapper {
                max-width: 550px;
                margin: auto;
                box-shadow: 0 0 20px #f3f3f3;
                padding: 30px 20px;
                background-color: #fff;
                border-radius: 10px;
            }
            .congratulation-contents.center-text .congratulation-contents-icon {
                margin: auto;
            }
            .congratulation-contents-icon {
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100px;
                width: 100px;
                background-color: #65c18c;
                color: #fff;
                font-size: 50px;
                border-radius: 50%;
                margin-bottom: 30px;
            }
            .congratulation-contents-title {
                font-size: 32px;
                line-height: 36px;
                margin: -6px 0 0;
            }
            .congratulation-contents-para {
                font-size: 16px;
                line-height: 24px;
                margin-top: 15px;
            }
            .btn-wrapper {
                display: block;
            }
            .cmn-btn.btn-bg-1 {
                background: #6176f6;
                color: #fff;
                border: 2px solid transparent;
                border-radius: 3px;
                text-decoration: none;
                padding: 5px;
            }
        </style>
    </head>
    <body>
        <%
            Map<String, String> fields = new HashMap<>();
            for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = params.nextElement();
                if (!"vnp_SecureHash".equals(fieldName)) {
                    fields.put(fieldName, request.getParameter(fieldName));
                }
            }
            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            String signValue = Config.hashAllFields(fields);
            String status = "";

            if (signValue.equals(vnp_SecureHash)) {
                if ("00".equals(request.getParameter("vnp_ResponseCode"))) {
                    status = "success";
                    Config.insertOrder(request.getParameter("vnp_TxnRef"), request.getParameter("vnp_BankTranNo"));
                    Config.removeCartItem();
                    Config.updateQuantity();
                } else {
                    status = "fail";
                }
            } else {
                out.print("Chữ ký không hợp lệ");
            }

            request.setAttribute("status", status);
        %>
        <c:choose>
            <c:when test="${status eq 'success'}">
                <div class="congratulation-area text-center mt-5">
                    <div class="container">
                        <div class="congratulation-wrapper">
                            <div class="congratulation-contents center-text">
                                <div class="congratulation-contents-icon">
                                    <i class="fas fa-check"></i>
                                </div>
                                <h4>Thanh toán thành công</h4>
                                <%
                                    String amountStr = request.getParameter("vnp_Amount");
                                    double amount = 0;

                                    if (amountStr != null && !amountStr.isEmpty()) {
                                        try {
                                            amount = Double.parseDouble(amountStr) / 100;
                                        } catch (NumberFormatException e) {
                                            amount = 0;
                                        }
                                    }

                                    DecimalFormat df = new DecimalFormat("#,###");
                                    String formattedAmount = df.format(amount);
                                %>
                                <h3 class="text-primary">
                                    <%= formattedAmount%> VND
                                </h3>
                                <div class="form-group congratulation-contents-para m-auto w-75 d-flex justify-content-between">
                                    <label>Mã giao dịch thanh toán:</label>
                                    <label><%= request.getParameter("vnp_BankTranNo")%></label>
                                </div>
                                <div class="form-group congratulation-contents-para m-auto w-75 d-flex justify-content-between">
                                    <label>Thời gian thanh toán:</label>
                                    <%
                                        String payDateStr = request.getParameter("vnp_PayDate");
                                        String formattedPayDate = "";

                                        if (payDateStr != null && !payDateStr.isEmpty()) {
                                            try {
                                                SimpleDateFormat inputFormat = new SimpleDateFormat("yyyyMMddHHmmss");
                                                SimpleDateFormat outputFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

                                                Date payDate = inputFormat.parse(payDateStr);
                                                formattedPayDate = outputFormat.format(payDate);
                                            } catch (Exception e) {
                                                formattedPayDate = payDateStr; 
                                            }
                                        }
                                    %>
                                    <label><%= formattedPayDate %></label>
                                </div>
                                <div class="form-group congratulation-contents-para m-auto w-75 d-flex justify-content-between">
                                    <label>Đơn vị thụ hưởng:</label>
                                    <label>IROSSECCA</label>
                                </div>
                                <div class="form-group congratulation-contents-para m-auto w-75 d-flex justify-content-between">
                                    <label>Mã hóa đơn:</label>
                                    <label><%= request.getParameter("vnp_TxnRef")%></label>
                                </div>
                                <div class="form-group congratulation-contents-para m-auto w-75 d-flex justify-content-between">
                                    <label>Mô tả giao dịch:</label>
                                    <label>Thanh toán đơn hàng - <%= request.getParameter("vnp_OrderInfo")%></label>
                                </div>
                                <div class="form-group congratulation-contents-para m-auto w-75 d-flex justify-content-between">
                                    <label>Mã ngân hàng thanh toán:</label>
                                    <label><%= request.getParameter("vnp_BankCode")%></label>
                                </div>
                                <div class="btn-wrapper mt-4">
                                    <a href="homecustomer" class="cmn-btn btn-bg-1">Go to Home</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="congratulation-area text-center mt-5">
                    <div class="container">
                        <div class="congratulation-wrapper">
                            <div class="congratulation-contents center-text">
                                <div class="congratulation-contents-icon" style="background-color: red;">
                                    <i class="fas fa-times" style="color: white;"></i>
                                </div>
                                <h3>Thanh toán không thành công</h3>
                                <div class="btn-wrapper mt-4">
                                    <a href="homecustomer" class="cmn-btn btn-bg-1">Go to Home</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </body>
</html>
