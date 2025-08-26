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
import java.util.HashMap;
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
        String idStr = request.getParameter("id");
        SupplierDAO dao = new SupplierDAO();

        if (idStr == null || idStr.isEmpty()) {
            response.sendError(404);
        }

        int id = Integer.parseInt(idStr);

        Supplier s = dao.getSupplierById(id);

        request.setAttribute("s", s);
        request.getRequestDispatcher("/views/supplier/viewSupplier.jsp").forward(request, response);
    }

    private void doGetEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        SupplierDAO dao = new SupplierDAO();

        if (idStr == null || idStr.isEmpty()) {
            response.sendError(404);
        }

        int id = Integer.parseInt(idStr);

        Supplier s = dao.getSupplierById(id);

        request.setAttribute("s", s);
        request.getRequestDispatcher("/views/supplier/editSupplier.jsp").forward(request, response);
    }

    private void doPostEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SupplierDAO dao = new SupplierDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();

        try {
            String idStr = request.getParameter("id");
            String email = request.getParameter("email");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            String taxCode = request.getParameter("taxCode");

            int id = Integer.parseInt(idStr);

            Supplier s = dao.getSupplierById(id);

            if (!s.getEmail().equals(email)) {
                if (dao.isEmailExisted(email)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Email đã tồn tại!");
                    sendJson(response, jsonMap);
                    return;
                }
            }
            if (!s.getSupplierName().equals(name)) {
                if (dao.isNameExisted(name)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Tên đã tồn tại!");
                    sendJson(response, jsonMap);
                    return;
                }
            }
            if (!s.getPhone().equals(phone)) {
                if (dao.isPhoneExisted(phone)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Số điện thoại đã tồn tại!");
                    sendJson(response, jsonMap);
                    return;
                }
            }
            if (!s.getTaxCode().equals(taxCode)) {
                if (dao.isTaxCodeExisted(taxCode)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Mã số thuế đã tồn tại!");
                    sendJson(response, jsonMap);
                    return;
                }
            }

            boolean success = dao.editSupplier(id, name, phone, email, taxCode, status);
            if (success) {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Lưu nhà cung cấp thành công!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Lưu nhà cung cấp thất bại. Vui lòng thử lại sau!");
            }
            sendJson(response, jsonMap);
        } catch (IOException e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Có lỗi trong quá trình lưu nhà cung cấp. Vui lòng thử lại sau!");
            sendJson(response, jsonMap);
        }
    }

    private void doPostAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SupplierDAO dao = new SupplierDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();

        try {
            String email = request.getParameter("email");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            String taxCode = request.getParameter("taxCode");

            if (dao.isEmailExisted(email)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Email đã tồn tại!");
                sendJson(response, jsonMap);
                return;
            }
            if (dao.isNameExisted(name)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Tên đã tồn tại!");
                sendJson(response, jsonMap);
                return;
            }
            if (dao.isPhoneExisted(phone)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Số điện thoại đã tồn tại!");
                sendJson(response, jsonMap);
                return;
            }
            if (dao.isTaxCodeExisted(taxCode)) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Mã số thuế đã tồn tại!");
                sendJson(response, jsonMap);
                return;
            }

            boolean success = dao.addSupplier(name, phone, email, taxCode, status);
            if (success) {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Thêm nhà cung cấp thành công!");
            } else {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Thêm nhà cung cấp thất bại. Vui lòng thử lại sau!");
            }
            sendJson(response, jsonMap);
        } catch (IOException e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Có lỗi xảy ra trong quá trình thêm nhà cung cấp. Vui lòng thử lại sau!");
            sendJson(response, jsonMap);
        }
    }

    private void doGetAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/supplier/addSupplier.jsp").forward(request, response);
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

        request.getRequestDispatcher("/views/supplier/listSupplier.jsp").forward(request, response);
    }

    public static void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = gson.toJson(data);
        response.getWriter().write(json);
        response.getWriter().flush();
    }
}
