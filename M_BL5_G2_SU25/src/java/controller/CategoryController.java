/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dal.SupplierDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import model.Supplier;

/**
 *
 * @author tayho
 */
/**
Chỉnh sửa lại annotation @WebServlet theo phần cá nhân làm riêng
*/
@WebServlet(name = "CategoryController", urlPatterns = {
    "/management/category",
    "/management/category/add",
    "/management/category/edit",
    "/management/category/detail"
})
public class CategoryController extends HttpServlet {

    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private final int ITEMS_PER_PAGE = 2;
    private final String BASE_PATH = "/management/category";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case BASE_PATH ->
                doGetList(request, response);
            case BASE_PATH + "/add" ->
                doGetAdd(request, response);
            case BASE_PATH + "/edit" ->
                doGetEdit(request, response);
            case BASE_PATH + "/detail" ->
                doGetDetail(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case BASE_PATH + "/add" ->
                doPostAdd(request, response);
            case BASE_PATH + "/edit" ->
                doPostEdit(request, response);
        }
    }

    private void doGetDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }

    private void doGetEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }

    private void doPostEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }

    private void doPostAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }

    private void doGetAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }

    private void doGetList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchKey = request.getParameter("search");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");

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

        int offset = (page - 1) * ITEMS_PER_PAGE;

        SupplierDAO dao = new SupplierDAO();

        List<Supplier> supList = dao.GetAllSupplierWithPagingAndFilter(searchKey, status, offset, ITEMS_PER_PAGE);

        int totalSuppliers = dao.countSuppliersWithFilter(searchKey, status);
        int totalPages = (int) Math.ceil((double) totalSuppliers / ITEMS_PER_PAGE);
        int endItem = (offset + 1) == totalSuppliers ? offset + 1 : offset + ITEMS_PER_PAGE;

        request.setAttribute("startItem", offset + 1);
        request.setAttribute("endItem", endItem);
        request.setAttribute("totalItems", totalSuppliers);
        request.setAttribute("suppliers", supList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKey", searchKey);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/views/category/listCategory.jsp").forward(request, response);
    }

    public static void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = gson.toJson(data);
        response.getWriter().write(json);
        response.getWriter().flush();
    }

}
