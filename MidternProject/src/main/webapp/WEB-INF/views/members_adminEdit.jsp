<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 編輯會員資料</title>
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
        .form-control:disabled { background-color: #f8f9fa; cursor: not-allowed; border-style: dashed; }
        
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
        
        .help-text { font-size: 12px; color: #94a3b8; margin-top: 5px; }
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
                <h2 style="margin-bottom: 25px; color: #2c3e50;">📝 編輯會員資料</h2>
                
                <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="memberId" value="${m.memberId}">
                    
                    <c:set var="isManager" value="${adminUser.role == 'manager'}" />

                    <div class="form-section">
                        <span class="section-title">帳號資訊</span>
                        <div class="form-group">
                            <label>會員帳號 Username</label>
                            <input type="text" class="form-control" value="${m.username}" disabled>
                        </div>
                    </div>

                    <div class="form-section">
                        <span class="section-title">個人資訊</span>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>姓名 Name</label>
                                <input type="text" name="fullName" class="form-control" value="${m.fullName}" required>
                            </div>
                            <div class="form-group">
                                <label>性別 Gender</label>
                                <div class="radio-group">
                                    <label class="radio-item">
                                        <input type="radio" name="gender" value="男" ${m.gender == '男' ? 'checked' : ''} required> 男
                                    </label>
                                    <label class="radio-item">
                                        <input type="radio" name="gender" value="女" ${m.gender == '女' ? 'checked' : ''}> 女
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>生日 Birthday</label>
                                <input type="text" id="birthdayPicker" name="birthday" class="form-control" value="${m.birthday}" readonly>
                            </div>
                            <div class="form-group">
                                <label>電話 Phone</label>
                                <input type="tel" id="phoneInput" name="phone" class="form-control" value="${m.phone}" placeholder="09XX-XXX-XXX" maxlength="12">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>電子信箱 Email</label>
                            <input type="email" name="email" class="form-control" value="${m.email}">
                        </div>
                    </div>

                    <div class="form-section">
                        <span class="section-title">權限與備註</span>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>帳號狀態 Status</label>
                                <select name="status" class="form-control" ${!isManager ? 'disabled' : ''}>
                                    <option value="Active" ${m.status == 'Active' ? 'selected' : ''}>正常 (Active)</option>
                                    <option value="Suspended" ${m.status == 'Suspended' ? 'selected' : ''}>停權 (Suspended)</option>
                                </select>
                                <c:if test="${!isManager}">
                                    <input type="hidden" name="status" value="${m.status}">
                                    <p class="help-text">* 僅主管可修改</p>
                                </c:if>
                            </div>
                            <div class="form-group">
                                <label>會員等級 Level</label>
                                <select name="membershipLevel" class="form-control" ${!isManager ? 'disabled' : ''}>
                                    <option value="Regular" ${m.membershipLevel == 'Regular' ? 'selected' : ''}>一般會員 (Regular)</option>
                                    <option value="VIP" ${m.membershipLevel == 'VIP' ? 'selected' : ''}>VIP 會員 (VIP)</option>
                                </select>
                                <c:if test="${!isManager}">
                                    <input type="hidden" name="membershipLevel" value="${m.membershipLevel}">
                                    <p class="help-text">* 僅主管可修改</p>
                                </c:if>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>備註 Note</label>
                            <textarea name="note" class="form-control" rows="3" style="resize: vertical;">${m.note}</textarea>
                        </div>
                    </div>

                    <div class="btn-group">
                        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard" class="btn btn-secondary">取消返回</a>
                        <button type="submit" class="btn btn-primary">儲存更新</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
    // 日期選擇器初始化
    flatpickr("#birthdayPicker", {
        dateFormat: "Y-m-d",
        maxDate: "today"
    });

    // 電話格式自動補橫線
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