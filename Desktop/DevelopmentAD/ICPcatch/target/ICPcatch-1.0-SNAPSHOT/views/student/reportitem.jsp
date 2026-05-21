<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Item – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="../shared/navbar.jsp" %>
<div class="container">
    <div class="card" style="max-width: 700px; margin: 30px auto;">
        <h2 style="margin-bottom: 24px; color: #0f3460;">
            ${param.type == 'LOST' ? '🔴 Report Lost Item' : '🟢 Report Found Item'}
        </h2>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/item" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="report">
            <input type="hidden" name="itemType" value="${not empty param.type ? param.type : 'LOST'}">

            <div class="form-group">
                <label>Item Title *</label>
                <input type="text" name="title" placeholder="e.g. Blue Dell Laptop" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Category *</label>
                    <select name="categoryId" required>
                        <option value="">Select Category</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}">${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Date ${param.type == 'LOST' ? 'Lost' : 'Found'} *</label>
                    <input type="date" name="dateOccurred" required>
                </div>
            </div>

            <div class="form-group">
                <label>Location *</label>
                <input type="text" name="location" placeholder="e.g. Library, 2nd Floor" required>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" rows="4"
                    placeholder="Describe the item in detail..."></textarea>
            </div>

            <div class="form-group">
                <label>Upload Image</label>
                <input type="file" name="image" accept="image/jpeg,image/png,image/gif">
            </div>

            <div style="display: flex; gap: 12px;">
                <button type="submit" class="btn btn-primary">Submit Report</button>
                <a href="${pageContext.request.contextPath}/item" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>