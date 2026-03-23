<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 管理員登入</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        /* 全域設定，延續模板風格 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', 'Noto Sans TC', Tahoma, Geneva, Verdana, sans-serif; }
        
        body { 
            background-color: #2c3e50; /* 使用 Sidebar 的深色背景 */
            display: flex; 
            justify-content: center; 
            align-items: center; 
            min-height: 100vh; 
            margin: 0; 
        }

        /* 登入卡片 */
        .login-card { 
            background: #fff; 
            padding: 45px; 
            border-radius: 12px; 
            width: 100%; 
            max-width: 420px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.3); 
        }

        .login-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .login-header h2 { 
            color: #2c3e50; 
            font-size: 26px; 
            font-weight: bold;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .login-header p {
            color: #7f8c8d;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        /* 表單設計 */
        .form-group { margin-bottom: 25px; }
        
        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: bold; 
            color: #34495e; 
            font-size: 14px; 
        }
        
        .form-control { 
            width: 100%; 
            padding: 12px 15px; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            font-size: 15px; 
            outline: none; 
            transition: all 0.3s;
            background-color: #f9f9f9;
        }

        .form-control:focus {
            border-color: #3498db;
            background-color: #fff;
            box-shadow: 0 0 8px rgba(52, 152, 219, 0.2);
        }

        /* 按鈕風格 */
        .btn-login { 
            width: 100%; 
            padding: 14px; 
            background: #2c3e50;
            color: white; 
            border: none; 
            border-radius: 6px; 
            font-size: 16px; 
            font-weight: bold; 
            cursor: pointer; 
            transition: 0.3s;
            letter-spacing: 1px;
        }

        .btn-login:hover { 
            background: #34495e; 
            transform: translateY(-1px);
            box-shadow: 0 5px 10px rgba(0,0,0,0.1);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        /* 錯誤訊息 */
        .error-box {
            background-color: #fdf2f2; 
            color: #e74c3c; 
            border: 1px solid #fadbd8;
            padding: 12px; 
            border-radius: 6px; 
            font-size: 14px; 
            text-align: center; 
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            animation: shake 0.4s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-6px); }
            75% { transform: translateX(6px); }
        }

        /* 下方連結 */
        .footer-links {
            margin-top: 30px;
            text-align: center;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }

        .back-link {
            color: #95a5a6;
            text-decoration: none;
            font-size: 13px;
            transition: 0.2s;
        }

        .back-link:hover {
            color: #3498db;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="login-header">
        <h2>羽球館管理系統</h2>
        <p>Admin Login</p>
    </div>
    
    <%-- 錯誤訊息邏輯 --%>
    <% if("1".equals(request.getParameter("error"))) { %>
        <div class="error-box">
            <span>❌</span> 帳號或密碼錯誤，請重新輸入
        </div>
    <% } %>
    
    <% if("no_auth".equals(request.getParameter("error"))) { %>
        <div class="error-box">
            <span>🔒</span> 權限不足，請先登入管理員帳號
        </div>
    <% } %>

    <form action="MembersAdminServlet" method="post">
        <input type="hidden" name="action" value="login">
        
        <div class="form-group">
            <label>帳號</label>
            <input type="text" name="username" class="form-control" 
                   placeholder="請輸入帳號" required autocomplete="off" spellcheck="false">
        </div>
        
        <div class="form-group">
            <label>密碼</label>
            <input type="password" name="password" class="form-control" 
                   placeholder="請輸入密碼" required autocomplete="current-password">
        </div>
        
        <button type="submit" class="btn-login">登入</button>
    </form>
    
    <div class="footer-links">
        <a href="MembersServlet?action=showLogin" class="back-link">← 返回前台會員登入</a>
    </div>
</div>

</body>
</html>