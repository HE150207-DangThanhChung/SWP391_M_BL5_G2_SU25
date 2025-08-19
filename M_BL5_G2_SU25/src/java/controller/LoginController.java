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
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
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

        Employee employee = loginDAO.checkLogin(username, password);

        if (employee != null) {
            HttpSession session = request.getSession();
            session.setAttribute("tendangnhap", username);
            session.setAttribute("employeeId", employee.getEmployeeId());
            
            String employeeName = employee.getLastName() + " " + employee.getMiddleName() + " " + employee.getFirstName();
            session.setAttribute("employeeName", employeeName);

            // Avoid form resubmission on refresh
            response.sendRedirect(request.getContextPath() + "/views/dashboard/ownerDashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid username or password");
            RequestDispatcher rd = request.getRequestDispatcher("/views/common/login.jsp");
            rd.forward(request, response);
        }
    }

}
