<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🏸 臨打管理</title>
<jsp:include page="/WEB-INF/backendHead.jsp" />
<style>
    /* 狀態標籤 */
    .status-tag {
        padding: 4px 12px;
        border-radius: 4px;
        font-size: 13px;
        font-weight: bold;
        display: inline-block;
    }
    .status-open { background: #d4edda; color: #155724; }
    .status-cancelled { background: #f8d7da; color: #721c24; }
    .status-full { background: #fff3cd; color: #856404; }
    .status-other { background: #e2e3e5; color: #383d41; }

    /* 搜尋列 */
    .toolbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
</style>
</head>
<body>
<div class="app-container">

    <jsp:include page="/WEB-INF/backendSidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/backendHeader.jsp" />

        <div class="content-body">
            <h2 style="color:#333; margin-bottom:20px;">臨打管理列表</h2>

            <c:if test="${not empty msg}">
                <script>
                    alert('${msg}');
                </script>
            </c:if>

            <div class="card">
                <div class="toolbar">
                    <a href="${pageContext.request.contextPath}/pickup?action=goCreateGame" class="btn btn-primary" style="background-color:#27ae60; font-size:15px;">
                        ＋ 新增揪團
                    </a>
                    <input type="text" id="searchInput" class="form-control" placeholder="輸入關鍵字" onkeyup="filterTable()" style="width:200px;">
                </div>

                <table class="table-custom" id="gameTable">
                    <thead>
                        <tr>
                            <th>編號</th>
                            <th>場地</th>
                            <th>日期</th>
                            <th>時段</th>
                            <th>人數</th>
                            <th>狀態</th>
                            <th>建立時間</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="game" items="${allGames}">
                            <tr>
                                <td>${game.gameId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty game.courtName}">${game.courtName}</c:when>
                                        <c:otherwise>場地 ${game.courtId}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${game.gameDate}</td>
                                <td>${game.startTime} - ${game.endTime}</td>
                                <td>${game.currentPlayers} / ${game.maxPlayers}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${game.status == 'open'}">
                                            <span class="status-tag status-open">開放中</span>
                                        </c:when>
                                        <c:when test="${game.status == 'cancelled'}">
                                            <span class="status-tag status-cancelled">已取消</span>
                                        </c:when>
                                        <c:when test="${game.status == 'full'}">
                                            <span class="status-tag status-full">已額滿</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-tag status-other">${game.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${game.createdAt}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/pickup?action=getSignupList&gameId=${game.gameId}" class="btn btn-primary" style="font-size:12px; padding:5px 10px;">
                                        檢視
                                    </a>
                                    <c:if test="${game.status == 'open'}">
                                        <a href="${pageContext.request.contextPath}/pickup?action=cancelGame&gameId=${game.gameId}"
                                           class="btn btn-danger" style="font-size:12px; padding:5px 10px;"
                                           onclick="return confirm('確定要取消此揪團嗎？');">
                                            取消
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty allGames}">
                    <p style="text-align:center; color:#888; padding:30px 0;">目前沒有任何臨打場次資料。</p>
                </c:if>
            </div>
        </div>
    </div>

</div>

<script>
function filterTable() {
    var input = document.getElementById("searchInput").value.toUpperCase();
    var table = document.getElementById("gameTable");
    var rows = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
    for (var i = 0; i < rows.length; i++) {
        var cells = rows[i].getElementsByTagName("td");
        var found = false;
        for (var j = 0; j < cells.length; j++) {
            if (cells[j].textContent.toUpperCase().indexOf(input) > -1) {
                found = true;
                break;
            }
        }
        rows[i].style.display = found ? "" : "none";
    }
}
</script>
</body>
</html>