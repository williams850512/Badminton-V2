<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>管理員工具 | 會員資料編輯</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-indigo: #4361ee;
        --soft-gray: #f8f9fa;
        --dark-text: #2b2d42;
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
    .edit-card { 
        background: white; 
        padding: 40px; 
        border-radius: 24px; 
        width: 100%;
        max-width: 450px; 
        box-shadow: 0 20px 40px rgba(0,0,0,0.08); 
    }
    h3 { 
        color: var(--dark-text); 
        text-align: center; 
        margin-bottom: 30px; 
        font-size: 24px;
        letter-spacing: 1px;
    }
    .form-group { margin-bottom: 22px; }
    label { 
        display: block; 
        font-size: 13px; 
        color: #8d99ae; 
        margin-bottom: 8px; 
        font-weight: 700; 
        padding-left: 5px;
    }
    input, select { 
        width: 100%; 
        padding: 14px; 
        border: 1.5px solid #edf2f4; 
        border-radius: 12px; 
        box-sizing: border-box; 
        font-size: 15px; 
        transition: 0.3s;
        background-color: var(--soft-gray);
    }
    input:focus, select:focus {
        outline: none;
        border-color: var(--primary-indigo);
        background-color: white;
        box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.1);
    }
    input:disabled { 
        background-color: #e9ecef; 
        color: #adb5bd; 
        cursor: not-allowed;
    }
    .role-highlight {
        border: 2px solid #dbeafe;
        background-color: #f0f7ff;
        color: var(--primary-indigo);
        font-weight: 700;
    }
    .btn-save { 
        width: 100%; 
        padding: 16px; 
        background: linear-gradient(135deg, #4361ee, #3f37c9);
        color: white; 
        border: none; 
        border-radius: 12px; 
        font-size: 16px; 
        font-weight: 700; 
        cursor: pointer; 
        transition: 0.3s; 
        margin-top: 15px;
        box-shadow: 0 8px 15px rgba(67, 97, 238, 0.2);
    }
    .btn-save:hover { 
        transform: translateY(-2px); 
        box-shadow: 0 12px 20px rgba(67, 97, 238, 0.3);
    }
    .cancel-link { 
        display: block; 
        text-align: center; 
        margin-top: 25px; 
        color: #8d99ae; 
        text-decoration: none; 
        font-size: 14px; 
        font-weight: 500;
    }
    .cancel-link:hover { color: var(--dark-text); }
</style>
</head>
<body>

<div class="edit-card">
    <h3>修改會員資料</h3>
    <form action="MembersServlet" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="member_id" value="${member.memberId}">

        <div class="form-group">
            <label>會員帳號 (無法修改)</label>
            <input type="text" value="${member.username}" disabled>
        </div>

        <div class="form-group">
            <label>設定職級 Role</label>
            <select name="role" class="role-highlight">
                <option value="user" ${member.role == 'user' ? 'selected' : ''}>👤 一般會員 (User)</option>
                <option value="vip" ${member.role == 'vip' ? 'selected' : ''}>💎 VIP 客戶 (VIP)</option>
                <option value="admin" ${member.role == 'admin' ? 'selected' : ''}>🔑 系統管理員 (Admin)</option>
            </select>
        </div>

        <div class="form-group">
            <label>姓名 Name</label>
            <input type="text" name="name" value="${member.name}" required>
        </div>

        <div class="form-group">
            <label>性別 Gender</label>
            <select name="gender">
                <option value="男" ${member.gender == '男' ? 'selected' : ''}>男</option>
                <option value="女" ${member.gender == '女' ? 'selected' : ''}>女</option>
                <option value="其他" ${member.gender == '其他' ? 'selected' : ''}>其他</option>
            </select>
        </div>

        <div class="form-group">
            <label>生日 Birthday</label>
            <input type="date" name="birthday" value="${member.birthday}">
        </div>

        <div class="form-group">
            <label>電話 Phone</label>
            <input type="text" name="phone" value="${member.phone}">
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value="${member.email}">
        </div>

        <button type="submit" class="btn-save">儲存變更</button>
        <a href="MembersServlet?action=list" class="cancel-link">取消並返回清單</a>
    </form>
</div>

</body>
</html>