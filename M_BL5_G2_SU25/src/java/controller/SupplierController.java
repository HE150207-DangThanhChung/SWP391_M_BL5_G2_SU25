package controller;

import dal.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Supplier;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupplierController", urlPatterns = {
    "/management/suppliers",
    "/management/suppliers/add",
    "/management/suppliers/edit",
    "/management/suppliers/detail"
})
public class SupplierController extends HttpServlet {

    private final int ITEMS_PER_PAGE = 2;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchKey = request.getParameter("search");
        String statusIdStr = request.getParameter("statusId");
        String pageStr = request.getParameter("page");

        Integer statusId = null;
        if (statusIdStr != null && !statusIdStr.isEmpty()) {
            statusId = Integer.parseInt(statusIdStr);
        }

        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }

        int offset = (page - 1) * ITEMS_PER_PAGE;

        SupplierDAO dao = new SupplierDAO();

        List<Supplier> supList = dao.GetAllSupplierWithPagingAndFilter(searchKey, statusId, offset, ITEMS_PER_PAGE);

        int totalSuppliers = dao.countSuppliersWithFilter(searchKey, statusId);
        int totalPages = (int) Math.ceil((double) totalSuppliers / ITEMS_PER_PAGE);

        request.setAttribute("suppliers", supList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKey", searchKey);
        request.setAttribute("statusId", statusId);

        request.getRequestDispatcher("/views/supplier/listSupplier.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }
}
