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
				    發布：<%= bean.getPublishAt() != null ? bean.getPublishAt() : "未設定" %><br>
				    下架：<%= bean.getExpireAt() != null ? bean.getExpireAt() : "未設定" %>
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

</body>
</html>