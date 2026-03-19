<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🏸 羽球報名名單 - 專業演示版</title>
<style>
    /* 1. 基本底色與字體*/
    body { 
        font-family: "Microsoft JhengHei", "PingFang TC", sans-serif; 
        background-color: #f0f2f5; 
        margin: 0;
        padding: 20px;
    }

    /* 2. 容器設計：加上圓角與陰影，展現 Presentation 專業感 */
    .container { 
        max-width: 900px; 
        margin: 40px auto; 
        background: white; 
        padding: 40px; 
        border-radius: 15px; 
        box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
    }

    /* 3. 標題美化 */
    h2 { 
        color: #1a73e8; 
        text-align: center; 
        font-size: 28px;
        margin-bottom: 30px;
        border-bottom: 3px solid #e8f0fe;
        padding-bottom: 15px;
    }

    /* 4. 表格樣式：結構嚴謹 */
    table { 
        width: 100%; 
        border-collapse: collapse; 
        margin-top: 10px; 
    }

    /* 5. 表頭與儲存格 */
    th { 
        background-color: #007bff; 
        color: white; 
        font-weight: bold; 
        padding: 15px;
    }

    td { 
        padding: 14px; 
        border-bottom: 1px solid #dee2e6; 
        text-align: center; 
        color: #495057;
    }

    /* 6. 互動效果：滑鼠滑過變色 */
    tr:nth-child(even) { background-color: #f8f9fa; }
    tr:hover { background-color: #eef4ff; transition: 0.3s; }

    /* 7. 狀態標籤與按鈕樣式 */
    .status-tag {
        background-color: #d4edda;
        color: #155724;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 0.9em;
    }

    .btn-test {
        display: inline-block;
        background-color: #28a745;
        color: white;
        padding: 12px 25px;
        text-decoration: none;
        border-radius: 30px;
        font-weight: bold;
        box-shadow: 0 4px 10px rgba(40,167,69,0.3);
        transition: 0.3s;
    }
    
    .btn-test:hover {
        background-color: #218838;
        transform: translateY(-2px);
    }
</style>
</head>
<body>

<div class="container">
    <h2>🏸 羽球活動報名清單</h2>
    
    <table>
        <thead>
            <tr>
                <th>報名編號</th>
                <th>會員 ID</th>
                <th>狀態</th>
                <th>報名時間</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="signup" items="${signupList}">
                <tr>
                    <td><strong>${signup.signupId}</strong></td>
                    <td>${signup.memberId}</td>
                    <td><span class="status-tag">${signup.status}</span></td>
                    <td>${signup.signedUpAt}</td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty signupList}">
                <tr>
                    <td colspan="4" style="color: #999; padding: 40px;">目前尚無報名紀錄</td>
                </tr>
            </c:if>
        </tbody>
    </table>
    
    <hr style="margin: 40px 0; border: 0; border-top: 1px dashed #ccc;">
    
    <div style="text-align: center;">
        <p style="color: #666; font-size: 0.9em; margin-bottom: 15px;">
            【Presentation 演示區】模擬點擊「活動清單」中的報名按鈕
        </p>
        
        <a href="AddSignupServlet?gameId=5" class="btn-test">
            🏸 模擬報名第 5 場活動 (GameID: 5)
        </a>
    </div>

    <div style="text-align: center; margin-top: 40px;">
        <button onclick="history.back()" style="padding: 10px 20px; cursor: pointer; border-radius: 5px; border: 1px solid #ccc; background: white;">
            🔙 回上一頁
        </button>
    </div>
</div>

</body>
</html>