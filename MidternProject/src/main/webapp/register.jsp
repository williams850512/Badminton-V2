<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球館 - 會員註冊 | Member Registration</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-green: #27ae60;
        --soft-gray: #f8f9fa;
        --dark-text: #2c3e50;
        --light-text: #7f8c8d;
    }

    body { 
        font-family: 'Noto Sans TC', sans-serif; 
        background-color: #f0f2f5; 
        display: flex; 
        justify-content: center; 
        align-items: center;
        min-height: 100vh;
        margin: 20px 0;
    }

    .reg-container { 
        background: white; 
        padding: 40px; 
        border-radius: 24px; 
        box-shadow: 0 15px 35px rgba(0,0,0,0.08); 
        width: 100%;
        max-width: 420px; 
    }

    h2 { 
        text-align: center; 
        color: var(--dark-text); 
        margin-bottom: 30px;
        line-height: 1.4;
        font-size: 26px;
    }
    h2 span {
        display: block;
        font-size: 14px;
        color: var(--light-text);
        font-weight: normal;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-top: 5px;
    }

    .form-group { margin-bottom: 20px; }
    
    label { 
        display: block; 
        margin-bottom: 8px; 
        font-weight: 700; 
        color: #4a5568;
        font-size: 14px;
        padding-left: 4px;
    }
    
    label span {
        font-size: 12px;
        color: #a0aec0;
        font-weight: normal;
        margin-left: 5px;
    }

    input, select { 
        width: 100%; 
        padding: 13px; 
        box-sizing: border-box; 
        border: 1.5px solid #edf2f4; 
        border-radius: 12px; 
        transition: all 0.3s;
        font-size: 15px;
        background-color: var(--soft-gray);
    }

    input:focus, select:focus {
        border-color: var(--primary-green);
        background-color: white;
        box-shadow: 0 0 0 4px rgba(39, 174, 96, 0.1);
        outline: none;
    }

    button { 
        width: 100%; 
        padding: 16px; 
        background: linear-gradient(135deg, #27ae60, #2ecc71);
        color: white; 
        border: none; 
        border-radius: 12px; 
        cursor: pointer; 
        font-size: 16px; 
        font-weight: bold;
        transition: 0.3s;
        margin-top: 15px;
        box-shadow: 0 8px 15px rgba(39, 174, 96, 0.2);
    }
    button:hover { 
        transform: translateY(-2px);
        box-shadow: 0 12px 20px rgba(39, 174, 96, 0.3);
    }

    .footer-link {
        text-align: center;
        margin-top: 25px;
        font-size: 14px;
        color: var(--light-text);
    }
    .footer-link a {
        color: var(--primary-green);
        text-decoration: none;
        font-weight: bold;
    }
    .footer-link a:hover { text-decoration: underline; }
</style>
</head>
<body>

<div class="reg-container">
    <h2>🏸 會員註冊<br><span>Join Our Badminton Club</span></h2>
    
    <form action="MembersServlet" method="post">
        <input type="hidden" name="action" value="register">
        
        <div class="form-group">
            <label>帳號 <span>Username</span></label>
            <input type="text" name="username" placeholder="設定您的登入帳號" required>
        </div>
        
        <div class="form-group">
            <label>密碼 <span>Password</span></label>
            <input type="password" name="password" placeholder="請輸入密碼" required>
        </div>
        
        <div class="form-group">
            <label>姓名 <span>Full Name</span></label>
            <input type="text" name="name" placeholder="請輸入真實姓名" required>
        </div>

        <div class="form-group">
            <label>性別 <span>Gender</span></label>
            <select name="gender">
                <option value="">請選擇性別</option>
                <option value="男">男 (Male)</option>
                <option value="女">女 (Female)</option>
                <option value="其他">其他 (Other)</option>
            </select>
        </div>

        <div class="form-group">
            <label>生日 <span>Birthday</span></label>
            <input type="date" name="birthday">
        </div>
        
        <div class="form-group">
            <label>電話 <span>Phone Number</span></label>
            <input type="text" name="phone" id="phone" placeholder="0900-000-000" maxlength="12">
        </div>
        
        <div class="form-group">
            <label>電子信箱 <span>Email Address</span></label>
            <input type="email" name="email" placeholder="example@mail.com">
        </div>
        
        <button type="submit">立即註冊 Register Now</button>
    </form>
    
    <div class="footer-link">
        已有帳號？ <a href="login.jsp">前往登入 Login</a>
    </div>
</div>

<script>
    // 自動格式化電話：09xx-xxx-xxx
    const phoneInput = document.getElementById('phone');
    phoneInput.addEventListener('input', function (e) {
        let value = e.target.value.replace(/\D/g, '');
        let formattedValue = '';
        if (value.length > 0) formattedValue += value.substring(0, 4); 
        if (value.length > 4) formattedValue += '-' + value.substring(4, 7); 
        if (value.length > 7) formattedValue += '-' + value.substring(7, 10);
        e.target.value = formattedValue;
    });
</script>

</body>
</html>