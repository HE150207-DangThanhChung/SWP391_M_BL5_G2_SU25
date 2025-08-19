/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dal.EmployeeDAO;
import dal.RoleDAO;
import dal.StoreDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Set;
import java.util.UUID;
import model.Employee;
import model.Role;
import model.Store;

/**
 *
 * @author tayho
 */
/**
 * Chỉnh sửa lại annotation @WebServlet theo phần cá nhân làm riêng
 */
@WebServlet(name = "ProfileController", urlPatterns = {
    "/profile",
    "/profile/edit"
})
@MultipartConfig(
        fileSizeThreshold = 512 * 1024, // 512 KB (in-memory threshold)
        maxFileSize = 5L * 1024 * 1024, // 5 MB per file
        maxRequestSize = 6L * 1024 * 1024 // 6 MB total
)
public class ProfileController extends HttpServlet {

    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private final int ITEMS_PER_PAGE = 2;
    private final String BASE_PATH = "/profile";
    private static final Set<String> ALLOWED_IMAGE_MIME = Set.of("image/jpeg", "image/png", "image/webp");
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

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
            case BASE_PATH + "/edit" ->
                doPostEdit(request, response);
        }
    }

    private void doGetDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("views/common/login.jsp");
            return;
        }

        String username = (String) session.getAttribute("tendangnhap");
        EmployeeDAO eDao = new EmployeeDAO();
        StoreDAO sDao = new StoreDAO();
        RoleDAO rDao = new RoleDAO();

        if (username == null || username.isEmpty()) {
            response.sendError(404);
        }

        Employee e = eDao.getEmployeeByUsername(username);
        Store s = sDao.findById(e.getStoreId());
        Role r = rDao.getRoleById(e.getRoleId());

        request.setAttribute("r", r);
        request.setAttribute("s", s);
        request.setAttribute("e", e);
        request.getRequestDispatcher("/views/profile/viewProfile.jsp").forward(request, response);
    }

    private void doGetEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("../views/common/login.jsp");
            return;
        }

        String username = (String) session.getAttribute("tendangnhap");
        EmployeeDAO eDao = new EmployeeDAO();
        StoreDAO sDao = new StoreDAO();
        RoleDAO rDao = new RoleDAO();

        if (username == null || username.isEmpty()) {
            response.sendError(404);
        }

        Employee e = eDao.getEmployeeByUsername(username);

        request.setAttribute("e", e);
        request.getRequestDispatcher("/views/profile/editProfile.jsp").forward(request, response);
    }

    private void doPostEdit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        EmployeeDAO dao = new EmployeeDAO();
        HashMap<String, Object> jsonMap = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);

            if (session == null) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Vui lòng đăng nhập lại");
                sendJson(response, jsonMap);
                return;
            }

            String username = (String) session.getAttribute("tendangnhap");

            Employee current = dao.getEmployeeByUsername(username);
            if (current == null) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Không tìm thấy người dùng.");
                sendJson(response, jsonMap);
                return;
            }

            String firstName = trimOrNull(request.getParameter("firstName"));
            String middleName = trimOrNull(request.getParameter("middleName"));
            String lastName = trimOrNull(request.getParameter("lastName"));
            String phone = trimOrNull(request.getParameter("phone"));
            String email = trimOrNull(request.getParameter("email"));
            String dobStr = trimOrNull(request.getParameter("dob"));
            String address = trimOrNull(request.getParameter("address"));
            String gender = trimOrNull(request.getParameter("gender"));

            if (firstName == null || lastName == null || middleName == null) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Họ và Tên là bắt buộc.");
                sendJson(response, jsonMap);
                return;
            }
            if (email != null && !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Email không hợp lệ.");
                sendJson(response, jsonMap);
                return;
            }

            if (!current.getPhone().equals(phone)) {
                if (dao.isPhoneExisted(phone)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Số điện thoại đã tồn tại.");
                    sendJson(response, jsonMap);
                    return;
                }
            }

            if (!current.getEmail().equals(email)) {
                if (dao.isEmailExisted(email)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Email đã tồn tại.");
                    sendJson(response, jsonMap);
                    return;
                }
            }

            LocalDate dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    dob = LocalDate.parse(dobStr, DATE_FMT);
                } catch (DateTimeParseException ex) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Ngày sinh không hợp lệ (định dạng yyyy-MM-dd).");
                    sendJson(response, jsonMap);
                    return;
                }
            }

            Part avatarPart = null;
            try {
                avatarPart = request.getPart("avatar");
            } catch (IllegalStateException | ServletException ignored) {

            }

            String newAvatarUrl = null;
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String mime = safeContentType(avatarPart);
                if (!ALLOWED_IMAGE_MIME.contains(mime)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Ảnh đại diện phải là JPEG, PNG hoặc WEBP.");
                    sendJson(response, jsonMap);
                    return;
                }

                String uploadsFolder = "/uploads/avatars";
                String absoluteUploadDir = getServletContext().getRealPath(uploadsFolder);

                if (absoluteUploadDir == null) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Không thể xác định thư mục lưu trữ ảnh.");
                    sendJson(response, jsonMap);
                    return;
                }

                String mainDir = absoluteUploadDir.replace(File.separator + "build" + File.separator + "web", File.separator + "web");

                Path uploadDir = Path.of(absoluteUploadDir);
                Path mainUploadDir = Path.of(mainDir);
                Files.createDirectories(uploadDir);
                Files.createDirectories(mainUploadDir);

                String originalName = getSubmittedFileName(avatarPart);
                String ext = guessExtension(mime, originalName);
                String fileName = "ava_" + username + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID() + ext;

                Path target = uploadDir.resolve(fileName);
                Path mainTarget = mainUploadDir.resolve(fileName);

                try (InputStream in = avatarPart.getInputStream()) {
                    byte[] data = in.readAllBytes();
                    Files.write(target, data);
                    Files.write(mainTarget, data);
                }

                newAvatarUrl = request.getContextPath() + uploadsFolder + "/" + fileName;

                if (current.getAvatar() != null && current.getAvatar().startsWith(request.getContextPath() + uploadsFolder)) {
                    try {
                        String oldFileName = current.getAvatar().substring((request.getContextPath() + uploadsFolder + "/").length());
                        Path oldPath = uploadDir.resolve(oldFileName);
                        Files.deleteIfExists(oldPath);
                    } catch (IOException ignored) {
                    }
                }
            }

            String ava = newAvatarUrl != null ? newAvatarUrl : current.getAvatar();
            Date dobMain = Date.valueOf(dob);

            boolean ok = dao.editEmployee(current.getEmployeeId(), current.getUserName(), firstName, middleName, lastName, phone, email, gender, current.getStatus(), current.getCccd(), dobMain, address, ava);

            if (!ok) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Cập nhật thất bại. Vui lòng thử lại.");
            } else {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Cập nhật thành công.");
            }

            sendJson(response, jsonMap);

        } catch (IOException e) {
            jsonMap.put("ok", false);
            jsonMap.put("message", "Có lỗi xảy ra, vui lòng thử lại sau!");
            sendJson(response, jsonMap);
        }
    }

    private static String trimOrNull(String s) {
        if (s == null) {
            return null;
        }
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private static String safeContentType(Part p) {
        String ct = p.getContentType();
        return ct == null ? "" : ct.toLowerCase();
    }

    private static String getSubmittedFileName(Part part) {
        try {
            String fileName = part.getSubmittedFileName();
            if (fileName != null) {
                return fileName;
            }
        } catch (Throwable ignored) {
        }
        String cd = part.getHeader("content-disposition");
        if (cd == null) {
            return "upload";
        }
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.startsWith("filename=")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                return name;
            }
        }
        return "upload";
    }

    private static String guessExtension(String mime, String original) {
        String ext = "";
        int dot = original.lastIndexOf('.');
        if (dot >= 0) {
            ext = original.substring(dot).toLowerCase();
            if (ext.matches("\\.(jpe?g|png|webp)")) {
                return ext;
            }
        }
        return switch (mime) {
            case "image/jpeg" ->
                ".jpg";
            case "image/png" ->
                ".png";
            case "image/webp" ->
                ".webp";
            default ->
                ".img";
        };
    }

    public static void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = gson.toJson(data);
        response.getWriter().write(json);
        response.getWriter().flush();
    }

}
