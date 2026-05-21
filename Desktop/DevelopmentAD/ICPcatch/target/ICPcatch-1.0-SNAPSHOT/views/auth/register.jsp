<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>
<div class="auth-container">
    <div class="auth-box wide">
        <div class="auth-header">
            <h1>🔍 ICPCatch</h1>
            <p>Create your account</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">${error}</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/auth" method="POST">
            <input type="hidden" name="action" value="register">

            <div class="form-row">
                <div class="form-group">
                    <label>Full Name *</label>
                    <input type="text" name="fullName" placeholder="Ram Bahadur" required>
                </div>
                <div class="form-group">
                    <label>Student ID *</label>
                    <input type="text" name="studentId" placeholder="ICP-2024-001" required>
                </div>
            </div>

            <div class="form-group">
                <label>Email Address *</label>
                <input type="email" name="email" placeholder="ram@icp.edu.np" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Program</label>
                    <select name="program">
                        <option value="">Select Program</option>
                        <option value="BSc CSIT">BSc CSIT</option>
                        <option value="BIM">BIM</option>
                        <option value="BCA">BCA</option>
                        <option value="MCA">MCA</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Year</label>
                    <select name="year">
                        <option value="1">1st Year</option>
                        <option value="2">2nd Year</option>
                        <option value="3">3rd Year</option>
                        <option value="4">4th Year</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="phone" placeholder="98XXXXXXXX">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Password *</label>
                    <input type="password" name="password" placeholder="Min 6 characters" required>
                </div>
                <div class="form-group">
                    <label>Confirm Password *</label>
                    <input type="password" name="confirmPassword" placeholder="Repeat password" required>
                </div>
            </div>

            <button type="submit" class="btn-primary">Create Account</button>
        </form>

        <p class="auth-link">
            Already have an account? 
            <a href="${pageContext.request.contextPath}/views/auth/login.jsp">Login here</a>
        </p>
    </div>
</div>
</body>
</html>