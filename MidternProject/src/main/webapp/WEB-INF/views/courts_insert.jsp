<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球預約管理系統 - 新增場地</title>
<jsp:include page="/WEB-INF/backendHead.jsp" />
</head>
<body>
	<div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />

        <div class="main-content">
            <jsp:include page="/WEB-INF/backendHeader.jsp" />

            <div class="content-body">
                <h2 style="margin-bottom: 20px; color: #333;">新增場地</h2>
                
                <div class="card">
    
    
    <div class="form-container">
        <!-- 這裡的 action 要對應到 Servlet，並且帶上 ?action=insert，且 method="post" -->
        <form action="${pageContext.request.contextPath}/CourtsServlet?action=insert" method="post">
        
        	<input type="hidden" name="venueId" value="${venueId}">
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: inline-block; width: 100px;">場地名稱：</label>
                <!-- 這裡的 name 屬性非常重要！Servlet 就是靠這個 name 來抓資料的 -->
                <input type="text" name="courtName" class="form-control" style="width: 300px;" required>
            </div>
            
            
            <button type="submit" class="btn btn-primary">🚀 確認新增</button>
            <a href="${pageContext.request.contextPath}/CourtsServlet?venueId=${venueId}" class="btn btn-warning" style="margin-left: 10px;">返回列表</a>
        </form>
    </div>
		</div>
			</div>
        </div>
    </div>
</body>
</html>
