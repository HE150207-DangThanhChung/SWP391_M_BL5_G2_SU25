package controller;

import dal.OrderDAO;
import dal.PaymentsDAO;
import dal.StoreStockDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import model.Order;
import model.OrderDetail;
import model.Payments;
import model.StoreStock;
import java.util.Random;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Calendar;
import java.util.Locale;
import java.util.TimeZone;

@WebServlet(name = "CheckoutInfo", urlPatterns = {"/checkoutInfo"})
public class CheckoutInfo extends HttpServlet {
    private OrderDAO orderDAO;
    private PaymentsDAO paymentsDAO;
    private StoreStockDAO storeStockDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        paymentsDAO = new PaymentsDAO();
        storeStockDAO = new StoreStockDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                request.setAttribute("error", "Không tìm thấy đơn hàng");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            if (!"pending".equalsIgnoreCase(order.getStatus())) {
                request.setAttribute("error", "Đơn hàng này không thể thanh toán");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            double totalAmount = 0;
            for (OrderDetail detail : order.getOrderDetails()) {
                totalAmount += detail.getTotalAmount();
            }

            request.setAttribute("order", order);
            request.setAttribute("rawAmount", totalAmount);
            request.setAttribute("totalAmount", formatCurrencyVND(totalAmount));
            request.getRequestDispatcher("/views/payment/checkout.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/orders");
        } catch (Exception e) {
            throw new ServletException("doGet failed", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        String paymentMethod = request.getParameter("paymentMethod");
        
        if (orderIdStr == null || paymentMethod == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null || !"pending".equalsIgnoreCase(order.getStatus())) {
                request.setAttribute("error", "Đơn hàng không hợp lệ hoặc không thể thanh toán");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            Date currentDate = Date.valueOf(LocalDateTime.now().toLocalDate());
            String paymentStatus = "Đang xử lý";
            String transactionCode = generateRandomNumberString();

            double totalAmount = 0;
            for (OrderDetail detail : order.getOrderDetails()) {
                totalAmount += detail.getTotalAmount();
            }
            long paymentPrice = Math.round(totalAmount);
            
            Payments payment = new Payments();
            payment.setOrderID(orderId);
            payment.setPaymentMethod(paymentMethod);
            payment.setPrice(String.valueOf(paymentPrice));
            payment.setPaymentDate(currentDate);
            payment.setPaymentStatus(paymentStatus);
            payment.setTransactionCode(transactionCode);

            if ("COD".equals(paymentMethod)) {
                paymentsDAO.savePayment(payment);
                order.setStatus("Đã thanh toán");
                orderDAO.updateOrder(order);

                boolean updateSuccess = true;
                for (OrderDetail detail : order.getOrderDetails()) {
                    StoreStock stock = storeStockDAO.getStoreStock(order.getStore().getStoreId(), detail.getProductVariantId());
                    if (stock != null) {
                        int newQuantity = stock.getQuantity() - detail.getQuantity();
                        if (newQuantity >= 0) {
                            stock.setQuantity(newQuantity);
                            storeStockDAO.updateStoreStock(stock);
                        } else {
                            updateSuccess = false;
                            break;
                        }
                    }
                }

                if (updateSuccess) {
                    request.getRequestDispatcher("/views/payment/success.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Lỗi cập nhật số lượng tồn kho");
                    request.getRequestDispatcher("/views/payment/error.jsp").forward(request, response);
                }
            } else if ("VNPAY".equals(paymentMethod)) {
                payment.setPaymentStatus("Chờ thanh toán");
                paymentsDAO.savePayment(payment);

                long vnpayAmount = (long)(totalAmount * 100); // Đơn vị xu
                String vnp_Version = "2.1.0";
                String vnp_Command = "pay";
                String vnp_TmnCode = Config.vnp_TmnCode;
                String vnp_ReturnUrl = Config.vnp_ReturnUrl;
                String vnp_IpAddr = Config.getIpAddress(request);
                String vnp_TxnRef = transactionCode;
                String vnp_OrderInfo = "Thanh toan don hang " + orderId;
                String vnp_CurrCode = "VND";
                String vnp_Locale = "vn";
                String vnp_OrderType = "other";
                Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
                SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
                String vnp_CreateDate = formatter.format(cld.getTime());
                cld.add(Calendar.MINUTE, 15);
                String vnp_ExpireDate = formatter.format(cld.getTime());

                Map<String, String> vnp_Params = new HashMap<>();
                vnp_Params.put("vnp_Version", vnp_Version);
                vnp_Params.put("vnp_Command", vnp_Command);
                vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
                vnp_Params.put("vnp_Amount", String.valueOf(vnpayAmount));
                vnp_Params.put("vnp_CurrCode", vnp_CurrCode);
                vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
                vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
                vnp_Params.put("vnp_OrderType", vnp_OrderType);
                vnp_Params.put("vnp_Locale", vnp_Locale);
                vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);
                vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
                vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
                vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

                List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
                Collections.sort(fieldNames);
                StringBuilder hashData = new StringBuilder();
                StringBuilder query = new StringBuilder();
                Iterator<String> itr = fieldNames.iterator();
                while (itr.hasNext()) {
                    String fieldName = itr.next();
                    String fieldValue = vnp_Params.get(fieldName);
                    if (fieldValue != null && fieldValue.length() > 0) {
                        hashData.append(fieldName);
                        hashData.append('=');
                        hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                        query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                        query.append('=');
                        query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                        if (itr.hasNext()) {
                            query.append('&');
                            hashData.append('&');
                        }
                    }
                }
                String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
                query.append("&vnp_SecureHash=").append(vnp_SecureHash);
                String paymentUrl = Config.vnp_PayUrl + "?" + query.toString();

                response.sendRedirect(paymentUrl);
            } else {
                request.setAttribute("error", "Phương thức thanh toán không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/orders");
            }
        } catch (Exception e) {
            throw new ServletException("doPost failed", e);
        }
    }

    public static String generateRandomNumberString() {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 10; i++) {
            int digit = random.nextInt(10);
            sb.append(digit);
        }
        return sb.toString();
    }

    public static String formatCurrencyVND(double amount) {
        DecimalFormat formatter = new DecimalFormat("#,###");
        formatter.setDecimalFormatSymbols(new DecimalFormatSymbols(new Locale("vi", "VN")));
        return formatter.format(amount);
    }

    @Override
    public String getServletInfo() {
        return "Handles checkout process without cart dependency";
    }
}