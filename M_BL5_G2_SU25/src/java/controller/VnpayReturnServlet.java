package controller;

import dal.OrderDAO;
import dal.PaymentsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Enumeration;
import model.Order;
import model.Payments;

@WebServlet(name = "VnpayReturnServlet", urlPatterns = {"/vnpay_return"})
public class VnpayReturnServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private PaymentsDAO paymentsDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        paymentsDAO = new PaymentsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processVnpayReturn(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processVnpayReturn(request, response);
    }

    private void processVnpayReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
    // Lấy orderId từ vnp_OrderInfo (ví dụ: "Thanh toan don hang 49")
    String vnpOrderInfo = request.getParameter("vnp_OrderInfo");
    String orderId = null;
    if (vnpOrderInfo != null) {
        // Xử lý cả trường hợp có dấu + hoặc khoảng trắng
        String prefixSpace = "Thanh toan don hang ";
        String prefixPlus = "Thanh+toan+don+hang+";
        if (vnpOrderInfo.startsWith(prefixSpace)) {
            orderId = vnpOrderInfo.replace(prefixSpace, "").trim();
        } else if (vnpOrderInfo.startsWith(prefixPlus)) {
            orderId = vnpOrderInfo.replace(prefixPlus, "").trim();
        }
    }
        String errorMessage = "";
        String formattedAmount = "0";
        String formattedPayDate = "Không xác định";

        // Xử lý số tiền
        String amountStr = request.getParameter("vnp_Amount");
        if (amountStr != null && !amountStr.isEmpty()) {
            try {
                DecimalFormat df = new DecimalFormat("#,###");
                double amount = Double.parseDouble(amountStr) / 100;
                formattedAmount = df.format(amount);
            } catch (NumberFormatException e) {
                formattedAmount = "0";
            }
        }

        // Xử lý thời gian thanh toán
        String payDateStr = request.getParameter("vnp_PayDate");
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

        // Chỉ cần check vnp_ResponseCode == "00" là thành công
        String responseCode = request.getParameter("vnp_ResponseCode");
        if ("00".equals(responseCode)) {
            status = "success";
            try {
                Order order = orderDAO.getOrderById(Integer.parseInt(orderId));
                if (order != null) {
                    order.setStatus("Đã thanh toán");
                    orderDAO.updateOrder(order);
                    Payments payment = paymentsDAO.getPaymentByOrderId(Integer.parseInt(orderId));
                    if (payment != null) {
                        payment.setPaymentStatus("Đã thanh toán");
                        payment.setTransactionCode(request.getParameter("vnp_BankTranNo") != null 
                            ? request.getParameter("vnp_BankTranNo") : orderId);
                        paymentsDAO.updatePayment(payment);
                    }
                } else {
                    status = "fail";
                    errorMessage = "Không tìm thấy đơn hàng #" + orderId;
                }
            } catch (Exception e) {
                status = "fail";
                errorMessage = "Lỗi cập nhật đơn hàng: " + e.getMessage();
            }
        } else {
            status = "fail";
            errorMessage = getVnpayErrorMessage(responseCode);
        }

        // Đặt các thuộc tính cho JSP
        request.setAttribute("status", status);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("formattedAmount", formattedAmount);
        request.setAttribute("formattedPayDate", formattedPayDate);
        request.setAttribute("vnp_BankTranNo", request.getParameter("vnp_BankTranNo"));
        request.setAttribute("vnp_TxnRef", request.getParameter("vnp_TxnRef"));
        request.setAttribute("vnp_OrderInfo", request.getParameter("vnp_OrderInfo"));
        request.setAttribute("vnp_BankCode", request.getParameter("vnp_BankCode"));

        request.getRequestDispatcher("/vnpay_return.jsp").forward(request, response);
    }

    private String getVnpayErrorMessage(String responseCode) {
        switch (responseCode) {
            case "00": return "Giao dịch thành công";
            case "07": return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
            case "09": return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.";
            case "10": return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần.";
            case "11": return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Vui lòng thực hiện lại giao dịch.";
            case "12": return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.";
            case "13": return "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP).";
            case "24": return "Giao dịch không thành công do: Khách hàng hủy giao dịch.";
            case "51": return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.";
            case "65": return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.";
            case "75": return "Ngân hàng thanh toán đang bảo trì.";
            case "79": return "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định.";
            case "99": return "Lỗi không xác định. Vui lòng thử lại sau.";
            default: return "Lỗi không xác định: " + responseCode;
        }
    }
}