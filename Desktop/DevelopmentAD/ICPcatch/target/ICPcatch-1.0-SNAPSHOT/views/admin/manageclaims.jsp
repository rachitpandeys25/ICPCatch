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
    <title>Manage Claims – Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<%@ include file="adminnav.jsp" %>
<div class="admin-layout">
    <%@ include file="adminsidebar.jsp" %>
    <div class="admin-content">
        <div class="page-header">
            <h1>📋 Manage Claims</h1>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success">${param.success}</div>
        </c:if>

        <div class="card">
            <div class="table-container">
                <table>
                    <tr>
                        <th>#</th><th>Item</th><th>Claimant</th>
                        <th>Proof Details</th><th>Submitted</th>
                        <th>Status</th><th>Remarks</th><th>Actions</th>
                    </tr>
                    <c:forEach var="claim" items="${claims}">
                        <tr>
                            <td>${claim.claimId}</td>
                            <td><strong>${claim.itemTitle}</strong></td>
                            <td>${claim.claimantName}</td>
                            <td style="max-width:180px;font-size:0.82rem;color:#555">
                                ${claim.proofDetails}
                            </td>
                            <td style="font-size:0.82rem">${claim.claimedAt}</td>
                            <td>
                                <span class="badge badge-${claim.status.toLowerCase()}">
                                    ${claim.status}
                                </span>
                            </td>
                            <td style="font-size:0.82rem;color:#666">
                                ${not empty claim.adminRemarks ? claim.adminRemarks : '—'}
                            </td>
                            <td>
                                <c:if test="${claim.status == 'PENDING'}">
                                    <a href="${pageContext.request.contextPath}/admin?action=approveClaim&id=${claim.claimId}&remarks=Verified and approved"
                                       class="btn btn-success" style="font-size:0.75rem;padding:3px 8px"
                                       onclick="return confirm('Approve this claim?')">✅ Approve</a>
                                    <a href="${pageContext.request.contextPath}/admin?action=rejectClaim&id=${claim.claimId}&remarks=Insufficient proof"
                                       class="btn btn-danger" style="font-size:0.75rem;padding:3px 8px"
                                       onclick="return confirm('Reject?')">❌ Reject</a>
                                </c:if>
                                <c:if test="${claim.status != 'PENDING'}">
                                    <span style="color:#999;font-size:0.8rem">Processed</span>
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