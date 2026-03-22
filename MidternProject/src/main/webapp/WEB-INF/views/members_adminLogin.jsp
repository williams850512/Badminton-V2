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
    label span { font-size: 12px; color: #9ca3af; font-weight: 400; margin-left: 4px; }
    
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
    <p>Administrator Login</p>
    
    <%-- 錯誤訊息處理 --%>
    <% if("1".equals(request.getParameter("error"))) { %>
        <div class="msg-error">❌ 管理員帳號或密碼錯誤</div>
    <% } %>
    
    <% if("no_auth".equals(request.getParameter("error"))) { %>
        <div class="msg-error">🔒 權限不足，請先登入管理員</div>
    <% } %>

    <form action="MembersAdminServlet" method="post">
        <input type="hidden" name="action" value="login">
        
        <div class="form-group">
            <label>帳號 <span>(Username)</span></label>
            <%-- ✅ 修正：加入 autocomplete="off" 與 spellcheck="false" 關閉自動完成 --%>
            <input type="text" name="username" placeholder="請輸入管理員帳號" 
                   required autocomplete="off" spellcheck="false">
        </div>
        
        <div class="form-group">
            <label>密碼 <span>(Password)</span></label>
            <%-- ✅ 修正：密碼欄位通常建議也加上，防止提示彈出 --%>
            <input type="password" name="password" placeholder="請輸入密碼" 
                   required autocomplete="new-password">
        </div>
        
        <button type="submit">進入管理系統</button>
    </form>
    
    <a href="MembersServlet?action=showLogin" class="back-link">返回前台</a>
</div>

</body>
</html>