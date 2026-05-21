<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <h1 style="margin-bottom: 20px; color: #0f3460;">🔍 Search Items</h1>

    <div class="search-bar">
        <form action="${pageContext.request.contextPath}/search" method="GET"
              style="display: flex; gap: 12px; flex-wrap: wrap; width: 100%; align-items: flex-end;">
            <div class="form-group" style="flex: 2; min-width: 200px; margin: 0;">
                <label>Keyword</label>
                <input type="text" name="keyword" value="${keyword}" placeholder="Search...">
            </div>
            <div class="form-group" style="flex: 1; min-width: 140px; margin: 0;">
                <label>Category</label>
                <select name="category">
                    <option value="">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.categoryName}"
                            ${selectedCategory == cat.categoryName ? 'selected' : ''}>${cat.categoryName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group" style="flex: 1; min-width: 120px; margin: 0;">
                <label>Type</label>
                <select name="type">
                    <option value="">All</option>
                    <option value="LOST" ${selectedType == 'LOST' ? 'selected' : ''}>Lost</option>
                    <option value="FOUND" ${selectedType == 'FOUND' ? 'selected' : ''}>Found</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Search</button>
        </form>
    </div>

    <div class="items-grid">
        <c:choose>
            <c:when test="${empty items}">
                <div class="empty-state" style="width: 100%;">
                    <h3>No items found</h3>
                    <p>Try different search terms or filters.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="item" items="${items}">
                    <a href="${pageContext.request.contextPath}/item?action=detail&id=${item.itemId}" class="item-card">
                        <img src="${pageContext.request.contextPath}/${not empty item.imagePath ? item.imagePath : 'resources/images/default.png'}"
     alt="${item.title}"
     style="width:100%;height:200px;object-fit:cover;"
     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/resources/images/default.png'">
                        <div class="item-card-body">
                            <span class="badge ${item.itemType == 'LOST' ? 'badge-lost' : 'badge-found'}">${item.itemType}</span>
                            <h3>${item.title}</h3>
                            <p>📁 ${item.categoryName}</p>
                            <p>📍 ${item.location}</p>
                        </div>
                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>