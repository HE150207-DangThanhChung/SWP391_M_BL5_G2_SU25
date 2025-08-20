/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.LoginDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
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
        final String email = req.getParameter("email");

        req.setAttribute("email", email); // preserve input

        if (email == null || email.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập email đã đăng ký.");
            req.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(req, resp);
            return;
        }

        // 1) Check existence (active account)
        boolean exists = loginDAO.existsEmailActive(email.trim());
        if (!exists) {
            req.setAttribute("error", "Email không tồn tại hoặc tài khoản không hoạt động.");
            req.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(req, resp);
            return;
        }

        // 2) Generate new 8-char password
        String newPass = PasswordUtil.generate(8);

        // 3) Update DB (plaintext for now)
        boolean updated = loginDAO.updatePasswordByEmail(email.trim(), newPass);
        if (!updated) {
            req.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            req.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(req, resp);
            return;
        }

        // 4) Send email (configure SMTP in EmailUtil)
        boolean mailed = EmailUtil.send(
                /* smtpHost */"smtp.gmail.com", // or "smtp.office365.com"
                /* port     */ 587, // 587 = STARTTLS, 465 = SSL
                /* useSSL   */ false, // false for 587, true for 465
                /* username */ "YOUR_FROM_EMAIL", // must be the real mailbox
                /* password */ "YOUR_APP_PASSWORD",
                /* to       */ email.trim(),
                /* subject  */ "HappySale - Mật khẩu mới",
                /* body     */ "Mật khẩu mới của bạn: " + newPass + "\nVui lòng đăng nhập và đổi mật khẩu."
        );

        if (mailed) {
            req.setAttribute("success", "Đã gửi mật khẩu mới tới email của bạn.");
        } else {
            req.setAttribute("error", "Gửi email thất bại. Vui lòng thử lại sau hoặc liên hệ quản trị.");
        }
        req.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(req, resp);
    }
}
