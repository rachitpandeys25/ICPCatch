package com.icp.controller;

import com.icp.dao.UserDAO;
import com.icp.model.User;
import com.icp.util.PasswordUtil;
import com.icp.util.ValidationUtil;
import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/auth"})
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            // Invalidate session to clear all user data
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(
                request.getContextPath() + "/views/auth/login.jsp");
        } else {
            response.sendRedirect(
                request.getContextPath() + "/views/auth/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "login":
                handleLogin(request, response);
                break;
            case "register":
                handleRegister(request, response);
                break;
            default:
                response.sendRedirect(
                    request.getContextPath() + "/views/auth/login.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate required fields
        if (!ValidationUtil.isNotEmpty(email)
                || !ValidationUtil.isNotEmpty(password)) {
            request.setAttribute("error", "Email and password are required.");
            forward(request, response, "/views/auth/login.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByEmail(email);

        // Check credentials using BCrypt comparison
        if (user == null
                || !PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            request.setAttribute("error", "Invalid email or password.");
            forward(request, response, "/views/auth/login.jsp");
            return;
        }

        // Check if account is active
        if (!"ACTIVE".equals(user.getStatus())) {
            request.setAttribute("error",
                "Your account is not active. Contact admin.");
            forward(request, response, "/views/auth/login.jsp");
            return;
        }

        // Create session and store user details
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("role", user.getRole());

        // Route based on role
        if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            response.sendRedirect(request.getContextPath()
                + "/views/student/dashboard.jsp");
        }
    }

    /**
     * Processes new user registration with full validation.
     * Validates all input fields, checks for duplicates,
     * hashes password with BCrypt before storing.
     *
     * @param request HttpServletRequest containing registration form data
     * @param response HttpServletResponse for redirect or forward
     * @throws ServletException if servlet error occurs
     * @throws IOException if I/O error occurs
     */
    private void handleRegister(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String studentId = request.getParameter("studentId");
        String program = request.getParameter("program");
        String yearStr = request.getParameter("year");
        String phone = request.getParameter("phone");

        // Validate required fields
        if (!ValidationUtil.isNotEmpty(fullName)
                || !ValidationUtil.isNotEmpty(email)
                || !ValidationUtil.isNotEmpty(password)
                || !ValidationUtil.isNotEmpty(studentId)) {
            request.setAttribute("error", "All required fields must be filled.");
            forward(request, response, "/views/auth/register.jsp");
            return;
        }

        // Validate email format
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address.");
            forward(request, response, "/views/auth/register.jsp");
            return;
        }

        // Check password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            forward(request, response, "/views/auth/register.jsp");
            return;
        }

        // Check minimum password length
        if (password.length() < 6) {
            request.setAttribute("error",
                "Password must be at least 6 characters.");
            forward(request, response, "/views/auth/register.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();

        // Check for duplicate email
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "This email is already registered.");
            forward(request, response, "/views/auth/register.jsp");
            return;
        }

        // Check for duplicate student ID
        if (userDAO.studentIdExists(studentId)) {
            request.setAttribute("error",
                "This Student ID is already registered.");
            forward(request, response, "/views/auth/register.jsp");
            return;
        }

        // Build user object with hashed password
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setStudentId(studentId);
        user.setProgram(program);
        user.setYear(yearStr != null && !yearStr.isEmpty()
                ? Integer.parseInt(yearStr) : 1);
        user.setPhone(phone);
        user.setRole("STUDENT");
        user.setStatus("ACTIVE");

        if (userDAO.register(user)) {
            request.setAttribute("success",
                "Registration successful! Please login.");
            forward(request, response, "/views/auth/login.jsp");
        } else {
            request.setAttribute("error",
                "Registration failed. Please try again.");
            forward(request, response, "/views/auth/register.jsp");
        }
    }

    /**
     * Helper method to forward request to a JSP view.
     *
     * @param req HttpServletRequest to forward
     * @param res HttpServletResponse to forward
     * @param path Path to the target JSP
     * @throws ServletException if servlet error occurs
     * @throws IOException if I/O error occurs
     */
    private void forward(HttpServletRequest req,
            HttpServletResponse res, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, res);
    }
}