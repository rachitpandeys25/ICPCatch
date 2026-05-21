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
    <title>Manage Items – Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<%@ include file="adminnav.jsp" %>
<div class="admin-layout">
    <%@ include file="adminsidebar.jsp" %>
    <div class="admin-content">
        <div class="page-header">
            <h1>📦 Manage Items</h1>
            <a href="${pageContext.request.contextPath}/admin?action=postItem" 
               class="btn btn-primary">➕ Post New Item</a>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success">${param.success}</div>
        </c:if>

        <div class="card">
            <div class="table-container">
                <table>
                    <tr>
                        <th>#</th><th>Title</th><th>Type</th><th>Category</th>
                        <th>Location</th><th>Reporter</th><th>Status</th><th>Actions</th>
                    </tr>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td>${item.itemId}</td>
                            <td><strong>${item.title}</strong></td>
                            <td>
                                <span class="badge ${item.itemType=='LOST'?'badge-lost':'badge-found'}">
                                    ${item.itemType}
                                </span>
                            </td>
                            <td>${item.categoryName}</td>
                            <td>${item.location}</td>
                            <td>${item.reporterName}</td>
                            <td>
                                <span class="badge badge-${item.status.toLowerCase()}">
                                    ${item.status}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin?action=editItem&id=${item.itemId}"
                                   class="btn btn-warning" style="font-size:0.8rem;padding:4px 8px">✏️ Edit</a>
                                <c:if test="${item.status == 'ACTIVE' || item.status == 'CLAIMED'}">
                                    <a href="${pageContext.request.contextPath}/admin?action=resolveItem&id=${item.itemId}"
                                       class="btn btn-success" style="font-size:0.8rem;padding:4px 8px"
                                       onclick="return confirm('Mark as resolved?')">✅ Resolve</a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/admin?action=deleteItem&id=${item.itemId}"
                                   class="btn btn-danger" style="font-size:0.8rem;padding:4px 8px"
                                   onclick="return confirm('Delete this item permanently?')">🗑️ Delete</a>
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