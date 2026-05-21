package com.icp.controller;

import com.icp.util.DbConfig;
import com.icp.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/shared/contact.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (!ValidationUtil.isNotEmpty(name) || !ValidationUtil.isNotEmpty(email)
                || !ValidationUtil.isNotEmpty(message)) {
            request.setAttribute("error", "Please fill all required fields.");
            request.getRequestDispatcher("/views/shared/contact.jsp")
                   .forward(request, response);
            return;
        }

        String sql = "INSERT INTO contact_inquiries (name, email, subject, message) " +
                     "VALUES (?,?,?,?)";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, message);
            ps.executeUpdate();
            request.setAttribute("success", 
                "Message sent successfully! We'll get back to you soon.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to send message. Try again.");
        }
        request.getRequestDispatcher("/views/shared/contact.jsp")
               .forward(request, response);
    }
}