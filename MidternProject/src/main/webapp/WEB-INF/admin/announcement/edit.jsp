<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.badminton.model.AnnouncementBean" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>編輯公告 - 後台管理</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input[type="text"], input[type="datetime-local"], select, textarea { width: 100%; max-width: 500px; padding: 8px; box-sizing: border-box; }
        textarea { height: 150px; resize: vertical; }
        .btn-submit { padding: 10px 20px; background-color: #ffc107; color: #333; border: none; cursor: pointer; border-radius: 4px; font-size: 16px; font-weight:bold;}
        .btn-submit:hover { background-color: #e0a800; }
        .btn-cancel { text-decoration: none; color: #555; margin-left: 10px; }
    </style>
</head>
<body>

    <h2>編輯公告</h2>

    <% 
        AnnouncementBean bean = (AnnouncementBean) request.getAttribute("announcement"); 
        if(bean != null) {
            
            // 【關鍵處理】：把資料庫撈出來的 Timestamp 轉換成 HTML 看得懂的 T 格式
            String pubTime = "";
            if (bean.getPublishAt() != null) {
                // 將 "2024-05-20 14:30:00.0" 轉成 "2024-05-20T14:30"
                pubTime = bean.getPublishAt().toString().replace(" ", "T").substring(0, 16);
            }
            
            String expTime = "";
            if (bean.getExpireAt() != null) {
                expTime = bean.getExpireAt().toString().replace(" ", "T").substring(0, 16);
            }
    %>

    <form action="<%=request.getContextPath()%>/AnnouncementServlet?action=update" method="post" onsubmit="return validateForm()">
        
        <input type="hidden" name="announcementId" value="<%= bean.getAnnouncementId() %>">

        <div class="form-group">
            <label for="title">公告標題：</label>
            <input type="text" id="title" name="title" required value="<%= bean.getTitle() %>">
        </div>

        <div class="form-group">
            <label for="category">公告分類：</label>
            <select id="category" name="category">
                <option value="一般公告" <%= "一般公告".equals(bean.getCategory()) ? "selected" : "" %>>一般公告</option>
                <option value="活動消息" <%= "活動消息".equals(bean.getCategory()) ? "selected" : "" %>>活動消息</option>
                <option value="緊急公告" <%= "緊急公告".equals(bean.getCategory()) ? "selected" : "" %>>緊急公告</option>
                <option value="系統公告" <%= "系統公告".equals(bean.getCategory()) ? "selected" : "" %>>系統公告</option>
            </select>
        </div>

        <div class="form-group">
		    <label for="status">發布狀態：</label>
		    <select id="status" name="status">
		        <% 
		            // 取得現在時間
		            java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
		            boolean isFuture = bean.getPublishAt() != null && bean.getPublishAt().after(now);
		            String currentStatus = bean.getStatus();
		        %>
		        
		        <%-- 如果時間還沒到，顯示 [排程中、已下架] --%>
		        <% if (isFuture) { %>
		            <option value="scheduled" <%= "scheduled".equals(currentStatus) ? "selected" : "" %>>排程中</option>
		            <option value="offline" <%= "offline".equals(currentStatus) ? "selected" : "" %>>已下架</option>
		            <option value="draft" <%= "draft".equals(currentStatus) ? "selected" : "" %>>草稿</option>
		        <% } else { %>
		            <%-- 如果時間已經到了，顯示 [已發布、已下架] --%>
		            <option value="published" <%= "published".equals(currentStatus) ? "selected" : "" %>>已發布</option>
		            <option value="offline" <%= "offline".equals(currentStatus) ? "selected" : "" %>>已下架</option>
		            <option value="draft" <%= "draft".equals(currentStatus) ? "selected" : "" %>>草稿</option>
		        <% } %>
		    </select>
		</div>

        <div class="form-group">
            <label for="publishAt">發布時間 (若為排程中請必填)：</label>
            <input type="datetime-local" id="publishAt" name="publishAt" value="<%= pubTime %>">
        </div>

        <div class="form-group">
            <label for="expireAt">下架時間 (選填，無到期日則留白)：</label>
            <input type="datetime-local" id="expireAt" name="expireAt" value="<%= expTime %>">
        </div>
        <div class="form-group">
            <label>
                <input type="checkbox" name="isPinned" <%= bean.getIsPinned() ? "checked" : "" %>> 置頂此篇公告
            </label>
        </div>

        <div class="form-group">
            <label for="content">公告內容：</label>
            <textarea id="content" name="content" required><%= bean.getContent() %></textarea>
        </div>

        <div class="form-group">
            <button type="submit" class="btn-submit">確認修改</button>
            <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list" class="btn-cancel">取消並返回列表</a>
        </div>

    </form>
    
    <% } else { %>
        <p style="color:red;">找不到該筆公告資料！</p>
        <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list">回列表頁</a>
    <% } %>

    <script>
 	// 檢查時間並更新選單選項的功能
    function updateStatusOptions() {
        var statusSelect = document.getElementById("status");
        var publishAtValue = document.getElementById("publishAt").value;
        var currentSelected = statusSelect.value;
        
        if (!publishAtValue) return;

        var selectedTime = new Date(publishAtValue);
        var now = new Date();

        // 清空現有選項
        statusSelect.innerHTML = "";

        if (selectedTime > now) {
            // 情境 A：未來時間 -> 顯示 排程、下架、草稿
            addOption(statusSelect, "scheduled", "排程中", currentSelected === "scheduled");
            addOption(statusSelect, "offline", "已下架", currentSelected === "offline");
            addOption(statusSelect, "draft", "草稿", currentSelected === "draft");
        } else {
            // 情境 B：現在或過去時間 -> 顯示 已發布、下架、草稿
            addOption(statusSelect, "published", "已發布", currentSelected === "published" || currentSelected === "scheduled");
            addOption(statusSelect, "offline", "已下架", currentSelected === "offline");
            addOption(statusSelect, "draft", "草稿", currentSelected === "draft");
        }
    }

    // 輔助函式：快速增加選項
    function addOption(selectObj, value, text, isSelected) {
        var option = document.createElement("option");
        option.value = value;
        option.text = text;
        option.selected = isSelected;
        selectObj.appendChild(option);
    }

    // 監聽發布時間欄位，只要時間一改，選單就連動
    document.getElementById("publishAt").addEventListener("change", updateStatusOptions);

    // 頁面載入時先執行一次檢查
    window.addEventListener("load", updateStatusOptions);
        function getCurrentDateTime() {
            var now = new Date();
            var year = now.getFullYear();
            var month = String(now.getMonth() + 1).padStart(2, '0');
            var day = String(now.getDate()).padStart(2, '0');
            var hours = String(now.getHours()).padStart(2, '0');
            var minutes = String(now.getMinutes()).padStart(2, '0');
            return year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
        }

        // 這裡的邏輯有改過：編輯頁面「只在使用者手動切換狀態時」才覆蓋時間
        function autoFillTime(event) {
            var status = document.getElementById("status").value;
            var publishAt = document.getElementById("publishAt");
            
            // 確保是手動切換 (change 事件)，且狀態是立即發布時才動作
            if (event && event.type === "change" && status === "published") {
                publishAt.value = getCurrentDateTime();
            }
        }

        // 綁定事件：當「發布狀態」被改變時才執行
        document.getElementById("status").addEventListener("change", autoFillTime);
        // 注意：這裡不綁定 load 事件了，因為要把原本的舊時間留給使用者看！

        // 表單送出前的防呆檢查
        function validateForm() {
            var status = document.getElementById("status").value;
            var publishAt = document.getElementById("publishAt").value;

            if (status === "scheduled" && publishAt === "") {
                alert("⚠️ 既然選擇了「排程中」，請務必設定「發布時間」喔！");
                document.getElementById("publishAt").focus(); 
                return false; 
            }
            return true; 
        }
    </script>
</body>
</html>