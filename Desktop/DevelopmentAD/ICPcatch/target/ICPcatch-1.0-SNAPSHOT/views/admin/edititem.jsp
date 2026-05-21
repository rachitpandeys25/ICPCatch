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
    <title>Edit Item – Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<%@ include file="adminnav.jsp" %>
<div class="admin-layout">
    <%@ include file="adminsidebar.jsp" %>
    <div class="admin-content">
        <div class="page-header">
            <h1>✏️ Edit Item</h1>
            <a href="${pageContext.request.contextPath}/admin?action=items" 
               class="btn btn-secondary">← Back</a>
        </div>
        <div class="card" style="max-width:700px">
            <form action="${pageContext.request.contextPath}/admin" method="POST">
                <input type="hidden" name="action" value="editItem">
                <input type="hidden" name="itemId" value="${item.itemId}">

                <div class="form-group">
                    <label>Item Title *</label>
                    <input type="text" name="title" value="${item.title}" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Item Type *</label>
                        <select name="itemType" required>
                            <option value="LOST" ${item.itemType=='LOST'?'selected':''}>LOST</option>
                            <option value="FOUND" ${item.itemType=='FOUND'?'selected':''}>FOUND</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Category *</label>
                        <select name="categoryId" required>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}"
                                    ${cat.categoryId == item.categoryId ? 'selected' : ''}>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Date *</label>
                        <input type="date" name="dateOccurred" 
                               value="${item.dateOccurred}" required>
                    </div>
                    <div class="form-group">
                        <label>Location *</label>
                        <input type="text" name="location" value="${item.location}" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4">${item.description}</textarea>
                </div>

                <div style="display:flex;gap:12px">
                    <button type="submit" class="btn btn-primary">💾 Save Changes</button>
                    <a href="${pageContext.request.contextPath}/admin?action=items" 
                       class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>