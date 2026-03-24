<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 編輯管理員資料</title>
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
        
        /* 單選鈕樣式 */
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
                <%-- 判斷邏輯保留 --%>
                <c:set var="isEditingSelf" value="${adminUser.adminId == a.adminId}" />
                <c:set var="isSelfStaff" value="${adminUser.role == 'staff' && isEditingSelf}" />

                <h2 style="margin-bottom: 25px; color: #2c3e50;">
                    <c:choose>
                        <c:when test="${isEditingSelf}">👤 個人帳號設定</c:when>
                        <c:otherwise>⚙️ 編輯管理員資料</c:otherwise>
                    </c:choose>
                </h2>
                
                <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="post">
                    <input type="hidden" name="action" value="adminUpdate">
                    <input type="hidden" name="adminId" value="${a.adminId}">
                    
                    <div class="form-section">
                        <span class="section-title">帳號資訊</span>
                        <div class="form-group">
                            <label>登入帳號 Username</label>
                            <input type="text" class="form-control" value="${a.username}" disabled>
                        </div>
                    </div>

                    <div class="form-section">
                        <span class="section-title">個人基本資料</span>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>姓名 Full Name</label>
                                <input type="text" name="fullName" class="form-control" value="${a.fullName}" required>
                            </div>
                            <div class="form-group">
                                <label>性別 Gender</label>
                                <div class="radio-group">
                                    <label class="radio-item">
                                        <input type="radio" name="gender" value="男" ${a.gender == '男' ? 'checked' : ''}> 男
                                    </label>
                                    <label class="radio-item">
                                        <input type="radio" name="gender" value="女" ${a.gender == '女' ? 'checked' : ''}> 女
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>生日 Birthday</label>
                                <input type="text" id="birthdayPicker" name="birthday" class="form-control" value="${a.birthday}" required readonly>
                            </div>
                            <div class="form-group">
                                <label>電話 Phone</label>
                                <input type="tel" id="phoneInput" name="phone" class="form-control" value="${a.phone}" maxlength="12" placeholder="09xx-xxx-xxx">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>電子信箱 Email</label>
                            <input type="email" name="email" class="form-control" value="${a.email}">
                        </div>
                    </div>

                    <div class="form-section">
                        <span class="section-title">權限與管理資訊</span>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>帳號狀態 Status</label>
                                <select name="status" class="form-control" ${isSelfStaff ? 'disabled' : ''}>
                                    <option value="active" ${a.status == 'active' ? 'selected' : ''}>🟢 啟用中 (Active)</option>
                                    <option value="inactive" ${a.status == 'inactive' ? 'selected' : ''}>🔴 停用 (Inactive)</option>
                                </select>
                                <c:if test="${isSelfStaff}">
                                    <input type="hidden" name="status" value="${a.status}">
                                    <p class="help-text">* 職員無法修改自身狀態</p>
                                </c:if>
                            </div>
                            <div class="form-group">
                                <label>職位權限 Role</label>
                                <select name="role" class="form-control" ${isSelfStaff ? 'disabled' : ''}>
                                    <option value="staff" ${a.role == 'staff' ? 'selected' : ''}>👤 一般職員 (Staff)</option>
                                    <option value="manager" ${a.role == 'manager' ? 'selected' : ''}>💼 系統主管 (Manager)</option>
                                </select>
                                <c:if test="${isSelfStaff}">
                                    <input type="hidden" name="role" value="${a.role}">
                                    <p class="help-text">* 職員無法修改自身職位</p>
                                </c:if>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>管理備註 Note</label>
                            <textarea name="note" class="form-control" rows="3" style="resize: vertical;">${a.note}</textarea>
                        </div>
                    </div>

                    <div class="btn-group">
                        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=listAdmins" 
                           class="btn btn-secondary">
                           取消返回
                        </a>
                        <button type="submit" class="btn btn-primary">儲存更新</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 初始化日曆
        flatpickr("#birthdayPicker", {
            dateFormat: "Y-m-d",
            maxDate: "today"
        });

        // 自動手機格式化
        const phoneInput = document.getElementById('phoneInput');
        if (phoneInput) {
            phoneInput.addEventListener('input', function (e) {
                let value = e.target.value.replace(/\D/g, ''); 
                let formattedValue = '';
                if (value.length > 0) {
                    formattedValue = value.substring(0, 4); 
                    if (value.length > 4) formattedValue += '-' + value.substring(4, 7); 
                    if (value.length > 7) formattedValue += '-' + value.substring(7, 11); 
                }
                e.target.value = formattedValue;
            });
        }
    });
</script>

</body>
</html>