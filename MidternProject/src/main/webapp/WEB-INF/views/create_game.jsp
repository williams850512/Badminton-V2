<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🏸 發起羽球臨打揪團</title>
<jsp:include page="/WEB-INF/backendHead.jsp" />
<style>
   
    body { font-family: "Microsoft JhengHei", sans-serif; background-color: #f0f2f5; padding: 40px; }
    .form-container { max-width: 450px; margin: auto; background: white; padding: 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
    h2 { color: #1a73e8; text-align: center; margin-bottom: 25px; font-size: 24px; }
    .form-group { margin-bottom: 18px; }
    label { display: block; margin-bottom: 8px; font-weight: bold; color: #333; }
    select, input { width: 100%; padding: 12px; border: 1px solid #ccd0d5; border-radius: 10px; box-sizing: border-box; font-size: 16px; }
    input:focus, select:focus { border-color: #1a73e8; outline: none; box-shadow: 0 0 5px rgba(26,115,232,0.3); }
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
            
            <div class="card">
                <div class="form-container" style="box-shadow: none; padding: 15px;">
    
    <c:if test="${not empty msg}">
        <div style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border-radius: 8px; text-align: center; font-weight: bold; border: 1px solid #f5c6cb;">
            ⚠️ ${msg}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/pickup?action=createGame" method="post">
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
    // 處理日期：限制不能選過去的日期，並預設為今天
    const dateInput = document.getElementById('gameDate');
    const today = new Date();
    // 調整時區以取得正確的本地 YYYY-MM-DD
    const localToday = new Date(today.getTime() - (today.getTimezoneOffset() * 60000)).toISOString().split('T')[0];
    
    dateInput.setAttribute('min', localToday); // 讓過去的日期反灰
    if (!dateInput.value) {
        dateInput.value = localToday; // 預設填入今天
    }

    // 處理開始/結束時間連動
    const startTimeSelect = document.querySelector('select[name="startTime"]');
    const endTimeSelect = document.querySelector('select[name="endTime"]');

    function updateEndTimes() {
        const startStr = startTimeSelect.value;
        let firstValidOption = null;
        
        // 走訪每一個結束時間的選項
        Array.from(endTimeSelect.options).forEach(opt => {
            // 如果結束時間小於等於開始時間，則隱藏/停用該選項
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

        // 如果目前選取的結束時間變得不合法 (被停用)，自動切換到第一個合法的選項
        if (endTimeSelect.value <= startStr && firstValidOption) {
            firstValidOption.selected = true;
        }
    }

    // 當開始時間改變時，連動更新結束時間
    startTimeSelect.addEventListener("change", updateEndTimes);
    
    // 網頁載入時先執行一次，以防預設選取的狀態不正確
    updateEndTimes();
});
</script>

</body>
</html>