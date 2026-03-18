<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>會員中心 | Member Profile</title>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    :root {
        --primary-color: #27ae60;
        --admin-color: #4361ee;
        --danger-color: #e74c3c;
        --text-dark: #2c3e50;
        --text-light: #7f8c8d;
        --bg-color: #f0f2f5;
    }

    body {
        font-family: "Microsoft JhengHei", sans-serif;
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
        border-radius: 24px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        overflow: hidden;
    }

    .profile-header {
        background: var(--primary-color);
        color: white;
        padding: 40px 30px;
        text-align: center;
    }
    
    .header-admin {
        background: var(--admin-color) !important;
    }

    .profile-header h2 { margin: 0; font-size: 26px; letter-spacing: 1px; }
    .profile-header p { margin: 10px 0 0; opacity: 0.9; font-size: 14px; }

    .profile-body { padding: 35px; }

    .info-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
        margin-bottom: 35px;
        background: #f8f9fa;
        padding: 25px;
        border-radius: 16px;
        border: 1px solid #edf2f7;
    }

    .info-item label {
        display: block;
        font-size: 11px;
        color: var(--text-light);
        margin-bottom: 4px;
        text-transform: uppercase;
        font-weight: 700;
    }

    .info-item .value {
        font-weight: 700;
        color: var(--text-dark);
        font-size: 15px;
    }

    .role-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
    }
    .badge-user { background: #e1f5fe; color: #0288d1; }
    .badge-admin { background: #fee2e2; color: #ef4444; }
    .badge-vip { background: #fef3c7; color: #d97706; }

    .update-section h3 {
        font-size: 18px;
        border-left: 5px solid var(--primary-color);
        padding-left: 12px;
        margin-bottom: 25px;
        color: var(--text-dark);
    }
    
    .admin-border { border-left-color: var(--admin-color) !important; }

    .form-group { margin-bottom: 22px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: bold; font-size: 14px; color: #4a5568; }
    
    input[type="text"], input[type="email"], input[type="date"], select {
        width: 100%;
        padding: 13px;
        border: 1.5px solid #e2e8f0;
        border-radius: 10px;
        box-sizing: border-box;
        font-size: 15px;
        transition: 0.3s;
        background-color: #fff;
    }

    input:focus, select:focus {
        border-color: var(--primary-color);
        outline: none;
        box-shadow: 0 0 0 4px rgba(39, 174, 96, 0.1);
    }
    
    .admin-focus:focus { 
        border-color: var(--admin-color) !important; 
        box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.1) !important;
    }

    .btn-update {
        width: 100%;
        background: var(--primary-color);
        color: white;
        border: none;
        padding: 16px;
        border-radius: 12px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
        box-shadow: 0 4px 12px rgba(39, 174, 96, 0.2);
    }
    .btn-update:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(39, 174, 96, 0.3); }
    .btn-admin { background: var(--admin-color) !important; box-shadow: 0 4px 12px rgba(67, 97, 238, 0.2) !important; }

    .nav-links {
        text-align: center;
        margin-top: 30px;
        padding-top: 25px;
        border-top: 1px solid #edf2f7;
    }
    .nav-links a { color: var(--text-light); text-decoration: none; font-size: 14px; margin: 0 12px; font-weight: 500; }
    .nav-links a:hover { color: var(--primary-color); }
    .admin-link { color: var(--admin-color) !important; font-weight: bold; }
</style>
</head>
<body>

    <div class="profile-card">
        <div class="profile-header ${user.role == 'admin' ? 'header-admin' : ''}">
            <h2>歡迎回來，${user.name}</h2>
            <p>${user.role == 'admin' ? '🛡️ 系統管理員權限已啟動' : '管理您的個人檔案與帳戶設定'}</p>
        </div>

        <div class="profile-body">
            <div class="info-grid">
                <div class="info-item">
                    <label>帳號 Username</label>
                    <div class="value">${user.username}</div>
                </div>
                <div class="info-item">
                    <label>會員等級 Role</label>
                    <div class="value">
                        <c:choose>
                            <c:when test="${user.role == 'admin'}">
                                <span class="role-badge badge-admin">🔑 管理員</span>
                            </c:when>
                            <c:when test="${user.role == 'vip'}">
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
                    <label>註冊日期</label>
                    <div class="value" style="font-size:13px; color: #7f8c8d;">
                        <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd" />
                    </div>
                </div>
                <div class="info-item">
                    <label>最近更新</label>
                    <div class="value" style="font-size:13px; color: #e67e22;">
                        <fmt:formatDate value="${not empty user.updatedAt ? user.updatedAt : user.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                    </div>
                </div>
            </div>

            <div class="update-section">
                <h3 class="${user.role == 'admin' ? 'admin-border' : ''}">修改個人資料</h3>
                <form id="profileForm" action="MembersServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    
                    <div class="form-group">
                        <label>姓名 Name</label>
                        <input type="text" name="name" value="${user.name}" class="${user.role == 'admin' ? 'admin-focus' : ''}" required>
                    </div>

                    <div class="form-group">
                        <label>性別 Gender</label>
                        <select name="gender" class="${user.role == 'admin' ? 'admin-focus' : ''}">
                            <option value="">請選擇</option>
                            <option value="男" ${user.gender == '男' ? 'selected' : ''}>男</option>
                            <option value="女" ${user.gender == '女' ? 'selected' : ''}>女</option>
                            <option value="其他" ${user.gender == '其他' ? 'selected' : ''}>其他</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>生日 Birthday</label>
                        <input type="date" name="birthday" value="${user.birthday}" class="${user.role == 'admin' ? 'admin-focus' : ''}">
                    </div>
                    
                    <div class="form-group">
                        <label>電話 Phone</label>
                        <input type="text" id="phoneInput" name="phone" value="${user.phone}" class="${user.role == 'admin' ? 'admin-focus' : ''}" maxlength="12" placeholder="0900-000-000">
                    </div>
                    
                    <div class="form-group">
                        <label>信箱 Email</label>
                        <input type="email" name="email" value="${user.email}" class="${user.role == 'admin' ? 'admin-focus' : ''}">
                    </div>

                    <input type="hidden" name="role" value="${user.role}">
                    <button type="submit" class="btn-update ${user.role == 'admin' ? 'btn-admin' : ''}">儲存變更</button>
                </form>
            </div>

            <div class="nav-links">
                <c:if test="${user.role == 'admin'}">
                    <a href="MembersServlet?action=list" class="admin-link">🛡️ 進入管理員後台</a> | 
                </c:if>
                <a href="MembersServlet?action=logout" style="color: #e67e22;">登出 Logout</a>
            </div>
        </div>
    </div>

<script>
// --- 1. 電話格式化 ---
const phoneInput = document.getElementById('phoneInput');
phoneInput.addEventListener('input', function (e) {
    let value = e.target.value.replace(/\D/g, '');
    let formattedValue = '';
    if (value.length > 0) formattedValue += value.substring(0, 4);
    if (value.length > 4) formattedValue += '-' + value.substring(4, 7);
    if (value.length > 7) formattedValue += '-' + value.substring(7, 10);
    e.target.value = formattedValue;
});

// --- 2. 成功提示 ---
const urlParams = new URLSearchParams(window.location.search);
if (urlParams.get('msg') === 'ok') {
    Swal.fire({
        icon: 'success',
        title: '更新成功！',
        text: '您的個人資料已成功存檔。',
        timer: 2000,
        showConfirmButton: false,
        borderRadius: '20px'
    });
    window.history.replaceState({}, document.title, window.location.pathname);
}
</script>

</body>
</html>