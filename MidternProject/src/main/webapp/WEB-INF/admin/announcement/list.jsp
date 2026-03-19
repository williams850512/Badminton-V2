<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.badminton.model.AnnouncementBean" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>後台 - 公告管理</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn-add { display: inline-block; padding: 8px 15px; background-color: #007BFF; color: white; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>

    <h2>(後台) 公告管理列表 </h2>
    
	<a href="<%=request.getContextPath()%>/AnnouncementServlet?action=showAddForm" class="btn-add">新增公告</a>
	<form action="<%=request.getContextPath()%>/AnnouncementServlet" method="get" style="display:inline-block; margin-left: 15px;">
        <input type="hidden" name="action" value="list">
        <input type="text" name="keyword" placeholder="搜尋標題或內容..." 
               value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>"
               style="padding: 6px; width: 200px;">
        <button type="submit" style="padding: 6px 15px;">搜尋</button>
        <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list" style="margin-left: 5px; text-decoration: none; color: gray;">清除</a>
    </form>
    
    <table>
        <thead>
            <tr>
                <th>分類</th>
                <th>置頂</th>
                <th>標題</th>
                <th>內容</th>
                <th>建立時間</th>
                <th>排程</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
            <%
                // 1. 從 request 中抓取 Servlet 幫我們準備好的 announcementList
                List<AnnouncementBean> list = (List<AnnouncementBean>) request.getAttribute("announcementList");
                
                // 2. 判斷如果有資料，就把資料一筆一筆印出來
                if (list != null && !list.isEmpty()) {
                    for (AnnouncementBean bean : list) {
            %>
            <tr>
                <td><%= bean.getCategory() %></td>
                <td><%= bean.getIsPinned() ? " 是" : "否" %></td>
                <td><%= bean.getTitle() %></td>
                <td><%= bean.getContent() %></td>
                <td><%= bean.getCreatedAt() %></td>
                <td>
<%
    // 取得伺服器當下的時間
    java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
    java.sql.Timestamp pubAt = bean.getPublishAt();
    java.sql.Timestamp expAt = bean.getExpireAt();
    
    // 判斷邏輯開始
    if (expAt != null && now.after(expAt)) {
        // 情況 1：現在時間大於下架時間 -> 顯示「已下架」
        out.print("<span style='color: red; font-weight: bold;'>已下架</span><br>");
        out.print("<span style='font-size: 0.9em; color: gray;'>下架時間: " + String.valueOf(expAt).substring(0, 16) + "</span>");
        
    } else if (pubAt != null && now.before(pubAt)) {
        // 情況 2：現在時間小於發布時間 -> 顯示「排程中」與詳細時間
        out.print("<span style='color: #fd7e14; font-weight: bold;'>排程中</span><br>");
        out.print("<span style='font-size: 0.9em;'>發布: " + String.valueOf(pubAt).substring(0, 16) + "</span><br>");
        out.print("<span style='font-size: 0.9em;'>下架: " + (expAt != null ? String.valueOf(expAt).substring(0, 16) : "未設定") + "</span>");
        
    } else {
        // 情況 3：現在時間大於發布時間，且還沒到下架時間 (或根本沒設下架) -> 顯示「已發布」
        out.print("<span style='color: green; font-weight: bold;'>已發布</span><br>");
        if (expAt != null) {
            // 有設定下架時間，顯示時間
            out.print("<span style='font-size: 0.9em; color: gray;'>預計下架: " + String.valueOf(expAt).substring(0, 16) + "</span>");
        } else {
            // 【新增這段】沒有設定下架時間，顯示明確的文字
            out.print("<span style='font-size: 0.9em; color: gray;'>下架時間:未設定</span>");
        }
    }
%>
</td>
                <td>
                    <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=edit&id=<%= bean.getAnnouncementId() %>">編輯</a> | 

					<a href="<%=request.getContextPath()%>/AnnouncementServlet?action=delete&id=<%= bean.getAnnouncementId() %>" 
					   onclick="return confirm('確定要刪除【<%= bean.getTitle() %>】這筆公告嗎？刪除後無法復原喔！');">
					   刪除
					</a>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="7" style="text-align: center; color: #888;">目前沒有任何公告資料。</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
	<script>
	    // 設定每 XX 秒 (XX000 毫秒) 自動重新整理一次頁面
	    setTimeout(function() {
	        window.location.reload();
	    }, 5000);
	</script>
</body>
</html>