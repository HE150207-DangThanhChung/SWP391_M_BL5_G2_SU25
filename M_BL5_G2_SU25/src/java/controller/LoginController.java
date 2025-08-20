/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.LoginDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Employee;

import java.io.IOException;

/**
 *
 * @author tayho
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    private final LoginDAO loginDAO = new LoginDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Show login page
        request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        final String username = request.getParameter("username");
        final String password = request.getParameter("password");
        // Empty input
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập tên đăng nhập và mật khẩu.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Basic credential check (Status='Active' enforced in DAO)
        boolean ok = loginDAO.checkLogin(username, password);
        if (!ok) {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
            request.setAttribute("username", username); // keep entered username
            RequestDispatcher rd = request.getRequestDispatcher("/views/common/login.jsp");
            rd.forward(request, response);
            return;
        }
        // Load full profile for session
        Employee profile = loginDAO.getProfile(username);
        if (profile == null) {
            // Defensive fallback: treat as failure if profile could not be loaded
            request.setAttribute("error", "Không thể lấy hồ sơ người dùng.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }
        // Session rotation (mitigate session fixation)
        HttpSession old = request.getSession(false);
        if (old != null) {
            old.invalidate();
        }
        HttpSession session = request.getSession(true);
        session.setAttribute("authUser", profile);     // preferred key for the full profile
        session.setAttribute("tendangnhap", username);
        session.setMaxInactiveInterval(30 * 60);       // 30 minutes

        // Redirect to dashboard 
        response.sendRedirect(request.getContextPath() + "/views/dashboard/ownerDashboard.jsp");
        
//        Will change to this after complete dashboard
//        response.sendRedirect(request.getContextPath() + "/owner/dashboard");

    }

}
