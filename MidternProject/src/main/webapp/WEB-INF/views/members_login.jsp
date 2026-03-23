<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 會員登入</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        /* 全域設定，延續後台模板風格 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', 'Noto Sans TC', Tahoma, Geneva, Verdana, sans-serif; }
        
        body { 
            background-color: #2c3e50; /* 使用與 Sidebar 一致的深色 */
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
            max-width: 400px; 
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

        label span {
            font-weight: normal;
            color: #95a5a6;
            font-size: 12px;
            margin-left: 5px;
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
            background: #3498db; /* 會員端使用明亮的藍色 */
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
            background: #2980b9; 
            transform: translateY(-1px);
            box-shadow: 0 5px 10px rgba(0,0,0,0.1);
        }

        /* 訊息提示方塊 */
        .msg-box {
            padding: 12px; 
            border-radius: 6px; 
            font-size: 14px; 
            text-align: center; 
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .msg-success {
            background-color: #f0fdf4;
            color: #10b981;
            border: 1px solid #dcfce7;
        }

        .msg-error {
            background-color: #fdf2f2; 
            color: #e74c3c; 
            border: 1px solid #fadbd8;
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
            color: #7f8c8d;
            font-size: 14px;
        }

        .footer-links a {
            color: #3498db;
            text-decoration: none;
            font-weight: bold;
            transition: 0.2s;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="login-header">
        <h2>🏸 會員登入</h2>
        <p>Badminton Member</p>
    </div>
    
    <%-- 註冊成功提示 --%>
    <% if("ok".equals(request.getParameter("status"))) { %>
        <div class="msg-box msg-success">
            <span>✔</span> 註冊成功！請直接登入
        </div>
    <% } %>
    
    <%-- 帳密錯誤提示 --%>
    <% if("1".equals(request.getParameter("error"))) { %>
        <div class="msg-box msg-error">
            <span>❌</span> 帳號或密碼錯誤
        </div>
    <% } %>
    
    <%-- 未登入強制跳轉提示 --%>
    <% if("need_login".equals(request.getParameter("error"))) { %>
        <div class="msg-box msg-error">
            <span>🔒</span> 請先登入會員以繼續操作
        </div>
    <% } %>

    <form action="MembersServlet" method="post">
        <input type="hidden" name="action" value="login">
        
        <div class="form-group">
            <label>帳號 <span>Username</span></label>
            <input type="text" name="username" class="form-control" 
                   placeholder="請輸入您的帳號" required autofocus autocomplete="off">
        </div>
        
        <div class="form-group">
            <label>密碼 <span>Password</span></label>
            <input type="password" name="password" class="form-control" 
                   placeholder="請輸入您的密碼" required autocomplete="current-password">
        </div>
        
        <button type="submit" class="btn-login">登入</button>
    </form>
    
    <div class="footer-links">
        還不是會員？<a href="MembersServlet?action=showRegister">點此註冊</a>
    </div>
</div>

</body>
</html>