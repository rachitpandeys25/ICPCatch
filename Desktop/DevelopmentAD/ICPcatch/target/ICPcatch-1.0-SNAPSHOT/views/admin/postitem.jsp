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
    <title>Post Item – Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<%@ include file="adminnav.jsp" %>
<div class="admin-layout">
    <%@ include file="adminsidebar.jsp" %>
    <div class="admin-content">
        <div class="page-header">
            <h1>➕ Post New Item</h1>
            <a href="${pageContext.request.contextPath}/admin?action=items" 
               class="btn btn-secondary">← Back to Items</a>
        </div>

        <div class="card" style="max-width:700px">
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <div style="background:#e8f4fd;padding:14px;border-radius:8px;margin-bottom:20px;font-size:0.9rem;color:#0f3460">
                <strong>ℹ️ Admin Item Posting:</strong> Use this to post items found by 
                college staff or security. Items will appear in the public lost &amp; found list 
                for students to claim.
            </div>

            <form action="${pageContext.request.contextPath}/admin" 
                  method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="postItem">

                <div class="form-group">
                    <label>Item Title *</label>
                    <input type="text" name="title" 
                           placeholder="e.g. Blue Laptop found at Library" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Item Type *</label>
                        <select name="itemType" required>
                            <option value="FOUND">FOUND (Staff Found Item)</option>
                            <option value="LOST">LOST (Reported by Student)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Category *</label>
                        <select name="categoryId" required>
                            <option value="">Select Category</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}">${cat.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Date Found/Lost *</label>
                        <input type="date" name="dateOccurred" required>
                    </div>
                    <div class="form-group">
                        <label>Location Found/Lost *</label>
                        <input type="text" name="location" 
                               placeholder="e.g. Library 2nd Floor" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Found By (Staff Name/Department)</label>
                    <input type="text" name="foundBy" 
                           placeholder="e.g. Mr. Ram - Security Guard, or Library Staff">
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4"
                        placeholder="Describe the item in detail for identification..."></textarea>
                </div>

                <div class="form-group">
                    <label>Upload Image (Optional)</label>
                    <input type="file" name="image" accept="image/jpeg,image/png,image/gif">
                </div>

                <div style="display:flex;gap:12px">
                    <button type="submit" class="btn btn-primary">📝 Post Item</button>
                    <a href="${pageContext.request.contextPath}/admin?action=items" 
                       class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>