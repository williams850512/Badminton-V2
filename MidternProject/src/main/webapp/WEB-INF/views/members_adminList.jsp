<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 系統管理員清單</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root { 
            --primary: #164e63; 
            --accent: #2ec4b6; 
            --bg: #f8fafc; 
            --text-main: #475569; 
            --text-light: #64748b; 
        }
        body { font-family: 'Noto Sans TC', sans-serif; background-color: var(--bg); margin: 0; padding: 50px 20px; color: var(--text-main); }
        
        .main-container { max-width: 1260px; margin: auto; background: #ffffff; padding: 40px; border-radius: 28px; box-shadow: 0 10px 40px rgba(15, 23, 42, 0.04); }
        
        .page-title { 
            color: var(--primary); 
            margin: 0; 
            font-size: 30px; 
            letter-spacing: 3px; /* 標題間距加寬 */
            font-weight: 700;
        }

        .admin-table { width: 100%; border-collapse: separate; border-spacing: 0; margin-top: 30px; }
        .admin-table th { background: #f1f5f9; color: var(--text-light); padding: 18px 16px; text-align: left; font-weight: 700; text-transform: uppercase; font-size: 13px; letter-spacing: 1.5px; border-bottom: 2px solid #e2e8f0; }
        
        .admin-table td { padding: 26px 16px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; transition: 0.2s; }
        .admin-table tr:hover td { background-color: #fdfdfd; }
        
        /* 標籤樣式優化：拉開文字間距與增加內距 */
        .role-badge { 
            padding: 8px 18px; 
            border-radius: 12px; 
            font-size: 13px; 
            font-weight: 700; 
            display: inline-flex;
            align-items: center;
            letter-spacing: 2px; /* 增加文字間距，解決擁擠感 */
            gap: 0; /* 照你要求的，圖示與文字緊貼 */
        }
        .role-manager { background: #fff1f2; color: #be123c; border: 1px solid #ffe4e6; }
        .role-staff { background: #f0f9ff; color: #0369a1; border: 1px solid #e0f2fe; }
        
        /* 狀態膠囊優化 */
        .status-pill { 
            padding: 8px 16px; 
            border-radius: 50px; 
            font-size: 13px; 
            font-weight: 700; 
            display: flex; 
            align-items: center; 
            gap: 8px; 
            width: fit-content;
            letter-spacing: 1.5px; /* 增加文字間距 */
        }
        .status-active { background: #ecfdf5; color: #059669; }
        .status-inactive { background: #fef2f2; color: #dc2626; }
        .status-dot { width: 8px; height: 8px; border-radius: 50%; }
        
        .btn-add { background: var(--accent); color: white; padding: 14px 28px; border-radius: 14px; text-decoration: none; font-weight: 700; font-size: 15px; transition: 0.3s; box-shadow: 0 4px 12px rgba(46, 196, 182, 0.2); letter-spacing: 1px; }
        .btn-add:hover { background: #27ad9f; transform: translateY(-2px); box-shadow: 0 6px 18px rgba(46, 196, 182, 0.3); }
        
        .btn-edit { color: #4361ee; font-weight: 700; text-decoration: none; padding: 10px 15px; border-radius: 10px; transition: 0.2s; letter-spacing: 1px; }
        .btn-edit:hover { background: #eef2ff; color: #3046bc; }
        
        .info-group { line-height: 1.6; }
        /* 灰字加深，提升閱讀性 */
        .sub-text { font-size: 13px; color: #64748b; margin-top: 5px; letter-spacing: 0.8px; font-weight: 500; }
        .id-text { font-weight: 700; color: #94a3b8; font-family: monospace; font-size: 15px; }
    </style>
</head>
<body>

<div class="main-container">
    <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <div>
            <h2 class="page-title">🛡️系統管理員名單</h2>
        </div>
        <div style="display: flex; align-items: center; gap: 25px;">
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=dashboard" style="color: var(--text-main); text-decoration: none; font-size: 14px; font-weight: 700;">← 返回會員管理</a>
            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdminAdd" class="btn-add">+ 新增管理人員</a>
        </div>
    </header>

    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>帳號/姓名</th>
                <th>職位權限</th>
                <th>性別/生日</th>
                <th>聯絡資訊</th>
                <th>最近登入</th>
                <th>目前狀態</th>
                <th>管理操作</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="a" items="${adminList}">
                <tr>
                    <td class="id-text">#${a.adminId}</td>
                    <td>
                        <div class="info-group">
                            <div style="font-weight: 700; color: var(--primary); font-size: 18px; letter-spacing: 0.5px;">${a.username}</div>
                            <div class="sub-text">${a.fullName}</div>
                        </div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${a.role == 'manager'}">
                                <span class="role-badge role-manager">💼主管</span>
                            </c:when>
                            <c:otherwise>
                                <span class="role-badge role-staff">👤一般職員</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="info-group">
                            <div style="font-size: 15px; color: var(--primary); font-weight: 700;">
                                <c:choose>
                                    <c:when test="${a.gender == '男'}">♂ 男</c:when>
                                    <c:when test="${a.gender == '女'}">♀ 女</c:when>
                                    <c:otherwise>${a.gender}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="sub-text">
                                🎂 <fmt:formatDate value="${a.birthday}" pattern="yyyy-MM-dd"/>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="info-group">
                            <div style="font-size: 14px; font-weight: 700; color: var(--primary);">${a.phone}</div>
                            <div class="sub-text">${a.email}</div>
                        </div>
                    </td>
                    <td>
                        <div class="info-group">
                            <div style="font-size: 14px; color: var(--primary); font-weight: 600;">
                                <fmt:formatDate value="${a.lastLoginAt}" pattern="yyyy/MM/dd HH:mm"/>
                            </div>
                            <c:if test="${empty a.lastLoginAt}"><span style="font-size: 12px; color: #94a3b8; font-weight: 700;">尚未登入過</span></c:if>
                        </div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${a.status == 'active'}">
                                <div class="status-pill status-active"><span class="status-dot" style="background: #059669;"></span>啟用中</div>
                            </c:when>
                            <c:otherwise>
                                <div class="status-pill status-inactive"><span class="status-dot" style="background: #dc2626;"></span>停用中</div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <a href="${pageContext.request.contextPath}/MembersAdminServlet?action=showAdminEdit&id=${a.adminId}" class="btn-edit">編輯</a>
                            <span style="color: #e2e8f0;">|</span>
                            <button onclick="showNote('${a.fullName}', '${a.note}')" style="background:none; border:none; color: var(--text-main); cursor:pointer; font-size: 14px; font-family: inherit; font-weight: 700;">備註</button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script>
    function showNote(name, note) {
        Swal.fire({
            title: '<span style="font-size:20px; letter-spacing:2px; font-weight:700; color:#164e63;">' + name + ' 的備註資訊</span>',
            html: '<div style="text-align:left; padding: 15px; color:#475569; line-height: 2; font-size:15px; font-weight:500;">' + (note || '目前尚無相關備註資料。') + '</div>',
            icon: 'info',
            confirmButtonText: '確定',
            confirmButtonColor: '#164e63',
            customClass: { popup: 'border-radius-25' }
        });
    }
</script>

</body>
</html>