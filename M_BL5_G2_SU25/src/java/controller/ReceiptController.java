/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CustomerDAO;
import dal.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Customer;
import model.Order;

/**
 *
 * @author hoanganhdev
 */
@WebServlet(name = "ReceiptController", urlPatterns = {
    "/receipt",
    "/receipt/edit"
})
public class ReceiptController extends HttpServlet {
    
    private static final String BASE_PATH = "/receipt";
    private static final String JSON_CONFIG_PATH = "";
    private static final int ITEM_PER_PAGE = 10;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case BASE_PATH ->
                doGetDetail(request, response);
            case BASE_PATH + "/edit" ->
                doGetEdit(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case BASE_PATH ->
                doPostDetail(request, response);
            case BASE_PATH + "/edit" ->
                doPostEdit(request, response);
        }
    }
    
    private void doGetDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO oDao = new OrderDAO();
        CustomerDAO cDao = new CustomerDAO();
        
        String pageStr = request.getParameter("page");
        String searchKey = request.getParameter("searchKey");
        
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException ignored) {
            }
        }
        
        int offset = (page - 1) * ITEM_PER_PAGE;
        
        List<Order> odList = oDao.getCompletedOrders(searchKey, ITEM_PER_PAGE, offset);
        
        for (Order o : odList) {
            Customer c = cDao.getById(o.getCustomer().getCustomerId());
            o.setCustomer(c);
        }
        
        int countTotal = oDao.getCompletedOrders(searchKey, Integer.MAX_VALUE, 0).size();
        int totalPages = (int) Math.ceil((double) countTotal / ITEM_PER_PAGE);
        int endItem = (offset + 1) == countTotal ? offset + 1 : offset + ITEM_PER_PAGE;
        
        request.setAttribute("startItem", offset + 1);
        request.setAttribute("endItem", endItem);
        request.setAttribute("totalItems", countTotal);
        request.setAttribute("odList", odList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKey", searchKey);
        request.getRequestDispatcher("/views/receipt/viewReceipt.jsp").forward(request, response);
    }
    
    private void doGetEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/receipt/editReceipt.jsp").forward(request, response);
    }
    
    private void doPostDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }
    
    private void doPostEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }
    
}
