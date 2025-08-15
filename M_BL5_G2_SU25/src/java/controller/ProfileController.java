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

/**
 *
 * @author tayho
 */
/**
Chỉnh sửa lại annotation @WebServlet theo phần cá nhân làm riêng
*/
@WebServlet(name = "ProfileController", urlPatterns = {
    "/profile",
    "/profile/edit"
})
public class ProfileController extends HttpServlet {

    

}
