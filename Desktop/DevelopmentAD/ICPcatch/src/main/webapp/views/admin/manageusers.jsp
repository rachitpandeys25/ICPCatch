<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.icp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users – Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<%@ include file="adminnav.jsp" %>
<div class="admin-layout">
    <%@ include file="adminsidebar.jsp" %>
    <div class="admin-content">
        <div class="page-header">
            <h1>👥 Manage Users</h1>
            <span style="color:#666">${users.size()} total users</span>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success">${param.success}</div>
        </c:if>

        <div class="card">
            <div class="table-container">
                <table>
                    <tr>
                        <th>#</th><th>Name</th><th>Email</th><th>Student ID</th>
                        <th>Program</th><th>Year</th><th>Role</th><th>Status</th><th>Actions</th>
                    </tr>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>${u.userId}</td>
                            <td><strong>${u.fullName}</strong></td>
                            <td>${u.email}</td>
                            <td>${u.studentId}</td>
                            <td>${u.program}</td>
                            <td>${u.year > 0 ? u.year : '-'}</td>
                            <td>
                                <span class="badge ${u.role=='ADMIN'?'badge-found':'badge-active'}">
                                    ${u.role}
                                </span>
                            </td>
                            <td>
                                <span class="badge badge-${u.status.toLowerCase()}">
                                    ${u.status}
                                </span>
                            </td>
                            <td>
                                <c:if test="${u.role != 'ADMIN'}">
                                    <c:if test="${u.status == 'ACTIVE'}">
                                        <a href="${pageContext.request.contextPath}/admin?action=toggleUserStatus&id=${u.userId}&status=SUSPENDED"
                                           class="btn btn-warning" style="font-size:0.75rem;padding:3px 8px"
                                           onclick="return confirm('Suspend this user?')">🚫 Suspend</a>
                                    </c:if>
                                    <c:if test="${u.status == 'SUSPENDED'}">
                                        <a href="${pageContext.request.contextPath}/admin?action=toggleUserStatus&id=${u.userId}&status=ACTIVE"
                                           class="btn btn-success" style="font-size:0.75rem;padding:3px 8px">✅ Activate</a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/admin?action=deleteUser&id=${u.userId}"
                                       class="btn btn-danger" style="font-size:0.75rem;padding:3px 8px"
                                       onclick="return confirm('Delete this user permanently?')">🗑️ Delete</a>
                                </c:if>
                                <c:if test="${u.role == 'ADMIN'}">
                                    <span style="color:#666;font-size:0.8rem">Protected</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>