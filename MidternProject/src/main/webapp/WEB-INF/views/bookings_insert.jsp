<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                
                <!-- 顯示搜尋訊息 -->
                <c:if test="${not empty msg}">
                    <div style="padding: 10px; margin-bottom: 15px; border-radius: 4px; ${msg.contains('不到') ? 'background-color: #f8d7da; color: #721c24;' : 'background-color: #d4edda; color: #155724;'}">
                        ${msg}
                    </div>
                </c:if>
                <c:if test="${param.message == 'missingMember'}">
                    <div style="padding: 10px; margin-bottom: 15px; background-color: #f8d7da; color: #721c24; border-radius: 4px;">
                        錯誤：無法新增，請先使用上方搜尋帶入會員編號！
                    </div>
                </c:if>

                <div class="card" style="margin-bottom: 20px; padding: 20px; background-color: #f8f9fa; border-left: 5px solid #3498db;">
                    <form action="${pageContext.request.contextPath}/BookingsServlet" method="get" style="display: flex; align-items: center; gap: 10px;">
                        <input type="hidden" name="action" value="addForm">
                        <label style="font-weight: bold; margin: 0;">🔍 查詢會員：</label>
                        <input type="text" name="searchKeyword" class="form-control" style="width: 250px;" placeholder="輸入姓名 / 電話 / 會員編號" value="${param.searchKeyword}" required>
                        <button type="submit" class="btn btn-info" style="background-color: #17a2b8; color: white;">模糊搜尋</button>
                    </form>
                </div>
                
                <div class="card">
                
         <div class="form-container">
        <!-- 這裡的 action 要對應到 Servlet，並且帶上 ?action=insert，且 method="post" -->
        <form action="${pageContext.request.contextPath}/BookingsServlet?action=insert" method="post">
        
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px; font-weight: bold;">會員姓名：</label>
                
                <c:choose>
                    <c:when test="${not empty foundMembers}">
                        <select name="memberId" class="form-control" style="width: 250px; display: inline-block; background-color: #d4edda; border-color: #28a745;" required>
                            <c:forEach var="m" items="${foundMembers}">
                                <option value="${m.memberId}">👤 ${m.fullName} (電話: ${m.phone})</option>
                            </c:forEach>
                        </select>
                        <span style="margin-left: 10px; color: #2ecc71; font-weight: bold; font-size: 14px;">已找到，請在選單中確認</span>
                    </c:when>
                    <c:otherwise>
                        <input type="text" class="form-control" style="width: 250px; background-color: #e9ecef; cursor: not-allowed; display: inline-block;" value="" placeholder="等待搜尋..." readonly required>
                        <!-- 防呆：沒有搜尋結果時送出空值給後端擋下 -->
                        <input type="hidden" name="memberId" value="">
                        <span style="margin-left: 10px; color: #e74c3c; font-size: 14px;">(請先在上方輸入關鍵字尋找會員)</span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px;">選擇球館：</label>
                <select id="venueSelect" class="form-control" style="width: 300px;" required>
                    <option value="">-- 請選擇球館 --</option>
                    <c:forEach var="v" items="${AllVenues}">
                        <option value="${v.venueId}">${v.venueName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px;">選擇場地：</label>
                <select name="courtId" id="courtSelect" class="form-control" style="width: 300px;" required disabled>
                    <option value="">-- 請先選擇球館 --</option>
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
                        <option value="${slot.startTime}"> ${fn:substring(slot.startTime, 0, 5)} </option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 120px;">結束時間：</label>
                <select name="endTime" class="form-control" style="width: 300px;" required>
                    <option value="">-- 請選擇結束時間 --</option>
                    <c:forEach var="slot" items="${AllTimeSlots}">
                        <option value="${slot.endTime}"> ${fn:substring(slot.endTime, 0, 5)} </option>
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
        const venueSelect = document.getElementById('venueSelect');
        const courtSelect = document.getElementById('courtSelect');
        const startTimeSelect = document.querySelector('select[name="startTime"]');
        const endTimeSelect = document.querySelector('select[name="endTime"]');
        const amountInput = document.querySelector('input[name="totalAmount"]');
        const HOURLY_RATE = 400; // 設定每小時的費率為 400 元

        // ===== 球館切換 → AJAX 載入場地 =====
        venueSelect.addEventListener('change', function() {
            const venueId = this.value;

            // 清空場地選單並禁用
            courtSelect.innerHTML = '<option value="">-- 載入中... --</option>';
            courtSelect.disabled = true;

            if (!venueId) {
                courtSelect.innerHTML = '<option value="">-- 請先選擇球館 --</option>';
                return;
            }

            // 發送 AJAX 請求
            fetch('${pageContext.request.contextPath}/BookingsServlet?action=getCourtsByVenue&venueId=' + venueId)
                .then(response => response.json())
                .then(courts => {
                    courtSelect.innerHTML = '<option value="">-- 請選擇場地 --</option>';
                    courts.forEach(c => {
                        const option = document.createElement('option');
                        option.value = c.courtId;
                        option.textContent = c.courtName;
                        courtSelect.appendChild(option);
                    });
                    courtSelect.disabled = false;
                })
                .catch(error => {
                    console.error('載入場地失敗:', error);
                    courtSelect.innerHTML = '<option value="">-- 載入失敗，請重試 --</option>';
                });
        });
        // =====================================

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