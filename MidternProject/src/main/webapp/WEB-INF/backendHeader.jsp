<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.badminton.model.MembersAdminBean" %>
<%
    // 從 session 取出登入的管理員實體
    MembersAdminBean adminUser = (MembersAdminBean) session.getAttribute("adminUser");
    String empName = "我是測試管理員^^";
    
    // 若 session 中有登入資訊則顯示其姓名
    if (adminUser != null && adminUser.getFullName() != null && !adminUser.getFullName().isEmpty()) {
        empName = adminUser.getFullName(); 
    }
%>
<style>
    .profile-link {
        display: inline-flex;
        align-items: center;
        margin: 0 12px;
        color: #7f8c8d;
        transition: color 0.2s;
    }
    .profile-link:hover {
        color: #3498db;
    }
    .profile-icon {
        width: 22px;
        height: 22px;
    }
    .user-info {
        display: flex;
        align-items: center;
        font-size: 14px;
        color: #666;
    }
</style>
<div class="top-header">
    <div class="header-title">羽球館管理系統</div>
    <div class="user-info">
        HI! <%= empName %> 
        <% if (adminUser != null) { %>
            <a href="<%=request.getContextPath()%>/MembersAdminServlet?action=showAdminEdit&id=<%= adminUser.getAdminId() %>" class="profile-link" title="個人帳號設定">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="profile-icon">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
            </a>
        <% } else { %>
            <span style="margin: 0 12px;"></span>
        <% } %>
        | <a href="<%=request.getContextPath()%>/MembersAdminServlet?action=logout" style="color: #e74c3c; text-decoration: none; margin-left: 12px;">登出</a>
    </div>
</div>