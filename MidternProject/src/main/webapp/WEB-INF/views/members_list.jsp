<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 會員管理後台</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        .action-btn { transition: 0.3s; text-decoration: none; display: inline-block; border: none; cursor: pointer; }
        .action-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .nav-link { color: #8d99ae; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s; display: flex; align-items: center; gap: 5px; }
        .nav-link:hover { color: #4361ee; }
        .logout-link:hover { color: #ef4444 !important; }
        table { width: 100%; border-collapse: separate; border-spacing: 0 15px; }
        th { padding: 0 20px; color: #8d99ae; font-size: 13px; text-transform: uppercase; }
        tr.member-row { background: #ffffff; box-shadow: 0 2px 10px rgba(0,0,0,0.03); transition: 0.3s; }
        tr.member-row:hover { background: #f8faff; }
        .search-input { padding: 10px 15px; border-radius: 12px; border: 1px solid #e2e8f0; width: 250px; outline: none; transition: 0.3s; }
        .search-input:focus { border-color: #4361ee; box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1); }
    </style>
</head>
<body style="font-family: 'Noto Sans TC', sans-serif; background-color: #f0f2f5; margin: 0; padding: 40px 20px;">

<%-- 安全檢查：若未登入則導回登入頁 --%>
<c:if test="${empty sessionScope.adminUser}">
    <script>location.href='${pageContext.request.contextPath}/MembersAdminServlet?action=showLogin';</script>
</c:if>

<div style="max-width: 1200px; margin: auto; background: #ffffff; padding: 40px; border-radius: 24px; box-shadow: 0 15px 35px rgba(0,0,0,0.05);">
    
    <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid #f8f9fa; padding-bottom: 20px;">
        <h2 style="font-size: 28px; margin: 0; color: #1a237e; display: flex; align-items: center; gap: 12px;">
            🏸 <span style="letter-spacing: 1px;">會員帳號管理中心</span>
        </h2>
        
        <div style="display: flex; align-items: center; gap: 25px;">
            <%-- ✅ 連結對齊：進入系統管理員清單 --%>
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=listAdmins" class="nav-link">
                ⚙️ 系統管理員設定
            </a>
            
            <span style="font-size: 14px; color: #64748b; border-left: 1px solid #e2e8f0; padding-left: 20px;">
                目前登入：<strong style="color: #1a237e;">${adminUser.fullName}</strong>
            </span>
            
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=logout" class="nav-link logout-link">
                登出 →
            </a>
        </div>
    </header>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="get" style="display: flex; gap: 10px; align-items: center;">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" placeholder="搜尋帳號或姓名..." value="${param.keyword}">
            <button type="submit" style="background: #4361ee; color: white; border: none; padding: 10px 20px; border-radius: 12px; cursor: pointer; font-weight: 500;">
                🔍 搜尋
            </button>
            <c:if test="${not empty param.keyword}">
                <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard" 
                   style="text-decoration: none; color: #8d99ae; font-size: 13px; margin-left: 5px;">清除搜尋</a>
            </c:if>
        </form>

        <%-- ✅ 連結對齊：開啟新增會員頁面 (members_adminAdd.jsp) --%>
        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdd" 
           style="background: #2ec4b6; color: white; text-decoration: none; padding: 10px 22px; border-radius: 12px; font-weight: 600; font-size: 14px; display: flex; align-items: center; gap: 8px;">
            <span>＋</span> 新增會員
        </a>
    </div>

    <table>
        <thead>
            <tr style="text-align: left;">
                <th style="width: 80px;">ID</th>
                <th>帳號/姓名</th>
                <th>性別/生日</th>
                <th>聯絡資訊</th>
                <th>會員等級</th>
                <th style="text-align: center;">管理操作</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="m" items="${memberList}">
                <tr class="member-row">
                    <td style="padding: 25px 20px; border-radius: 15px 0 0 15px; font-weight: 700; color: #ced4da; font-size: 18px;">
                        # ${m.memberId}
                    </td>
                    
                    <td style="padding: 25px 20px;">
                        <div style="font-weight: 700; color: #2b2d42; font-size: 16px;">${m.username}</div>
                        <div style="font-size: 13px; color: #8d99ae;">${m.fullName}</div>
                    </td>

                    <td style="padding: 25px 20px;">
                        <div style="font-size: 14px; color: #2b2d42; margin-bottom: 4px;">
                            <c:choose>
                                <c:when test="${m.gender == '男'}">♂️ 男</c:when>
                                <c:when test="${m.gender == '女'}">♀️ 女</c:when>
                                <c:otherwise>❓ ${m.gender}</c:otherwise>
                            </c:choose>
                        </div>
                        <div style="font-size: 12px; color: #8d99ae;">🎂 ${not empty m.birthday ? m.birthday : '未填'}</div>
                    </td>

                    <td style="padding: 25px 20px;">
                        <div style="font-size: 14px; color: #2b2d42; margin-bottom: 4px;">📱 ${m.phone}</div>
                        <div style="font-size: 12px; color: #4361ee;">📧 ${m.email}</div>
                    </td>

                    <td style="padding: 25px 20px;">
                        <c:choose>
                            <c:when test="${m.membershipLevel == 'VIP'}">
                                <span style="background: #fef3c7; color: #d97706; padding: 6px 14px; border-radius: 10px; font-size: 11px; font-weight: 700;">
                                    💎 VIP 會員
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span style="background: #dbeafe; color: #2563eb; padding: 6px 14px; border-radius: 10px; font-size: 11px; font-weight: 700;">
                                    👤 一般會員
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td style="padding: 25px 20px; border-radius: 0 15px 15px 0; text-align: center; min-width: 160px;">
                        <%-- ✅ 連結對齊：修改會員 (members_adminEdit.jsp) --%>
                        <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showEdit&memberId=${m.memberId}" 
                           class="action-btn"
                           style="background: #f0f4ff; color: #4361ee; padding: 10px 18px; border-radius: 10px; font-size: 13px; font-weight: 600; margin-right: 8px;">
                            編輯
                        </a>
                        <button type="button" class="action-btn" onclick="confirmDelete('${m.memberId}', '${m.username}')" 
                                style="background: #fff1f1; color: #ff4d4d; padding: 10px 18px; border-radius: 10px; font-size: 13px; font-weight: 600;">
                            刪除
                        </button>
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
        cancelButtonText: '返回',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = '${pageContext.request.contextPath}/MembersAdminServlet?action=delete&memberId=' + id;
        }
    })
}

// 處理通知訊息
const urlParams = new URLSearchParams(window.location.search);
const msg = urlParams.get('msg');
if (msg) {
    let title = '', text = '';
    if (msg === 'del_ok') { title = '已刪除！'; text = '該會員帳號已成功移除。'; }
    else if (msg === 'update_ok') { title = '更新成功！'; text = '會員資料已同步至資料庫。'; }
    else if (msg === 'add_ok') { title = '新增成功！'; text = '新會員已成功加入。'; }
    
    if (title) {
        Swal.fire({ title: title, text: text, icon: 'success', timer: 1500, showConfirmButton: false });
        // 清除 URL 中的 msg 參數，避免重整頁面時重複彈窗
        window.history.replaceState({}, document.title, window.location.pathname + "?action=dashboard");
    }
}
</script>
</body>
</html>