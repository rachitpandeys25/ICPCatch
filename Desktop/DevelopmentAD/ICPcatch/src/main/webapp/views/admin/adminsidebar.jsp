<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String currentAction = request.getParameter("action");
    if (currentAction == null) currentAction = "dashboard";
%>
<div class="admin-sidebar">
    <div class="sidebar-menu">
        <div class="sidebar-section">MAIN</div>
        <a href="${pageContext.request.contextPath}/admin" 
           class="sidebar-link <%= "dashboard".equals(currentAction) ? "active" : "" %>">
            📊 Dashboard
        </a>

        <div class="sidebar-section">ITEMS</div>
        <a href="${pageContext.request.contextPath}/admin?action=postItem"
           class="sidebar-link <%= "postItem".equals(currentAction) ? "active" : "" %>">
            ➕ Post New Item
        </a>
        <a href="${pageContext.request.contextPath}/admin?action=items"
           class="sidebar-link <%= "items".equals(currentAction) ? "active" : "" %>">
            📦 Manage Items
        </a>

        <div class="sidebar-section">CLAIMS</div>
        <a href="${pageContext.request.contextPath}/admin?action=claims"
           class="sidebar-link <%= "claims".equals(currentAction) ? "active" : "" %>">
            📋 All Claims
        </a>

        <div class="sidebar-section">USERS</div>
        <a href="${pageContext.request.contextPath}/admin?action=users"
           class="sidebar-link <%= "users".equals(currentAction) ? "active" : "" %>">
            👥 Manage Users
        </a>
    </div>
</div>