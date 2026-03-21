<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球館 | 系統管理中心</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    :root {
        --admin-dark: #1a1c23;
        --admin-blue: #4361ee;
        --error-red: #ef4444;
        --bg-dark: #111317;
    }
    
    body { 
        font-family: 'Noto Sans TC', sans-serif; 
        background-color: var(--bg-dark); 
        display: flex; justify-content: center; align-items: center; 
        min-height: 100vh; margin: 0; 
    }

    .admin-card { 
        background: white; padding: 50px; border-radius: 20px; 
        width: 100%; max-width: 400px; 
        box-shadow: 0 30px 60px rgba(0,0,0,0.4); 
    }

    h2 { color: var(--admin-dark); text-align: center; margin-bottom: 5px; font-size: 24px; font-weight: 700; }
    p { text-align: center; color: #8d99ae; font-size: 13px; margin-bottom: 35px; text-transform: uppercase; letter-spacing: 1px; }

    .form-group { margin-bottom: 25px; }
    label { display: block; margin-bottom: 8px; font-weight: 700; color: #4b5563; font-size: 14px; padding-left: 2px; }
    
    input { 
        width: 100%; padding: 14px; border: 2px solid #edf2f7; 
        border-radius: 12px; box-sizing: border-box; font-size: 15px; 
        background-color: #f9fafb; transition: all 0.3s ease;
    }

    input:focus {
        outline: none; 
        border-color: var(--admin-blue);
        background-color: white; 
        box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.1);
    }

    button { 
        width: 100%; padding: 16px; 
        background: var(--admin-dark);
        color: white; border: none; border-radius: 12px; 
        font-size: 16px; font-weight: 700; cursor: pointer; 
        transition: 0.3s; margin-top: 10px;
        letter-spacing: 1px;
    }

    button:hover { 
        background: var(--admin-blue); 
        transform: translateY(-2px);
        box-shadow: 0 8px 15px rgba(67, 97, 238, 0.2);
    }

    .msg-error {
        background-color: #fef2f2; 
        color: var(--error-red); 
        border: 1px solid #fecaca;
        padding: 14px; border-radius: 12px; 
        font-size: 14px; text-align: center; 
        margin-bottom: 25px;
        animation: shake 0.5s ease-in-out;
    }

    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-5px); }
        75% { transform: translateX(5px); }
    }

    .back-link {
        display: block; text-align: center; margin-top: 30px;
        color: #8d99ae; text-decoration: none; font-size: 13px;
        transition: 0.3s;
    }
    .back-link:hover { color: var(--admin-blue); text-decoration: underline; }
</style>
</head>
<body>

<div class="admin-card">
    <h2>系統管理後台</h2>
    <p>Admin Dashboard Login</p>
    
    <%-- 錯誤訊息處理 --%>
    <%-- 1 代表帳密錯誤 --%>
    <% if("1".equals(request.getParameter("error"))) { %>
        <div class="msg-error">❌ 管理員帳號或密碼錯誤</div>
    <% } %>
    
    <%-- no_auth 代表試圖闖入被 Filter 踢回來 --%>
    <% if("no_auth".equals(request.getParameter("error"))) { %>
        <div class="msg-error">🔒 權限不足，請先登入管理員</div>
    <% } %>

    <%-- 修正：確保 Action 正確指向 MembersAdminServlet --%>
    <form action="MembersAdminServlet" method="post">
        <%-- 修正：確保 action 參數為 login，對齊 Servlet 的 switch-case --%>
        <input type="hidden" name="action" value="login">
        
        <div class="form-group">
            <label>帳號 <span>(Username)</span></label>
            <input type="text" name="username" placeholder="請輸入管理員帳號" required autocomplete="username">
        </div>
        
        <div class="form-group">
            <label>密碼 <span>(Password)</span></label>
            <input type="password" name="password" placeholder="請輸入密碼" required autocomplete="current-password">
        </div>
        
        <button type="submit">進入管理系統 ENTER ADMIN</button>
    </form>
    
    <%-- 返回一般會員登入頁面 (同樣維持隱藏概念，讓管理員能隨時切回前台) --%>
    <a href="MembersServlet?action=showLogin" class="back-link">← 返回一般會員入口</a>
</div>

</body>
</html>