<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Items – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="../shared/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>📦 My Items</h1>
        <div>
            <a href="${pageContext.request.contextPath}/item?action=report&type=LOST" class="btn btn-danger">+ Lost</a>
            <a href="${pageContext.request.contextPath}/item?action=report&type=FOUND" class="btn btn-success">+ Found</a>
        </div>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">${param.success}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty items}">
            <div class="empty-state card">
                <h3>No items posted yet</h3>
                <p>Start by reporting a lost or found item!</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card">
                <div class="table-container">
                    <table>
                        <tr>
                            <th>Title</th>
                            <th>Type</th>
                            <th>Category</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        <c:forEach var="item" items="${items}">
                            <tr>
                                <td><strong>${item.title}</strong></td>
                                <td><span class="badge ${item.itemType == 'LOST' ? 'badge-lost' : 'badge-found'}">${item.itemType}</span></td>
                                <td>${item.categoryName}</td>
                                <td>${item.location}</td>
                                <td>${item.dateOccurred}</td>
                                <td><span class="badge badge-${item.status.toLowerCase()}">${item.status}</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/item?action=detail&id=${item.itemId}" class="btn btn-secondary" style="font-size:0.8rem; padding: 4px 10px;">View</a>
                                    <a href="${pageContext.request.contextPath}/item?action=edit&id=${item.itemId}" class="btn btn-warning" style="font-size:0.8rem; padding: 4px 10px;">Edit</a>
                                    <a href="${pageContext.request.contextPath}/item?action=resolve&id=${item.itemId}"
                                       class="btn btn-success" style="font-size:0.8rem; padding: 4px 10px;"
                                       onclick="return confirm('Mark as resolved?')">Resolve</a>
                                    <a href="${pageContext.request.contextPath}/item?action=delete&id=${item.itemId}"
                                       class="btn btn-danger" style="font-size:0.8rem; padding: 4px 10px;"
                                       onclick="return confirm('Delete this item?')">Delete</a>
                                </td>
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