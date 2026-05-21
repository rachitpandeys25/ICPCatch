<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>About – ICPCatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <div class="card" style="max-width:800px;margin:0 auto;text-align:center;padding:40px">
        <h1 style="color:#0f3460;font-size:2.5rem;margin-bottom:12px">🔍 ICPCatch</h1>
        <p style="color:#666;font-size:1.1rem;margin-bottom:30px">
            Lost & Found Platform for Informatics College Pokhara
        </p>
        <hr style="border:none;border-top:2px solid #f0f0f0;margin:24px 0">
        <div style="text-align:left">
            <h2 style="color:#0f3460;margin-bottom:16px">About ICPCatch</h2>
            <p style="line-height:1.8;color:#555;margin-bottom:16px">
                ICPCatch is a centralized digital platform designed to help students, 
                faculty, and staff of Informatics College Pokhara report lost items 
                and found items. The system bridges the gap between those who lose 
                belongings and those who find them.
            </p>
            <h3 style="color:#0f3460;margin:20px 0 12px">✨ Features</h3>
            <ul style="line-height:2;color:#555;padding-left:20px">
                <li>Report lost and found items with images</li>
                <li>Search and filter items by category, type, and date</li>
                <li>Claim items with proof of ownership</li>
                <li>Admin verification of claims</li>
                <li>Role-based access for students and admins</li>
                <li>Staff can submit found items through admin</li>
            </ul>
            <h3 style="color:#0f3460;margin:20px 0 12px">🏫 About ICP</h3>
            <p style="line-height:1.8;color:#555">
                Informatics College Pokhara is one of Nepal's leading IT colleges, 
                offering programs in BSc CSIT, BIM, BCA, and MCA. Located in the 
                beautiful city of Pokhara, ICP is committed to providing quality 
                education and a supportive campus environment.
            </p>
        </div>
    </div>
</div>
</body>
</html>