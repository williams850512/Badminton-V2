<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新增公告</title>
    <jsp:include page="/WEB-INF/backendHead.jsp" />
    <style>
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px 0;
        }

        /* 每個表單群組改為 Flex 佈局 */
        .form-group-horizontal {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        /* 左側標籤固定寬度，文字靠右對齊 */
        .form-group-horizontal label {
            flex: 0 0 120px; /* 固定寬度 120px */
            text-align: right;
            margin-right: 20px; /* 與輸入框的間距 */
            margin-bottom: 0; 
            font-weight: 500;
            color: #555;
            font-size: 14px;
        }

        /* 內容區域 */
        .form-input-control {
            flex: 1;
        }

        /* 統一輸入框樣式 */
        .form-style-input {
            width: 100%;
            max-width: 350px; /* 固定最大寬度，不讓它滿版，像參考圖那樣 */
            padding: 6px 12px; /* 較精緻的 padding */
            border: 1px solid #ced4da; /* 淡淡的灰色邊框 */
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        
        /* 聚焦樣式 */
        .form-style-input:focus {
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        /* 文字區域 */
        textarea.form-style-input {
            max-width: 550px;
            height: 150px;
            resize: vertical;
        }

        /* 置頂勾選框 */
        .checkbox-align {
            margin-left: 140px; /* label 120px + margin 20px */
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            font-size: 14px;
        }
        .checkbox-align input {
            margin-right: 8px;
            width: 16px;
            height: 16px;
        }

        /* 下方按鈕 */
        .form-actions-align {
            margin-left: 140px; /* label 120px + margin 20px */
            padding-top: 20px;
            border-top: 1px solid #eee;
            margin-top: 25px;
        }
    </style>
</head>
<body>
	<div class="app-container">
        <jsp:include page="/WEB-INF/backendSidebar.jsp" />

        <div class="main-content">
            <jsp:include page="/WEB-INF/backendHeader.jsp" />

            <div class="content-body">
			    <h2 style="margin-bottom: 20px; color: #333;">新增公告</h2>
			
				<div class="card">
					<div class="form-container">
					    <form action="<%=request.getContextPath()%>/AnnouncementServlet?action=insert" method="post" onsubmit="return validateForm()">
					        
					        <div class="form-group-horizontal">
					            <label for="title">公告標題：</label>
					            <div class="form-input-control">
					                <input type="text" id="title" name="title" class="form-style-input" required placeholder="請輸入標題">
					            </div>
						    </div>
							
							<div class="form-group-horizontal">
					            <label for="category">公告分類：</label>
					            <div class="form-input-control">
						            <select id="category" name="category" class="form-style-input" style="max-width: 180px;">
						                <option value="一般公告">一般公告</option>
						                <option value="活動消息">活動消息</option>
						                <option value="緊急公告">緊急公告</option>
						                <option value="系統公告">系統公告</option>
						            </select>
						        </div>
						    </div>
							
							<div class="form-group-horizontal">
					            <label for="status">發布狀態：</label>
					            <div class="form-input-control">
						            <select id="status" name="status" class="form-style-input" style="max-width: 180px;">
						                <option value="published">立即發布</option>
						                <option value="scheduled">排程中</option>
						                <option value="draft">草稿</option>
						            </select>
						        </div>
						    </div>
					        
					        <div class="form-group-horizontal">
					            <label for="publishAt">發布時間：</label>
					            <div class="form-input-control">
					                <input type="datetime-local" id="publishAt" name="publishAt" class="form-style-input" style="max-width: 200px;">
					            </div>
					        </div>
					
					        <div class="form-group-horizontal">
					            <label for="expireAt">下架時間：<br><span style="color: #ADADAD;">(選填)</span></label>
					            <div class="form-input-control">
					                <input type="datetime-local" id="expireAt" name="expireAt" class="form-style-input" style="max-width: 200px;">
					            </div>
					        </div>
					
					        <div class="checkbox-align">
					            <label style="display: flex; align-items: center; font-weight: normal; cursor: pointer; margin: 0;">
					                <input type="checkbox" name="isPinned"> 置頂公告
					            </label>
					        </div>
					
					        <div class="form-group-horizontal" style="align-items: flex-start;">
					            <label for="content" style="margin-top: 8px;">公告內容：</label>
					            <div class="form-input-control">
					                <textarea id="content" name="content" class="form-style-input" required placeholder="請輸入內容..."></textarea>
					            </div>
					        </div>
					
					        <div class="form-actions-align">
					            <button type="submit" class="btn btn-primary" style="font-size: 14px; padding: 6px 18px;">新增</button>
					            <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list" class="btn" style="background-color: #f8f9fa; color: #333; border: 1px solid #ddd; margin-left: 10px; font-size: 14px; padding: 6px 18px; text-decoration: none;">取消</a>
					        </div>
					
					    </form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
        // 1.取得本機時間、換成 YYYY-MM-DDTHH:mm 格式
        function getCurrentDateTime() {
            var now = new Date();
            var year = now.getFullYear();
            var month = String(now.getMonth() + 1).padStart(2, '0');
            var day = String(now.getDate()).padStart(2, '0');
            var hours = String(now.getHours()).padStart(2, '0');
            var minutes = String(now.getMinutes()).padStart(2, '0');
            
            return year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
        }

        // 2.網頁一載入自動填入時間
        function autoFillTime() {
            var status = document.getElementById("status").value;
            var publishAt = document.getElementById("publishAt");
            
            if (status === "published") {
                publishAt.value = getCurrentDateTime();
            } else if (status === "draft") {
                publishAt.value = "";
            }
        }

        // 綁定事件：當發布狀態下拉選單被改變，執行 autoFillTime
        document.getElementById("status").addEventListener("change", autoFillTime);
        
        window.addEventListener("load", autoFillTime);


        // 3.送出前檢查
        function validateForm() {
            var status = document.getElementById("status").value;
            var publishAt = document.getElementById("publishAt").value;

            if (status === "scheduled" && publishAt === "") {
                alert("目前選擇【排程】，請設定發布時間喔！");
                document.getElementById("publishAt").focus();
                return false;
            }
            return true;
        }
    </script>
</body>
</html>