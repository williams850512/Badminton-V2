<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 會員管理中心</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root { 
            --primary: #1a237e; 
            --accent: #2ec4b6; 
            --bg: #f8fafc; 
            --text-main: #1e293b; 
            --text-light: #8d99ae;
            --btn-blue: #f0f4ff;
            --btn-blue-text: #4361ee;
            --table-head-bg: #f1f5f9;
        }
        body { font-family: 'Noto Sans TC', sans-serif; background-color: var(--bg); margin: 0; padding: 40px 20px; color: var(--text-main); }
        .main-container { max-width: 1500px; margin: auto; background: #ffffff; padding: 40px; border-radius: 28px; box-shadow: 0 10px 40px rgba(15, 23, 42, 0.04); }
        
        .page-title { color: var(--primary); margin: 0; font-size: 30px; letter-spacing: 2px; font-weight: 700; display: flex; align-items: center; gap: 12px; }

        .nav-link { color: var(--text-light); text-decoration: none; font-size: 14px; font-weight: 700; transition: 0.3s; display: flex; align-items: center; gap: 5px; }
        .nav-link:hover { color: var(--btn-blue-text); }
        .logout-link:hover { color: #ef4444 !important; }

        .search-group { display: flex; gap: 8px; align-items: center; background: #f1f5f9; padding: 6px; border-radius: 16px; }
        .search-input { padding: 10px 16px; border-radius: 12px; border: 1px solid transparent; width: 250px; outline: none; transition: 0.3s; font-size: 14px; }
        .search-input:focus { border-color: var(--btn-blue-text); background: white; }
        
        .btn-search { background: var(--btn-blue-text); color: white; border: none; padding: 10px 20px; border-radius: 10px; cursor: pointer; font-weight: 700; font-size: 14px; transition: 0.3s; }
        .btn-search:hover { background: #3046bc; }
        
        .btn-clear { background: #e2e8f0; color: #64748b; border: none; padding: 10px 16px; border-radius: 10px; cursor: pointer; font-weight: 700; font-size: 14px; text-decoration: none; transition: 0.3s; display: inline-block; line-height: 1.4; }
        .btn-clear:hover { background: #cbd5e1; color: #1e293b; }
        
        .btn-add { background: var(--accent); color: white; padding: 12px 26px; border-radius: 12px; text-decoration: none; font-weight: 700; font-size: 14px; transition: 0.3s; box-shadow: 0 4px 12px rgba(46, 196, 182, 0.2); display: flex; align-items: center; gap: 8px; }
        .btn-add:hover { background: #27ad9f; transform: translateY(-2px); }

        table { width: 100%; border-collapse: separate; border-spacing: 0 12px; margin-top: 20px; }
        th { padding: 18px 15px; background-color: var(--table-head-bg); color: var(--text-light); font-size: 13px; text-transform: uppercase; font-weight: 700; text-align: left; }
        th:first-child { border-radius: 12px 0 0 12px; }
        th:last-child { border-radius: 0 12px 12px 0; }

        tr.member-row { background: #ffffff; transition: 0.3s; }
        tr.member-row:hover { background: #f8faff; transform: scale(1.002); box-shadow: 0 5px 15px rgba(0,0,0,0.03); }

        .id-text { font-weight: 700; color: #94a3b8; font-size: 16px; font-family: monospace; }
        .sub-text { font-size: 12px; color: var(--text-light); font-weight: 500; }

        .level-badge { padding: 6px 14px; border-radius: 10px; font-size: 11px; font-weight: 700; letter-spacing: 1px; display: inline-block; }
        .level-vip { background: #fef3c7; color: #d97706; }
        .level-normal { background: #dbeafe; color: #2563eb; }

        .status-pill { padding: 8px 16px; border-radius: 50px; font-size: 12px; font-weight: 700; display: flex; align-items: center; gap: 8px; width: fit-content; margin: auto; }
        .status-dot { width: 7px; height: 7px; border-radius: 50%; display: inline-block; }
        .status-active { background: #ecfdf5; color: #059669; }
        .status-suspended { background: #fef2f2; color: #dc2626; }

        .action-container { display: flex; gap: 6px; justify-content: center; align-items: center; }
        .action-btn { padding: 8px 14px; border-radius: 10px; font-size: 13px; font-weight: 700; text-decoration: none; transition: 0.2s; border: none; cursor: pointer; }
        
        .btn-edit { background: var(--btn-blue); color: var(--btn-blue-text); }
        .btn-edit:hover { background: #e0e8ff; }
        
        .btn-note { background: #f1f5f9; color: #64748b; }
        .btn-note:hover { background: #e2e8f0; color: #1e293b; }
        
        .btn-del { background: #fff1f1; color: #ff4d4d; }
        .btn-del:hover { background: #ffe4e4; }
        
        .time-text { font-size: 12px; color: #64748b; font-weight: 500; line-height: 1.4; }
    </style>
</head>
<body>
<fmt:setTimeZone value="GMT+8" />

<div class="main-container">
    <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid #f1f5f9; padding-bottom: 20px;">
        <h2 class="page-title">🏸 <span>會員管理中心</span></h2>
        <div style="display: flex; align-items: center; gap: 25px;">
            <c:choose>
                <c:when test="${adminUser.role == 'manager'}">
                    <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=listAdmins" class="nav-link">⚙️ 系統管理員中心</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdminEdit&id=${adminUser.adminId}" class="nav-link">⚙️ 個人帳號設定</a>
                </c:otherwise>
            </c:choose>
            
            <span style="font-size: 14px; color: var(--text-light); border-left: 1px solid #e2e8f0; padding-left: 20px;">
                管理員：<strong style="color: var(--primary);">${adminUser.fullName}</strong>
            </span>
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=logout" class="nav-link logout-link">登出</a>
        </div>
    </header>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="get" class="search-group">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" placeholder="搜尋 ID、帳號、姓名..." value="${param.keyword}">
            <button type="submit" class="btn-search">🔍 搜尋</button>
            <c:if test="${not empty param.keyword}">
                <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard" class="btn-clear">✕ 清除</a>
            </c:if>
        </form>

        <%-- ✅ 修正：移除 c:if，讓所有管理員都能看到新增按鈕 --%>
        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdd" class="btn-add">＋ 新增會員</a>
    </div>

    <table>
        <thead>
            <tr>
                <th style="width: 70px; padding-left: 25px;">ID</th>
                <th>會員帳號 / 姓名</th>
                <th>會員等級</th>
                <th>性別 / 生日</th>
                <th>聯絡資訊</th>
                <th>帳號創建時間</th>
                <th>最後登入</th>
                <th style="text-align: center;">狀態</th>
                <th style="text-align: center;">管理操作</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="m" items="${memberList}">
                <tr class="member-row">
                    <td style="padding: 20px 25px; border-radius: 15px 0 0 15px;" class="id-text">#${m.memberId}</td>
                    <td>
                        <div style="font-weight: 700; color: #1e293b; font-size: 15px;">${m.username}</div>
                        <div class="sub-text">${m.fullName}</div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${m.membershipLevel == 'VIP'}"><span class="level-badge level-vip">💎 VIP 會員</span></c:when>
                            <c:otherwise><span class="level-badge level-normal">👤 一般會員</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="font-size: 13px; font-weight: 700; color: var(--primary);">${m.gender == '男' ? '♂ 男' : '♀ 女'}</div>
                        <div class="sub-text">🎂 ${not empty m.birthday ? m.birthday : '未填'}</div>
                    </td>
                    <td>
                        <div style="font-size: 13px; font-weight: 700;">📱 ${m.phone}</div>
                        <div class="sub-text">📧 ${m.email}</div>
                    </td>
                    <td class="time-text">
                        <fmt:formatDate value="${m.createdAt}" pattern="yyyy/MM/dd HH:mm" />
                    </td>
                    <td class="time-text">
                        <c:choose>
                            <c:when test="${not empty m.lastLogin}">
                                <fmt:formatDate value="${m.lastLogin}" pattern="yyyy/MM/dd HH:mm" />
                            </c:when>
                            <c:otherwise><span style="color: var(--text-light);">尚未登入</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td style="text-align: center;">
                        <div class="status-pill ${m.status == 'Active' ? 'status-active' : 'status-suspended'}">
                            <span class="status-dot" style="background: ${m.status == 'Active' ? '#059669' : '#dc2626'};"></span>
                            ${m.status == 'Active' ? '正常' : '停權'}
                        </div>
                    </td>
                    <td style="padding: 20px 25px; border-radius: 0 15px 15px 0; min-width: 220px;">
                        <div class="action-container">
                            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showEdit&memberId=${m.memberId}" class="action-btn btn-edit">編輯</a>
                            
                            <%-- ✅ 修正：備註按鈕使用 ES6 反引號包裹 m.note，防止換行或特殊符號出錯 --%>
                            <button type="button" class="action-btn btn-note" 
                                onclick="showNote('${m.memberId}', '${m.fullName}', `${m.note}`)">備註</button>
                            
                            <%-- 只有主管能刪除 --%>
                            <c:if test="${adminUser.role == 'manager'}">
                                <button type="button" class="action-btn btn-del" onclick="confirmDelete('${m.memberId}', '${m.username}')">刪除</button>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script>
function confirmDelete(id, username) {
    Swal.fire({
        title: '確定要刪除嗎？',
        text: "你即將移除會員「" + username + "」，此動作無法復原！",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ff4d4d',
        cancelButtonColor: '#adb5bd',
        confirmButtonText: '刪除',
        cancelButtonText: '返回'
    }).then((result) => {
        if (result.isConfirmed) {
            // ✅ 確保 Servlet 中的 action 參數名稱對應正確
            window.location.href = '${pageContext.request.contextPath}/MembersAdminServlet?action=delete&memberId=' + id;
        }
    })
}

function showNote(id, name, currentNote) {
    // ✅ 處理傳入值
    const displayNote = (currentNote === 'null' || !currentNote) ? '' : currentNote;

    Swal.fire({
        title: '<span style="font-size:20px; font-weight:700; color:var(--primary);">' + name + ' 的備註</span>',
        input: 'textarea',
        inputValue: displayNote,
        inputPlaceholder: '請輸入備註內容...',
        showCancelButton: true,
        confirmButtonText: '儲存更新',
        cancelButtonText: '取消',
        confirmButtonColor: '#1a237e',
        cancelButtonColor: '#adb5bd'
    }).then((result) => {
        if (result.isConfirmed) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/MembersAdminServlet';
            
            // ✅ 這裡的 action 必須與 Servlet 的 case 一致
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