package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Enumeration;

@WebServlet(name = "VnpayReturnServlet", urlPatterns = {"/vnpay_return"})
public class VnpayReturnServlet extends HttpServlet {
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

        if (signValue.equals(vnp_SecureHash)) {
            if ("00".equals(request.getParameter("vnp_ResponseCode"))) {
                status = "success";
                // TODO: Xử lý lưu đơn hàng, cập nhật trạng thái, xóa giỏ hàng, v.v.
            } else {
                status = "fail";
            }
        } else {
            status = "invalid_signature";
        }

        request.setAttribute("status", status);
        request.setAttribute("vnp_Amount", request.getParameter("vnp_Amount"));
        request.setAttribute("vnp_BankTranNo", request.getParameter("vnp_BankTranNo"));
        request.setAttribute("vnp_PayDate", request.getParameter("vnp_PayDate"));
        request.setAttribute("vnp_TxnRef", request.getParameter("vnp_TxnRef"));
        request.setAttribute("vnp_OrderInfo", request.getParameter("vnp_OrderInfo"));
        request.setAttribute("vnp_BankCode", request.getParameter("vnp_BankCode"));

        // Forward về trang JSP hiển thị kết quả
        request.getRequestDispatcher("/vnpay_return.jsp").forward(request, response);
    }
}
