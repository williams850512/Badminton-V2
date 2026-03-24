<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 新增管理員</title>
    <jsp:include page="/WEB-INF/backendHead.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    
    <style>
        /* 卡片風格 */
        .card { background: #fff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 30px; max-width: 800px; margin: 0 auto; }
        
        /* 表單樣式 */
        .form-section { margin-bottom: 25px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        .section-title { font-size: 16px; font-weight: bold; color: #3498db; margin-bottom: 15px; display: block; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; }
        .form-control { width: 100%; padding: 10px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; outline: none; transition: 0.2s; }
        .form-control:focus { border-color: #3498db; box-shadow: 0 0 5px rgba(52, 152, 219, 0.3); }
        
        /* 單選鈕與複選樣式 */
        .radio-group { display: flex; gap: 20px; padding: 10px 0; }
        .radio-item { display: flex; align-items: center; gap: 5px; cursor: pointer; }

        /* 按鈕風格 */
        .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; transition: 0.2s; text-align: center; }
        .btn-primary { background-color: #3498db; color: white; min-width: 120px; }
        .btn-primary:hover { background-color: #2980b9; }
        .btn-secondary { background-color: #95a5a6; color: white; }
        .btn-secondary:hover { background-color: #7f8c8d; }
        
        .btn-group { display: flex; gap: 10px; margin-top: 30px; justify-content: flex-end; }
        
        .error-msg { background: #fef2f2; color: #dc2626; padding: 12px; border-radius: 6px; font-size: 14px; text-align: center; margin-bottom: 20px; border: 1px solid #fee2e2; }
    </style>
</head>
<body>

<div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />

    <div class="main-content">
        <%
            String empName = (String) session.getAttribute("empName");
            if (empName == null || empName.isEmpty()) { empName = "測試管理員"; }
        %>
        <jsp:include page="/WEB-INF/backendHeader.jsp" />

        <div class="content-body">
            <div class="card">
                <h2 style="margin-bottom: 25px; color: #2c3e50;">🛡️ 新增管理員</h2>
                
                <c:if test="${not empty param.error}">
                    <div class="error-msg">❌ 新增失敗，請檢查帳號是否重複或格式有誤。</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="post">
                    <input type="hidden" name="action" value="adminAdd">
                    
                    <div class="form-section">
                        <span class="section-title">帳號設定</span>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>登入帳號 Username</label>
                                <input type="text" name="username" class="form-control" required placeholder="請輸入帳號" autocapitalize="none" spellcheck="false">
                            </div>
                            <div class="form-group">
                                <label>密碼 Password</label>
                                <input type="password" name="password" class="form-control" required placeholder="請輸入密碼">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <span class="section-title">個人資料</span>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>姓名 Full Name</label>
                                <input type="text" name="fullName" class="form-control" required placeholder="請輸入姓名">
                            </div>
                            <div class="form-group">
                                <label>性別 Gender</label>
                                <div class="radio-group">
                                    <label class="radio-item"><input type="radio" name="gender" value="男" checked> 男</label>
                                    <label class="radio-item"><input type="radio" name="gender" value="女"> 女</label>
                                </div>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>生日 Birthday</label>
                                <input type="text" id="birthdayPicker" name="birthday" class="form-control" required placeholder="請選取日期" readonly>
                            </div>
                            <div class="form-group">
                                <label>電話 Phone</label>
                                <input type="tel" id="phoneInput" name="phone" class="form-control" maxlength="12" placeholder="09xx-xxx-xxx">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>電子信箱 Email</label>
                            <input type="email" name="email" class="form-control" placeholder="example@badminton.com">
                        </div>
                    </div>

                    <div class="form-section">
                        <span class="section-title">職位與備註</span>
                        <div class="form-group">
                            <label>職位權限 Role</label>
                            <select name="role" class="form-control">
                                <option value="staff">👤 一般職員 (Staff)</option>
                                <option value="manager">💼 系統主管 (Manager)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>備註 Note</label>
                            <textarea name="note" class="form-control" rows="3" placeholder="請輸入備註" style="resize: vertical;"></textarea>
                        </div>
                    </div>

                    <div class="btn-group">
                        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=listAdmins" class="btn btn-secondary">返回列表</a>
                        <button type="submit" class="btn btn-primary">建立帳號</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 1. 初始化日曆
        flatpickr("#birthdayPicker", {
            dateFormat: "Y-m-d",
            maxDate: "today"
        });

        // 2. 自動處理手機號碼格式 (09xx-xxx-xxx)
        const phoneInput = document.getElementById('phoneInput');
        if (phoneInput) {
            phoneInput.addEventListener('input', function (e) {
                let value = e.target.value.replace(/\D/g, ''); 
                let formattedValue = '';
                if (value.length > 0) {
                    formattedValue = value.substring(0, 4); 
                    if (value.length > 4) formattedValue += '-' + value.substring(4, 7); 
                    if (value.length > 7) formattedValue += '-' + value.substring(7, 12); 
                }
                e.target.value = formattedValue;
            });
        }
    });
</script>

</body>
</html>