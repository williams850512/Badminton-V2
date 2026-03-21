<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球館 | 會員登入</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-blue: #5c67f2; /* 圖片中的深藍色調 */
        --border-color: #e5eaf2;
        --label-color: #4a5568;
        --placeholder-color: #a0aec0;
        --soft-gray: #f8f9fa;
        --error-red: #ef4444;
        --success-green: #10b981;
    }
    body { 
        font-family: 'Noto Sans TC', sans-serif; 
        background-color: #f0f2f5; 
        display: flex; justify-content: center; align-items: center; 
        min-height: 100vh; margin: 0; 
    }
    .login-card { 
        background: white; padding: 40px; border-radius: 24px; 
        width: 100%; max-width: 420px; 
        box-shadow: 0 20px 40px rgba(0,0,0,0.08); 
    }
    h2 { color: #2d3748; text-align: center; margin-bottom: 35px; font-size: 28px; font-weight: 700; }
    
    /* ✨ 新增標籤樣式：與圖片一致 */
    .form-group { margin-bottom: 25px; }
    .form-group label {
        display: block;
        margin-bottom: 12px;
        color: var(--label-color);
        font-weight: 700;
        font-size: 18px; /* 稍微放大，符合圖片視覺 */
    }
    .form-group label span {
        font-weight: 500;
        color: #718096;
        font-size: 16px;
    }

    /* ✨ 調整輸入框：模擬圖片中的粗圓角藍框 */
    input { 
        width: 100%; padding: 16px 20px; 
        border: 2px solid var(--border-color); 
        border-radius: 18px; /* 更圓潤的角 */
        box-sizing: border-box; font-size: 18px; 
        transition: all 0.3s ease; 
        background-color: white;
    }
    /* 圖片中被選取時的深藍色邊框效果 */
    input:focus {
        outline: none; 
        border-color: var(--primary-blue);
        box-shadow: 0 0 0 4px rgba(92, 103, 242, 0.1);
    }
    /* 佔位文字顏色調淡 */
    input::placeholder {
        color: var(--placeholder-color);
    }

    button { 
        width: 100%; padding: 18px; 
        background: linear-gradient(135deg, var(--primary-blue), #4752e8);
        color: white; border: none; border-radius: 18px; 
        font-size: 18px; font-weight: 700; cursor: pointer; 
        transition: 0.3s; margin-top: 15px;
    }
    button:hover { transform: translateY(-2px); box-shadow: 0 8px 15px rgba(92, 103, 242, 0.2); }
    
    .msg-box { padding: 12px; border-radius: 12px; font-size: 15px; text-align: center; margin-bottom: 20px; }
    .msg-success { background-color: #ecfdf5; color: var(--success-green); border: 1px solid #a7f3d0; }
    .msg-error { background-color: #fef2f2; color: var(--error-red); border: 1px solid #fecaca; }
    
    .footer-links { text-align: center; margin-top: 30px; font-size: 15px; color: #718096; }
    .footer-links a { color: var(--primary-blue); text-decoration: none; font-weight: 700; margin-left: 5px; }
</style>
</head>
<body>
<div class="login-card">
    <h2>🏸 會員登入</h2>
    
    <%-- 訊息顯示區域 --%>
    <% if("ok".equals(request.getParameter("status"))) { %>
        <div class="msg-box msg-success">🎉 註冊成功！請登入</div>
    <% } %>
    
    <% if("1".equals(request.getParameter("error"))) { %>
        <div class="msg-box msg-error">❌ 帳號或密碼錯誤</div>
    <% } %>
    
    <% if("need_login".equals(request.getParameter("error"))) { %>
        <div class="msg-box msg-error">🔒 請先登入會員</div>
    <% } %>
    
    <form action="MembersServlet" method="post">
        <input type="hidden" name="action" value="login">
        
        <div class="form-group">
            <label>帳號 <span>(Username)</span></label>
            <input type="text" name="username" placeholder="請輸入帳號" required autofocus>
        </div>
        
        <div class="form-group">
            <label>密碼 <span>(Password)</span></label>
            <input type="password" name="password" placeholder="請輸入密碼" required>
        </div>
        
        <button type="submit">立即登入</button>
    </form>
    
    <div class="footer-links">
        尚無帳號？<a href="MembersServlet?action=showRegister">前往註冊</a>
    </div>
</div>
</body>
</html>