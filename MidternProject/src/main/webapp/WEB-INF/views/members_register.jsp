<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球館 | 會員註冊</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

<style>
    :root {
        --primary-blue: #5c67f2; 
        --border-color: #e5eaf2;
        --label-color: #4b5563;
        --placeholder-color: #cbd5e0;
        --error-red: #ef4444;
        --bg-color: #f8fafc;
    }

    body { 
        font-family: 'Noto Sans TC', sans-serif; 
        background-color: var(--bg-color); 
        display: flex; justify-content: center; align-items: center; 
        min-height: 100vh; margin: 0; padding: 40px 0;
    }

    .reg-container { 
        background: white; padding: 45px 40px; border-radius: 20px; 
        width: 100%; max-width: 400px; 
        box-shadow: 0 15px 35px rgba(0,0,0,0.05); 
        border: 1px solid #f1f5f9;
    }

    h2 { color: #0f172a; text-align: center; margin-bottom: 30px; font-size: 24px; font-weight: 700; line-height: 1.2; }
    h2 span { display: block; font-size: 12px; color: #94a3b8; font-weight: 500; text-transform: uppercase; margin-top: 6px; letter-spacing: 1px; }

    .form-group { margin-bottom: 20px; }
    
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

    input[type="text"], input[type="password"], input[type="email"], #birthdayPicker { 
        width: 100%; padding: 12px 16px; 
        border: 1.5px solid var(--border-color); 
        border-radius: 12px; 
        box-sizing: border-box; font-size: 15px; 
        transition: all 0.2s ease; 
        background-color: white;
        color: #334155;
    }

    input:focus, #birthdayPicker:focus {
        outline: none; 
        border-color: var(--primary-blue);
        box-shadow: 0 0 0 4px rgba(92, 103, 242, 0.08);
    }

    input::placeholder { color: var(--placeholder-color); font-size: 14px; }

    .radio-group { display: flex; gap: 30px; padding: 5px 2px; }
    .radio-label { display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: 500; color: #4b5563; font-size: 15px; }
    .radio-input { width: 18px !important; height: 18px !important; cursor: pointer; accent-color: var(--primary-blue); }

    button { 
        width: 100%; padding: 14px; 
        background: var(--primary-blue);
        color: white; border: none; border-radius: 12px; 
        font-size: 16px; font-weight: 700; cursor: pointer; 
        transition: 0.3s; margin-top: 15px;
        letter-spacing: 0.5px;
    }
    button:hover { 
        background: #4752e8;
        transform: translateY(-1px); 
        box-shadow: 0 5px 15px rgba(92, 103, 242, 0.2); 
    }

    .msg-error { 
        background-color: #fef2f2; color: var(--error-red); 
        border: 1px solid #fee2e2; padding: 10px; border-radius: 10px; 
        text-align: center; margin-bottom: 25px; font-size: 13px; font-weight: 500;
    }

    .footer-link { 
        text-align: center; 
        margin-top: 30px; 
        font-size: 14px; 
        color: #64748b;
    }
    .footer-link a { 
        color: var(--primary-blue); 
        text-decoration: none; 
        font-weight: 700; 
        margin-left: 5px;
    }
    .footer-link a:hover { text-decoration: underline; }
</style>
</head>
<body>
<div class="reg-container">
    <h2>🏸 會員註冊<br><span>Join Our Badminton Club</span></h2>
    
    <% if("2".equals(request.getParameter("error"))) { %>
        <div class="msg-error">❌ 帳號已存在，請更換帳號</div>
    <% } else if("1".equals(request.getParameter("error"))) { %>
        <div class="msg-error">❌ 註冊失敗，請檢查輸入內容</div>
    <% } %>

    <form action="MembersServlet" method="post">
        <input type="hidden" name="action" value="register">
        
        <div class="form-group">
            <label>帳號 <span>(Username)</span></label>
            <input type="text" name="username" required placeholder="設定登入帳號" autofocus autocomplete="off">
        </div>
        
        <div class="form-group">
            <label>密碼 <span>(Password)</span></label>
            <input type="password" name="password" required placeholder="設定登入密碼" autocomplete="new-password">
        </div>
        
        <div class="form-group">
            <label>姓名 <span>(Full Name)</span></label>
            <input type="text" name="fullName" placeholder="請輸入姓名" required autocomplete="off">
        </div>
        
        <div class="form-group">
            <label>性別 <span>(Gender)</span></label>
            <div class="radio-group">
                <label class="radio-label"><input type="radio" name="gender" value="男" class="radio-input" checked required> 男</label>
                <label class="radio-label"><input type="radio" name="gender" value="女" class="radio-input"> 女</label>
            </div>
        </div>
        
        <div class="form-group">
            <label>生日 <span>(Birthday)</span></label>
            <input type="text" name="birthday" id="birthdayPicker" placeholder="請選取日期" readonly>
        </div>
        
        <div class="form-group">
            <label>電話 <span>(Phone)</span></label>
            <input type="text" name="phone" id="phone" maxlength="12" placeholder="09xx-xxx-xxx" required autocomplete="off">
        </div>
        
        <div class="form-group">
            <label>電子信箱 <span>(Email)</span></label>
            <input type="email" name="email" placeholder="example@mail.com" autocomplete="off">
        </div>
        
        <button type="submit">立即註冊 Register Now</button>
    </form>
    
    <div class="footer-link">
        已有帳號？<a href="MembersServlet?action=showLogin">前往登入 Login</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/zh-tw.js"></script>

<script>
    flatpickr("#birthdayPicker", {
        locale: "zh_tw",
        dateFormat: "Y-m-d",
        maxDate: "today",
        monthSelectorType: "dropdown",
        onReady: function(selectedDates, dateStr, instance) {
            if (instance.currentYearElement) instance.currentYearElement.setAttribute("min", "1930");
        }
    });

    const phoneInput = document.getElementById('phone');
    if (phoneInput) {
        phoneInput.addEventListener('input', function (e) {
            let v = e.target.value.replace(/\D/g, ''); 
            let f = '';
            if (v.length > 0) {
                f = v.substring(0, 4); 
                if (v.length > 4) f += '-' + v.substring(4, 7); 
                if (v.length > 7) f += '-' + v.substring(7, 11);
            }
            e.target.value = f;
        });
    }
</script>
</body>
</html>