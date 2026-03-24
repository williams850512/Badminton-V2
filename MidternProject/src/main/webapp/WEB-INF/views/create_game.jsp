<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🏸 發起羽球臨打揪團</title>
<jsp:include page="/WEB-INF/backendHead.jsp" />
<style>
    .create-game-form .form-group { margin-bottom: 18px; }
    .create-game-form label { display: block; margin-bottom: 8px; font-weight: bold; color: #333; }
    .create-game-form select,
    .create-game-form input[type="date"] { width: 100%; padding: 12px; border: 1px solid #ccd0d5; border-radius: 10px; box-sizing: border-box; font-size: 16px; }
    .create-game-form input:focus,
    .create-game-form select:focus { border-color: #1a73e8; outline: none; box-shadow: 0 0 5px rgba(26,115,232,0.3); }
    .btn-submit { width: 100%; background: linear-gradient(135deg, #28a745, #218838); color: white; border: none; padding: 15px; border-radius: 10px; font-size: 18px; cursor: pointer; transition: 0.3s; font-weight: bold; margin-top: 10px; }
    .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(40,167,69,0.4); }
    .note { font-size: 0.85em; color: #666; margin-top: 5px; background: #e8f0fe; padding: 10px; border-radius: 5px; }
</style>
</head>
<body>
<div class="app-container">
    <jsp:include page="/WEB-INF/backendSidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/backendHeader.jsp" />
        
        <div class="content-body">
            <h2 style="margin-bottom: 20px; color: #333;">🏸 發起新揪團</h2>

            <!-- 搜尋訊息 -->
            <c:if test="${not empty searchMsg}">
                <div style="padding: 10px; margin-bottom: 15px; border-radius: 4px; ${searchMsg.contains('不到') ? 'background-color: #f8d7da; color: #721c24;' : 'background-color: #d4edda; color: #155724;'}">
                    ${searchMsg}
                </div>
            </c:if>

            <!-- 🔍 會員搜尋區塊 -->
            <div class="card" style="margin-bottom: 20px; padding: 20px; background-color: #f8f9fa; border-left: 5px solid #3498db;">
                <form action="${pageContext.request.contextPath}/pickup" method="get" style="display: flex; align-items: center; gap: 10px;">
                    <input type="hidden" name="action" value="goCreateGame">
                    <label style="font-weight: bold; margin: 0;">🔍 查詢會員：</label>
                    <input type="text" name="searchKeyword" class="form-control" style="width: 250px;" placeholder="輸入姓名 / 電話 / 會員編號" value="${param.searchKeyword}" required>
                    <button type="submit" class="btn btn-info" style="background-color: #17a2b8; color: white;">模糊搜尋</button>
                </form>
            </div>

            <div class="card">
                <div class="create-game-form" style="max-width: 500px; padding: 15px;">
    
    <c:if test="${not empty msg}">
        <div style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border-radius: 8px; text-align: center; font-weight: bold; border: 1px solid #f5c6cb;">
            ⚠️ ${msg}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/pickup?action=createGame" method="post">

        <!-- 會員名稱欄位 (第一欄) -->
        <div class="form-group">
            <label>會員名稱：</label>
            <c:choose>
                <c:when test="${not empty foundMembers}">
                    <select name="hostMemberId" style="width: 100%; padding: 12px; border: 1px solid #28a745; border-radius: 10px; background-color: #d4edda; font-size: 16px;" required>
                        <c:forEach var="m" items="${foundMembers}">
                            <option value="${m.memberId}">👤 ${m.fullName} (電話: ${m.phone})</option>
                        </c:forEach>
                    </select>
                    <div style="color: #2ecc71; font-weight: bold; font-size: 14px; margin-top: 5px;">✅ 已找到，請在選單中確認主揪會員</div>
                </c:when>
                <c:otherwise>
                    <input type="text" style="width: 100%; padding: 12px; border: 1px solid #ccd0d5; border-radius: 10px; background-color: #e9ecef; cursor: not-allowed;" value="" placeholder="等待搜尋..." readonly required>
                    <input type="hidden" name="hostMemberId" value="">
                    <div style="color: #e74c3c; font-size: 14px; margin-top: 5px;">(請先在上方輸入關鍵字尋找會員)</div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="form-group">
            <label>選擇球場：</label>
            <select name="courtId" required>
                <c:forEach var="court" items="${courts}">
                    <option value="${court.courtId}" ${param.courtId == court.courtId ? 'selected' : ''}>${court.displayName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>活動日期：</label>
            <input type="date" name="gameDate" id="gameDate" required value="${param.gameDate}">
        </div>

        <div class="form-group">
            <label>開始時間：</label>
            <select name="startTime" required>
                <c:forEach var="ts" items="${timeSlots}">
                    <option value="${ts.startTime}" ${param.startTime == ts.startTime ? 'selected' : ''}>${ts.startTime}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>預計結束：</label>
            <select name="endTime" required>
                <c:forEach var="ts" items="${timeSlots}">
                    <option value="${ts.endTime}" ${param.endTime == ts.endTime ? 'selected' : ''}>${ts.endTime}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
             <label>徵求球友人數 (不含主揪)：</label>
             <select name="neededPlayers" required>
             <option value="1" ${param.neededPlayers == '1' ? 'selected' : ''}>1 位 (總計 2 人)</option>
             <option value="2" ${param.neededPlayers == '2' ? 'selected' : ''}>2 位 (總計 3 人)</option>
             <option value="3" ${param.neededPlayers == '3' ? 'selected' : ''}>3 位 (總計 4 人)</option>
             <option value="4" ${param.neededPlayers == '4' ? 'selected' : ''}>4 位 (總計 5 人)</option>
             <option value="5" ${param.neededPlayers == '5' ? 'selected' : ''}>5 位 (總計 6 人)</option>
             <option value="6" ${param.neededPlayers == '6' ? 'selected' : ''}>6 位 (總計 7 人)</option>
             <option value="7" ${param.neededPlayers == '7' || empty param.neededPlayers ? 'selected' : ''}>7 位 (總計 8 人)</option>
             </select>
         <div class="note">
           ※ 系統會自動將您計入名單，選 7 位即代表該團上限為 8 人。
         </div>
        </div>

        <button type="submit" class="btn-submit">確認發起，立馬開團！</button>
        <div style="text-align: center; margin-top: 15px;">
            <a href="${pageContext.request.contextPath}/pickup" style="color: #6c757d; text-decoration: none; font-weight: bold;">← 返回首頁</a>
        </div>
    </form>
</div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const dateInput = document.getElementById('gameDate');
    const today = new Date();
    const localToday = new Date(today.getTime() - (today.getTimezoneOffset() * 60000)).toISOString().split('T')[0];
    
    dateInput.setAttribute('min', localToday);
    if (!dateInput.value) {
        dateInput.value = localToday;
    }

    const startTimeSelect = document.querySelector('select[name="startTime"]');
    const endTimeSelect = document.querySelector('select[name="endTime"]');

    function updateEndTimes() {
        const startStr = startTimeSelect.value;
        let firstValidOption = null;
        
        Array.from(endTimeSelect.options).forEach(opt => {
            if (opt.value <= startStr) {
                opt.disabled = true;
                opt.style.display = 'none';
            } else {
                opt.disabled = false;
                opt.style.display = '';
                if (!firstValidOption) {
                    firstValidOption = opt;
                }
            }
        });

        if (endTimeSelect.value <= startStr && firstValidOption) {
            firstValidOption.selected = true;
        }
    }

    startTimeSelect.addEventListener("change", updateEndTimes);
    updateEndTimes();
});
</script>

</body>
</html>