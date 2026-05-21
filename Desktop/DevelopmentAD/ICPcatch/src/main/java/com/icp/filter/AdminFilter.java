package com.icp.filter;

import com.icp.model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

@WebFilter(urlPatterns = {"/views/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if ("ADMIN".equals(user.getRole())) {
                chain.doFilter(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}