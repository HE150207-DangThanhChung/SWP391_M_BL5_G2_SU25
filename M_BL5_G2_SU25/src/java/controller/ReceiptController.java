/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dal.CustomerDAO;
import dal.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;
import model.Customer;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author hoanganhdev
 */
@WebServlet(name = "ReceiptController", urlPatterns = {
    "/receipt",
    "/receipt/edit",
    "/receipt/detail"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ReceiptController extends HttpServlet {

    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private static final String BASE_PATH = "/receipt";
    private static final String JSON_CONFIG_PATH = "receipt-config.json";
    private static final String UPLOAD_DIR = "uploads/logos";
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
            case BASE_PATH + "/detail" ->
                doGetDetailReceipt(request, response);
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

        HashMap<String, Object> config = loadConfigFromJson();
        
        request.setAttribute("font", config.get("font"));
        request.setAttribute("color", config.get("color"));
        request.setAttribute("logo", config.get("logo"));
        request.setAttribute("title", config.get("title"));
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
        HashMap<String, Object> config = loadConfigFromJson();

        request.setAttribute("font", config.get("font"));
        request.setAttribute("color", config.get("color"));
        request.setAttribute("logo", config.get("logo"));
        request.setAttribute("title", config.get("title"));
        request.getRequestDispatcher("/views/receipt/editReceipt.jsp").forward(request, response);
    }

    private HashMap<String, Object> loadConfigFromJson() {
        HashMap<String, Object> config = new HashMap<>();

        try {
            String configPath = getServletContext().getRealPath("") + File.separator + JSON_CONFIG_PATH;
            File configFile = new File(configPath);

            if (configFile.exists()) {
                String jsonContent = new String(Files.readAllBytes(Paths.get(configPath)));
                config = gson.fromJson(jsonContent, HashMap.class);
            } else {
                config.put("title", "Receipt");
                config.put("font", "Arial");
                config.put("color", "#000000");
                config.put("logo", null);
            }
        } catch (IOException e) {
            System.err.println("Error reading receipt config: " + e.getMessage());
            config.put("title", "Receipt");
            config.put("font", "Arial");
            config.put("color", "#000000");
            config.put("logo", null);
        }

        return config;
    }

    private void doGetDetailReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO oDao = new OrderDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();

        String odIdStr = request.getParameter("id");

        try {
            int odId = Integer.parseInt(odIdStr);

            Order o = oDao.getOrderById(odId);
            List<OrderDetail> odDetail = oDao.getOrderDetails(odId);

            jsonMap.put("success", true);
            jsonMap.put("order", o);
            jsonMap.put("orderDetails", odDetail);

        } catch (NumberFormatException e) {
            jsonMap.put("success", false);
            jsonMap.put("message", "Invalid order ID format.");
        } catch (Exception e) {
            jsonMap.put("success", false);
            jsonMap.put("message", "Error fetching order details: " + e.getMessage());
        }

        sendJson(response, jsonMap);
    }

    private void doPostDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    private void doPostEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HashMap<String, Object> jsonResponse = new HashMap<>();
        try {
            String title = request.getParameter("title");
            String font = request.getParameter("font");
            String color = request.getParameter("color");
            String logoPath = null;
            Part logoPart = request.getPart("logo");
            if (logoPart != null && logoPart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                String mainUploadPath = uploadPath.replace(File.separator + "build" + File.separator + "web", File.separator + "web");
                File uploadDir = new File(uploadPath);
                File mainUploadDir = new File(mainUploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                if (!mainUploadDir.exists()) {
                    mainUploadDir.mkdir();
                }
                String originalFilename = getSubmittedFileName(logoPart);
                String fileExtension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String uniqueFilename = UUID.randomUUID().toString() + fileExtension;
                String filePath = uploadPath + File.separator + uniqueFilename;
                String mainFilePath = filePath.replace(File.separator + "build" + File.separator + "web", File.separator + "web");

                try (InputStream input = logoPart.getInputStream()) {
                    Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                }
                Files.copy(Paths.get(filePath), Paths.get(mainFilePath), StandardCopyOption.REPLACE_EXISTING);

                logoPath = UPLOAD_DIR + "/" + uniqueFilename;
            }
            HashMap<String, Object> config = new HashMap<>();
            config.put("title", title);
            config.put("font", font);
            config.put("color", color);
            config.put("logo", logoPath);
            config.put("lastModified", System.currentTimeMillis());
            saveConfigToJson(config);
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Receipt design saved successfully");
            jsonResponse.put("config", config);
        } catch (ServletException | IOException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error saving receipt design: " + e.getMessage());
        }
        sendJson(response, jsonResponse);
    }

    private void saveConfigToJson(HashMap<String, Object> config) throws IOException {
        String configPath = getServletContext().getRealPath("") + File.separator + JSON_CONFIG_PATH;
        String mainConfigPath = configPath.replace(File.separator + "build" + File.separator + "web", File.separator + "web");

        try (FileWriter writer = new FileWriter(configPath)) {
            gson.toJson(config, writer);
        }

        try (FileWriter writer = new FileWriter(mainConfigPath)) {
            gson.toJson(config, writer);
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            String[] items = contentDisposition.split(";");
            for (String item : items) {
                if (item.trim().startsWith("filename")) {
                    String filename = item.substring(item.indexOf("=") + 1).trim();
                    return filename.replace("\"", "");
                }
            }
        }
        return null;
    }

    public static void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = gson.toJson(data);
        response.getWriter().write(json);
        response.getWriter().flush();
    }
}
