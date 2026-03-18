<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球館 | 會員登入</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-indigo: #4361ee;
        --soft-gray: #f8f9fa;
        --dark-text: #2b2d42;
        --error-red: #ef4444;
        --success-green: #10b981;
    }
    body { 
        font-family: 'Noto Sans TC', sans-serif; 
        background-color: #f0f2f5; 
        display: flex; 
        justify-content: center; 
        align-items: center; 
        min-height: 100vh; 
        margin: 0; 
    }
    .login-card { 
        background: white; 
        padding: 40px; 
        border-radius: 24px; 
        width: 100%;
        max-width: 380px; 
        box-shadow: 0 20px 40px rgba(0,0,0,0.08); 
    }
    h2 { 
        color: var(--dark-text); 
        text-align: center; 
        margin-bottom: 30px; 
        font-size: 26px;
        letter-spacing: 1px;
    }
    .form-group { margin-bottom: 20px; }
    input { 
        width: 100%; 
        padding: 14px; 
        border: 1.5px solid #edf2f4; 
        border-radius: 12px; 
        box-sizing: border-box; 
        font-size: 15px; 
        transition: 0.3s;
        background-color: var(--soft-gray);
    }
    input:focus {
        outline: none;
        border-color: var(--primary-indigo);
        background-color: white;
        box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.1);
    }
    button { 
        width: 100%; 
        padding: 16px; 
        background: linear-gradient(135deg, #4361ee, #3f37c9);
        color: white; 
        border: none; 
        border-radius: 12px; 
        font-size: 16px; 
        font-weight: 700; 
        cursor: pointer; 
        transition: 0.3s; 
        margin-top: 10px;
        box-shadow: 0 8px 15px rgba(67, 97, 238, 0.2);
    }
    button:hover { 
        transform: translateY(-2px); 
        box-shadow: 0 12px 20px rgba(67, 97, 238, 0.3);
    }
    .msg-box {
        padding: 12px;
        border-radius: 10px;
        font-size: 14px;
        text-align: center;
        margin-bottom: 20px;
        font-weight: 500;
    }
    .msg-success { background-color: #ecfdf5; color: var(--success-green); border: 1px solid #a7f3d0; }
    .msg-error { background-color: #fef2f2; color: var(--error-red); border: 1px solid #fecaca; }
    
    .footer-links {
        text-align: center;
        margin-top: 25px;
        font-size: 14px;
        color: #8d99ae;
    }
    .footer-links a {
        color: var(--primary-indigo);
        text-decoration: none;
        font-weight: 600;
    }
    .footer-links a:hover { text-decoration: underline; }
</style>
</head>
<body>

<div class="login-card">
    <h2>🏸 會員登入</h2>
    
    <%-- 註冊成功提示 --%>
    <% if("ok".equals(request.getParameter("status"))) { %>
        <div class="msg-box msg-success">🎉 註冊成功！請登入</div>
    <% } %>

    <%-- 帳密錯誤提示 --%>
    <% if("1".equals(request.getParameter("error"))) { %>
        <div class="msg-box msg-error">❌ 帳號或密碼錯誤</div>
    <% } %>

    <%-- 權限不足提示 (由 MembersAuthFilter 傳回) --%>
    <% if("no_permission".equals(request.getParameter("error"))) { %>
        <div class="msg-box msg-error">⚠️ 權限不足，請以管理員登入</div>
    <% } %>

    <form action="MembersServlet" method="post">
        <input type="hidden" name="action" value="login">
        <div class="form-group">
            <input type="text" name="username" placeholder="請輸入帳號" required>
        </div>
        <div class="form-group">
            <input type="password" name="password" placeholder="請輸入密碼" required>
        </div>
        <button type="submit">立即登入</button>
    </form>

    <div class="footer-links">
        還沒有帳號？ <a href="register.jsp">點此去註冊</a>
    </div>
</div>

</body>
</html>