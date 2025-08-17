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
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;
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
                response.sendRedirect("views/common/login.jsp");
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

            // 4) Basic validations (extend as needed)
            if (firstName == null || lastName == null) {
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

            // 5) Handle avatar (multipart)
            Part avatarPart = null;
            try {
                avatarPart = request.getPart("avatar");
            } catch (IllegalStateException | ServletException ignored) {
                // not multipart or size exceeded → handled by @MultipartConfig; ignore here
            }

            String newAvatarUrl = null;
            if (avatarPart != null && avatarPart.getSize() > 0) {
                // Validate MIME
                String mime = safeContentType(avatarPart);
                if (!ALLOWED_IMAGE_MIME.contains(mime)) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Ảnh đại diện phải là JPEG, PNG hoặc WEBP.");
                    sendJson(response, jsonMap);
                    return;
                }

                // Build upload path inside the webapp (switch to external path if you prefer)
                String uploadsFolder = "/uploads/avatars";
                String absoluteUploadDir = getServletContext().getRealPath(uploadsFolder);
                if (absoluteUploadDir == null) {
                    jsonMap.put("ok", false);
                    jsonMap.put("message", "Không thể xác định thư mục lưu trữ ảnh.");
                    sendJson(response, jsonMap);
                    return;
                }

                Path uploadDir = Path.of(absoluteUploadDir);
                Files.createDirectories(uploadDir);

                String originalName = getSubmittedFileName(avatarPart);
                String ext = guessExtension(mime, originalName); // keep original ext if possible
                String fileName = "ava_" + username + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID() + ext;

                Path target = uploadDir.resolve(fileName);
                try (InputStream in = avatarPart.getInputStream()) {
                    Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
                }

                // Public URL for the client
                newAvatarUrl = request.getContextPath() + uploadsFolder + "/" + fileName;

                // Optionally, delete old local avatar if it was in the same uploads folder
                if (current.getAvatar() != null && current.getAvatar().startsWith(request.getContextPath() + uploadsFolder)) {
                    try {
                        String oldFileName = current.getAvatar().substring((request.getContextPath() + uploadsFolder + "/").length());
                        Path oldPath = uploadDir.resolve(oldFileName);
                        Files.deleteIfExists(oldPath);
                    } catch (IOException ignored) {
                    }
                }
            }

            // 6) Build updated entity
            Employee updated = new Employee();
            updated.setEmployeeId(current.getEmployeeId());
            updated.setFirstName(firstName);
            updated.setMiddleName(middleName);
            updated.setLastName(lastName);
            updated.setPhone(phone);
            updated.setEmail(email);
//            updated.setDob(dob);                  // or setDob(java.sql.Date) depending on your model
            updated.setAddress(address);
            updated.setGender(gender);
            updated.setAvatar(newAvatarUrl != null ? newAvatarUrl : current.getAvatar());

            // 7) Persist
            boolean ok = dao.updateProfile(updated);

            if (!ok) {
                jsonMap.put("ok", false);
                jsonMap.put("message", "Cập nhật thất bại. Vui lòng thử lại.");
            } else {
                jsonMap.put("ok", true);
                jsonMap.put("message", "Cập nhật thành công.");
                Map<String, Object> data = new HashMap<>();
                data.put("avatar", updated.getAvatar());
                data.put("firstName", updated.getFirstName());
                data.put("middleName", updated.getMiddleName());
                data.put("lastName", updated.getLastName());
                data.put("phone", updated.getPhone());
                data.put("email", updated.getEmail());
                data.put("dob", dob != null ? dob.toString() : null);
                data.put("address", updated.getAddress());
                data.put("gender", updated.getGender());
                jsonMap.put("data", data);
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
