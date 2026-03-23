<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>🏸 尋找臨打揪團</title>
    <jsp:include page="/WEB-INF/backendHead.jsp" />
    <style>
        body { font-family: "Microsoft JhengHei", sans-serif; background: #f0f2f5; padding: 40px; }
        .list-container { max-width: 800px; margin: auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .game-item { display: flex; justify-content: space-between; align-items: center; padding: 20px; border-bottom: 1px solid #eee; transition: 0.3s; }
        .game-item:hover { background: #f9f9f9; }
        .btn-join { background: #28a745; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: bold; }
        .btn-join:hover { background: #218838; }
    </style>
</head>
<body>
<div class="app-container">
    <jsp:include page="/WEB-INF/backendSidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/backendHeader.jsp" />
        
        <div class="content-body">
            <h2 style="margin-bottom: 20px; color: #333;">🏸 目前開放中的揪團</h2>
            
            <div class="card">
                <div class="list-container" style="box-shadow: none; padding: 15px; margin: 0; max-width: none;">
    
    <c:forEach var="game" items="${allGames}">
        <div class="game-item">
            <div>
                <strong>📅 日期：${game.gameDate}</strong><br>
                ⏰ 時間：${game.startTime} - ${game.endTime}<br>
                📍 地點：${game.courtName}
            </div>
            <a href="${pageContext.request.contextPath}/pickup?action=addSignup&gameId=${game.gameId}" class="btn-join">我要報名</a>
        </div>
    </c:forEach>

    <c:if test="${empty allGames}">
        <p style="text-align: center; color: #888;">目前沒有任何開放中的揪團喔！</p>
    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>