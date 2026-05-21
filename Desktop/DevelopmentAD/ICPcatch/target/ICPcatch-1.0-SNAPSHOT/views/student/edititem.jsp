<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.icp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Item – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="../shared/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>✏️ Edit Item</h1>
        <a href="${pageContext.request.contextPath}/item?action=myitems" 
           class="btn btn-secondary">← My Items</a>
    </div>
    <div class="card" style="max-width:700px;margin:0 auto">
        <form action="${pageContext.request.contextPath}/item" method="POST">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="itemId" value="${item.itemId}">

            <div class="form-group">
                <label>Item Title *</label>
                <input type="text" name="title" value="${item.title}" required>
            </div>
            <div class="form-row">
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
                <div class="form-group">
                    <label>Date *</label>
                    <input type="date" name="dateOccurred" 
                           value="${item.dateOccurred}" required>
                </div>
            </div>
            <div class="form-group">
                <label>Location *</label>
                <input type="text" name="location" value="${item.location}" required>
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" rows="4">${item.description}</textarea>
            </div>
            <div style="display:flex;gap:12px">
                <button type="submit" class="btn btn-primary">💾 Save Changes</button>
                <a href="${pageContext.request.contextPath}/item?action=myitems" 
                   class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>