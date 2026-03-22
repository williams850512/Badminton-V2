<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球館 | 會員登入</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-blue: #5c67f2; 
        --border-color: #e5eaf2;
        --label-color: #4b5563;
        --placeholder-color: #cbd5e0;
        --error-red: #ef4444;
        --success-green: #10b981;
        --bg-color: #f8fafc;
    }

    body { 
        font-family: 'Noto Sans TC', sans-serif; 
        background-color: var(--bg-color); 
        display: flex; justify-content: center; align-items: center; 
        min-height: 100vh; margin: 0; 
        color: #1e293b;
    }

    .login-card { 
        background: white; padding: 45px 40px; border-radius: 20px; 
        width: 100%; max-width: 380px; /* 寬度稍微縮小更精緻 */
        box-shadow: 0 15px 35px rgba(0,0,0,0.05); 
        border: 1px solid #f1f5f9;
    }

    h2 { color: #0f172a; text-align: center; margin-bottom: 30px; font-size: 24px; font-weight: 700; letter-spacing: 1px; }
    
    .form-group { margin-bottom: 22px; }
    
    /* ✨ 標籤字體降級：由 18px 改為 14px，更具質感 */
    .form-group label {
        display: block;
        margin-bottom: 8px;
        color: var(--label-color);
        font-weight: 700;
        font-size: 14px; 
        padding-left: 2px;
    }

    .form-group label span {
        font-weight: 400;
        color: #94a3b8;
        font-size: 12px;
        margin-left: 4px;
    }

  
    input { 
        width: 100%; padding: 12px 16px; 
        border: 1.5px solid var(--border-color); 
        border-radius: 12px; 
        box-sizing: border-box; font-size: 15px; 
        transition: all 0.2s ease; 
        background-color: #ffffff;
        color: #334155;
    }
    
    input:focus {
        outline: none; 
        border-color: var(--primary-blue);
        background-color: #fff;
        box-shadow: 0 0 0 4px rgba(92, 103, 242, 0.08);
    }
    
    input::placeholder {
        color: var(--placeholder-color);
        font-size: 14px;
    }


    button { 
        width: 100%; padding: 14px; 
        background: var(--primary-blue);
        color: white; border: none; border-radius: 12px; 
        font-size: 16px; font-weight: 700; cursor: pointer; 
        transition: 0.3s; margin-top: 10px;
        letter-spacing: 0.5px;
    }
    
    button:hover { background: #4752e8; transform: translateY(-1px); box-shadow: 0 5px 15px rgba(92, 103, 242, 0.2); }
    
    /* 訊息顯示 */
    .msg-box { padding: 10px; border-radius: 10px; font-size: 13px; text-align: center; margin-bottom: 20px; font-weight: 500; }
    .msg-success { background-color: #f0fdf4; color: var(--success-green); border: 1px solid #dcfce7; }
    .msg-error { background-color: #fef2f2; color: var(--error-red); border: 1px solid #fee2e2; }
    
    .footer-links { text-align: center; margin-top: 25px; font-size: 14px; color: #64748b; }
    .footer-links a { color: var(--primary-blue); text-decoration: none; font-weight: 700; margin-left: 5px; }
    .footer-links a:hover { text-decoration: underline; }
</style>
</head>
<body>
<div class="login-card">
    <h2>🏸 會員登入</h2>
    
    <% if("ok".equals(request.getParameter("status"))) { %>
        <div class="msg-box msg-success">註冊成功！請直接登入</div>
    <% } %>
    
    <% if("1".equals(request.getParameter("error"))) { %>
        <div class="msg-box msg-error">帳號或密碼錯誤</div>
    <% } %>
    
    <% if("need_login".equals(request.getParameter("error"))) { %>
        <div class="msg-box msg-error">🔒 請先登入會員</div>
    <% } %>
    
    <form action="MembersServlet" method="post">
        <input type="hidden" name="action" value="login">
        
        <div class="form-group">
            <label>帳號 <span>(Username)</span></label>
            <input type="text" name="username" placeholder="請輸入帳號" 
                   required autofocus autocomplete="off" spellcheck="false">
        </div>
        
        <div class="form-group">
            <label>密碼 <span>(Password)</span></label>
            <input type="password" name="password" placeholder="請輸入密碼" 
                   required autocomplete="new-password">
        </div>
        
        <button type="submit">立即登入</button>
    </form>
    
    <div class="footer-links">
        還不是會員？<a href="MembersServlet?action=showRegister">點此註冊</a>
    </div>
</div>
</body>
</html>