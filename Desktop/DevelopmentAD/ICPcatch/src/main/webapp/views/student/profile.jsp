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
    <title>My Profile – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="../shared/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>👤 My Profile</h1>
        <a href="${pageContext.request.contextPath}/views/student/dashboard.jsp" 
           class="btn btn-secondary">← Dashboard</a>
    </div>

    <div style="display:flex;gap:24px;flex-wrap:wrap">

        <!-- Update Profile -->
        <div class="card" style="flex:1;min-width:300px">
            <h3 style="margin-bottom:20px;color:#0f3460">✏️ Update Profile</h3>

            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/profile" method="POST">
                <input type="hidden" name="action" value="updateProfile">

                <div class="form-group">
                    <label>Full Name *</label>
                    <input type="text" name="fullName" 
                           value="${profileUser.fullName}" required>
                </div>
                <div class="form-group">
                    <label>Email (cannot change)</label>
                    <input type="email" value="${profileUser.email}" disabled
                           style="background:#f5f5f5;cursor:not-allowed">
                </div>
                <div class="form-group">
                    <label>Student ID (cannot change)</label>
                    <input type="text" value="${profileUser.studentId}" disabled
                           style="background:#f5f5f5;cursor:not-allowed">
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" 
                           value="${profileUser.phone}" placeholder="98XXXXXXXX">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Program</label>
                        <select name="program">
                            <option value="BSc CSIT" 
                                ${profileUser.program=='BSc CSIT'?'selected':''}>BSc CSIT</option>
                            <option value="BIM" 
                                ${profileUser.program=='BIM'?'selected':''}>BIM</option>
                            <option value="BCA" 
                                ${profileUser.program=='BCA'?'selected':''}>BCA</option>
                            <option value="MCA" 
                                ${profileUser.program=='MCA'?'selected':''}>MCA</option>
                            <option value="Other" 
                                ${profileUser.program=='Other'?'selected':''}>Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Year</label>
                        <select name="year">
                            <option value="1" ${profileUser.year==1?'selected':''}>1st Year</option>
                            <option value="2" ${profileUser.year==2?'selected':''}>2nd Year</option>
                            <option value="3" ${profileUser.year==3?'selected':''}>3rd Year</option>
                            <option value="4" ${profileUser.year==4?'selected':''}>4th Year</option>
                        </select>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">💾 Save Changes</button>
            </form>
        </div>

        <!-- Change Password -->
        <div class="card" style="flex:1;min-width:300px">
            <h3 style="margin-bottom:20px;color:#0f3460">🔒 Change Password</h3>

            <c:if test="${not empty passSuccess}">
                <div class="alert alert-success">${passSuccess}</div>
            </c:if>
            <c:if test="${not empty passError}">
                <div class="alert alert-error">${passError}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/profile" method="POST">
                <input type="hidden" name="action" value="changePassword">
                <div class="form-group">
                    <label>Current Password *</label>
                    <input type="password" name="currentPassword" required>
                </div>
                <div class="form-group">
                    <label>New Password *</label>
                    <input type="password" name="newPassword" 
                           placeholder="Min 6 characters" required>
                </div>
                <div class="form-group">
                    <label>Confirm New Password *</label>
                    <input type="password" name="confirmPassword" required>
                </div>
                <button type="submit" class="btn btn-warning">🔑 Change Password</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>