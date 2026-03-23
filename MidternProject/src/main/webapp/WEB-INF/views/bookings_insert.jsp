<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.LocalDate" %>
<%
    // 在 Server 端抓取伺服器當下的日期 (格式直接就是 YYYY-MM-DD)
    request.setAttribute("minDate", LocalDate.now().toString());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球預約管理系統 - 新增預約</title>
<jsp:include page="/WEB-INF/backendHead.jsp" />
</head>
<body>
<div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />

        <div class="main-content">
            <jsp:include page="/WEB-INF/backendHeader.jsp" />

            <div class="content-body">
                <h2 style="margin-bottom: 20px; color: #333;">新增預約</h2>
                
                <div class="card">
                
         <div class="form-container">
        <!-- 這裡的 action 要對應到 Servlet，並且帶上 ?action=insert，且 method="post" -->
        <form action="${pageContext.request.contextPath}/BookingsServlet?action=insert" method="post">
        
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px;">會員手機號碼：</label>
                <!-- 這裡的 name 屬性非常重要！Servlet 就是靠這個 name 來抓資料的 -->
                <input type="text" name="memberPhone" class="form-control" style="width: 300px;" placeholder="請輸入會員手機號碼" required>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px;">選擇場地：</label>
                <select name="courtId" class="form-control" style="width: 300px;" required>
                    <option value="">-- 請選擇想預約的場地 --</option>
                    <c:forEach var="c" items="${AllCourts}">
                        <option value="${c.courtId}">${c.courtName} (場地ID: ${c.courtId})</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px;">預約日期：</label>
                <!-- 直接利用從 JSP 算出來的 minDate 塞給 min 屬性 -->
                <input type="date" name="bookingDate" class="form-control" style="width: 300px;" required min="${minDate}">
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px;">開始時間：</label>
                <select name="startTime" class="form-control" style="width: 300px;" required>
                    <option value="">-- 請選擇開始時間 --</option>
                    <c:forEach var="slot" items="${AllTimeSlots}">
                        <option value="${slot.startTime}"> ${slot.startTime} </option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px;">結束時間：</label>
                <select name="endTime" class="form-control" style="width: 300px;" required>
                    <option value="">-- 請選擇結束時間 --</option>
                    <c:forEach var="slot" items="${AllTimeSlots}">
                        <option value="${slot.endTime}"> ${slot.endTime} </option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px;">訂單總額：</label>
                <input type="number" name="totalAmount" class="form-control" style="width: 300px;" min="0" required>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px; vertical-align: top;">備註：</label>
                <textarea name="note" class="form-control" style="width: 300px; height: 80px;" placeholder="如有需要請填寫備註"></textarea>
            </div>
            
            <div class="form-group" style="margin-bottom: 20px;">
                <button type="submit" class="btn btn-primary">🚀 確認新增</button>
                <a href="${pageContext.request.contextPath}/BookingsServlet" class="btn btn-warning" style="margin-left: 10px;">返回列表</a>
            </div>
            </form>
                </div>
			</div>
        </div>
    </div>
</div>

<script>
    // 監聽網頁載入完成
    document.addEventListener("DOMContentLoaded", function() {
        const startTimeSelect = document.querySelector('select[name="startTime"]');
        const endTimeSelect = document.querySelector('select[name="endTime"]');
        const amountInput = document.querySelector('input[name="totalAmount"]');
        const HOURLY_RATE = 400; // 設定每小時的費率為 400 元

        // 建立一個共用的計算函數
        function calculateAmount() {
            const startVal = startTimeSelect.value;
            const endVal = endTimeSelect.value;
            
            // 如果還沒選齊，就清空金額
            if (!startVal || !endVal) {
                amountInput.value = '';
                return;
            }
            
            // 抓出開頭的小時並轉為數字 (例如 "08:00:00" -> 8)
            const startHour = parseInt(startVal.split(':')[0], 10);
            const endHour = parseInt(endVal.split(':')[0], 10);
            
            // 防呆處理：結束時間必須大於開始時間
            if (endHour <= startHour) {
                alert("錯誤：結束時間必須晚於開始時間！");
                endTimeSelect.value = ''; // 清除錯誤選項
                amountInput.value = '';
                return;
            }
            
            // 計算總時數
            const duration = endHour - startHour;
            
            // 自動將結果寫入到總金額輸入框
            amountInput.value = duration * HOURLY_RATE;
        }

        // 兩個下拉選單有改變時，都會觸發重新計算
        startTimeSelect.addEventListener('change', calculateAmount);
        endTimeSelect.addEventListener('change', calculateAmount);
    });
</script>
</body>
</html>