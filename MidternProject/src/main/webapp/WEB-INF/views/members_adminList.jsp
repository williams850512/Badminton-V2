<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 系統管理員中心</title>
    <jsp:include page="/WEB-INF/backendHead.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        /* 表格風格 (局部微調) */
        .table-custom { font-size: 14px; }

        /* 按鈕風格 */
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; transition: 0.2s; }
        .btn-primary { background-color: #3498db; color: white; }
        .btn-danger { background-color: #e74c3c; color: white; }
        .btn-warning { background-color: #f1c40f; color: #333; }
        .btn-info { background-color: #9b59b6; color: white; }
        .btn-disabled { background-color: #bdc3c7; color: #ecf0f1; cursor: not-allowed; }

        /* 搜尋列 */
        .search-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .form-control { padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; outline: none; }
        
        /* 標籤樣式 */
        .badge { padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: bold; display: inline-block; }
        .badge-manager { background-color: #be123c; color: #fff; }
        .badge-staff { background-color: #0369a1; color: #fff; }
        .status-active { color: #2ecc71; font-weight: bold; }
        .status-inactive { color: #e74c3c; font-weight: bold; }
    </style>
</head>
<body>

<div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/backendHeader.jsp" />

        <div class="content-body">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2 style="color: #333;">系統管理員中心</h2>
                <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard" class="btn btn-primary" style="background-color: #7f8c8d;">← 返回會員管理</a>
            </div>
            
            <div class="card">
                <div class="search-bar">
                    <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="get" style="display: flex; gap: 10px;">
                        <input type="hidden" name="action" value="searchAdmin">
                        <input type="text" name="keyword" class="form-control" placeholder="搜尋管理員姓名/帳號..." value="${param.keyword}">
                        <button type="submit" class="btn btn-primary">🔍 搜尋</button>
                        <c:if test="${not empty param.keyword}">
                            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=listAdmins" class="btn btn-warning">✕ 清除</a>
                        </c:if>
                    </form>
                    
                    <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdminAdd" class="btn btn-primary">＋ 新增管理員</a>
                </div>

                <fmt:setTimeZone value="GMT+8" />
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>帳號 / 姓名</th>
                            <th>職位權限</th>
                            <th>性別 / 生日</th>
                            <th>聯絡資訊</th>
                            <th>創建時間</th>
                            <th>最後登入</th>
                            <th>狀態</th>
                            <th style="text-align: center;">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${adminList}">
                            <c:set var="isSelf" value="${a.adminId == adminUser.adminId}" />
                            <tr>
                                <td>#${a.adminId}</td>
                                <td>
                                    <div style="font-weight: bold;">${a.username}</div>
                                    <div style="font-size: 12px; color: #7f8c8d;">${a.fullName}</div>
                                </td>
                                <td>
                                    <span class="badge ${a.role == 'manager' ? 'badge-manager' : 'badge-staff'}">
                                        ${a.role == 'manager' ? '💼 主管' : '👤 一般職員'}
                                    </span>
                                </td>
                                <td>
                                    <div>${a.gender}</div>
                                    <div style="font-size: 12px; color: #7f8c8d;">🎂 <fmt:formatDate value="${a.birthday}" pattern="yyyy-MM-dd"/></div>
                                </td>
                                <td>
                                    <div style="font-size: 13px;">📱 ${a.phone}</div>
                                    <div style="font-size: 12px; color: #7f8c8d;">📧 ${a.email}</div>
                                </td>
                                <td style="font-size: 12px; color: #64748b;">
                                    <fmt:formatDate value="${a.createdAt}" pattern="yyyy/MM/dd HH:mm"/>
                                </td>
                                <td style="font-size: 12px;">
                                    <c:choose>
                                        <c:when test="${not empty a.lastLoginAt}">
                                            <fmt:formatDate value="${a.lastLoginAt}" pattern="yyyy/MM/dd HH:mm"/>
                                        </c:when>
                                        <c:otherwise><span style="color:#bdc3c7;">尚未登入</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="${a.status == 'active' ? 'status-active' : 'status-inactive'}">
                                        ${a.status == 'active' ? '● 啟用中' : '● 停用'}
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <div style="display: flex; gap: 5px; justify-content: center;">
                                        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdminEdit&id=${a.adminId}" class="btn btn-warning" style="padding: 4px 10px; font-size: 12px;">編輯</a>
                                        
                                        <button type="button" class="btn btn-info" style="padding: 4px 10px; font-size: 12px;"
                                            onclick="showNote('${a.adminId}', '${a.fullName}', '${a.note}')">備註</button>
                                        
                                        <c:choose>
                                            <c:when test="${!isSelf}">
                                                <button type="button" class="btn btn-danger" style="padding: 4px 10px; font-size: 12px;" 
                                                    onclick="confirmDeleteAdmin('${a.adminId}', '${a.username}')">刪除</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-disabled" style="padding: 4px 10px; font-size: 12px;" disabled title="無法刪除自己">刪除</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
function showNote(id, name, currentNote) {
    Swal.fire({
        title: name + ' 的管理備註',
        input: 'textarea',
        inputValue: (currentNote && currentNote !== 'null') ? currentNote : '',
        inputPlaceholder: '請輸入備註內容...',
        showCancelButton: true,
        confirmButtonText: '儲存更新',
        cancelButtonText: '取消',
        confirmButtonColor: '#3498db',
    }).then((result) => {
        if (result.isConfirmed) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/MembersAdminServlet';
            const params = { 'action': 'updateAdminNote', 'id': id, 'note': result.value };
            for (const key in params) {
                const input = document.createElement('input');
                input.type = 'hidden'; input.name = key; input.value = params[key];
                form.appendChild(input);
            }
            document.body.appendChild(form);
            form.submit();
        }
    });
}

function confirmDeleteAdmin(id, username) {
    Swal.fire({
        title: '確定要刪除管理員嗎？',
        text: '您即將移除帳號「' + username + '」，此操作無法撤銷！',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#e74c3c',
        cancelButtonColor: '#95a5a6',
        confirmButtonText: '確定刪除',
        cancelButtonText: '取消'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = '${pageContext.request.contextPath}/MembersAdminServlet?action=deleteAdmin&id=' + id;
        }
    });
}
</script>
</body>
</html>