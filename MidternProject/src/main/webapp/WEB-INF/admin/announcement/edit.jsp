<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.badminton.model.AnnouncementBean" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>編輯公告</title>
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
            max-width: 350px; 
            padding: 6px 12px; 
            border: 1px solid #ced4da; 
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
                <h2 style="margin-bottom: 20px; color: #333;">編輯公告</h2>

                <div class="card">
                    <div class="form-container">
                        <% 
                            AnnouncementBean bean = (AnnouncementBean) request.getAttribute("announcement"); 
                            if(bean != null) {
                                
                                // Timestamp 轉換格式
                                String pubTime = "";
                                if (bean.getPublishAt() != null) {
                                    pubTime = bean.getPublishAt().toString().replace(" ", "T").substring(0, 16);
                                }
                                
                                String expTime = "";
                                if (bean.getExpireAt() != null) {
                                    expTime = bean.getExpireAt().toString().replace(" ", "T").substring(0, 16);
                                }
                        %>

                        <form action="<%=request.getContextPath()%>/AnnouncementServlet?action=update" method="post" onsubmit="return validateForm()">
                            
                            <input type="hidden" name="announcementId" value="<%= bean.getAnnouncementId() %>">

                            <div class="form-group-horizontal">
                                <label for="title">公告標題：</label>
                                <div class="form-input-control">
                                    <input type="text" id="title" name="title" class="form-style-input" required value="<%= bean.getTitle() %>">
                                </div>
                            </div>

                            <div class="form-group-horizontal">
                                <label for="category">公告分類：</label>
                                <div class="form-input-control">
                                    <select id="category" name="category" class="form-style-input" style="max-width: 180px;">
                                        <option value="一般公告" <%= "一般公告".equals(bean.getCategory()) ? "selected" : "" %>>一般公告</option>
                                        <option value="活動消息" <%= "活動消息".equals(bean.getCategory()) ? "selected" : "" %>>活動消息</option>
                                        <option value="緊急公告" <%= "緊急公告".equals(bean.getCategory()) ? "selected" : "" %>>緊急公告</option>
                                        <option value="系統公告" <%= "系統公告".equals(bean.getCategory()) ? "selected" : "" %>>系統公告</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group-horizontal">
                                <label for="status">發布狀態：</label>
                                <div class="form-input-control">
                                    <select id="status" name="status" class="form-style-input" style="max-width: 180px;">
                                        <% 
                                            // 取得現在時間
                                            java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
                                            boolean isFuture = bean.getPublishAt() != null && bean.getPublishAt().after(now);
                                            String currentStatus = bean.getStatus();
                                        %>
                                        
                                        <% if (isFuture) { %>
                                            <option value="scheduled" <%= "scheduled".equals(currentStatus) ? "selected" : "" %>>排程中</option>
                                            <option value="offline" <%= "offline".equals(currentStatus) ? "selected" : "" %>>已下架</option>
                                            <option value="draft" <%= "draft".equals(currentStatus) ? "selected" : "" %>>草稿</option>
                                        <% } else { %>
                                            <option value="published" <%= "published".equals(currentStatus) ? "selected" : "" %>>已發布</option>
                                            <option value="offline" <%= "offline".equals(currentStatus) ? "selected" : "" %>>已下架</option>
                                            <option value="draft" <%= "draft".equals(currentStatus) ? "selected" : "" %>>草稿</option>
                                        <% } %>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group-horizontal">
                                <label for="publishAt">發布時間：</label>
                                <div class="form-input-control">
                                    <input type="datetime-local" id="publishAt" name="publishAt" class="form-style-input" style="max-width: 200px;" value="<%= pubTime %>">
                                </div>
                            </div>

                            <div class="form-group-horizontal">
                                <label for="expireAt">下架時間：<br><span style="color: #ADADAD;">(選填)</span></label>
                                <div class="form-input-control">
                                    <input type="datetime-local" id="expireAt" name="expireAt" class="form-style-input" style="max-width: 200px;" value="<%= expTime %>">
                                </div>
                            </div>

                            <div class="checkbox-align">
                                <label style="display: flex; align-items: center; font-weight: normal; cursor: pointer; margin: 0;">
                                    <input type="checkbox" name="isPinned" <%= bean.getIsPinned() ? "checked" : "" %>> 置頂公告
                                </label>
                            </div>

                            <div class="form-group-horizontal" style="align-items: flex-start;">
                                <label for="content" style="margin-top: 8px;">公告內容：</label>
                                <div class="form-input-control">
                                    <textarea id="content" name="content" class="form-style-input" required><%= bean.getContent() %></textarea>
                                </div>
                            </div>

                            <div class="form-actions-align">
                                <button type="submit" class="btn btn-warning" style="font-size: 14px; padding: 6px 18px; border:none; cursor:pointer; border-radius:4px; font-weight:bold;">確認修改</button>
                                <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list" class="btn" style="background-color: #f8f9fa; color: #333; border: 1px solid #ddd; margin-left: 10px; font-size: 14px; padding: 6px 18px; text-decoration: none;">取消</a>
                            </div>

                        </form>
                        
                        <% } else { %>
                            <div style="text-align: center; padding: 50px;">
                                <h3 style="color:red;">找不到該筆公告資料！</h3>
                                <a href="<%=request.getContextPath()%>/AnnouncementServlet?action=list" class="btn btn-primary" style="text-decoration: none; padding: 10px 20px;">回列表頁</a>
                            </div>
                        <% } %>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 檢查時間並更新選單
        function updateStatusOptions() {
            var statusSelect = document.getElementById("status");
            var publishAtValue = document.getElementById("publishAt").value;
            var currentSelected = statusSelect.value;
            
            if (!publishAtValue) return;

            var selectedTime = new Date(publishAtValue);
            var now = new Date();

            // 清空選項
            statusSelect.innerHTML = "";

            if (selectedTime > now) {
                // 未來時間 -> 顯示 排程、下架、草稿
                addOption(statusSelect, "scheduled", "排程中", currentSelected === "scheduled");
                addOption(statusSelect, "offline", "已下架", currentSelected === "offline");
                addOption(statusSelect, "draft", "草稿", currentSelected === "draft");
            } else {
                // 現在或過去時間 -> 顯示 已發布、下架、草稿
                addOption(statusSelect, "published", "已發布", currentSelected === "published" || currentSelected === "scheduled");
                addOption(statusSelect, "offline", "已下架", currentSelected === "offline");
                addOption(statusSelect, "draft", "草稿", currentSelected === "draft");
            }
        }

        function addOption(selectObj, value, text, isSelected) {
            var option = document.createElement("option");
            option.value = value;
            option.text = text;
            option.selected = isSelected;
            selectObj.appendChild(option);
        }

        // 只要時間一改，選單就改變
        document.getElementById("publishAt").addEventListener("change", updateStatusOptions);

        // 頁面載入時先檢查一次
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

        // 只在手動切換狀態時才覆蓋時間
        function autoFillTime(event) {
            var status = document.getElementById("status").value;
            var publishAt = document.getElementById("publishAt");
            var expireAt = document.getElementById("expireAt"); // 取得下架時間欄位
            
            // 確保是使用者手動切換狀態
            if (event && event.type === "change") {
                if (status === "published") {
                    // 1. 如果切換成立即發布，只更新上架時間為現在
                    publishAt.value = getCurrentDateTime();
                    
                } else if (status === "offline") {
                    // 2. 如果切換成已下架，把上架和下架時間都設為現在
                    var nowTime = getCurrentDateTime();
                    publishAt.value = nowTime;
                    expireAt.value = nowTime;
                }
            }
        }

        // 綁定事件：當發布狀態被改變時才執行
        document.getElementById("status").addEventListener("change", autoFillTime);

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