<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <div class="sidebar-logo">
        Badminton
    </div>
    <ul class="sidebar-menu">
        <li><a href="#">會員管理</a></li>
        <li><a href="<%=request.getContextPath()%>/VenuesServlet?action=list">場館及場地管理</a></li>
        <li><a href="#">預約管理</a></li>
        <li><a href="#">臨打管理</a></li>
        <li><a href="#">商品管理</a></li>
        <li><a href="#">訂單管理</a></li>
        <li><a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list">公告管理</a></li>
    </ul>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // 取得當前網址的路徑 (例如：/MidternProject/VenuesServlet)
        const currentPath = window.location.pathname;
        
        // 移除所有預設的 active 狀態
        document.querySelectorAll('.sidebar-menu li').forEach(li => li.classList.remove('active'));
        
        // 根據網址來判斷目前在哪個 Servlet，並加上 active
        if (currentPath.includes('VenuesServlet') || currentPath.includes('CourtsServlet')) {
            const venueLink = document.querySelector('.sidebar-menu a[href*="VenuesServlet"]');
            if(venueLink) venueLink.parentElement.classList.add('active');
        } else if (currentPath.includes('AnnouncementServlet')) {
            const annLink = document.querySelector('.sidebar-menu a[href*="AnnouncementServlet"]');
            if(annLink) annLink.parentElement.classList.add('active');
        }
        // 未來如果有 MemberServlet, OrderServlet 等，可以繼續在這邊新增 else if
    });
</script>