<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>羽球館 | 會員管理後台</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body style="font-family: 'Noto Sans TC', sans-serif; background-color: #f0f2f5; margin: 0; padding: 40px 20px;">

<div style="max-width: 1200px; margin: auto; background: #ffffff; padding: 40px; border-radius: 24px; box-shadow: 0 15px 35px rgba(0,0,0,0.05);">
    
    <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; border-bottom: 2px solid #f8f9fa; padding-bottom: 20px;">
        <h2 style="font-size: 28px; margin: 0; color: #1a237e; display: flex; align-items: center; gap: 12px;">
            🏸 <span style="letter-spacing: 1px;">會員帳號管理中心</span>
        </h2>
        <a href="profile.jsp" style="color: #8d99ae; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s;" 
           onmouseover="this.style.color='#4361ee'" onmouseout="this.style.color='#8d99ae'">
            ← 返回個人中心
        </a>
    </header>

    <table style="width: 100%; border-collapse: separate; border-spacing: 0 15px;">
        <thead>
            <tr style="text-align: left;">
                <th style="padding: 0 20px; color: #8d99ae; font-size: 13px; text-transform: uppercase; width: 60px;">ID</th>
                <th style="padding: 0 20px; color: #8d99ae; font-size: 13px;">帳號/姓名</th>
                <th style="padding: 0 20px; color: #8d99ae; font-size: 13px;">性別/生日</th>
                <th style="padding: 0 20px; color: #8d99ae; font-size: 13px;">聯絡資訊</th>
                <th style="padding: 0 20px; color: #8d99ae; font-size: 13px;">權限等級</th>
                <th style="padding: 0 20px; color: #8d99ae; font-size: 13px; text-align: center;">管理操作</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="m" items="${memberList}">
                <tr style="background: #ffffff; box-shadow: 0 2px 10px rgba(0,0,0,0.03); border: 1px solid #f1f3f5;">
                    <td style="padding: 25px 20px; border-radius: 15px 0 0 15px; font-weight: 700; color: #ced4da; font-size: 18px;">
                        # ${m.memberId}
                    </td>
                    
                    <td style="padding: 25px 20px;">
                        <div style="font-weight: 700; color: #2b2d42; font-size: 16px;">${m.username}</div>
                        <div style="font-size: 13px; color: #8d99ae;">${m.name}</div>
                    </td>

                    <td style="padding: 25px 20px;">
                        <div style="font-size: 14px; color: #2b2d42; margin-bottom: 4px;">
                            <c:choose>
                                <c:when test="${m.gender == '男'}">♂️ 男</c:when>
                                <c:when test="${m.gender == '女'}">♀️ 女</c:when>
                                <c:otherwise>❓ ${m.gender}</c:otherwise>
                            </c:choose>
                        </div>
                        <div style="font-size: 12px; color: #8d99ae;">🎂 ${m.birthday != null ? m.birthday : '尚未填寫'}</div>
                    </td>

                    <td style="padding: 25px 20px;">
                        <div style="font-size: 14px; color: #2b2d42; margin-bottom: 4px;">📱 ${m.phone}</div>
                        <div style="font-size: 12px; color: #4361ee;">📧 ${m.email}</div>
                    </td>

                    <td style="padding: 25px 20px;">
                        <c:choose>
                            <c:when test="${m.role == 'admin'}">
                                <span style="background: #fee2e2; color: #ef4444; padding: 6px 14px; border-radius: 10px; font-size: 11px; font-weight: 700;">
                                    🛡️ 管理員
                                </span>
                            </c:when>
                            <c:when test="${m.role == 'vip'}">
                                <span style="background: #fef3c7; color: #d97706; padding: 6px 14px; border-radius: 10px; font-size: 11px; font-weight: 700;">
                                    💎 VIP
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span style="background: #dbeafe; color: #2563eb; padding: 6px 14px; border-radius: 10px; font-size: 11px; font-weight: 700;">
                                    👤 一般
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td style="padding: 25px 20px; border-radius: 0 15px 15px 0; text-align: center; min-width: 160px;">
                        <a href="MembersServlet?action=edit&id=${m.memberId}" 
                           style="background: #f0f4ff; color: #4361ee; padding: 10px 18px; border-radius: 10px; text-decoration: none; font-size: 13px; font-weight: 600; margin-right: 8px; transition: 0.3s; display: inline-block;">
                            編輯
                        </a>
                        <button type="button" onclick="confirmDelete('${m.memberId}', '${m.username}')" 
                                style="background: #fff1f1; color: #ff4d4d; padding: 10px 18px; border-radius: 10px; border: none; font-size: 13px; font-weight: 600; cursor: pointer; transition: 0.3s;">
                            刪除
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script>
function confirmDelete(id, name) {
    Swal.fire({
        title: '確定要刪除嗎？',
        text: "你即將移除會員「" + name + "」，此動作無法復原！",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ff4d4d',
        cancelButtonColor: '#adb5bd',
        confirmButtonText: '刪除',
        cancelButtonText: '返回',
        reverseButtons: true,
        borderRadius: '16px'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = 'MembersServlet?action=delete&id=' + id;
        }
    })
}

const urlParams = new URLSearchParams(window.location.search);
if (urlParams.get('msg') === 'del_ok') {
    Swal.fire({
        title: '已刪除！',
        text: '該會員帳號已成功移除。',
        icon: 'success',
        timer: 2000,
        showConfirmButton: false,
        borderRadius: '16px'
    });
    window.history.replaceState({}, document.title, window.location.pathname);
}
</script>

</body>
</html>