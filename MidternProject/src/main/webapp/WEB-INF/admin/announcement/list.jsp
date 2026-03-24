<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.badminton.model.AnnouncementBean" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    String keyword = (String) request.getAttribute("keyword");
    String keywordParam = (keyword != null && !keyword.trim().isEmpty()) ? "&keyword=" + keyword : "";
    List<AnnouncementBean> list = (List<AnnouncementBean>) request.getAttribute("announcementList");
    
 	// 分頁設定
    int pageSize = 5; // 每頁顯示 5 筆
    int currentPage = 1;
    
    // 取得目前使用者點擊的頁數
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    // 計算總筆數與總頁數
    int totalItems = (list != null) ? list.size() : 0;
    int totalPages = (int) Math.ceil((double) totalItems / pageSize);
    if (totalPages == 0) totalPages = 1; // 就算沒資料也至少顯示第 1 頁
    
    // 確保當前頁數不超出範圍
    if (currentPage > totalPages) currentPage = totalPages;
    if (currentPage < 1) currentPage = 1;
    
    // 計算要從 List 抓取的起始索引與結束索引
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = Math.min(startIndex + pageSize, totalItems);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>公告管理</title>
    <jsp:include page="/WEB-INF/backendHead.jsp" />
</head>
<body>
    <div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />
        <div class="main-content">
            <jsp:include page="/WEB-INF/backendHeader.jsp" />
            <div class="content-body">
                <h2 style="margin-bottom: 20px; color: #333;">公告管理列表</h2>
                <div class="card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                        <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=showAddForm" class="btn btn-primary">＋ 新增公告</a>
                        
                        <form action="<%=request.getContextPath()%>/AnnouncementServlet" method="get">
                            <input type="hidden" name="action" value="list">
                            <input type="text" name="keyword" class="form-control"
                                   value="<%= keyword != null ? keyword : "" %>" 
                                   placeholder="輸入關鍵字" 
                                   onkeypress="if(event.keyCode === 13) { this.form.submit(); return false; }"
                                   onfocus="this.value=''">
                        </form>
                    </div>

                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="white-space: nowrap; width: 100px; text-align: center;">分類</th>
                                <th>標題</th>
                                <th>內容</th>
                                <th>建立時間</th>
                                <th>排程狀態</th>
                                <th>置頂</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (list != null && !list.isEmpty()) {
                                	for (int i = startIndex; i < endIndex; i++) {
                                        AnnouncementBean bean = list.get(i);
                            %>
                            <tr>
                                <td><span style="white-space: nowrap; background:#eef2f5; padding:4px 8px; border-radius:4px; font-size:12px;"><%= bean.getCategory() %></span></td>
                                <td><strong><%= bean.getTitle() %></strong></td>
                                <td style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= bean.getContent() %></td>
                                <td style="font-size: 13px; color: #777;"><%= bean.getCreatedAt() %></td>
                                <td style="font-size: 13px;">
                                    <%
                                        if ("draft".equals(bean.getStatus())) {
                                    %>
                                        <span style='color: #95a5a6; font-weight: bold;'>草稿</span>
                                    <%
                                        } else {
                                            long nowMs = System.currentTimeMillis();
                                            String publishText = (bean.getPublishAt() == null || bean.getPublishAt().getTime() <= nowMs) 
                                                ? "<span style='color: #27ae60; font-weight: bold;'>已發布</span>" 
                                                : sdf.format(bean.getPublishAt());
                                                
                                            String expireText = (bean.getExpireAt() == null) 
                                                ? "<span style='color: #3498db;'>永久發布</span>" 
                                                : (bean.getExpireAt().getTime() <= nowMs ? "<span style='color: #e74c3c; font-weight: bold;'>已下架</span>" : sdf.format(bean.getExpireAt()));
                                    %>
                                        上架：<%= publishText %><br>
                                        下架：<%= expireText %>
                                    <%
                                        }
                                    %>
                                </td>
                                <td><%= bean.getIsPinned() ? "是" : "否" %></td>
                                <td>
								    <div style="display: flex; flex-wrap: wrap; gap: 8px;">
								        <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=edit&id=<%= bean.getAnnouncementId() %>" class="btn btn-warning" style="padding: 4px 8px; font-size: 12px;">編輯</a>
								        <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=delete&id=<%= bean.getAnnouncementId() %>" class="btn btn-danger" style="padding: 4px 8px; font-size: 12px;" onclick="return confirm('確定要刪除嗎？ ヾ(;ﾟ;Д;ﾟ;)ﾉﾞ');">刪除</a>
								    </div>
								</td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr><td colspan="7" style="text-align: center; color: #999;">目前沒有任何公告資料</td></tr>
                            <% } %>
                        </tbody>
                    </table>
				    <div style="margin-top: 20px; text-align: center; font-size: 16px;">
				        
				        <%-- 顯示上一頁 --%>
				        <% if (currentPage > 1) { %>
				            <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list<%=keywordParam%>&page=<%=currentPage - 1%>" style="padding: 5px 10px; border: 1px solid #ccc; text-decoration: none; color: #333;">上一頁</a>
				        <% } %>
				
				        <%-- 顯示中間的頁碼 --%>
				        <% for (int i = 1; i <= totalPages; i++) { %>
				            <% if (i == currentPage) { %>
				                <span style="padding: 5px 10px; background-color: #007BFF; color: white; border: 1px solid #007BFF; font-weight: bold;"><%= i %></span>
				            <% } else { %>
				                <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list<%=keywordParam%>&page=<%= i %>" style="padding: 5px 10px; border: 1px solid #ccc; text-decoration: none; color: #333;"><%= i %></a>
				            <% } %>
				        <% } %>
				
				        <%-- 顯示下一頁 --%>
				        <% if (currentPage < totalPages) { %>
				            <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list<%=keywordParam%>&page=<%=currentPage + 1%>" style="padding: 5px 10px; border: 1px solid #ccc; text-decoration: none; color: #333;">下一頁</a>
				        <% } %>
				        
				        <div style="margin-top: 10px; font-size: 14px; color: #666;">
				            共 <%= totalItems %> 筆資料，目前在第 <%= currentPage %> / <%= totalPages %> 頁
				        </div>
				    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>