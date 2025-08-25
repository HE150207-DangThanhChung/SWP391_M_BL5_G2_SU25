/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import dal.PaymentsDAO;
import dal.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.Order;

import model.Payments;
import model.Customer;

/**
 *
 * @author Hello
 */
@WebServlet(name = "ViewPayments", urlPatterns = {"/viewpayments"})
public class ViewPayments extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ViewPayments</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewPayments at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String strsellerId = request.getParameter("sid");
        if (strsellerId == null || strsellerId.trim().isEmpty()) {
            // Nếu không có sid, lấy từ session
            model.Employee employee = (model.Employee) request.getSession().getAttribute("employee");
            if (employee != null) {
                strsellerId = String.valueOf(employee.getEmployeeId());
            }
            if (strsellerId == null) {
                response.sendRedirect("login"); // Chuyển về trang login nếu không có sid
                return;
            }
        }
        
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String status = request.getParameter("status");
        String method = request.getParameter("method");
        String pageStr = request.getParameter("page");
        if (action == null || action.trim().length() == 0) {
            action = "list";
        }
        // Thêm các tham số phân trang
        int page = (pageStr != null) ? Integer.parseInt(pageStr) : 1; // Trang hiện tại
        int pageSize = 10; // Số mục hiển thị mỗi trang
        try {
            OrderDAO oDAO = new OrderDAO();
            CustomerDAO uDAO = new CustomerDAO();
            PaymentsDAO pDao = new PaymentsDAO();
            int sellerId = Integer.parseInt(strsellerId);
            List<Payments> listP = new ArrayList<>();
            switch (action) {
                case "list":
                    listP = pDao.getAllPaymentbySellerId(sellerId);
                    break;
                case "paymentmethod":
                    if (method == null || method.isEmpty() || "All".equals(method)) {
                        listP = pDao.getAllPaymentbySellerId(sellerId);
                    } else {
                        listP = pDao.getAllPaymentbySellerIdandMethod(sellerId, method);
                    }
                    break;
                case "status":
                    if (status == null || status.isEmpty() || "All".equals(status)) {
                        listP = pDao.getAllPaymentbySellerId(sellerId);
                    } else {
                        listP = pDao.getAllPaymentbySellerIdandStatus(sellerId, status);
                    }
                    break;

                default:
                    throw new AssertionError();
            }
            // Thực hiện phân trang trên danh sách kết quả
            int totalPayments = listP.size();
            int totalPages = (int) Math.ceil((double) totalPayments / pageSize);
            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalPayments);
            List<Payments> paginatedList = listP.subList(fromIndex, toIndex);
            List<Payments> listPm = pDao.getAllPaymentMethod();
            List<Payments> listPs = pDao.getAllPaymentStatus();
            List<Order> listO = oDAO.getAllOrders();
            List<Customer> listU = uDAO.getAllCustomers();
            request.setAttribute("listO", listO);
            request.setAttribute("listU", listU);
            request.setAttribute("listPm", listPm);
            request.setAttribute("listPs", listPs);
            request.setAttribute("listP", paginatedList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);

            // Forward the request and response to the JSP page
            request.getRequestDispatcher("/views/payment/viewpayment.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in ViewPayments: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
