<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新增商品</title>
    <jsp:include page="/WEB-INF/backendHead.jsp" />
</head>
<body>
    <div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />

        <div class="main-content">
            <jsp:include page="/WEB-INF/backendHeader.jsp" />

            <div class="content-body">
                <div class="card">
                    <h2 style="margin-bottom: 20px;">新增商品</h2>

                    <form action="<%=request.getContextPath()%>/ProductServlet" method="post">
                        <input type="hidden" name="action" value="productInsert">

                        <table style="width:100%;">
                            <tr>
                                <td style="padding:10px;">商品名稱</td>
                                <td style="padding:10px;"><input class="form-control" type="text" name="productName" required></td>
                            </tr>
                            <tr>
                                <td style="padding:10px;">分類</td>
                                <td style="padding:10px;"><input class="form-control" type="text" name="category" required></td>
                            </tr>
                            <tr>
                                <td style="padding:10px;">品牌</td>
                                <td style="padding:10px;"><input class="form-control" type="text" name="brand"></td>
                            </tr>
                            <tr>
                                <td style="padding:10px;">價格</td>
                                <td style="padding:10px;"><input class="form-control" type="number" step="0.01" name="price" required></td>
                            </tr>
                            <tr>
                                <td style="padding:10px;">庫存</td>
                                <td style="padding:10px;"><input class="form-control" type="number" name="stockQty" required></td>
                            </tr>
                            <tr>
                                <td style="padding:10px;">描述</td>
                                <td style="padding:10px;"><input class="form-control" type="text" name="description"></td>
                            </tr>
                            <tr>
                                <td style="padding:10px;">圖片網址</td>
                                <td style="padding:10px;"><input class="form-control" type="text" name="imageUrl"></td>
                            </tr>
                            <tr>
                                <td style="padding:10px;">狀態</td>
                                <td style="padding:10px;">
                                    <select class="form-control" name="status">
                                        <option value="active">active</option>
                                        <option value="inactive">inactive</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding:10px;">建立日期</td>
                                <td style="padding:10px;"><input class="form-control" type="date" name="productCreateAt"></td>
                            </tr>
                        </table>

                        <div style="margin-top: 20px;">
                            <button type="submit" class="btn btn-primary">新增商品</button>
                            <a class="btn btn-warning" href="<%=request.getContextPath()%>/ProductServlet?action=productList">返回列表</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>