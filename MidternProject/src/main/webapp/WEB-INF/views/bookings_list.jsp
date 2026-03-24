<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>預約查詢</title>
<jsp:include page="/WEB-INF/backendHead.jsp" />
</head>
<body>
	<div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />

        <div class="main-content">
            <jsp:include page="/WEB-INF/backendHeader.jsp" />

            <div class="content-body">
                <h2 style="margin-bottom: 20px; color: #333;">預約管理清單</h2>
                
                <div class="card">
    <!-- 成功訊息提示 -->
<c:if test="${param.message == 'insertSuccess'}">
    <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
        ✅ 新增預約成功！
    </div>
</c:if>
<c:if test="${param.message == 'updateSuccess'}">
    <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
        ✅ 修改預約成功！
    </div>
</c:if>
<c:if test="${param.message == 'deleteSuccess'}">
    <div style="background-color: #fff3cd; color: #856404; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
        ⚠️ 預約已取消！
    </div>
</c:if>
     <!-- 失敗訊息提示 -->
<c:if test="${param.message == 'insertFail'}">
    <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
        ❌ 新增失敗，請稍後再試！
    </div>
</c:if>

<!-- 加入「新增預約」的按鈕，連結到 Servlet 並帶上 action=addForm 參數 -->
	<div style="margin-bottom: 15px;">
		<a href="${pageContext.request.contextPath}/BookingsServlet?action=addForm" class="btn btn-primary">
		   ➕ 新增預約
		   </a>
    </div>
    
	<table class="table-custom">
		<tr>
			<th>預約編號</th>
			<th>會員姓名</th>
			<th>場館編號</th>
			<th>預約日期</th>
			<th>開始時間</th>
			<th>結束時間</th>
			<th>狀態</th>
			<th>金額</th>
			<th>備註</th>
			<th>操作</th>
		</tr>
		<!-- 開始跑迴圈！ -->
        <!-- items="\${AllBookings}": 因為你在 Servlet 裡寫了 request.setAttribute("AllBookings", bookingsList) -->
        <!-- var="b": 這是在迴圈裡我們給每一筆資料取的代號 (BookingsBean) -->
        <c:forEach var="b" items="${AllBookings}" >
        <tr>
        	<td>${b.bookingId}</td>
        	<td>${b.memberName}</td>
        	<td>${b.courtId}</td>
        	<td>${b.bookingDate}</td>
        	<td>${b.startTime}</td>
        	<td>${b.endTime}</td>
        	<td>${b.status}</td>
        	<td>${b.totalAmount}</td>
        	<td>${b.note}</td>
        	<td>
        		<form action="${pageContext.request.contextPath}/BookingsServlet?action=updateStatus" method="post" style="display:inline;">
        			<input type="hidden" name="bookingId" value="${b.bookingId}">
        			<input type="hidden" name="status" value="已取消">
        			<button type="submit" class="btn btn-danger" onclick="return confirm('確定要將這筆預約設為已取消嗎?')">取消預約</button>
        		</form>
        	</td>
        </tr>
		
		</c:forEach>
	</table>
    
    			</div>
			</div>
        </div>
    </div>


</body>
</html>