<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>
<div class="auth-container">
    <div class="auth-box">
        <div class="auth-header">
            <h1>🔍 ICPCatch</h1>
            <p>Lost & Found – Informatics College Pokhara</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">${error}</div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">${success}</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/auth" method="POST">
            <input type="hidden" name="action" value="login">

            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="your@email.com" required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn-primary">Login</button>
        </form>

        <p class="auth-link">
            Don't have an account? 
            <a href="${pageContext.request.contextPath}/views/auth/register.jsp">Register here</a>
        </p>
    </div>
</div>
</body>
</html>