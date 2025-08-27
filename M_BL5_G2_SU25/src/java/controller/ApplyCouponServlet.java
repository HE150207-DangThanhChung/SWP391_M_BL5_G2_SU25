package controller;

import dal.CouponDAO;
import model.Coupon;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

@WebServlet(name="ApplyCouponServlet", urlPatterns={"/apply-coupon"})
public class ApplyCouponServlet extends HttpServlet {
    private final CouponDAO couponDAO = new CouponDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String couponCode = request.getParameter("couponCode");
        double orderTotal = Double.parseDouble(request.getParameter("orderTotal"));
        int productCount = Integer.parseInt(request.getParameter("productCount"));
        
        if (couponCode == null || couponCode.trim().isEmpty()) {
            sendError(response, "Vui lòng nhập mã giảm giá");
            return;
        }
        
        Coupon coupon = couponDAO.getByCode(couponCode);
        if (coupon == null) {
            sendError(response, "Mã giảm giá không tồn tại");
            return;
        }
        
        // Kiểm tra trạng thái
        if (!"Active".equals(coupon.getStatus())) {
            sendError(response, "Mã giảm giá không còn hiệu lực");
            return;
        }
        
        // Kiểm tra thời gian hiệu lực
        Date now = new Date();
        if (now.before(coupon.getFromDate()) || now.after(coupon.getToDate())) {
            sendError(response, "Mã giảm giá không trong thời gian sử dụng");
            return;
        }
        
        // Kiểm tra điều kiện áp dụng
        if (orderTotal < coupon.getMinTotal()) {
            sendError(response, "Đơn hàng chưa đạt giá trị tối thiểu " + String.format("%,.0f₫", coupon.getMinTotal()));
            return;
        }
        
        if (productCount < coupon.getMinProduct()) {
            sendError(response, "Đơn hàng cần có ít nhất " + coupon.getMinProduct() + " sản phẩm");
            return;
        }
        
        // Tính giảm giá
        double discountAmount = orderTotal * (coupon.getDiscountPercent() / 100);
        if (discountAmount > coupon.getMaxDiscount()) {
            discountAmount = coupon.getMaxDiscount();
        }
        
        // Giảm số lần sử dụng còn lại của coupon
        if (!couponDAO.decrementApplyLimit(coupon.getCouponId())) {
            sendError(response, "Mã giảm giá đã hết lượt sử dụng");
            return;
        }
        
        // Trả về kết quả
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.format(
            "{\"success\":true,\"discountAmount\":%f,\"discountPercent\":%f,\"maxDiscount\":%f}",
            discountAmount, coupon.getDiscountPercent(), coupon.getMaxDiscount()
        ));
    }
    
    private void sendError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.format(
            "{\"success\":false,\"message\":\"%s\"}", 
            message.replace("\"", "\\\"")
        ));
    }
}
