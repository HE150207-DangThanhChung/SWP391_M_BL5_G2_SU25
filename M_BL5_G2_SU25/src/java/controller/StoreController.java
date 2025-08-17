/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.StoreDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.Store;

/**
 *
 * @author tayho
 */

@WebServlet(name = "StoreController", urlPatterns = {"/stores/*"})
public class StoreController extends HttpServlet {

    private StoreDAO storeDAO;

    @Override
    public void init() {
        storeDAO = new StoreDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {

            int pageSize = 5;
            int pageNumber = 1;
            String searchKeyword = request.getParameter("search");
            String filterStatus = request.getParameter("status");
            
            try {
                pageNumber = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
            
            }

            List<Store> stores = storeDAO.findAll(pageNumber, pageSize, searchKeyword, filterStatus);
            int totalStores = storeDAO.getTotalStores(searchKeyword, filterStatus);
            int totalPages = (int) Math.ceil((double) totalStores / pageSize);

            request.setAttribute("stores", stores);
            request.setAttribute("currentPage", pageNumber);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("filterStatus", filterStatus);
            
            RequestDispatcher rd = request.getRequestDispatcher("/views/store/listStore.jsp");
            rd.forward(request, response);
        } else if (pathInfo.equals("/add")) {
        
            RequestDispatcher rd = request.getRequestDispatcher("/views/store/addStore.jsp");
            rd.forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
     
            try {
                int storeId = Integer.parseInt(pathInfo.substring(6));
                Store store = storeDAO.findById(storeId);
                if (store != null) {
                    request.setAttribute("store", store);
                    RequestDispatcher rd = request.getRequestDispatcher("/views/store/editStore.jsp");
                    rd.forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/stores");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/stores");
            }
        } else if (pathInfo.startsWith("/view/")) {
       
            try {
                int storeId = Integer.parseInt(pathInfo.substring(6));
                Store store = storeDAO.findById(storeId);
                if (store != null) {
                    request.setAttribute("store", store);
                    RequestDispatcher rd = request.getRequestDispatcher("/views/store/viewStore.jsp");
                    rd.forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/stores");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/stores");
            }
        } else if (pathInfo.startsWith("/delete/")) {
         
            try {
                int storeId = Integer.parseInt(pathInfo.substring(8));
                boolean deleted = storeDAO.delete(storeId);
                if (deleted) {
                    request.setAttribute("message", "Store deleted successfully");
                } else {
                    request.setAttribute("error", "Failed to delete store");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid store ID");
            }
            response.sendRedirect(request.getContextPath() + "/stores");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
        
            response.sendRedirect(request.getContextPath() + "/stores");
        } else if (pathInfo.equals("/add")) {
         
            Store store = new Store();
            store.setStoreName(request.getParameter("storeName"));
            store.setAddress(request.getParameter("address"));
            store.setPhone(request.getParameter("phone"));
            store.setStatus(request.getParameter("status"));

            boolean added = storeDAO.add(store);
            if (added) {
                request.setAttribute("message", "Store added successfully");
            } else {
                request.setAttribute("error", "Failed to add store");
            }
            response.sendRedirect(request.getContextPath() + "/stores");
        } else if (pathInfo.equals("/edit")) {
         
            try {
                Store store = new Store();
                store.setStoreId(Integer.parseInt(request.getParameter("storeId")));
                store.setStoreName(request.getParameter("storeName"));
                store.setAddress(request.getParameter("address"));
                store.setPhone(request.getParameter("phone"));
                store.setStatus(request.getParameter("status"));

                boolean updated = storeDAO.update(store);
                if (updated) {
                    request.setAttribute("message", "Store updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update store");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid store ID");
            }
            response.sendRedirect(request.getContextPath() + "/stores");
        }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
 
    
    }
}
