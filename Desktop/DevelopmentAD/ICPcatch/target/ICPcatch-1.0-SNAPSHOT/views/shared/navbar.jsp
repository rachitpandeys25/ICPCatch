<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.icp.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
%>
<nav class="navbar">
    <div class="nav-brand">
        <a href="${pageContext.request.contextPath}/item">🔍 ICPCatch</a>
    </div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/item">Browse</a>
        <a href="${pageContext.request.contextPath}/search">Search</a>
        <a href="${pageContext.request.contextPath}/views/shared/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact">Contact</a>

        <% if (currentUser != null) { %>
            <a href="${pageContext.request.contextPath}/item?action=report&type=LOST">
                Report Lost
            </a>
            <a href="${pageContext.request.contextPath}/item?action=report&type=FOUND">
                Report Found
            </a>
            <a href="${pageContext.request.contextPath}/item?action=myitems">My Items</a>
            <a href="${pageContext.request.contextPath}/claim?action=myclaims">My Claims</a>
            <a href="${pageContext.request.contextPath}/profile">Profile</a>
            <% if ("ADMIN".equals(currentUser.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin" class="admin-link">
                    🛡️ Admin
                </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/auth?action=logout" 
               class="logout-btn">Logout</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/views/auth/login.jsp">Login</a>
            <a href="${pageContext.request.contextPath}/views/auth/register.jsp">Register</a>
        <% } %>
    </div>
</nav>