<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 假設登入成功時，有把員工姓名存在 session 中，屬性名稱叫做 "empName"
    // (如果屬性名稱不同，例如 "employeeName" 或 "admin", 請自行替換字)
    String empName = (String) session.getAttribute("empName");
    
    // 防呆機制：如果 session 過期或沒登入直接進來，給個預設值
    if (empName == null || empName.isEmpty()) {
        empName = "我是測試管理員^^"; 
    }
%>
<div class="top-header">
    <div class="header-title">羽球館管理系統</div>
    <div class="user-info">
    	<% // 這邊待修改登入人員!! %>
        HI! <%= empName %> | <a href="<%=request.getContextPath()%>/LogoutServlet" style="color: #e74c3c; text-decoration: none;">登出</a>
    </div>
</div>