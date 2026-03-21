<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球館 | 會員註冊</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

<style>
    :root { --primary-green: #27ae60; --soft-gray: #f8f9fa; --dark-text: #2c3e50; --light-text: #7f8c8d; }
    body { font-family: 'Noto Sans TC', sans-serif; background-color: #f0f2f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 20px 0; }
    .reg-container { background: white; padding: 40px; border-radius: 24px; box-shadow: 0 15px 35px rgba(0,0,0,0.08); width: 100%; max-width: 420px; }
    h2 { text-align: center; color: var(--dark-text); margin-bottom: 30px; line-height: 1.4; font-size: 26px; }
    h2 span { display: block; font-size: 14px; color: var(--light-text); font-weight: normal; text-transform: uppercase; letter-spacing: 1px; margin-top: 5px; }
    .form-group { margin-bottom: 20px; }
    label { display: block; margin-bottom: 8px; font-weight: 700; color: #4a5568; font-size: 14px; padding-left: 4px; }
    label span { font-size: 12px; color: #a0aec0; font-weight: normal; margin-left: 5px; }
    
    /* 輸入框樣式 */
    input[type="text"], input[type="password"], input[type="email"] { 
        width: 100%; padding: 13px; box-sizing: border-box; border: 1.5px solid #edf2f4; border-radius: 12px; transition: all 0.3s; font-size: 15px; background-color: var(--soft-gray); 
    }
    /* 特別針對生日欄位優化 */
    #birthdayPicker {
        width: 100%; padding: 13px; box-sizing: border-box; border: 1.5px solid #edf2f4; border-radius: 12px; transition: all 0.3s; font-size: 15px; background-color: var(--soft-gray);
        cursor: pointer;
    }

    input:focus, #birthdayPicker:focus { border-color: var(--primary-green); background-color: white; box-shadow: 0 0 0 4px rgba(39, 174, 96, 0.1); outline: none; }
    
    .radio-group { display: flex; gap: 30px; padding: 10px 5px; }
    .radio-label { display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: normal; color: var(--dark-text); font-size: 15px; }
    .radio-input { width: auto !important; margin: 0; cursor: pointer; }

    button { width: 100%; padding: 16px; background: linear-gradient(135deg, #27ae60, #2ecc71); color: white; border: none; border-radius: 12px; cursor: pointer; font-size: 16px; font-weight: bold; transition: 0.3s; margin-top: 15px; box-shadow: 0 8px 15px rgba(39, 174, 96, 0.2); }
    button:hover { transform: translateY(-2px); box-shadow: 0 12px 20px rgba(39, 174, 96, 0.3); }
    
    .footer-link { text-align: center; margin-top: 25px; font-size: 14px; color: var(--light-text); }
    .footer-link a { color: var(--primary-green); text-decoration: none; font-weight: bold; }
</style>
</head>
<body>
<div class="reg-container">
    <h2>🏸 會員註冊<br><span>Join Our Badminton Club</span></h2>
    <form action="MembersServlet" method="post">
        <input type="hidden" name="action" value="register">
        
        <div class="form-group">
            <label>帳號 <span>Username</span></label>
            <input type="text" name="username" required placeholder="設定登入帳號">
        </div>
        
        <div class="form-group">
            <label>密碼 <span>Password</span></label>
            <input type="password" name="password" required placeholder="設定登入密碼">
        </div>
        
        <div class="form-group">
            <label>姓名 <span>Full Name</span></label>
            <input type="text" name="fullName" placeholder="請輸入真實姓名" required>
        </div>
        
        <div class="form-group">
            <label>性別 <span>Gender</span></label>
            <div class="radio-group">
                <label class="radio-label"><input type="radio" name="gender" value="男" class="radio-input" checked required> 男</label>
                <label class="radio-label"><input type="radio" name="gender" value="女" class="radio-input"> 女</label>
            </div>
        </div>
        
        <div class="form-group">
            <label>生日 <span>Birthday</span></label>
            <input type="text" name="birthday" id="birthdayPicker" placeholder="請選擇生日日期" readonly>
        </div>
        
        <div class="form-group">
            <label>電話 <span>Phone Number</span></label>
            <input type="text" name="phone" id="phone" maxlength="12" placeholder="09xx-xxx-xxx" required>
        </div>
        
        <div class="form-group">
            <label>電子信箱 <span>Email Address</span></label>
            <input type="email" name="email" placeholder="example@mail.com">
        </div>
        
        <button type="submit">立即註冊 Register Now</button>
    </form>
    <div class="footer-link">已有帳號？ <a href="MembersServlet?action=showLogin">前往登入 Login</a></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/zh-tw.js"></script>

<script>
    // 1. 初始化 Flatpickr 專業月曆功能
    flatpickr("#birthdayPicker", {
        locale: "zh_tw",      // 繁體中文
        dateFormat: "Y-m-d", // 存入資料庫格式
        maxDate: "today",    // 不能選未來
        monthSelectorType: "dropdown", // 月份下拉選單
        // 設定年份範圍從 1930 開始到今年
        onReady: function(selectedDates, dateStr, instance) {
            const yearInput = instance.currentYearElement;
            if (yearInput) {
                yearInput.setAttribute("min", "1930");
            }
        }
    });

    // 2. 手機號碼自動帶入橫線邏輯 (09xx-xxx-xxx)
    const phoneInput = document.getElementById('phone');
    if (phoneInput) {
        phoneInput.addEventListener('input', function (e) {
            let v = e.target.value.replace(/\D/g, ''); // 移除所有非數字
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