<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Items – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>📋 Browse Lost & Found Items</h1>
        <div>
            <a href="${pageContext.request.contextPath}/item?action=report&type=LOST" class="btn btn-danger">+ Report Lost</a>
            <a href="${pageContext.request.contextPath}/item?action=report&type=FOUND" class="btn btn-success">+ Report Found</a>
        </div>
    </div>

    <!-- Filter Tabs -->
    <div class="filter-tabs">
        <a href="${pageContext.request.contextPath}/item" class="filter-tab active">All</a>
        <a href="${pageContext.request.contextPath}/search?type=LOST" class="filter-tab">Lost Items</a>
        <a href="${pageContext.request.contextPath}/search?type=FOUND" class="filter-tab">Found Items</a>
    </div>

    <!-- Items Grid -->
    <div class="items-grid">
        <c:choose>
            <c:when test="${empty items}">
                <div class="empty-state">
                    <h3>No items posted yet</h3>
                    <p>Be the first to report a lost or found item!</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="item" items="${items}">
                    <a href="${pageContext.request.contextPath}/item?action=detail&id=${item.itemId}" class="item-card">
                       <%-- Item Image --%>
                    <%-- If image exists show from uploads, else show default --%>
                    <c:choose>
                        <c:when test="${not empty item.imagePath}">
                            <img src="${pageContext.request.contextPath}/uploads/${item.imagePath}"
                                 alt="${item.title}"
                                 style="width:100%;height:200px;object-fit:cover;"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/resources/images/default.png'">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/resources/images/default.png"
                                 alt="No Image"
                                 style="width:100%;height:200px;object-fit:cover;">
                        </c:otherwise>
                    </c:choose>
                        <div class="item-card-body">
                            <span class="badge ${item.itemType == 'LOST' ? 'badge-lost' : 'badge-found'}">${item.itemType}</span>
                            <h3>${item.title}</h3>
                            <p>📁 ${item.categoryName}</p>
                            <p>📍 ${item.location}</p>
                            <p>📅 ${item.dateOccurred}</p>
                            <span class="badge badge-${item.status.toLowerCase()}">${item.status}</span>
                        </div>
                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>