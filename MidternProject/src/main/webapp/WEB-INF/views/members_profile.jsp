<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 個人中心</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/zh-tw.js"></script>

    <style>
        /* 全域設定 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', 'Noto Sans TC', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: #f4f7f6; color: #333; }
        
        /* 佈局容器 */
        .app-container { display: flex; height: 100vh; overflow: hidden; }
        
        /* 左側選單 */
        .sidebar { width: 15%; background-color: #2c3e50; color: #fff; display: flex; flex-direction: column; transition: all 0.3s; }
        .sidebar-logo { padding: 20px; font-size: 22px; font-weight: bold; text-align: center; border-bottom: 1px solid #34495e; letter-spacing: 2px;}
        .sidebar-menu { list-style: none; padding: 10px 0; margin: 0; }
        .sidebar-menu li { padding: 15px 25px; cursor: pointer; border-left: 4px solid transparent; transition: 0.2s; }
        .sidebar-menu li:hover { background-color: #34495e; border-left: 4px solid #3498db; }
        .sidebar-menu li.active { background-color: #34495e; border-left: 4px solid #3498db; color: #3498db; font-weight: bold;}
        .sidebar-menu a { text-decoration: none; color: inherit; display: block; }
        
        /* 右側主要區域 */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        
        /* 上方導覽列 */
        .top-header { height: 60px; background-color: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; z-index: 10; }
        .header-title { font-size: 18px; font-weight: bold; color: #555; }
        .user-info { font-size: 14px; color: #666; }
        
        /* 內容區域 */
        .content-body { flex: 1; padding: 30px; overflow-y: auto; }
        
        /* 個人資料卡片 */
        .profile-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; max-width: 900px; margin: 0 auto; }
        .profile-header { background: #3498db; color: white; padding: 30px; text-align: center; }
        .profile-header h2 { font-size: 24px; margin-bottom: 5px; }
        .profile-header p { font-size: 14px; opacity: 0.9; }

        /* 資料概覽網格 */
        .info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; padding: 30px; background-color: #fcfdfe; border-bottom: 1px solid #eee; }
        .info-item label { display: block; font-size: 11px; color: #95a5a6; font-weight: bold; margin-bottom: 5px; text-transform: uppercase; }
        .info-item .value { font-size: 15px; font-weight: 600; color: #2c3e50; }

        /* 會員等級標籤 */
        .role-badge { display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; }
        .badge-user { background: #ecf0f1; color: #7f8c8d; }
        .badge-vip { background: #fff9db; color: #f1c40f; border: 1px solid #f9eba0; }

        /* 表單區域 */
        .form-section { padding: 40px; }
        .form-section h3 { font-size: 18px; color: #2c3e50; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        .form-section h3::before { content: ''; display: block; width: 4px; height: 18px; background: #3498db; border-radius: 2px; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; font-size: 14px; }
        
        .form-control { 
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; 
            font-size: 14px; transition: 0.3s; background: #fff;
        }
        .form-control:focus { border-color: #3498db; outline: none; box-shadow: 0 0 0 3px rgba(52,152,219,0.1); }

        .radio-group { display: flex; gap: 30px; padding: 10px 0; }
        .radio-item { display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 14px; }

        .btn-submit { 
            width: 100%; padding: 14px; background: #2c3e50; color: white; border: none; 
            border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; transition: 0.3s;
        }
        .btn-submit:hover { background: #34495e; transform: translateY(-1px); box-shadow: 0 5px 10px rgba(0,0,0,0.1); }

        /* Flatpickr 客製化 */
        .flatpickr-day.selected { background: #3498db !important; border-color: #3498db !important; }
    </style>
</head>
<body>

<div class="app-container">
    <div class="sidebar">
        <div class="sidebar-logo">Badminton</div>
        <ul class="sidebar-menu">
            <li class="active"><a href="${pageContext.request.contextPath}/MembersServlet?action=showProfile">個人中心</a></li>
            <li><a href="#">我的預約</a></li>
            <li><a href="#">消費紀錄</a></li>
            <li><a href="#">修改密碼</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="top-header">
            <div class="header-title">會員中心 | Account Settings</div>
            <div class="user-info">
                HI! ${user.fullName} | 
                <a href="${pageContext.request.contextPath}/MembersServlet?action=logout" style="color: #e74c3c; text-decoration: none;">登出</a>
            </div>
        </div>

        <div class="content-body">
            <div class="profile-card">
                <div class="profile-header">
                    <h2>歡迎回來，${user.fullName}</h2>
                    <p>您可以在此查看與修改您的帳戶資訊</p>
                </div>

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
                </div>

                <div class="form-section">
                    <h3>修改個人資料</h3>
                    <form id="profileForm" action="MembersServlet" method="post">
                        <input type="hidden" name="action" value="update">
                        
                        <div class="form-grid">
                            <div class="form-group">
                                <label>姓名 Name</label>
                                <input type="text" name="fullName" class="form-control" value="${user.fullName}" required autocomplete="off">
                            </div>

                            <div class="form-group">
                                <label>性別 Gender</label>
                                <div class="radio-group">
                                    <label class="radio-item">
                                        <input type="radio" name="gender" value="男" ${user.gender == '男' ? 'checked' : ''} required> 男
                                    </label>
                                    <label class="radio-item">
                                        <input type="radio" name="gender" value="女" ${user.gender == '女' ? 'checked' : ''}> 女
                                    </label>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>生日 Birthday</label>
                                <input type="text" id="birthdayPicker" name="birthday" 
                                       class="form-control" 
                                       value="${user.birthday}" 
                                       placeholder="請選取日期" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label>電話 Phone</label>
                                <input type="text" id="phoneInput" name="phone" class="form-control" value="${user.phone}" maxlength="12" placeholder="09xx-xxx-xxx" autocomplete="off">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>電子信箱 Email</label>
                            <input type="email" name="email" class="form-control" value="${user.email}" placeholder="example@mail.com" autocomplete="off">
                        </div>

                        <button type="submit" class="btn-submit">儲存所有變更</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// 1. 初始化 Flatpickr
flatpickr("#birthdayPicker", {
    locale: "zh_tw",
    dateFormat: "Y-m-d",
    maxDate: "today", 
    disableMobile: "true"
});

// 2. 電話格式化 (09xx-xxx-xxx)
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
        text: '您的個人資料已同步至最新狀態。',
        confirmButtonColor: '#3498db',
        timer: 2000,
        showConfirmButton: false
    });
    // 清除 URL 中的成功訊息，避免重整頁面時重複彈窗
    window.history.replaceState({}, document.title, "MembersServlet?action=showProfile");
}
</script>

</body>
</html>