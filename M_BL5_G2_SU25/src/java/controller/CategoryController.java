package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

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
            case BASE_PATH -> doGetList(request, response);
            case BASE_PATH + "/add" -> doGetAdd(request, response);
            case BASE_PATH + "/edit" -> doGetEdit(request, response);
            case BASE_PATH + "/detail" -> doGetDetail(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case BASE_PATH + "/add" -> doPostAdd(request, response);
            case BASE_PATH + "/edit" -> doPostEdit(request, response);
        }
    }

    private void doGetDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        CategoryDAO dao = new CategoryDAO();

        if (idStr == null || idStr.isEmpty()) {
            response.sendError(404);
            return;
        }

        int id = Integer.parseInt(idStr);
        Category c = dao.getCategoryById(id);

        request.setAttribute("c", c);
        request.getRequestDispatcher("/views/category/viewCategory.jsp").forward(request, response);
    }

    private void doGetEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        CategoryDAO dao = new CategoryDAO();

        if (idStr == null || idStr.isEmpty()) {
            response.sendError(404);
            return;
        }

        int id = Integer.parseInt(idStr);
        Category c = dao.getCategoryById(id);

        request.setAttribute("c", c);
        request.getRequestDispatcher("/views/category/editCategory.jsp").forward(request, response);
    }

    private void doPostEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CategoryDAO dao = new CategoryDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();

        try {
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String status = request.getParameter("status");

            int id = Integer.parseInt(idStr);
            Category c = dao.getCategoryById(id);

            if (!c.getName().equals(name) && dao.isNameExisted(name)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Name is already existed!");
                sendJson(response, jsonMap);
                return;
            }

            boolean success = dao.editCategory(id, name, status);
            if (success) {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Category saved successfully!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Failed to save category. Please try again.");
            }
            sendJson(response, jsonMap);

        } catch (IOException e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Something wrong, please try again later!");
            sendJson(response, jsonMap);
        }
    }

    private void doPostAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CategoryDAO dao = new CategoryDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();

        try {
            String name = request.getParameter("name");
            String status = request.getParameter("status");

            if (dao.isNameExisted(name)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Name is already existed!");
                sendJson(response, jsonMap);
                return;
            }

            boolean success = dao.addCategory(name, status, status)
            if (success) {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Category added successfully!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Failed to add category. Please try again.");
            }
            sendJson(response, jsonMap);

        } catch (IOException e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Something wrong, please try again later!");
            sendJson(response, jsonMap);
        }
    }

    private void doGetAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/category/addCategory.jsp").forward(request, response);
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
            } catch (NumberFormatException ignored) {}
        }

        int offset = (page - 1) * ITEMS_PER_PAGE;
        CategoryDAO dao = new CategoryDAO();

        List<Category> catList = dao.GetAllCategoryWithPagingAndFilter(searchKey, status, offset, ITEMS_PER_PAGE);
        int totalCategories = dao.countCategoriesWithFilter(searchKey, status);
        int totalPages = (int) Math.ceil((double) totalCategories / ITEMS_PER_PAGE);
        int endItem = (offset + 1) == totalCategories ? offset + 1 : offset + ITEMS_PER_PAGE;

        request.setAttribute("startItem", offset + 1);
        request.setAttribute("endItem", endItem);
        request.setAttribute("totalItems", totalCategories);
        request.setAttribute("categories", catList);
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
