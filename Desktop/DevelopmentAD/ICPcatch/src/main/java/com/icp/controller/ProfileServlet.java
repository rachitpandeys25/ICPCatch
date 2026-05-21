package com.icp.controller;

import com.icp.dao.UserDAO;
import com.icp.model.User;
import com.icp.util.PasswordUtil;
import com.icp.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        // Refresh user from DB
        User freshUser = new UserDAO().findById(user.getUserId());
        request.setAttribute("profileUser", freshUser);
        request.getRequestDispatcher("/views/student/profile.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            updateProfile(request, response, user);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response, user);
        }
    }

    private void updateProfile(HttpServletRequest request,
            HttpServletResponse response, User user)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String program = request.getParameter("program");
        String yearStr = request.getParameter("year");

        if (!ValidationUtil.isNotEmpty(fullName)) {
            request.setAttribute("error", "Name cannot be empty.");
            doGet(request, response);
            return;
        }

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setProgram(program);
        user.setYear(yearStr != null && !yearStr.isEmpty()
                ? Integer.parseInt(yearStr) : user.getYear());

        UserDAO userDAO = new UserDAO();
        if (userDAO.updateProfile(user)) {
            // Update session
            User updated = userDAO.findById(user.getUserId());
            request.getSession().setAttribute("user", updated);
            request.setAttribute("success", "Profile updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update profile.");
        }
        request.setAttribute("profileUser", user);
        request.getRequestDispatcher("/views/student/profile.jsp")
               .forward(request, response);
    }

    private void changePassword(HttpServletRequest request,
            HttpServletResponse response, User user)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UserDAO userDAO = new UserDAO();
        User dbUser = userDAO.findById(user.getUserId());

        if (!PasswordUtil.checkPassword(currentPassword, dbUser.getPasswordHash())) {
            request.setAttribute("passError", "Current password is incorrect.");
            request.setAttribute("profileUser", dbUser);
            request.getRequestDispatcher("/views/student/profile.jsp")
                   .forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("passError", "New passwords do not match.");
            request.setAttribute("profileUser", dbUser);
            request.getRequestDispatcher("/views/student/profile.jsp")
                   .forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("passError", "Password must be at least 6 characters.");
            request.setAttribute("profileUser", dbUser);
            request.getRequestDispatcher("/views/student/profile.jsp")
                   .forward(request, response);
            return;
        }

        String newHash = PasswordUtil.hashPassword(newPassword);
        if (userDAO.updatePassword(user.getUserId(), newHash)) {
            request.setAttribute("passSuccess", "Password changed successfully!");
        } else {
            request.setAttribute("passError", "Failed to change password.");
        }
        request.setAttribute("profileUser", dbUser);
        request.getRequestDispatcher("/views/student/profile.jsp")
               .forward(request, response);
    }
}