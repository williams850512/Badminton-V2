<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.badminton.model.ProductBean" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品列表</title>
    <jsp:include page="/WEB-INF/backendHead.jsp" />
</head>
<body>
<%
    List<ProductBean> products = (List<ProductBean>) request.getAttribute("products");
    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) {
        keyword = "";
    }
%>

    <div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />

        <div class="main-content">
            <jsp:include page="/WEB-INF/backendHeader.jsp" />

            <div class="content-body">
                <div class="card">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h2>商品列表</h2>
                        <a class="btn btn-primary" href="<%=request.getContextPath()%>/ProductServlet?action=productInsertForm">新增商品</a>
                    </div>

                    <!-- 查詢表單 -->
                    <form action="<%=request.getContextPath()%>/ProductServlet" method="get" style="margin: 20px 0; display: flex; gap: 10px; align-items: center;">
                        <input type="hidden" name="action" value="searchProduct">
                        <input type="text" name="keyword" value="<%= keyword %>" placeholder="請輸入商品名稱、分類或品牌"
                               style="padding: 8px; width: 300px; border: 1px solid #ccc; border-radius: 6px;">
                        <button type="submit" class="btn btn-primary">查詢</button>
                        <a href="<%=request.getContextPath()%>/ProductServlet?action=productList" class="btn btn-secondary">顯示全部</a>
                    </form>

                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>商品ID</th>
                                <th>商品圖片</th>
                                <th>商品名稱</th>
                                <th>分類</th>
                                <th>品牌</th>
                                <th>價格</th>
                                <th>庫存</th>
                                <th>狀態</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (products != null && !products.isEmpty()) {
                                for (ProductBean product : products) {
                        %>
                            <tr>
                                <td><%= product.getProductId() %></td>
                                <td>
                                    <%
                                        String imageUrl = product.getImageUrl();

                                        if (imageUrl == null || imageUrl.trim().isEmpty()) {
                                            imageUrl = "images/default.png";
                                        }
                                    %>
                                    <img src="<%= request.getContextPath() + "/" + imageUrl %>" width="100">
                                </td>
                                <td><%= product.getProductName() %></td>
                                <td><%= product.getCategory() %></td>
                                <td><%= product.getBrand() == null ? "" : product.getBrand() %></td>
                                <td><%= product.getPrice() %></td>
                                <td><%= product.getStockQty() %></td>
                                <td><%= product.getStatus() %></td>
                                <td>
                                    <a class="btn btn-warning" href="<%=request.getContextPath()%>/ProductServlet?action=productUpdateForm&productId=<%=product.getProductId()%>">修改</a>

                                    <form action="<%=request.getContextPath()%>/ProductServlet" method="post" style="display:inline-block;" onsubmit="return confirm('確定要刪除這筆商品嗎？');">
                                        <input type="hidden" name="action" value="productDelete">
                                        <input type="hidden" name="productId" value="<%=product.getProductId()%>">
                                        <button type="submit" class="btn btn-danger">刪除</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="9" style="text-align: center;">目前沒有商品資料</td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>