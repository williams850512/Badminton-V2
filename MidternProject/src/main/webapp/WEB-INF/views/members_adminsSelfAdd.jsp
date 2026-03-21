<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 新增管理員</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/material_green.css">
    
    <style>
        :root { 
            --accent: #2ec4b6; 
            --accent-hover: #27ad9f;
            --primary: #0f172a; 
            --bg: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%); 
            --text-main: #334155;
            --text-label: #64748b;
        }

        body { 
            font-family: 'Noto Sans TC', sans-serif; 
            background: var(--bg); 
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 20px;
        }

        .container { 
            width: 100%;
            max-width: 600px; 
            background: rgba(255, 255, 255, 0.95); 
            padding: 50px; 
            border-radius: 32px; 
            box-shadow: 0 20px 50px rgba(0,0,0,0.08); 
            backdrop-filter: blur(10px);
        }

        h2 { 
            color: var(--primary); 
            font-size: 28px;
            margin-bottom: 35px; 
            display: flex; 
            align-items: center; 
            gap: 12px;
            letter-spacing: -0.5px;
        }

        .section-title {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--accent);
            font-weight: 700;
            margin: 25px 0 15px 0;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 8px;
        }

        .form-group { margin-bottom: 24px; position: relative; }

        label { 
            display: block; 
            margin-bottom: 10px; 
            font-weight: 600; 
            color: var(--text-main); 
            font-size: 16px; 
        }

        input, select, textarea { 
            width: 100%; 
            padding: 14px 18px; 
            border-radius: 14px; 
            border: 1px solid #cbd5e1; 
            background-color: #f8fafc;
            outline: none; 
            box-sizing: border-box; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 15px;
            color: var(--primary);
            font-family: inherit;
        }

        input:focus, select:focus, textarea:focus { 
            border-color: var(--accent); 
            background-color: #fff;
            box-shadow: 0 0 0 4px rgba(46, 196, 182, 0.15); 
            transform: translateY(-1px);
        }

        textarea {
            resize: none;
        }

        .date-input-wrapper { position: relative; }
        .date-input-wrapper::after {
            content: "📅";
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none;
            font-size: 18px;
            opacity: 0.6;
        }

        .radio-group { 
            display: flex; 
            gap: 30px; 
            padding: 12px 18px;
            background: #f8fafc;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
        }

        .radio-item { 
            display: flex; 
            align-items: center; 
            gap: 10px; 
            cursor: pointer; 
            font-size: 16px;
            color: var(--text-main);
            font-weight: 500;
        }

        .radio-item input[type="radio"] { 
            width: 20px; 
            height: 20px; 
            accent-color: var(--accent);
            cursor: pointer;
        }

        .btn-group { 
            display: flex; 
            gap: 16px; 
            margin-top: 45px; 
        }

        .btn-base { 
            flex: 1; 
            padding: 16px; 
            border-radius: 16px; 
            font-size: 17px; 
            font-weight: 700; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            transition: all 0.3s ease; 
            cursor: pointer; 
            border: none; 
            text-decoration: none; 
            font-family: inherit;
        }

        .btn-save { 
            background: var(--accent); 
            color: white; 
            box-shadow: 0 8px 20px rgba(46, 196, 182, 0.3);
        }

        .btn-save:hover { 
            background: var(--accent-hover); 
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(46, 196, 182, 0.4); 
        }

        .btn-cancel { 
            background: #fff; 
            color: #64748b; 
            border: 1px solid #e2e8f0;
        }

        .btn-cancel:hover { 
            background: #f1f5f9; 
            color: #475569;
            transform: translateY(-2px);
        }

        @media (max-width: 480px) {
            .container { padding: 30px; border-radius: 0; }
            .btn-group { flex-direction: column-reverse; }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>🛡️ 新增系統管理員</h2>
    <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="post">
        <input type="hidden" name="action" value="adminAdd">
        
        <div class="section-title">帳號安全</div>
        <div class="form-group">
            <label>帳號 Username</label>
            <input type="text" name="username" required 
                   placeholder="設定 6-12 位英數字"
                   autocapitalize="none"
                   autocorrect="off"
                   spellcheck="false">
        </div>
        <div class="form-group">
            <label>密碼 Password</label>
            <input type="password" name="password" required placeholder="請設定安全性密碼">
        </div>

        <div class="section-title">個人基本資訊</div>
        <div class="form-group">
            <label>姓名 Name</label>
            <input type="text" name="fullName" required placeholder="請輸入完整姓名">
        </div>
        
        <div class="form-group">
            <label>性別 Gender</label>
            <div class="radio-group">
                <label class="radio-item"><input type="radio" name="gender" value="男" checked> 男</label>
                <label class="radio-item"><input type="radio" name="gender" value="女"> 女</label>
            </div>
        </div>

        <div class="form-group">
            <label>生日 Birthday</label>
            <div class="date-input-wrapper">
                <input type="text" id="birthdayPicker" name="birthday" required placeholder="請點擊選取日期">
            </div>
        </div>

        <div class="form-group">
            <label>電子信箱 Email</label>
            <input type="email" name="email" placeholder="example@badminton.com">
        </div>

        <div class="form-group">
            <label>電話 Phone</label>
            <input type="tel" name="phone" placeholder="例如：0912-345-678">
        </div>

        <div class="form-group">
            <label>職位權限 Role</label>
            <select name="role">
                <option value="staff">👤 一般職員 (Staff)</option>
                <option value="manager">💼 主管 (Manager)</option>
            </select>
        </div>

        <div class="form-group">
            <label>管理員備注 Note (僅供內部查閱)</label>
            <textarea name="note" rows="3" placeholder="請輸入備注內容，例如職責說明或聯絡細項..."></textarea>
        </div>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=listAdmins" class="btn-base btn-cancel">取消</a>
            <button type="submit" class="btn-base btn-save">建立管理員帳號</button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://npmcdn.com/flatpickr/dist/l10n/zh-tw.js"></script>
<script>
    flatpickr("#birthdayPicker", {
        locale: "zh_tw",
        dateFormat: "Y-m-d",
        maxDate: "today",
        disableMobile: "true"
    });
</script>
</body>
</html>