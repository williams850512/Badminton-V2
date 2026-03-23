<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 會員管理中心</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
        .content-body { flex: 1; padding: 20px; overflow-y: auto; }
        
        /* 卡片風格 */
        .card { background: #fff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 25px; margin-bottom: 20px;}
        
        /* 表格風格 */
        .table-custom { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 14px; }
        .table-custom th, .table-custom td { border-bottom: 1px solid #eee; padding: 12px 15px; text-align: left; }
        .table-custom th { background-color: #f8f9fa; color: #555; font-weight: bold; }
        .table-custom tr:hover { background-color: #f1f4f8; }
        
        /* 按鈕風格 */
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; transition: 0.2s; }
        .btn-primary { background-color: #3498db; color: white; }
        .btn-primary:hover { background-color: #2980b9; }
        .btn-danger { background-color: #e74c3c; color: white; }
        .btn-danger:hover { background-color: #c0392b; }
        .btn-warning { background-color: #f1c40f; color: #333; }
        .btn-info { background-color: #2ecc71; color: white; }

        /* 搜尋列 */
        .search-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .form-control { padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; outline: none; }
        
        /* 標籤樣式 */
        .badge { padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .badge-vip { background-color: #f1c40f; color: #000; }
        .badge-normal { background-color: #bdc3c7; color: #fff; }
        .status-active { color: #2ecc71; font-weight: bold; }
        .status-suspended { color: #e74c3c; font-weight: bold; }
    </style>
</head>
<body>

<div class="app-container">
    <div class="sidebar">
        <div class="sidebar-logo">Badminton</div>
        <ul class="sidebar-menu">
            <li class="active"><a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard">會員管理</a></li>
            <li><a href="#">預約管理</a></li>
            <li><a href="#">臨打管理</a></li>
            <li><a href="#">商品管理</a></li>
            <li><a href="#">訂單管理</a></li>
            <li><a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list">公告管理</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="top-header">
            <div class="header-title">羽球館管理系統</div>
            <div class="user-info">
                管理員：<c:out value="${not empty adminUser.fullName ? adminUser.fullName : '測試管理員'}" /> | 
                <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=logout" style="color: #e74c3c; text-decoration: none;">登出</a>
            </div>
        </div>

        <div class="content-body">
            <h2 style="margin-bottom: 20px; color: #333;">🏸 會員管理中心</h2>
            
            <div class="card">
                <div class="search-bar">
                    <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="get" style="display: flex; gap: 10px;">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" class="form-control" placeholder="搜尋 ID、帳號、姓名..." value="${param.keyword}">
                        <button type="submit" class="btn btn-primary">🔍 搜尋</button>
                        <c:if test="${not empty param.keyword}">
                            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard" class="btn btn-warning">✕ 清除</a>
                        </c:if>
                    </form>
                    
                    <div>
                        <c:if test="${adminUser.role == 'manager'}">
                            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=listAdmins" class="btn" style="background: #95a5a6; color:white;">⚙️ 職員管理</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdd" class="btn btn-primary">＋ 新增會員</a>
                    </div>
                </div>

                <fmt:setTimeZone value="GMT+8" />
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>帳號 / 姓名</th>
                            <th>等級</th>
                            <th>性別 / 生日</th>
                            <th>聯絡資訊</th>
                            <th>帳號創建</th>
                            <th>狀態</th>
                            <th style="text-align: center;">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="m" items="${memberList}">
                            <tr>
                                <td>#${m.memberId}</td>
                                <td>
                                    <div style="font-weight: bold;">${m.username}</div>
                                    <div style="font-size: 12px; color: #7f8c8d;">${m.fullName}</div>
                                </td>
                                <td><c:choose><c:when test="${m.membershipLevel == 'VIP'}"><span class="badge badge-vip">VIP</span></c:when><c:otherwise><span class="badge badge-normal">一般</span></c:otherwise></c:choose></td>
                                <td>
                                    <div>${m.gender}</div>
                                    <div style="font-size: 12px; color: #7f8c8d;">🎂 ${not empty m.birthday ? m.birthday : '未填'}</div>
                                </td>
                                <td>
                                    <div style="font-size: 13px;">📱 ${m.phone}</div>
                                    <div style="font-size: 12px; color: #7f8c8d;">📧 ${m.email}</div>
                                </td>
                                <td style="font-size: 12px;">
                                    <fmt:formatDate value="${m.createdAt}" pattern="yyyy/MM/dd" />
                                </td>
                                <td>
                                    <span class="${m.status == 'Active' ? 'status-active' : 'status-suspended'}">
                                        ${m.status == 'Active' ? '● 正常' : '● 停權'}
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <div style="display: flex; gap: 5px; justify-content: center;">
                                        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showEdit&memberId=${m.memberId}" class="btn btn-warning" style="padding: 4px 10px; font-size: 12px;">編輯</a>
                                        
                                        <button type="button" class="btn btn-info" style="padding: 4px 10px; font-size: 12px;"
                                            onclick="showNote('${m.memberId}', '${m.fullName}', `${m.note}`)">備註</button>
                                        
                                        <c:if test="${adminUser.role == 'manager'}">
                                            <button type="button" class="btn btn-danger" style="padding: 4px 10px; font-size: 12px;" 
                                                onclick="confirmDelete('${m.memberId}', '${m.username}')">刪除</button>
                                        </c:if>
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
function confirmDelete(id, username) {
    Swal.fire({
        title: '確定要刪除嗎？',
        text: "你即將移除會員「" + username + "」，此動作無法復原！",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#e74c3c',
        cancelButtonColor: '#adb5bd',
        confirmButtonText: '確定刪除',
        cancelButtonText: '取消'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = '${pageContext.request.contextPath}/MembersAdminServlet?action=delete&memberId=' + id;
        }
    })
}

function showNote(id, name, currentNote) {
    const displayNote = (currentNote === 'null' || !currentNote) ? '' : currentNote;

    Swal.fire({
        title: '會員備註：' + name,
        input: 'textarea',
        inputValue: displayNote,
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
            
            const params = { 'action': 'updateMemberNote', 'memberId': id, 'note': result.value };
            
            for (const key in params) {
                const input = document.createElement('input');
                input.type = 'hidden'; 
                input.name = key; 
                input.value = params[key];
                form.appendChild(input);
            }
            document.body.appendChild(form);
            form.submit();
        }
    });
}
</script>
</body>
</html>