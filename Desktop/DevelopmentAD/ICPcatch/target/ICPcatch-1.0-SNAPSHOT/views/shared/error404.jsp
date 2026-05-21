<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>404 – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <div class="card" style="text-align:center;padding:60px;max-width:500px;margin:60px auto">
        <div style="font-size:5rem">🔍</div>
        <h1 style="color:#0f3460;font-size:3rem;margin:16px 0">404</h1>
        <h2 style="color:#666;margin-bottom:16px">Page Not Found</h2>
        <p style="color:#888;margin-bottom:24px">
            Looks like this item went missing too!
        </p>
        <a href="${pageContext.request.contextPath}/item" class="btn btn-primary">
            Go to Browse Items
        </a>
    </div>
</div>
</body>
</html>