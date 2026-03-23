<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <div class="sidebar-logo">
        Badminton
    </div>
    <ul class="sidebar-menu">
        <li><a href="#">會員管理</a></li>
        <li><a href="#">預約管理</a></li>
        <li><a href="#">臨打管理</a></li>
        <li class="active"><a href="<%=request.getContextPath()%>/ProductServlet?action=list">商品管理</a></li>
        <li><a href="#">訂單管理</a></li>
        <li><a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list">公告管理</a></li>
    </ul>
</div>