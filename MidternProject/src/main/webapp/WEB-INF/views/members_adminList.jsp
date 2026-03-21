<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 系統管理員中心</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root { 
            --primary: #334155; 
            --admin-title: #0f172a; 
            --accent: #6366f1; 
            --bg: #f1f5f9; 
            --text-main: #1e293b; 
            --text-light: #64748b;
            --btn-blue: #f5f3ff; 
            --btn-blue-text: #7c3aed; 
            --btn-gray: #f8fafc;
            --btn-gray-text: #94a3b8;
            --table-head-bg: #e2e8f0; 
        }
        body { font-family: 'Noto Sans TC', sans-serif; background-color: var(--bg); margin: 0; padding: 50px 20px; color: var(--text-main); }
        .main-container { max-width: 1500px; margin: auto; background: #ffffff; padding: 40px; border-radius: 28px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06); border: 1px solid #e2e8f0; }
        
        .page-title-admin { 
            color: var(--admin-title); 
            margin: 0; font-size: 30px; letter-spacing: 2px; font-weight: 700; 
            display: flex; align-items: center; gap: 12px;
        }

        .search-container { display: flex; gap: 8px; align-items: center; background: #fff; padding: 4px; border-radius: 14px; border: 1px solid #e2e8f0; width: fit-content; }
        .search-input { padding: 10px 15px; border: none; width: 250px; outline: none; font-size: 14px; border-radius: 10px; }
        .btn-search { background: var(--primary); color: white; border: none; padding: 10px 20px; border-radius: 10px; cursor: pointer; font-weight: 700; font-size: 14px; transition: 0.3s; }
        .btn-search:hover { background: #1e293b; }
        .btn-clear { background: #f1f5f9; color: var(--text-light); text-decoration: none; padding: 10px 15px; border-radius: 10px; font-size: 13px; font-weight: 700; transition: 0.2s; display: inline-block; }
        
        .btn-add { background: var(--accent); color: white; padding: 12px 26px; border-radius: 12px; text-decoration: none; font-weight: 700; font-size: 14px; transition: 0.3s; box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2); display: flex; align-items: center; gap: 8px; }
        .btn-add:hover { background: #4f46e5; transform: translateY(-2px); }

        table { width: 100%; border-collapse: separate; border-spacing: 0 12px; margin-top: 20px; }
        th { padding: 18px 15px; background-color: var(--table-head-bg); color: #475569; font-size: 13px; text-transform: uppercase; font-weight: 800; text-align: left; }
        th:first-child { border-radius: 12px 0 0 12px; }
        th:last-child { border-radius: 0 12px 12px 0; }

        tr.admin-row { background: #ffffff; transition: 0.3s; }
        tr.admin-row:hover { background: #f5f3ff; transform: scale(1.002); box-shadow: 0 5px 15px rgba(0,0,0,0.05); }

        .id-text { font-weight: 700; color: #94a3b8; font-size: 16px; font-family: monospace; }
        .sub-text { font-size: 12px; color: var(--text-light); font-weight: 500; }

        .level-badge { padding: 6px 14px; border-radius: 10px; font-size: 11px; font-weight: 700; letter-spacing: 1px; display: inline-block; }
        .role-manager { background: #fff1f2; color: #be123c; border: 1px solid #ffe4e6; }
        .role-staff { background: #f0f9ff; color: #0369a1; border: 1px solid #e0f2fe; }
        
        .status-pill { padding: 8px 16px; border-radius: 50px; font-size: 12px; font-weight: 700; display: flex; align-items: center; gap: 8px; width: fit-content; margin: auto; }
        .status-dot { width: 7px; height: 7px; border-radius: 50%; display: inline-block; }
        .status-active { background: #ecfdf5; color: #059669; }
        .status-inactive { background: #fef2f2; color: #dc2626; }

        .action-container { display: flex; align-items: center; justify-content: center; gap: 8px; }
        .action-btn { padding: 8px 14px; border-radius: 10px; font-size: 13px; font-weight: 700; text-decoration: none; transition: 0.3s; border: none; cursor: pointer; }
        
        .btn-edit { background: var(--btn-blue); color: var(--btn-blue-text); }
        .btn-note { background: var(--btn-gray); color: var(--btn-gray-text); }
        .btn-del { background: #fff1f1; color: #ef4444; }
        
        /* 時間欄位樣式 */
        .time-text { font-size: 12px; color: #64748b; font-weight: 500; line-height: 1.4; }
    </style>
</head>
<body>
<%-- ✨ 強制設定時區為台北 (修正 8 小時時差) --%>
<fmt:setTimeZone value="GMT+8" />

<div class="main-container">
    <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid #e2e8f0; padding-bottom: 20px;">
        <h2 class="page-title-admin">🛡️ <span>系統管理員中心</span></h2>
        <div style="display: flex; align-items: center; gap: 20px;">
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard" style="color: var(--text-light); text-decoration: none; font-size: 14px; font-weight: 700;">← 返回會員管理</a>
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdminAdd" class="btn-add">+ 新增管理員</a>
        </div>
    </header>

    <div style="display: flex; justify-content: flex-start; align-items: center; margin-bottom: 30px;">
        <form action="${pageContext.request.contextPath}/MembersAdminServlet" method="get" class="search-container">
            <input type="hidden" name="action" value="searchAdmin">
            <input type="text" name="keyword" class="search-input" placeholder="搜尋 ID、帳號、姓名..." value="${param.keyword}">
            <button type="submit" class="btn-search">🔍 搜尋</button>
            <c:if test="${not empty param.keyword}">
                <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=listAdmins" class="btn-clear">✕ 清除</a>
            </c:if>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th style="width: 70px; padding-left: 25px;">ID</th>
                <th>帳號 / 姓名</th>
                <th>職位權限</th>
                <th>性別 / 生日</th>
                <th>聯絡資訊</th>
                <th>帳號創建時間</th> <%-- ✨ 新增欄位 --%>
                <th>最後登入</th>
                <th style="text-align: center;">目前狀態</th>
                <th style="text-align: center;">管理操作</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="a" items="${adminList}">
                <tr class="admin-row">
                    <td style="padding: 20px 25px; border-radius: 15px 0 0 15px;" class="id-text">#${a.adminId}</td>
                    <td>
                        <div style="font-weight: 700; color: #1e293b; font-size: 16px;">${a.username}</div>
                        <div class="sub-text">${a.fullName}</div>
                    </td>
                    <td>
                        <span class="level-badge ${a.role == 'manager' ? 'role-manager' : 'role-staff'}">
                            ${a.role == 'manager' ? '💼 主管' : '👤 一般職員'}
                        </span>
                    </td>
                    <td>
                        <div style="font-size: 14px; font-weight: 700; color: #475569;">${a.gender == '男' ? '♂ 男' : '♀ 女'}</div>
                        <div class="sub-text">🎂 <fmt:formatDate value="${a.birthday}" pattern="yyyy-MM-dd"/></div>
                    </td>
                    <td>
                        <div style="font-size: 14px; font-weight: 700;">📱 ${a.phone}</div>
                        <div class="sub-text">📧 ${a.email}</div>
                    </td>
                    <%-- ✨ 帳號創建時間單元格 --%>
                    <td class="time-text">
                        <c:choose>
                            <c:when test="${not empty a.createdAt}">
                                <fmt:formatDate value="${a.createdAt}" pattern="yyyy/MM/dd HH:mm" />
                            </c:when>
                            <c:otherwise><span style="color: #cbd5e1;">無紀錄</span></c:otherwise>
                        </c:choose>
                    </td>
                    <%-- ✨ 最後登入單元格 --%>
                    <td class="time-text">
                        <c:choose>
                            <c:when test="${not empty a.lastLoginAt}">
                                <strong style="color: var(--text-main);">
                                    <fmt:formatDate value="${a.lastLoginAt}" pattern="yyyy/MM/dd HH:mm"/>
                                </strong>
                            </c:when>
                            <c:otherwise>
                                <span style="color: var(--text-light); font-weight: 500;">尚未登入</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="text-align: center;">
                        <div class="status-pill ${a.status == 'active' ? 'status-active' : 'status-inactive'}">
                            <span class="status-dot" style="background: ${a.status == 'active' ? '#059669' : '#dc2626'};"></span>
                            ${a.status == 'active' ? '啟用中' : '停用'}
                        </div>
                    </td>
                    <td style="padding: 20px 25px; border-radius: 0 15px 15px 0; min-width: 220px;">
                        <div class="action-container">
                            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdminEdit&id=${a.adminId}" class="action-btn btn-edit">編輯</a>
                            <button onclick="showNote('${a.adminId}', '${a.fullName}', '${a.note}')" class="action-btn btn-note">備註</button>
                            <button onclick="confirmDeleteAdmin('${a.adminId}', '${a.username}')" class="action-btn btn-del">刪除</button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script>
    function showNote(id, name, currentNote) {
        Swal.fire({
            title: '<span style="font-size:20px; font-weight:700; color:var(--admin-title);">' + name + ' 的備註</span>',
            input: 'textarea',
            inputValue: (currentNote && currentNote !== 'null') ? currentNote : '',
            inputPlaceholder: '輸入備註',
            showCancelButton: true,
            confirmButtonText: '儲存更新',
            cancelButtonText: '取消',
            confirmButtonColor: '#334155',
            cancelButtonColor: '#94a3b8'
        }).then((result) => {
            if (result.isConfirmed) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/MembersAdminServlet';
                
                const params = {
                    'action': 'updateAdminNote',
                    'id': id,
                    'note': result.value
                };

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

    function confirmDeleteAdmin(id, username) {
        Swal.fire({
            title: '確定要刪除管理員嗎？',
            text: '您即將移除帳號「' + username + '」，此操作無法撤銷！',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#94a3b8',
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