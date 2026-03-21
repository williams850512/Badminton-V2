<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球館 | 個人中心</title>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/zh-tw.js"></script>

<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-color: #27ae60;
        --text-dark: #2c3e50;
        --text-light: #7f8c8d;
        --bg-color: #f0f2f5;
        --border-color: #e2e8f0;
    }

    body {
        font-family: 'Noto Sans TC', sans-serif;
        background-color: var(--bg-color);
        margin: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        padding: 40px 20px;
    }

    .profile-card {
        background: white;
        width: 100%;
        max-width: 650px;
        border-radius: 28px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        overflow: hidden;
    }

    .profile-header {
        background: var(--primary-color);
        color: white;
        padding: 40px 30px;
        text-align: center;
    }
    
    .profile-header h2 { margin: 0; font-size: 26px; font-weight: 700; letter-spacing: 1px; }
    .profile-header p { margin: 10px 0 0; opacity: 0.9; font-size: 14px; }

    .profile-body { padding: 35px; }

    .info-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
        margin-bottom: 35px;
        background: #f8f9fa;
        padding: 25px;
        border-radius: 20px;
        border: 1px solid #edf2f7;
    }

    .info-item label {
        display: block; font-size: 11px; color: var(--text-light);
        margin-bottom: 4px; text-transform: uppercase; font-weight: 700;
    }

    .info-item .value { font-weight: 700; color: var(--text-dark); font-size: 15px; }

    .role-badge {
        display: inline-block; padding: 4px 12px; border-radius: 20px;
        font-size: 12px; font-weight: bold;
    }
    .badge-user { background: #e1f5fe; color: #0288d1; }
    .badge-vip { background: #fef3c7; color: #d97706; }

    .update-section h3 {
        font-size: 18px; border-left: 5px solid var(--primary-color);
        padding-left: 12px; margin-bottom: 25px; color: var(--text-dark); font-weight: 700;
    }
    
    .form-group { margin-bottom: 22px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: 700; font-size: 14px; color: #4a5568; }
    
    input[type="text"], 
    input[type="email"] {
        width: 100%; padding: 13px 15px; border: 1.5px solid var(--border-color);
        border-radius: 12px; box-sizing: border-box; font-size: 15px;
        font-family: inherit; transition: all 0.3s ease; background-color: #fff;
    }

    /* 專門給 Flatpickr 使用的樣式 */
    .datepicker-input {
        width: 100%; padding: 13px 15px; border: 1.5px solid var(--border-color);
        border-radius: 12px; box-sizing: border-box; font-size: 15px;
        font-family: inherit; background-color: #fff; cursor: pointer;
    }

    input:focus, .datepicker-input:focus {
        border-color: var(--primary-color); outline: none;
        box-shadow: 0 0 0 4px rgba(39, 174, 96, 0.1); background-color: #fafdfb;
    }
    
    .radio-group { display: flex; gap: 30px; padding: 10px 5px; }
    .radio-label { display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: 500; font-size: 15px; }

    .btn-update {
        width: 100%; background: var(--primary-color); color: white; border: none;
        padding: 16px; border-radius: 14px; font-size: 16px; font-weight: 700;
        cursor: pointer; transition: 0.3s; box-shadow: 0 4px 12px rgba(39, 174, 96, 0.2);
        margin-top: 10px;
    }
    .btn-update:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(39, 174, 96, 0.3); }

    .nav-links {
        text-align: center; margin-top: 30px; padding-top: 25px; border-top: 1px solid #edf2f7;
    }
    .nav-links a { color: var(--text-light); text-decoration: none; font-size: 14px; margin: 0 12px; font-weight: 500; }
    .nav-links a:hover { color: var(--primary-color); }

    /* 客製化 Flatpickr 顏色 */
    .flatpickr-day.selected { background: var(--primary-color) !important; border-color: var(--primary-color) !important; }
</style>
</head>
<body>

    <div class="profile-card">
        <div class="profile-header">
            <h2>歡迎回來，${user.fullName}</h2>
            <p>管理您的個人帳戶資訊</p>
        </div>

        <div class="profile-body">
            <div class="info-grid">
                <div class="info-item">
                    <label>帳號 Username</label>
                    <div class="value">${user.username}</div>
                </div>
                <div class="info-item">
                    <label>會員等級 Level</label>
                    <div class="value">
                        <c:choose>
                            <c:when test="${user.membershipLevel == 'VIP'}">
                                <span class="role-badge badge-vip">💎 VIP 會員</span>
                            </c:when>
                            <c:otherwise>
                                <span class="role-badge badge-user">👤 一般會員</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <label>性別 Gender</label>
                    <div class="value">${not empty user.gender ? user.gender : '未設定'}</div>
                </div>
                <div class="info-item">
                    <label>生日 Birthday</label>
                    <div class="value">${not empty user.birthday ? user.birthday : '未設定'}</div>
                </div>
                <div class="info-item">
                    <label>電子信箱 Email</label>
                    <div class="value">${not empty user.email ? user.email : '未填寫'}</div>
                </div>
                <div class="info-item">
                    <label>電話 Phone</label>
                    <div class="value">${not empty user.phone ? user.phone : '未填寫'}</div>
                </div>
            </div>

            <div class="update-section">
                <h3>修改個人資料</h3>
                <form id="profileForm" action="MembersServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    
                    <div class="form-group">
                        <label>姓名 Name</label>
                        <input type="text" name="fullName" value="${user.fullName}" required>
                    </div>

                    <div class="form-group">
                        <label>性別 Gender</label>
                        <div class="radio-group">
                            <label class="radio-label">
                                <input type="radio" name="gender" value="男" ${user.gender == '男' ? 'checked' : ''} required> 男
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="gender" value="女" ${user.gender == '女' ? 'checked' : ''}> 女
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>生日 Birthday</label>
                        <%-- 這裡改為 text 類型，由 Flatpickr 接手 --%>
                        <input type="text" id="birthdayPicker" name="birthday" 
                               class="datepicker-input" 
                               value="${user.birthday}" 
                               placeholder="請選取日期" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>電話 Phone</label>
                        <input type="text" id="phoneInput" name="phone" value="${user.phone}" maxlength="12" placeholder="0900-000-000">
                    </div>
                    
                    <div class="form-group">
                        <label>信箱 Email</label>
                        <input type="email" name="email" value="${user.email}">
                    </div>

                    <button type="submit" class="btn-update">儲存變更</button>
                </form>
            </div>

            <div class="nav-links">
                <a href="MembersServlet?action=logout" style="color: #e67e22; font-weight: 700;">登出 Logout</a>
            </div>
        </div>
    </div>

<script>
// 1. 初始化 Flatpickr 月曆選取器
flatpickr("#birthdayPicker", {
    locale: "zh_tw",
    dateFormat: "Y-m-d",
    maxDate: "today", // 禁止選擇未來日期
    disableMobile: "true", // 強制在手機上也使用這個精緻月曆，而非手機原生選取器
    altInput: true,
    altFormat: "Y-m-d", // 顯示給使用者看的格式
});

// 2. 電話格式自動加上 "-"
const phoneInput = document.getElementById('phoneInput');
if (phoneInput) {
    phoneInput.addEventListener('input', function (e) {
        let value = e.target.value.replace(/\D/g, '');
        let formattedValue = '';
        if (value.length > 0) formattedValue += value.substring(0, 4);
        if (value.length > 4) formattedValue += '-' + value.substring(4, 7);
        if (value.length > 7) formattedValue += '-' + value.substring(7, 11);
        e.target.value = formattedValue;
    });
}

// 3. 處理更新成功彈窗
const urlParams = new URLSearchParams(window.location.search);
if (urlParams.get('msg') === 'ok') {
    Swal.fire({
        icon: 'success',
        title: '更新成功！',
        text: '您的個人資料已成功存檔。',
        timer: 1500,
        showConfirmButton: false
    });
    window.history.replaceState({}, document.title, "MembersServlet?action=showProfile");
}
</script>

</body>
</html>