<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                <label style="display: inline-block; width: 100px;">會員手機號碼：</label>
                <!-- 這裡的 name 屬性非常重要！Servlet 就是靠這個 name 來抓資料的 -->
                <input type="text" name="memberPhone" class="form-control" style="width: 300px;" placeholder="請輸入會員手機號碼" required>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 100px;">選擇場地：</label>
                <select name="courtId" class="form-control" style="width: 300px;" required>
                    <option value="">-- 請選擇想預約的場地 --</option>
                    <c:forEach var="c" items="${AllCourts}">
                        <option value="${c.courtId}">${c.courtName} (場地ID: ${c.courtId})</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 100px;">預約日期：</label>
                <!-- 強烈推薦：使用 HTML5 內建的 type="date" 就能直接獲得一個很生動的日曆選擇器！ -->
                <input type="date" name="bookingDate" class="form-control" style="width: 300px;" required>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 100px;">開始時間：</label>
                <!-- 同理：使用 type="time" 就能直接獲得時間選擇滑輪！ -->
                <input type="time" name="startTime" class="form-control" style="width: 300px;" required>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 100px;">結束時間：</label>
                <input type="time" name="endTime" class="form-control" style="width: 300px;" required>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 100px;">訂單總額：</label>
                <input type="number" name="totalAmount" class="form-control" style="width: 300px;" min="0" required>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 100px; vertical-align: top;">備註：</label>
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
</body>
</html>