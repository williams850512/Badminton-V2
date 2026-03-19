<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球預約管理系統 - 場館列表</title>
<style>

    body{
         font-family: "微軟正黑體", Arial, sans-serif;
         padding: 30px;
    }
    
    table{
    	  border-collapse:collapse;
    	  width:60%;
    	  margin-top:20px;
    	  box-shadow:0 0 10px rgba(0,0,0,0.1);
    }
    
    tr,td{
          border: 1px solid #dddddd;
          padding: 12px;
          text-align: left;
    }
    
    th{
       background-color: #4CAF50;
       color: white;
    }
    
    tr:nth-child(even){
        background-color: #f9f9f9;
    }
    
    tr:hover { 
       background-color: #f1f1f1; 
    }
    
</style>
</head>
<body>
	<h2>🏸 隔壁老謙高級羽球館</h2>
	
	<!-- 成功訊息提示 -->
<c:if test="${param.message == 'insertSuccess'}">
    <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
        ✅ 新增場館成功！
    </div>
</c:if>
<c:if test="${param.message == 'updateSuccess'}">
    <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
        ✅ 修改場館成功！
    </div>
</c:if>
<c:if test="${param.message == 'deleteSuccess'}">
    <div style="background-color: #fff3cd; color: #856404; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
        ⚠️ 場館已停用！
    </div>
</c:if>
     <!-- 失敗訊息提示 -->
<c:if test="${param.message == 'insertFail'}">
    <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
        ❌ 新增失敗，請稍後再試！
    </div>
</c:if>
	
	<!-- 加入「新增場館」的按鈕，連結到 Servlet 並帶上 action=addForm 參數 -->
	<div style="margin-bottom: 15px;">
		<a href="${pageContext.request.contextPath}/VenuesServlet?action=addForm" 
		   style="background-color: #008CBA; color: white; padding: 10px 15px; text-decoration: none; border-radius: 4px; display: inline-block;">
		   ➕ 新增場館
		</a>
	</div>
	
	<table>
		<tr>
			<th>場館編號</th>
			<th>球館名稱</th>
			<th>場館地址</th>
			<th>聯絡電話</th>
			<th>目前狀態</th>
			<th>操作</th>
		</tr>
		
		<!-- 開始跑迴圈！ -->
        <!-- items="\${AllVenues}": 因為你在 Servlet 裡寫了 request.setAttribute("AllVenues", venuesList) -->
        <!-- var="v": 這是在迴圈裡我們給每一筆資料取的代號 (VenuesBean) -->
        <c:forEach var="v" items="${AllVenues}" >
        	<tr>
        		<td>${v.venueId}</td>
        		<td>${v.venueName}</td>
        		<td>${v.address}</td>
        		<td>${v.phone}</td>
        		<!-- 這裡用了一個 EL 的小技巧 (三元運算子) 來把 true/false 轉換成中文 -->
        		<td>${v.isActive ? '✅ 營業中' : '❌ 暫停營業'}</td>
        		<td>
        		<a href="${pageContext.request.contextPath}/VenuesServlet?action=editForm&venueId=${v.venueId}"><button>✏️編輯</button></a>
        		<form action="${pageContext.request.contextPath}/VenuesServlet?action=delete" method="post" style="display:inline;">
        		<input type="hidden" name="venueId" value="${v.venueId}">
        		<button type="submit" onclick="return confirm('確定要停用這間場館嗎?')">🚫 停用</button>
        		</form>
        		</td>
        	</tr>
        </c:forEach>
        
        
        
	</table>

</body>
</html>