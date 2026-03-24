<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理首頁</title>
    <jsp:include page="/WEB-INF/backendHead.jsp" />
</head>
<body>
    <div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />

        <div class="main-content">
            <jsp:include page="/WEB-INF/backendHeader.jsp" />

            <div class="content-body">
                <div class="card">
                    <h2 style="margin-bottom: 15px;">商品管理</h2>
                    <p style="margin-bottom: 20px;">歡迎進入商品管理後台，您可以查看、新增、修改與刪除商品資料。</p>

                    <a class="btn btn-primary" href="<%=request.getContextPath()%>/ProductServlet?action=productList">查看商品列表</a>
                    <a class="btn btn-warning" href="<%=request.getContextPath()%>/ProductServlet?action=productInsertForm">新增商品</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>