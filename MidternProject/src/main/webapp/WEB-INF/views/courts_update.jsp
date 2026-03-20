<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>羽球預約管理系統 - 修改場館資料</title>
<style>
    body { font-family: "微軟正黑體", Arial, sans-serif; padding: 30px; }
    .form-container {
        width: 400px;
        padding: 20px;
        border: 1px solid #ccc;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
    .form-group input { width: 100%; padding: 8px; box-sizing: border-box; }
    .btn { background-color: #4CAF50; color: white; padding: 10px 15px; border: none; cursor: pointer; border-radius: 4px; }
    .btn:hover { background-color: #45a049; }
</style>
</head>
<body>

    <h2>🏸 修改場地資料</h2>
    
    <div class="form-container">
        <!-- 這裡的 action 要對應到 Servlet，並且帶上 ?action=insert，且 method="post" -->
        <form action="${pageContext.request.contextPath}/CourtsServlet?action=update" method="post">
            <input type="hidden" name="courtId" value="${court.courtId}">
			<input type="hidden" name="venueId" value="${court.venueId}">
            
            <div class="form-group">
                <label>場地名稱：</label>
                <!-- 這裡的 name 屬性非常重要！Servlet 就是靠這個 name 來抓資料的 -->
                <input type="text" name="courtName" value="${court.courtName}" required>
            </div>
            
            
            <div class="form-group">
                <label>營業狀態：</label>
                <select name="isActive">
                <option value="true" ${court.isActive ? 'selected' : ''}>✅ 營業中</option>
                <option value="false" ${!court.isActive ? 'selected' : ''}>❌ 暫停營業</option>
                </select>
            </div>
            
            <button type="submit" class="btn">🚀 確認修改</button>
            <a href="${pageContext.request.contextPath}/CourtsServlet?venueId=${court.venueId}" style="margin-left: 10px;">返回列表</a>
        </form>
    </div>

</body>
</html>
