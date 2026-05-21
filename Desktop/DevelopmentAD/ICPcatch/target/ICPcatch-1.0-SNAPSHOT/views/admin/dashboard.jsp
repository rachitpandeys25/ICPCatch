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
    <title>Admin Dashboard – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<%@ include file="adminnav.jsp" %>
<div class="admin-layout">
    <%@ include file="adminsidebar.jsp" %>
    <div class="admin-content">
        <div class="page-header">
            <h1>📊 Dashboard Overview</h1>
            <span class="welcome-text">Welcome, <%= user.getFullName() %></span>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success">${param.success}</div>
        </c:if>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card" style="border-top:4px solid #0f3460">
                <div class="stat-icon">📦</div>
                <div class="stat-number">${totalItems}</div>
                <div class="stat-label">Total Items</div>
                <a href="${pageContext.request.contextPath}/admin?action=items" class="stat-link">View All →</a>
            </div>
            <div class="stat-card" style="border-top:4px solid #27ae60">
                <div class="stat-icon">👥</div>
                <div class="stat-number">${totalUsers}</div>
                <div class="stat-label">Registered Students</div>
                <a href="${pageContext.request.contextPath}/admin?action=users" class="stat-link">View All →</a>
            </div>
            <div class="stat-card" style="border-top:4px solid #f39c12">
                <div class="stat-icon">⏳</div>
                <div class="stat-number">${pendingClaims}</div>
                <div class="stat-label">Pending Claims</div>
                <a href="${pageContext.request.contextPath}/admin?action=claims" class="stat-link">Review →</a>
            </div>
            <div class="stat-card" style="border-top:4px solid #e74c3c">
                <div class="stat-icon">✅</div>
                <div class="stat-number">${successRate}</div>
                <div class="stat-label">Success Rate</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="card">
            <h3 style="margin-bottom:16px;color:#0f3460">⚡ Quick Actions</h3>
            <div style="display:flex;gap:12px;flex-wrap:wrap">
                <a href="${pageContext.request.contextPath}/admin?action=postItem" class="btn btn-primary">📝 Post New Item</a>
                <a href="${pageContext.request.contextPath}/admin?action=items" class="btn btn-warning">📦 Manage Items</a>
                <a href="${pageContext.request.contextPath}/admin?action=claims" class="btn btn-success">📋 Review Claims</a>
                <a href="${pageContext.request.contextPath}/admin?action=users" class="btn btn-secondary">👥 Manage Users</a>
            </div>
        </div>

        <!-- Pending Claims Table -->
        <div class="card">
            <h3 style="margin-bottom:16px;color:#0f3460">⏳ Pending Claims</h3>
            <c:choose>
                <c:when test="${empty recentClaims}">
                    <p style="color:#666;text-align:center;padding:20px">✅ No pending claims!</p>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table>
                            <tr>
                                <th>#</th><th>Item</th><th>Claimant</th>
                                <th>Proof</th><th>Date</th><th>Actions</th>
                            </tr>
                            <c:forEach var="claim" items="${recentClaims}">
                                <tr>
                                    <td>${claim.claimId}</td>
                                    <td><strong>${claim.itemTitle}</strong></td>
                                    <td>${claim.claimantName}</td>
                                    <td style="max-width:200px;font-size:0.85rem;color:#555">${claim.proofDetails}</td>
                                    <td style="font-size:0.85rem">${claim.claimedAt}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin?action=approveClaim&id=${claim.claimId}&remarks=Verified and approved by admin"
                                           class="btn btn-success" style="font-size:0.8rem;padding:4px 10px"
                                           onclick="return confirm('Approve this claim?')">✅ Approve</a>
                                        <a href="${pageContext.request.contextPath}/admin?action=rejectClaim&id=${claim.claimId}&remarks=Insufficient proof provided"
                                           class="btn btn-danger" style="font-size:0.8rem;padding:4px 10px"
                                           onclick="return confirm('Reject this claim?')">❌ Reject</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Category Stats -->
        <div class="card">
            <h3 style="margin-bottom:16px;color:#0f3460">📊 Items by Category</h3>
            <c:forEach var="stat" items="${categoryStats}">
                <div style="display:flex;align-items:center;gap:12px;margin-bottom:12px">
                    <span style="width:160px;font-size:0.9rem;font-weight:600">${stat.key}</span>
                    <div style="flex:1;background:#f0f2f5;border-radius:20px;height:24px;overflow:hidden">
                        <div style="background:linear-gradient(90deg,#0f3460,#16213e);height:100%;
                             border-radius:20px;width:${stat.value > 0 ? stat.value * 15 : 5}px;
                             max-width:100%;display:flex;align-items:center;padding-left:8px;
                             color:white;font-size:0.75rem"></div>
                    </div>
                    <span style="font-weight:700;color:#0f3460;width:30px">${stat.value}</span>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
</body>
</html>