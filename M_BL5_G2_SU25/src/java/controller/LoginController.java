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
        // Show the login page (adjust path to where your JSP actually lives)
        RequestDispatcher rd = request.getRequestDispatcher("/views/common/login.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean isValid = loginDAO.checkLogin(username, password);
        if (!isValid) {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu.");
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

        // Set employeeId and employeeName for later use
        session.setAttribute("employeeId", profile.getEmployeeId());
        String employeeName = profile.getLastName() + " " + profile.getMiddleName() + " " + profile.getFirstName();
        session.setAttribute("employeeName", employeeName);

        // Redirect to dashboard only after all session work is done
        if (profile.getRoleId() == 1) {
            response.sendRedirect(request.getContextPath() + "/management/employees");

        } else if (profile.getRoleId() == 1) {
            response.sendRedirect(request.getContextPath() + "/orders");

        } else if (profile.getRoleId() == 2) {
            response.sendRedirect(request.getContextPath() + "/product");

        }
        
//        Will change to this after complete dashboard
//        response.sendRedirect(request.getContextPath() + "/owner/dashboard");

    }

}
