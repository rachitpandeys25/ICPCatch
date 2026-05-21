<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Claims – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="../shared/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>📋 My Claims</h1>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">${param.success}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty claims}">
            <div class="empty-state card">
                <h3>No claims submitted yet</h3>
                <p>Browse items and claim what belongs to you!</p>
                <a href="${pageContext.request.contextPath}/item" class="btn btn-primary" style="margin-top: 16px;">Browse Items</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card">
                <div class="table-container">
                    <table>
                        <tr>
                            <th>Item</th>
                            <th>Submitted</th>
                            <th>Status</th>
                            <th>Admin Remarks</th>
                        </tr>
                        <c:forEach var="claim" items="${claims}">
                            <tr>
                                <td><strong>${claim.itemTitle}</strong></td>
                                <td>${claim.claimedAt}</td>
                                <td><span class="badge badge-${claim.status.toLowerCase()}">${claim.status}</span></td>
                                <td>${not empty claim.adminRemarks ? claim.adminRemarks : '—'}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>