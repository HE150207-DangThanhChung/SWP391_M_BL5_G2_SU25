/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.WardDAO;
import model.Ward;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 *
 * @author tayho
 */
@WebServlet(name = "LookupController", urlPatterns = {"/lookup/ward-options"})
public class LookupController extends HttpServlet {

    private final WardDAO wardDAO = new WardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String cityIdRaw = req.getParameter("cityId");
        int cityId = 0;
        try {
            cityId = Integer.parseInt(cityIdRaw);
        } catch (Exception ignore) {
        }

        try (PrintWriter out = resp.getWriter()) {
            if (cityId <= 0) {
                out.write(""); // nothing to show
                return;
            }

            // You must have this DAO method:
            // public List<Ward> getByCityId(int cityId)
            List<Ward> wards = wardDAO.getByCityId(cityId);

            // Return pure <option> elements (your JS prepends the default prompt)
            if (wards != null) {
                for (Ward w : wards) {
                    out.write("<option value=\"");
                    out.write(String.valueOf(w.getWardId()));
                    out.write("\">");
                    out.write(escapeHtml(w.getWardName()));
                    out.write("</option>");
                }
            }
        }
    }

    // Very small HTML escape helper (covers the common cases)
    private static String escapeHtml(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

}
