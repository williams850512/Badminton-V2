<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🏸 羽球活動報名名單</title>
<style>
    body { font-family: "Microsoft JhengHei", sans-serif; background-color: #f8f9fa; padding: 30px; }
    .container { max-width: 800px; margin: auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
    h2 { text-align: center; color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th { background-color: #007bff; color: white; padding: 12px; }
    td { border-bottom: 1px solid #ddd; padding: 12px; text-align: center; }
    .status-host { color: #d9534f; font-weight: bold; } /* 主揪紅色 */
    .status-player { color: #5cb85c; font-weight: bold; } /* 會員B綠色 */
    .empty-msg { text-align: center; color: #888; padding: 50px; }
</style>
</head>
<body>

<div class="container">
    <h2>🏸 羽球活動報名名單 (場次 ID: ${currentGameId})</h2>

    <c:if test="${not empty msg}">
        <div style="color: blue; text-align: center; margin-bottom: 10px;">${msg}</div>
    </c:if>

    <table>
        <thead>
            <tr>
                <th>報名編號</th>
                <th>會員 ID</th>
                <th>角色狀態</th>
                <th>報名時間</th>
            </tr>
        </thead>
        <tbody>
      <c:forEach var="signup" items="${signupList}">
    <tr>
        <td>${signup.memberName}</td> 
        
        <td>${signup.memberId}</td>
        
        <td>
            <c:choose>
                <c:when test="${signup.status == 'host'}">👑 主揪發起</c:when>
                <c:otherwise>🏸 臨打成員</c:otherwise>
            </c:choose>
        </td>
        
        <td>${signup.signedUpAt}</td>
    </tr>
</c:forEach>
            <c:if test="${empty signupList}">
                <tr><td colspan="4" class="empty-msg">目前尚無報名紀錄</td></tr>
            </c:if>
        </tbody>
    </table>

    <div style="text-align: center; margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/GoCreateGame" style="text-decoration: none; color: #666;">← 返回發起活動</a>
    </div>
</div>

</body>
</html>