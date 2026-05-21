<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.icp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    if ("ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/admin");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/student.css">
</head>
<body>
<%@ include file="../shared/navbar.jsp" %>
<div class="container">

    <!-- Welcome Banner -->
    <div class="welcome-banner">
        <div>
            <h1>Welcome back, <%= user.getFullName() %>! 👋</h1>
            <p>Find your lost items or help others find theirs.</p>
        </div>
        <div style="display:flex;gap:12px">
            <a href="${pageContext.request.contextPath}/item?action=report&type=LOST" 
               class="btn btn-danger">🔴 Report Lost</a>
            <a href="${pageContext.request.contextPath}/item?action=report&type=FOUND" 
               class="btn btn-success">🟢 Report Found</a>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="stats-grid">
        <div class="stat-card" style="border-top:4px solid #e74c3c">
            <div class="stat-icon">🔴</div>
            <div class="stat-label">Report a Lost Item</div>
            <a href="${pageContext.request.contextPath}/item?action=report&type=LOST" 
               class="btn btn-danger" style="margin-top:12px">Report Lost</a>
        </div>
        <div class="stat-card" style="border-top:4px solid #27ae60">
            <div class="stat-icon">🟢</div>
            <div class="stat-label">Report a Found Item</div>
            <a href="${pageContext.request.contextPath}/item?action=report&type=FOUND" 
               class="btn btn-success" style="margin-top:12px">Report Found</a>
        </div>
        <div class="stat-card" style="border-top:4px solid #0f3460">
            <div class="stat-icon">📦</div>
            <div class="stat-label">My Posted Items</div>
            <a href="${pageContext.request.contextPath}/item?action=myitems" 
               class="btn btn-primary" style="margin-top:12px">View Items</a>
        </div>
        <div class="stat-card" style="border-top:4px solid #f39c12">
            <div class="stat-icon">📋</div>
            <div class="stat-label">My Claims</div>
            <a href="${pageContext.request.contextPath}/claim?action=myclaims" 
               class="btn btn-warning" style="margin-top:12px">View Claims</a>
        </div>
    </div>

    <!-- Search Section -->
    <div class="card">
        <h3 style="margin-bottom:16px;color:#0f3460">🔍 Search Lost & Found Items</h3>
        <form action="${pageContext.request.contextPath}/search" method="GET"
              style="display:flex;gap:12px;align-items:flex-end;flex-wrap:wrap">
            <div style="flex:2;min-width:200px">
                <input type="text" name="keyword" 
                       placeholder="Search for items... e.g. laptop, wallet, ID card"
                       style="width:100%;padding:10px 14px;border:2px solid #e0e0e0;
                              border-radius:8px;font-size:0.95rem;outline:none">
            </div>
            <div style="flex:1;min-width:140px">
                <select name="type" 
                        style="width:100%;padding:10px 14px;border:2px solid #e0e0e0;
                               border-radius:8px;font-size:0.95rem;outline:none">
                    <option value="">All Types</option>
                    <option value="LOST">Lost Items</option>
                    <option value="FOUND">Found Items</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Search</button>
        </form>
    </div>

    <!-- Browse Recent Items -->
    <div class="card">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px">
            <h3 style="color:#0f3460">📋 Recent Items</h3>
            <a href="${pageContext.request.contextPath}/item" class="btn btn-secondary">View All</a>
        </div>
        <p style="color:#666;font-size:0.9rem">
            Browse all lost and found items posted by students and staff.
        </p>
        <div style="margin-top:12px">
            <a href="${pageContext.request.contextPath}/item" class="btn btn-primary">Browse Items</a>
            <a href="${pageContext.request.contextPath}/search?type=LOST" 
               class="btn btn-danger" style="margin-left:8px">Lost Items</a>
            <a href="${pageContext.request.contextPath}/search?type=FOUND" 
               class="btn btn-success" style="margin-left:8px">Found Items</a>
        </div>
    </div>

    <!-- Profile Info -->
    <div class="card">
        <div style="display:flex;justify-content:space-between;align-items:center">
            <div>
                <h3 style="color:#0f3460;margin-bottom:8px">👤 My Profile</h3>
                <p><strong>Name:</strong> <%= user.getFullName() %></p>
                <p><strong>Email:</strong> <%= user.getEmail() %></p>
                <p><strong>Student ID:</strong> <%= user.getStudentId() %></p>
                <p><strong>Program:</strong> <%= user.getProgram() %></p>
            </div>
            <a href="${pageContext.request.contextPath}/profile" 
               class="btn btn-secondary">Edit Profile</a>
        </div>
    </div>
</div>
</body>
</html>