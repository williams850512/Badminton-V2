<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>結帳成功</title>
<jsp:include page="/WEB-INF/backendHead.jsp" />
<style>
        .box { background: white; border-radius: 12px; padding: 40px; max-width: 500px; margin: auto; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        h1 { color: #27ae60; }
        .order-id { font-size: 2rem; font-weight: bold; color: #2c3e50; margin: 20px 0; }
        a { display: inline-block; margin-top: 20px; padding: 12px 24px; background: #3498db; color: white; text-decoration: none; border-radius: 8px; }
</style>
</head>
<body>
<div class="app-container">
    <jsp:include page="/WEB-INF/backendSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="/WEB-INF/backendHeader.jsp" />
        <div class="content-body" style="display: flex; justify-content: center; align-items: center; background: #f5f5f5;">
            <div class="box">
                    <h1>✅ 結帳成功！</h1>
                    <p>感謝您的購買，您的訂單已成功建立。</p>
                    <div class="order-id">訂單編號：#${orderId}</div>
                    <p>我們將盡快為您處理訂單。</p>
                    <a href="${pageContext.request.contextPath}/index.jsp">返回首頁</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>