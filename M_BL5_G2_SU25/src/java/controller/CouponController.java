package controller;

import dal.CouponDAO;
import model.Coupon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author tayho
 */
@WebServlet(name = "CouponController", urlPatterns = {"/coupon"})
public class CouponController extends HttpServlet {

    // View paths
    private static final String VIEW_LIST = "/views/coupon/listCoupon.jsp";
    private static final String VIEW_ADD = "/views/coupon/addCoupon.jsp";
    private static final String VIEW_EDIT = "/views/coupon/editCoupon.jsp";
    private static final String VIEW_DETAIL = "/views/coupon/viewCoupon.jsp";
    private final CouponDAO dao = new CouponDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check null with nvl
        String action = nvl(request.getParameter("action"), "list");
        switch (action) {
            case "addForm" ->
                request.getRequestDispatcher(VIEW_ADD).forward(request, response);
            case "editForm" ->
                handleEditForm(request, response);
            case "list", "search", "searchCoupon" ->
                handleList(request, response);
            case "viewCoupon" ->
                handleView(request, response);
            default ->
                handleList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = nvl(request.getParameter("action"), "list");

        switch (action) {
            case "addCoupon" ->
                handleAdd(request, response);
            case "editCoupon" ->
                handleEdit(request, response);
            case "updateStatus" ->
                handleUpdateStatus(request, response);
            default ->
                handleList(request, response);
        }
    }

    // =================== Handlers ===================
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int pageIndex = parseInt(request.getParameter("page"), 1);
        int pageSize = parseInt(request.getParameter("size"), 10);
        String search = trimToNull(request.getParameter("search"));
        String status = trimToNull(request.getParameter("status"));
        String sortBy = nvl(trimToNull(request.getParameter("sortBy")), "couponId");
        String sortDir = nvl(trimToNull(request.getParameter("sortDir")), "ASC");

        int total = dao.count(search, status);
        int totalPages = Math.max(1, (int) Math.ceil((double) total / pageSize));
        if (pageIndex > totalPages) {
            pageIndex = totalPages;
        }
        if (pageIndex < 1) {
            pageIndex = 1;
        }

        List<Coupon> list = dao.list(pageIndex, pageSize, search, status, sortBy, sortDir);

        request.setAttribute("listCoupons", list);
        request.setAttribute("page", pageIndex);
        request.setAttribute("size", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", total);
        request.setAttribute("search", nvl(search, ""));
        request.setAttribute("status", nvl(status, ""));
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortDir", sortDir);

        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("couponId"), -1);
        Coupon c = dao.getById(id);
        if (c == null) {
            request.setAttribute("error", "Coupon not found.");
            handleList(request, response);
            return;
        }
        request.setAttribute("coupon", c);
        request.getRequestDispatcher(VIEW_EDIT).forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();
        Coupon c = bindFromRequest(request, errors, null);

        if (c.getCouponCode() != null && dao.codeExists(c.getCouponCode(), null)) {
            errors.add("Coupon code already exists.");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("coupon", c);
            request.getRequestDispatcher(VIEW_ADD).forward(request, response);
            return;
        }

        boolean ok = dao.insert(c);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/coupon?action=list&msg=added");
        } else {
            errors.add("Failed to add coupon. Please try again.");
            request.setAttribute("errors", errors);
            request.setAttribute("coupon", c);
            request.getRequestDispatcher(VIEW_ADD).forward(request, response);
        }
    }

    private void handleView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("couponId"), -1);
        var c = dao.getById(id);
        if (c == null) {
            request.setAttribute("error", "Coupon not found.");
            handleList(request, response);
            return;
        }
        request.setAttribute("coupon", c);
        request.getRequestDispatcher(VIEW_DETAIL).forward(request, response);
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseInt(request.getParameter("couponId"), -1);
        List<String> errors = new ArrayList<>();
        Coupon c = bindFromRequest(request, errors, id);
        c.setCouponId(id);

        if (id <= 0) {
            errors.add("Invalid couponId.");
        }
        if (c.getCouponCode() != null && dao.codeExists(c.getCouponCode(), id)) {
            errors.add("Coupon code already exists on another record.");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("coupon", c);
            request.getRequestDispatcher(VIEW_EDIT).forward(request, response);
            return;
        }

        boolean ok = dao.update(c);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/coupon?action=list&msg=updated");
        } else {
            errors.add("Failed to update coupon. Please try again.");
            request.setAttribute("errors", errors);
            request.setAttribute("coupon", c);
            request.getRequestDispatcher(VIEW_EDIT).forward(request, response);
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = parseInt(request.getParameter("couponId"), -1);
        String status = nvl(request.getParameter("status"), "Active");
        dao.updateStatus(id, status);
        response.sendRedirect(request.getContextPath() + "/coupon?action=list&msg=status");
    }

    // ================ Binding & Utils ================
    /**
     * Bind request params into a Coupon and collect validation errors.
     */
    private Coupon bindFromRequest(HttpServletRequest req, List<String> errors, Integer idForUpdate) {
        Coupon c = new Coupon();

        String code = upper(trimToNull(req.getParameter("couponCode")));
        if (code == null) {
            errors.add("Cần nhập mã khuyến mãi.");
        }
        c.setCouponCode(code);

        Double discountPercent = parsePercent(req.getParameter("discountPercent"), null);
        if (discountPercent == null) {
            errors.add("Cần nhập phần trăm giảm giá.");
        } else if (discountPercent < 0 || discountPercent > 100) {
            errors.add("Phần trăm giảm giá phải trong khoảng 0–100.");
        }
        c.setDiscountPercent(discountPercent != null ? discountPercent : 0d);
        Double maxDiscount = parseMoney(req.getParameter("maxDiscount"), null);
        if (maxDiscount == null) {
            errors.add("Cần nhập giảm tối đa bao nhiêu.");
        }
        c.setMaxDiscount(maxDiscount != null ? maxDiscount : 0d);

        c.setRequirement(nvl(req.getParameter("requirement"), ""));

        Double minTotal = parseMoney(req.getParameter("minTotal"), null);
        if (minTotal == null) {
            errors.add("Cần nhập giá trị đơn hàng tối thiểu");
        }
        c.setMinTotal(minTotal != null ? minTotal : 0d);

        c.setMinProduct(parseInt(req.getParameter("minProduct"), 0));
        c.setApplyLimit(parseInt(req.getParameter("applyLimit"), 0));

        Date from = parseSqlDate(req.getParameter("fromDate"), errors, "Cần nhập ngày bắt đầu.");
        Date to = parseSqlDate(req.getParameter("toDate"), errors, "Cần nhập ngày kết thúc");
        c.setFromDate(from);
        c.setToDate(to);

        c.setStatus(nvl(req.getParameter("status"), "Active"));
        if (maxDiscount != null && maxDiscount < 0) {
            errors.add("Giảm tối đa không được âm.");
        }
        if (minTotal != null && minTotal < 0) {
            errors.add("Tổng tối thiểu không được âm.");
        }

        // Date logic
        if (from != null && to != null && to.before(from)) {
            errors.add("Đến ngày phải lớn hơn hoặc bằng Từ ngày.");
        }

        return c;
    }

    private static Double parseMoney(String s, Double def) {
        if (s == null) {
            return def;
        }
        String v = s.trim();
        if (v.isEmpty()) {
            return def;
        }
        try {
            // Remove currency symbols and spaces
            v = v.replaceAll("[\\p{Sc}\\s]", ""); // \p{Sc} = currency symbol

            int lastComma = v.lastIndexOf(',');
            int lastDot = v.lastIndexOf('.');

            // Decide which is the decimal separator (the rightmost of , or .)
            char decimalSep = (lastComma > lastDot) ? ',' : '.';

            if (decimalSep == ',') {
                // comma is decimal: remove dots (thousands), convert comma to dot
                v = v.replace(".", "");
                v = v.replace(",", ".");
            } else {
                // dot is decimal: remove commas (thousands)
                v = v.replace(",", "");
            }
            return Double.parseDouble(v);
        } catch (Exception e) {
            return def; // let validation add the "required" message
        }
    }

    private static String trimToNull(String s) {
        if (s == null) {
            return null;
        }
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private static String nvl(String s, String def) {
        return (s == null) ? def : s;
    }

    private static String upper(String s) {
        return s == null ? null : s.toUpperCase();
    }

    private static int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private static Double parseDouble(String s, Double def) {
        try {
            return Double.parseDouble(s);
        } catch (Exception e) {
            return def;
        }
    }

    private static Double parsePercent(String s, Double def) {
        if (s == null || s.isBlank()) {
            return def;
        }
        try {
            return Double.parseDouble(s.replace(',', '.')); // accept 10,5 or 10.5
        } catch (Exception e) {
            return def;
        }
    }

    private static Date parseSqlDate(String s, List<String> errors, String requiredMsg) {
        if (s == null || s.isBlank()) {
            if (requiredMsg != null) {
                errors.add(requiredMsg);
            }
            return null;
        }
        try {
            return Date.valueOf(s.trim()); // expects yyyy-MM-dd
        } catch (IllegalArgumentException ex) {
            errors.add("Invalid date format: " + s + " (expected yyyy-MM-dd)");
            return null;
        }
    }
}
