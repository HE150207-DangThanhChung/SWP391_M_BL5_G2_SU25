/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.LoginDAO;
import utils.PasswordUtil;
import utils.EmailUtil;

/**
 *
 * @author tayho
 */
@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot"})
public class ForgotPasswordController extends HttpServlet {

    private final LoginDAO loginDAO = new LoginDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        final String rawEmail = req.getParameter("email");
        final String email = (rawEmail == null) ? null : rawEmail.trim();
        req.setAttribute("email", email);

        if (email == null || email.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập email đã đăng ký.");
            req.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(req, resp);
            return;
        }

        // 1) Check if email exists
        boolean exists = loginDAO.existsEmailActive(email);
        if (!exists) {
            req.setAttribute("error", "Email không tồn tại hoặc tài khoản không hoạt động.");
            req.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(req, resp);
            return;
        }

        // 2) Generate new random password
        String newPass = PasswordUtil.generate(8);

        // 3) Update DB with new password
        boolean updated = loginDAO.updatePasswordByEmail(email, newPass);
        if (!updated) {
            req.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            req.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(req, resp);
            return;
        }

        // 4) Send the email
        boolean mailed = EmailUtil.sendMail(
                email,
                "HappySale - Mật khẩu mới",
                "Mật khẩu mới của bạn: " + newPass + "\nVui lòng đăng nhập và đổi mật khẩu."
        );
        req.setAttribute(mailed ? "success" : "error",
                mailed ? "Đã gửi mật khẩu mới tới email của bạn."
                        : "Không thể gửi email (SMTP). Kiểm tra cấu hình và thử lại.");

        req.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(req, resp);
    }
}
