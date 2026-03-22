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
        --primary-blue: #5c67f2;
        --text-dark: #334155;
        --text-light: #94a3b8;
        --bg-color: #f8fafc;
        --border-color: #e2e8f0;
        --card-bg: #ffffff;
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
        color: var(--text-dark);
    }

    .profile-card {
        background: var(--card-bg);
        width: 100%;
        max-width: 600px;
        border-radius: 24px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.03);
        overflow: hidden;
        border: 1px solid #f1f5f9;
    }

    .profile-header {
        background: var(--primary-blue);
        color: white;
        padding: 40px 30px;
        text-align: center;
    }
    
    .profile-header h2 { margin: 0; font-size: 22px; font-weight: 700; letter-spacing: 0.5px; }
    .profile-header p { margin: 8px 0 0; opacity: 0.85; font-size: 13px; font-weight: 400; }

    .profile-body { padding: 40px; }


    .info-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 40px;
        background: #fcfdfe;
        padding: 25px;
        border-radius: 16px;
        border: 1px solid #f1f5f9;
    }

    .info-item label {
        display: block; font-size: 11px; color: var(--text-light);
        margin-bottom: 6px; text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px;
    }

    .info-item .value { font-weight: 600; color: #1e293b; font-size: 14px; }

    /* 會員等級標籤 */
    .role-badge {
        display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 6px;
        font-size: 11px; font-weight: 700;
    }
    .badge-user { background: #f1f5f9; color: #64748b; }
    .badge-vip { background: #fffbeb; color: #d97706; border: 1px solid #fef3c7; }

    .update-section h3 {
        font-size: 16px; border-left: 4px solid var(--primary-blue);
        padding-left: 12px; margin-bottom: 25px; color: #1e293b; font-weight: 700;
    }
    
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: 700; font-size: 13px; color: #475569; }
    
    input[type="text"], 
    input[type="email"],
    .datepicker-input {
        width: 100%; padding: 12px 16px; border: 1.5px solid var(--border-color);
        border-radius: 10px; box-sizing: border-box; font-size: 14px;
        font-family: inherit; transition: all 0.2s ease; background-color: #fff;
    }

    input:focus, .datepicker-input:focus {
        border-color: var(--primary-blue); outline: none;
        box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.08);
    }
    
    .radio-group { display: flex; gap: 30px; padding: 5px 0; }
    .radio-label { display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: 500; font-size: 14px; }
    .radio-label input { accent-color: var(--primary-blue); width: 16px; height: 16px; }

    .btn-update {
        width: 100%; background: var(--primary-blue); color: white; border: none;
        padding: 14px; border-radius: 10px; font-size: 15px; font-weight: 700;
        cursor: pointer; transition: 0.3s; margin-top: 10px;
    }
    .btn-update:hover { background: #3651d4; transform: translateY(-1px); box-shadow: 0 5px 15px rgba(67, 97, 238, 0.15); }

    .nav-links {
        text-align: center; margin-top: 30px; padding-top: 25px; border-top: 1px solid #f1f5f9;
    }
    .nav-links a { color: var(--text-light); text-decoration: none; font-size: 13px; margin: 0 12px; font-weight: 500; }
    .nav-links a:hover { color: var(--primary-blue); }

    /*  Flatpickr 顏色 */
    .flatpickr-day.selected { background: var(--primary-blue) !important; border-color: var(--primary-blue) !important; }
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
                        <input type="text" name="fullName" value="${user.fullName}" required autocomplete="off">
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
                        <input type="text" id="birthdayPicker" name="birthday" 
                               class="datepicker-input" 
                               value="${user.birthday}" 
                               placeholder="請選取日期" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>電話 Phone</label>
                        <input type="text" id="phoneInput" name="phone" value="${user.phone}" maxlength="12" placeholder="0900-000-000" autocomplete="off">
                    </div>
                    
                    <div class="form-group">
                        <label>信箱 Email</label>
                        <input type="email" name="email" value="${user.email}" autocomplete="off">
                    </div>

                    <button type="submit" class="btn-update">儲存變更</button>
                </form>
            </div>

            <div class="nav-links">
                <a href="MembersServlet?action=logout" style="color: #94a3b8;">登出 Logout</a>
            </div>
        </div>
    </div>

<script>
// 1. 初始化 Flatpickr
flatpickr("#birthdayPicker", {
    locale: "zh_tw",
    dateFormat: "Y-m-d",
    maxDate: "today", 
    disableMobile: "true",
    altInput: true,
    altFormat: "Y-m-d",
});

// 2. 電話格式
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
        confirmButtonColor: '#4361ee',
        timer: 1500,
        showConfirmButton: false
    });
    window.history.replaceState({}, document.title, "MembersServlet?action=showProfile");
}
</script>

</body>
</html>