<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 新增會員</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    
    <style>
        body { font-family: 'Noto Sans TC', sans-serif; background-color: #f0f2f5; margin: 0; padding: 40px 20px; }
        .form-container { max-width: 600px; margin: auto; background: #ffffff; padding: 40px; border-radius: 24px; box-shadow: 0 15px 35px rgba(0,0,0,0.05); }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 500; color: #64748b; font-size: 14px; }
        input, select { width: 100%; padding: 12px 15px; border-radius: 12px; border: 1px solid #e2e8f0; outline: none; box-sizing: border-box; transition: 0.3s; font-size: 15px; }
        input:focus, select:focus { border-color: #4361ee; box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1); }

        /* Radio 按鈕樣式 */
        .radio-group { display: flex; gap: 25px; padding: 10px 0; }
        .radio-label { display: flex; align-items: center; gap: 8px; cursor: pointer; color: #2b2d42; }
        .radio-input { width: auto !important; margin: 0; }

      /* 按鈕群組  */
.btn-group { display: flex; gap: 15px; margin-top: 30px; }
.btn-save { flex: 2; background: #2ec4b6; color: white; border: none; padding: 16px; border-radius: 12px; font-size: 20px; font-weight: 700; letter-spacing: 2px; cursor: pointer; transition: 0.3s; box-shadow: 0 4px 10px rgba(46, 196, 182, 0.2); }
.btn-save:hover { background: #27ad9f; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(46, 196, 182, 0.3); }
.btn-cancel { flex: 1; background: #f1f5f9; color: #64748b; text-decoration: none; display: flex; align-items: center; justify-content: center; padding: 16px; border-radius: 12px; font-size: 19px; font-weight: 700; transition: 0.3s; }
.btn-cancel:hover { background: #e2e8f0; color: #475569; }

        /* 強制讓 Flatpickr 的年份和月份選單看起來更像下拉選單 */
        .flatpickr-calendar .flatpickr-month { height: 40px; }
        .flatpickr-current-month .numInputWrapper { width: 7ch; }
    </style>
</head>
<body>

<div class="form-container">
    <h2 style="color: #1a237e; margin-bottom: 30px; display: flex; align-items: center; gap: 10px;">
        🏸 <span>新增會員資料</span>
    </h2>
    
    <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="post">
        <input type="hidden" name="action" value="add">
        
        <div class="form-group">
            <label>會員帳號 Username</label>
            <input type="text" name="username" required placeholder="請輸入帳號">
        </div>

        <div class="form-group">
            <label>初始密碼 Password</label>
            <input type="password" name="password" required placeholder="請輸入預設密碼">
        </div>

        <div class="form-group">
            <label>姓名 Name</label>
            <input type="text" name="fullName" required placeholder="例如：王小明">
        </div>

        <div style="display: flex; gap: 20px;">
            <div class="form-group" style="flex: 1;">
                <label>性別 Gender</label>
                <div class="radio-group">
                    <label class="radio-label"><input type="radio" name="gender" value="男" checked class="radio-input"> 男</label>
                    <label class="radio-label"><input type="radio" name="gender" value="女" class="radio-input"> 女</label>
                </div>
            </div>
            <div class="form-group" style="flex: 1;">
                <label>生日 Birthday</label>
                <input type="text" name="birthday" id="birthdayPicker" placeholder="請選擇日期..." 
                       style="background-color: #fff; cursor: pointer;" readonly>
            </div>
        </div>

        <div class="form-group">
            <label>電話 Phone</label>
            <input type="tel" id="phoneInput" name="phone" placeholder="09xx-xxx-xxx" maxlength="12" required>
        </div>

        <div class="form-group">
            <label>電子信箱 Email</label>
            <input type="email" name="email" placeholder="example@mail.com">
        </div>

        <div class="form-group">
            <label>會員等級</label>
            <select name="membershipLevel">
                <option value="Regular">一般會員</option>
                <option value="VIP">VIP 會員</option>
            </select>
        </div>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard" class="btn-cancel">取消</a>
            <button type="submit" class="btn-save">新增會員</button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/zh-tw.js"></script>

<script>
    // 🔴 初始化 Flatpickr 專業月曆
    flatpickr("#birthdayPicker", {
        locale: "zh_tw",       // 繁體中文
        dateFormat: "Y-m-d",  // 資料庫標準格式
        maxDate: "today",     // 不能選未來
        // 核心設定：開啟下拉選單挑選模式
        monthSelectorType: "dropdown", 
        // 設定年份範圍：1930 到今年
        showMonths: 1,
        static: false,
        onReady: function(selectedDates, dateStr, instance) {
            // 強制設定年份輸入框為 1930-今年
            const yearInput = instance.currentYearElement;
            yearInput.setAttribute("min", "1930");
        }
    });

    // 手機號碼自動帶入橫線邏輯
    document.getElementById('phoneInput').addEventListener('input', function (e) {
        let value = e.target.value.replace(/\D/g, ''); 
        let formattedValue = '';
        if (value.length > 0) {
            formattedValue = value.substring(0, 4);
            if (value.length > 4) formattedValue += '-' + value.substring(4, 7);
            if (value.length > 7) formattedValue += '-' + value.substring(7, 10);
        }
        e.target.value = formattedValue;
    });
</script>

</body>
</html>