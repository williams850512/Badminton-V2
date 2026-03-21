<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球館 | 會員資料編輯</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-blue: #34495e;
        --accent-orange: #f39c12;
        --bg-gray: #f4f7f6;
        --border-color: #dcdde1;
        --text-dark: #2c3e50;
    }
    body { 
        font-family: 'Noto Sans TC', sans-serif; 
        background-color: var(--bg-gray); 
        display: flex; justify-content: center; align-items: center; 
        min-height: 100vh; margin: 0; padding: 20px;
    }
    .edit-card { 
        background: white; padding: 30px; border-radius: 16px; 
        width: 100%; max-width: 500px; 
        box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
    }
    h3 { color: var(--primary-blue); border-bottom: 2px solid var(--accent-orange); 
         padding-bottom: 10px; margin-bottom: 25px; text-align: center; }
    
    .form-group { margin-bottom: 18px; }
    label { display: block; margin-bottom: 5px; font-weight: 700; color: #4b5563; font-size: 14px; }
    
    input, select { 
        width: 100%; padding: 12px; border: 1.5px solid var(--border-color); 
        border-radius: 8px; box-sizing: border-box; font-size: 15px; transition: 0.3s;
    }
    input:disabled { background-color: #f9f9f9; cursor: not-allowed; color: #bdc3c7; border-color: #eee; }
    input:focus, select:focus { outline: none; border-color: var(--accent-orange); box-shadow: 0 0 0 3px rgba(243, 156, 18, 0.1); }

    .radio-group { display: flex; gap: 30px; padding: 8px 5px; }
    .radio-label { display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: normal; color: var(--text-dark); }
    .radio-label input { width: 18px; height: 18px; cursor: pointer; margin: 0; }

    .btn-save { 
        width: 100%; padding: 14px; background-color: var(--primary-blue); 
        color: white; border: none; border-radius: 8px; 
        font-size: 16px; font-weight: 700; cursor: pointer; transition: 0.3s; margin-top: 20px;
    }
    .btn-save:hover { background-color: #2c3e50; transform: translateY(-1px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
    
    .cancel-link { 
        display: block; text-align: center; margin-top: 15px; 
        color: #95a5a6; text-decoration: none; font-size: 14px; 
    }
    .cancel-link:hover { color: #e67e22; text-decoration: underline; }
    
    .role-highlight { border-left: 4px solid var(--accent-orange); font-weight: bold; background-color: #fff9f0; }
</style>
</head>
<body>

<div class="edit-card">
    <h3>🛠️ 修改會員資料</h3>
    
    <%-- 修正：Action 指向 MembersAdminServlet，使用 POST 送出 --%>
    <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="post">
        <input type="hidden" name="action" value="update">
        
        <%-- 重要：這裡的 id 要跟 Servlet 抓的名稱一致 --%>
        <input type="hidden" name="memberId" value="${m.memberId}">

        <div class="form-group">
            <label>會員帳號</label>
            <input type="text" value="${m.username}" disabled>
        </div>

        <div class="form-group">
            <label>設定會員等級 Membership Level</label>
            <select name="membershipLevel" class="role-highlight">
                <option value="Normal" ${m.membershipLevel == 'Normal' ? 'selected' : ''}>👤 一般會員 (Normal)</option>
                <option value="VIP" ${m.membershipLevel == 'VIP' ? 'selected' : ''}>💎 VIP 客戶 (VIP)</option>
            </select>
        </div>
        
        <div class="form-group">
            <label>帳號狀態 Status</label>
            <select name="status">
                <option value="Active" ${m.status == 'Active' ? 'selected' : ''}>✅ 正常使用 (Active)</option>
                <option value="Suspended" ${m.status == 'Suspended' ? 'selected' : ''}>🚫 停權 (Suspended)</option>
            </select>
        </div>

        <div class="form-group">
            <label>姓名 Name</label>
            <input type="text" name="fullName" value="${m.fullName}" required>
        </div>

        <div class="form-group">
            <label>性別 Gender</label>
            <div class="radio-group">
                <label class="radio-label">
                    <input type="radio" name="gender" value="男" ${m.gender == '男' ? 'checked' : ''} required> 男 (Male)
                </label>
                <label class="radio-label">
                    <input type="radio" name="gender" value="女" ${m.gender == '女' ? 'checked' : ''}> 女 (Female)
                </label>
            </div>
        </div>

        <div class="form-group">
            <label>生日 Birthday</label>
            <input type="date" name="birthday" value="${m.birthday}">
        </div>

        <div class="form-group">
            <label>電話 Phone</label>
            <input type="text" name="phone" id="phoneInput" value="${m.phone}" placeholder="0900-000-000" maxlength="12">
        </div>

        <div class="form-group">
            <label>電子信箱 Email</label>
            <input type="email" name="email" value="${m.email}" placeholder="example@mail.com">
        </div>

        <button type="submit" class="btn-save">儲存變更 Save Changes</button>
        
        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard" class="cancel-link">← 取消並返回清單</a>
    </form>
</div>

<script>
    // 自動格式化電話號碼
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
</script>

</body>
</html>