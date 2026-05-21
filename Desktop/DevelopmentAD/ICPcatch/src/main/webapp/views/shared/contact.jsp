<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <div style="display:flex;gap:24px;flex-wrap:wrap;max-width:900px;margin:0 auto">

        <!-- Contact Form -->
        <div class="card" style="flex:2;min-width:300px">
            <h2 style="color:#0f3460;margin-bottom:20px">📬 Contact Us</h2>

            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/contact" method="POST">
                <div class="form-group">
                    <label>Your Name *</label>
                    <input type="text" name="name" placeholder="Ram Bahadur" required>
                </div>
                <div class="form-group">
                    <label>Email Address *</label>
                    <input type="email" name="email" 
                           placeholder="ram@icp.edu.np" required>
                </div>
                <div class="form-group">
                    <label>Subject</label>
                    <input type="text" name="subject" 
                           placeholder="e.g. Item not found in system">
                </div>
                <div class="form-group">
                    <label>Message *</label>
                    <textarea name="message" rows="5" required
                        placeholder="Describe your inquiry..."></textarea>
                </div>
                <button type="submit" class="btn btn-primary">📤 Send Message</button>
            </form>
        </div>

        <!-- Contact Info -->
        <div style="flex:1;min-width:250px">
            <div class="card">
                <h3 style="color:#0f3460;margin-bottom:16px">📍 Find Us</h3>
                <p style="line-height:2;color:#555">
                    <strong>🏫 Informatics College Pokhara</strong><br>
                    Pokhara, Gandaki Province<br>
                    Nepal<br><br>
                    <strong>📧 Email:</strong><br>
                    admin@icp.edu.np<br><br>
                    <strong>📞 Phone:</strong><br>
                    +977-61-XXXXXX<br><br>
                    <strong>🕒 Office Hours:</strong><br>
                    Sun–Fri: 9:00 AM – 5:00 PM
                </p>
            </div>
            <div class="card" style="margin-top:16px">
                <h3 style="color:#0f3460;margin-bottom:12px">🔍 Quick Links</h3>
                <div style="display:flex;flex-direction:column;gap:8px">
                    <a href="${pageContext.request.contextPath}/item" 
                       class="btn btn-primary">Browse Items</a>
                    <a href="${pageContext.request.contextPath}/search" 
                       class="btn btn-secondary">Search Items</a>
                    <a href="${pageContext.request.contextPath}/views/shared/about.jsp" 
                       class="btn btn-secondary">About ICPCatch</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>