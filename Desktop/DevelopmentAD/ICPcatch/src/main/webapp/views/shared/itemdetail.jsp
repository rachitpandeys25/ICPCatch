<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.icp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${item.title} – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <div style="display: flex; gap: 30px; flex-wrap: wrap;">
        <!-- Item Image -->
        <div style="flex: 1; min-width: 300px;">
            <img src="${not empty item.imagePath ? 
    pageContext.request.contextPath.concat('/').concat(item.imagePath) : 
    pageContext.request.contextPath.concat('/resources/images/default.png')}"
     alt="${item.title}"
     style="width:100%;border-radius:12px;box-shadow:0 4px 20px rgba(0,0,0,0.1);"
     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/resources/images/default.png'">
        </div>

        <!-- Item Details -->
        <div style="flex: 1; min-width: 300px;">
            <div class="card">
                <span class="badge ${item.itemType == 'LOST' ? 'badge-lost' : 'badge-found'}"
                      style="font-size: 0.9rem; margin-bottom: 12px;">${item.itemType}</span>
                <h1 style="color: #0f3460; margin: 10px 0;">${item.title}</h1>
                <p><strong>Category:</strong> ${item.categoryName}</p>
                <p><strong>Location:</strong> ${item.location}</p>
                <p><strong>Date:</strong> ${item.dateOccurred}</p>
                <p><strong>Reported by:</strong> ${item.reporterName}</p>
                <p><strong>Status:</strong>
                    <span class="badge badge-${item.status.toLowerCase()}">${item.status}</span>
                </p>
                <hr style="margin: 16px 0; border: none; border-top: 1px solid #f0f0f0;">
                <p><strong>Description:</strong></p>
                <p style="color: #555; line-height: 1.6;">${item.description}</p>
            </div>

            <!-- Claim Form -->
            <%
                User u = (User) session.getAttribute("user");
                if (u != null && !"ADMIN".equals(u.getRole())) {
            %>
            <c:if test="${item.status == 'ACTIVE'}">
                <div class="card">
                    <h3 style="margin-bottom: 16px; color: #0f3460;">🙋 Claim This Item</h3>
                    <form action="${pageContext.request.contextPath}/claim" method="POST">
                        <input type="hidden" name="action" value="submit">
                        <input type="hidden" name="itemId" value="${item.itemId}">
                        <div class="form-group">
                            <label>Proof of Ownership *</label>
                            <textarea name="proofDetails" rows="4" required
                                placeholder="Describe how this item belongs to you..."></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Submit Claim</button>
                    </form>
                </div>
            </c:if>
            <%  } %>
        </div>
    </div>
</div>
</body>
</html>