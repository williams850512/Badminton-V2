<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新增公告 - 後台管理</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input[type="text"], select, textarea { width: 100%; max-width: 500px; padding: 8px; box-sizing: border-box; }
        textarea { height: 150px; resize: vertical; }
        .btn-submit { padding: 10px 20px; background-color: #28a745; color: white; border: none; cursor: pointer; border-radius: 4px; font-size: 16px;}
        .btn-submit:hover { background-color: #218838; }
        .btn-cancel { text-decoration: none; color: #555; margin-left: 10px; }
    </style>
</head>
<body>

    <h2>新增公告</h2>

    <form action="<%=request.getContextPath()%>/AnnouncementServlet?action=insert" method="post" onsubmit="return validateForm()">
        
        <div class="form-group">
            <label for="title">公告標題：</label>
            <input type="text" id="title" name="title" required placeholder="請輸入標題 (例如：歡慶羽球館開幕)">
        </div>

        <div class="form-group">
            <label for="category">公告分類：</label>
            <select id="category" name="category">
                <option value="一般公告">一般公告</option>
                <option value="活動消息">活動消息</option>
                <option value="緊急公告">緊急公告</option>
                <option value="系統公告">系統公告</option>
            </select>
        </div>

        <div class="form-group">
            <label for="status">發布狀態：</label>
            <select id="status" name="status">
                <option value="published">立即發布</option>
                <option value="draft">草稿</option>
                <option value="scheduled">排程中</option>
                <option value="offline">已下架</option>
            </select>
        </div>
        
        <div class="form-group">
            <label for="publishAt">發布時間 (若為排程中請必填)：</label>
            <input type="datetime-local" id="publishAt" name="publishAt">
        </div>

        <div class="form-group">
            <label for="expireAt">下架時間 (選填，無到期日則留白)：</label>
            <input type="datetime-local" id="expireAt" name="expireAt">
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" name="isPinned"> 置頂此篇公告
            </label>
        </div>

        <div class="form-group">
            <label for="content">公告內容：</label>
            <textarea id="content" name="content" required placeholder="請輸入詳細的公告內容..."></textarea>
        </div>

        <div class="form-group">
            <button type="submit" class="btn-submit">確認新增</button>
            <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list" class="btn-cancel">取消並返回列表</a>
        </div>

    </form>

	<script>
        // --- 功能 1：取得現在的本機時間，並轉換成 datetime-local 看得懂的格式 (YYYY-MM-DDTHH:mm) ---
        function getCurrentDateTime() {
            var now = new Date();
            var year = now.getFullYear();
            var month = String(now.getMonth() + 1).padStart(2, '0'); // 月份從 0 開始，所以要 +1，並且補零
            var day = String(now.getDate()).padStart(2, '0');
            var hours = String(now.getHours()).padStart(2, '0');
            var minutes = String(now.getMinutes()).padStart(2, '0');
            
            return year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
        }

        // --- 功能 2：當網頁一載入，或是使用者切換狀態時，自動填入時間 ---
        function autoFillTime() {
            var status = document.getElementById("status").value;
            var publishAt = document.getElementById("publishAt");
            
            // 如果狀態是「立即發布」，就自動把發布時間填上「現在時間」
            if (status === "published") {
                publishAt.value = getCurrentDateTime();
            }
        }

        // 綁定事件：當「發布狀態」下拉選單被改變 (change) 時，執行 autoFillTime
        document.getElementById("status").addEventListener("change", autoFillTime);
        
        // 綁定事件：當網頁剛打開 (load) 時，也執行一次 (因為預設選項就是立即發布)
        window.addEventListener("load", autoFillTime);


        // --- 功能 3：表單送出前的防呆檢查 (維持不變) ---
        function validateForm() {
            var status = document.getElementById("status").value;
            var publishAt = document.getElementById("publishAt").value;

            if (status === "scheduled" && publishAt === "") {
                alert("既然選擇了「排程中」，請務必設定「發布時間」喔！");
                document.getElementById("publishAt").focus(); 
                return false; 
            }
            return true; 
        }
    </script>
</body>
</html>