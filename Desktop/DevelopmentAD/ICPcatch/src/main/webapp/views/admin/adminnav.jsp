<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.icp.model.User" %>
<%
    User adminUser = (User) session.getAttribute("user");
%>
<nav class="admin-navbar">
    <div class="nav-brand">
        <span>🔍</span>
        <span>ICPCatch <span style="font-size:0.7rem;opacity:0.7">Admin</span></span>
    </div>
    <div class="admin-nav-right">
        <span style="color:rgba(255,255,255,0.8);font-size:0.9rem">
            👤 <%= adminUser != null ? adminUser.getFullName() : "Admin" %>
        </span>
        <a href="${pageContext.request.contextPath}/item" 
           style="color:rgba(255,255,255,0.8);text-decoration:none;font-size:0.85rem">
            View Site
        </a>
        <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-danger" 
           style="font-size:0.85rem;padding:6px 14px">Logout</a>
    </div>
</nav>