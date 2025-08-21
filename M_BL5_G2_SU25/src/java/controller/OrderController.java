    // ...existing code...
    // ...existing code...
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.CustomerDAO;
import dal.OrderDAO;
import dal.ProductDAO;
import dal.StoreDAO;
import model.Order;
import model.OrderDetail;
import model.Customer;
import model.Employee;
import model.Store;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;

@WebServlet(name = "OrderController", urlPatterns = {"/orders", "/order/view", "/order/edit", "/order/create"})
public class OrderController extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        switch (action) {
            case "/orders":
                listOrders(request, response);
                break;
            case "/order/view":
                viewOrder(request, response);
                break;
            case "/order/edit":
                showEditForm(request, response);
                break;
            case "/order/create":
                showCreateForm(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        switch (action) {
            case "/order/edit":
                editOrder(request, response);
                break;
            case "/order/create":
                createOrder(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Order> orders = orderDAO.getAllOrders();
        System.out.println("Number of orders retrieved: " + orders.size());
        for (Order order : orders) {
            System.out.println("Order ID: " + order.getOrderId() 
                + ", Customer: " + (order.getCustomer() != null ? order.getCustomer().getFullName() : "null")
                + ", Status: " + order.getStatus());
        }
         StoreDAO storeDAO = new StoreDAO();
        List<Store> stores = storeDAO.getAllStores();
        request.setAttribute("stores", stores);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/views/order/listOrder.jsp").forward(request, response);
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);
        request.setAttribute("order", order);
        request.getRequestDispatcher("/views/order/view.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);
        request.setAttribute("order", order);
        request.getRequestDispatcher("/views/order/editOrder.jsp").forward(request, response);
    }

    private void editOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Chỉ lấy orderId và status từ form vì chỉ cho phép cập nhật trạng thái
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            
            // Lấy thông tin đơn hàng hiện tại từ database
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                throw new Exception("Không tìm thấy đơn hàng");
            }
            
            // Chỉ cập nhật trạng thái mới
            order.setStatus(status);
            boolean success = orderDAO.updateOrder(order);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/orders");
            } else {
                request.setAttribute("error", "Chỉ có thể sửa đơn hàng khi trạng thái là pending!");
                request.setAttribute("order", orderDAO.getOrderById(orderId));
                request.getRequestDispatcher("/views/order/editOrder.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi cập nhật đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("/views/order/editOrder.jsp").forward(request, response);
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CustomerDAO customerDAO = new CustomerDAO();
        List<Customer> customers = customerDAO.getAllCustomers();
        request.setAttribute("customers", customers);

        StoreDAO storeDAO = new StoreDAO();
        List<Store> stores = storeDAO.getAllStores();
        request.setAttribute("stores", stores);

        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);

        request.getRequestDispatcher("/views/order/addOrder.jsp").forward(request, response);
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            java.sql.Date orderDate = java.sql.Date.valueOf(request.getParameter("orderDate"));
            String status = request.getParameter("status");
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            int createdById = Integer.parseInt(request.getParameter("createdById"));
            int saleById = Integer.parseInt(request.getParameter("saleById"));
            int storeId = Integer.parseInt(request.getParameter("storeId"));

            // Lấy danh sách chi tiết sản phẩm từ form
            String[] productVariantIds = request.getParameterValues("productVariantId");
            String[] productNames = request.getParameterValues("productName");
            String[] prices = request.getParameterValues("price");
            String[] quantities = request.getParameterValues("quantity");
            String[] discounts = request.getParameterValues("discount");
            String[] taxRates = request.getParameterValues("taxRate");
            String[] totalAmounts = request.getParameterValues("totalAmount");
            String[] detailStatuses = request.getParameterValues("detailStatus");

            List<OrderDetail> orderDetails = new java.util.ArrayList<>();
            if (productVariantIds != null) {
                for (int i = 0; i < productVariantIds.length; i++) {
                    OrderDetail detail = new OrderDetail();
                    detail.setProductVariantId(Integer.parseInt(productVariantIds[i]));
                    detail.setProductName(productNames[i]);
                    detail.setPrice(Double.parseDouble(prices[i]));
                    detail.setQuantity(Integer.parseInt(quantities[i]));
                    detail.setDiscount((discounts[i] != null && !discounts[i].isEmpty()) ? Double.parseDouble(discounts[i]) : null);
                    detail.setTaxRate((taxRates[i] != null && !taxRates[i].isEmpty()) ? Double.parseDouble(taxRates[i]) : null);
                    detail.setTotalAmount(Double.parseDouble(totalAmounts[i]));
                    detail.setStatus(detailStatuses[i]);
                    orderDetails.add(detail);
                }
            }

            Customer customer = new Customer(); customer.setCustomerId(customerId);
            Employee createdBy = new Employee(); createdBy.setEmployeeId(createdById);
            Employee saleBy = new Employee(); saleBy.setEmployeeId(saleById);
            Store store = new Store(); store.setStoreId(storeId);

            Order order = new Order(0, orderDate, status, customer, createdBy, saleBy, store, orderDetails);
            boolean success = orderDAO.createOrder(order);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/orders");
            } else {
                request.setAttribute("error", "Lỗi tạo đơn hàng!");
                request.getRequestDispatcher("/views/order/addOrder.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi tạo đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("/views/order/addOrder.jsp").forward(request, response);
        }
    }
}
