<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 新增系統管理員</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/confetti.css">
    
    <style>
        :root { 
            --accent: #6366f1; /* 質感紫色 */
            --accent-hover: #4f46e5;
            --primary: #0f172a; 
            --bg: linear-gradient(135deg, #f5f3ff 0%, #ede9fe 100%); /* 淡紫色漸層背景 */
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
            padding: 40px 20px;
        }

        .container { 
            width: 100%;
            max-width: 650px; 
            background: rgba(255, 255, 255, 0.95); 
            padding: 50px; 
            border-radius: 32px; 
            box-shadow: 0 20px 50px rgba(99, 102, 241, 0.1); 
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        h2 { 
            color: var(--primary); 
            font-size: 28px;
            margin-bottom: 35px; 
            display: flex; 
            align-items: center; 
            gap: 12px;
            letter-spacing: -0.5px;
            justify-content: center; 
        }

        .section-title {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--accent);
            font-weight: 700;
            margin: 30px 0 15px 0;
            border-bottom: 2px solid #f5f3ff;
            padding-bottom: 8px;
        }

        .form-group { margin-bottom: 24px; position: relative; }

        label { 
            display: block; 
            margin-bottom: 10px; 
            font-weight: 600; 
            color: var(--text-main); 
            font-size: 15px; 
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
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15); 
            transform: translateY(-1px);
        }

        textarea { resize: none; }

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
            font-size: 15px;
            color: var(--text-main);
            font-weight: 500;
        }

        .radio-item input[type="radio"] { 
            width: 18px; 
            height: 18px; 
            accent-color: var(--accent); 
            cursor: pointer;
            margin: 0;
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
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.3);
        }

        .btn-save:hover { 
            background: var(--accent-hover); 
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(99, 102, 241, 0.4); 
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

        /* 錯誤提示樣式 */
        .error-msg {
            background: #fef2f2;
            color: #dc2626;
            padding: 12px;
            border-radius: 12px;
            font-size: 14px;
            text-align: center;
            margin-bottom: 20px;
            border: 1px solid #fee2e2;
        }

        @media (max-width: 480px) {
            .container { padding: 30px 20px; border-radius: 0; }
            .btn-group { flex-direction: column-reverse; }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>🛡️ 新增系統管理員</h2>

    <%-- 顯示錯誤訊息 --%>
    <c:if test="${not empty param.error}">
        <div class="error-msg">❌ 新增失敗，請檢查帳號是否重複或格式有誤。</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="post">
        <input type="hidden" name="action" value="adminAdd">
        
        <div class="section-title">帳號安全設定</div>
        <div class="form-group">
            <label>登入帳號 Username</label>
            <input type="text" name="username" required 
                   placeholder="請輸入帳號"
                   autocapitalize="none"
                   autocorrect="off"
                   spellcheck="false">
        </div>
        <div class="form-group">
            <label>密碼 Password</label>
            <input type="password" name="password" required placeholder="請輸入密碼">
        </div>

        <div class="section-title">個人資料</div>
        <div class="form-group">
            <label>姓名 Full Name</label>
            <input type="text" name="fullName" required placeholder="請輸入姓名">
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
                <input type="text" id="birthdayPicker" name="birthday" required placeholder="請選取日期">
            </div>
        </div>

        <div class="section-title">聯絡與權限</div>
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
                <option value="manager">💼 系統主管 (Manager)</option>
            </select>
        </div>

        <div class="form-group">
            <label>備註 Note</label>
            <textarea name="note" rows="3" placeholder="請輸入備註"></textarea>
        </div>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=listAdmins" class="btn-base btn-cancel">返回列表</a>
            <button type="submit" class="btn-base btn-save">建立帳號</button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/zh-tw.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        flatpickr("#birthdayPicker", {
            locale: "zh_tw",
            dateFormat: "Y-m-d",
            maxDate: "today", // 禁止選擇未來的日期
            disableMobile: "true"
        });
    });
</script>
</body>
</html>