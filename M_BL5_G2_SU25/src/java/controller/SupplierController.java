package controller;

import dal.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Supplier;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "SupplierController", urlPatterns = {
    "/management/suppliers",
    "/management/suppliers/add",
    "/management/suppliers/edit",
    "/management/suppliers/detail"
})
public class SupplierController extends HttpServlet {

    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private final int ITEMS_PER_PAGE = 2;
    private final String BASE_PATH = "/management/suppliers";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch(path){
            case BASE_PATH -> doGetList(request, response);
            case BASE_PATH + "/add" -> doGetAdd(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch(path){
            case BASE_PATH + "/add" -> doPostAdd(request, response);
        }
    }
    
    private void doPostAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        
    }
    
    private void doGetAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        request.getRequestDispatcher("/views/supplier/addSupplier.jsp").forward(request, response);
    }
    
    private void doGetList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String searchKey = request.getParameter("search");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");

        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
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

        request.getRequestDispatcher("/views/supplier/listSupplier.jsp").forward(request, response);
    }
    
    public static void sendJson(HttpServletResponse response, Object data) throws IOException {
        // Set content type and encoding
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Convert object to JSON string
        String json = gson.toJson(data);

        // Write JSON to response
        response.getWriter().write(json);
        response.getWriter().flush();
    }
}
