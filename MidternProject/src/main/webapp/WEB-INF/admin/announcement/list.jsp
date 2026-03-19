<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.badminton.model.AnnouncementBean" %>
<%@ page import="java.sql.Timestamp" %>
<%
    // 取得當前時間並格式化為 flatpickr 認得的格式
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
    String nowTime = sdf.format(new java.util.Date());
%>
<%
    // 從 Servlet 接收資料庫撈出來的公告清單
    List<AnnouncementBean> list = (List<AnnouncementBean>) request.getAttribute("announcementList");
    String keyword = (String) request.getAttribute("keyword");
    
    // ================= 分頁邏輯設定 =================
    int pageSize = 5; // 每頁顯示 5 筆
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    int totalItems = (list != null) ? list.size() : 0;
    int totalPages = (int) Math.ceil((double) totalItems / pageSize);
    
    // 確保當前頁數在合法範圍內
    if (currentPage > totalPages && totalPages > 0) {
        currentPage = totalPages;
    } else if (currentPage < 1) {
        currentPage = 1;
    }
    
    // 計算 List 的擷取範圍 (subList 的 index)
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = Math.min(startIndex + pageSize, totalItems);
    
    // 處理搜尋關鍵字附加到分頁連結 (保留使用者的搜尋狀態)
    String queryString = "";
    if (keyword != null && !keyword.isEmpty()) {
        queryString = "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
    }
%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告管理 - 羽球館後台</title>
    <!-- 引入 Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- 引入 Phosphor Icons -->
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <!-- 引入 jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- 引入 Flatpickr 日期選擇器 CSS & JS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/airbnb.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/zh-tw.js"></script>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700;900&display=swap');
        body { font-family: 'Noto Sans TC', sans-serif; }
        
        /* 自訂一下捲軸樣式讓它更現代 */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #94a3b8; }

        /* Flatpickr 覆蓋微調 */
        .flatpickr-calendar {
            border-radius: 16px !important;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1) !important;
            border: 1px solid #f3f4f6 !important;
            padding: 10px;
        }

        /* 讓文字最多顯示兩行，超過的變成省略號 (...) */
        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;  
            overflow: hidden;
        }
    </style>
</head>
<body class="bg-slate-50 flex h-screen overflow-hidden text-gray-800 font-sans">

    <!-- 左側導覽列 -->
    <aside class="w-[260px] bg-white border-r border-gray-100 flex flex-col justify-between h-screen shrink-0 relative z-20">
        <div>
            <!-- Logo 區塊 -->
            <div class="h-20 flex items-center px-8">
                <div class="flex items-center text-blue-600">
                    <span class="text-2xl font-black italic tracking-wider">Badminton!</span>
                </div>
            </div>

            <!-- 選單群組 -->
            <div class="px-6 py-4">
                <div class="text-[11px] font-bold text-gray-400 mb-3 tracking-widest uppercase">General</div>
                <nav class="space-y-1.5">
                    <a href="#" class="flex items-center px-4 py-3 text-gray-500 hover:text-gray-900 hover:bg-gray-50 rounded-xl transition-all font-medium text-sm">
                        <i class="ph ph-users text-lg mr-3"></i> 會員管理 (Members)
                    </a>
                    <a href="#" class="flex items-center px-4 py-3 text-gray-500 hover:text-gray-900 hover:bg-gray-50 rounded-xl transition-all font-medium text-sm">
                        <i class="ph ph-calendar-check text-lg mr-3"></i> 預約管理 (Bookings)
                    </a>
                    <a href="#" class="flex items-center px-4 py-3 text-gray-500 hover:text-gray-900 hover:bg-gray-50 rounded-xl transition-all font-medium text-sm">
                        <i class="ph ph-shopping-cart text-lg mr-3"></i> 訂單管理 (Orders)
                    </a>
                    <a href="<%= request.getContextPath() %>/AnnouncementServlet?action=list" class="flex items-center px-4 py-3 bg-blue-50 text-blue-600 rounded-xl transition-all font-medium text-sm">
                        <i class="ph-fill ph-megaphone text-lg mr-3"></i> 公告管理 (Announce)
                    </a>
                </nav>
            </div>
        </div>

        <!-- 底部使用者 -->
        <div class="p-6 border-t border-gray-50">
            <div class="flex items-center justify-between hover:bg-gray-50 p-2 -mx-2 rounded-xl cursor-pointer transition-colors">
                <div class="flex items-center space-x-3">
                    <img src="https://ui-avatars.com/api/?name=Admin&background=2563eb&color=fff" alt="Admin" class="w-10 h-10 rounded-full border-2 border-white shadow-sm">
                    <div>
                        <div class="text-sm font-bold text-gray-900">最高管理員</div>
                        <div class="text-xs text-gray-500">admin@badminton.com</div>
                    </div>
                </div>
            </div>
        </div>
    </aside>

    <!-- 右側主內容區 -->
    <main class="flex-1 flex flex-col h-screen overflow-hidden">
        
        <!-- Header -->
        <header class="h-24 px-10 flex items-center justify-between shrink-0">
            <div>
                <h2 class="text-2xl font-bold text-gray-900">您好 管理員，歡迎回來！ <span class="text-2xl ml-1">👋</span></h2>
                <p class="text-sm text-gray-500 mt-1">這邊顯示公告內容的一些設定！</p>
            </div>
            
            <div class="flex items-center space-x-5">
                <form action="<%= request.getContextPath() %>/AnnouncementServlet" method="GET" class="relative flex items-center">
                    <input type="hidden" name="action" value="list">
                    <i class="ph ph-magnifying-glass absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400 text-lg"></i>
                    <input type="text" name="keyword" value="<%= keyword != null ? keyword : "" %>" placeholder="搜尋您想找的公告" class="w-72 pl-11 pr-10 py-2.5 bg-white border border-gray-200 rounded-full text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-shadow shadow-sm">
                    <% if(keyword != null && !keyword.isEmpty()) { %>
                        <a href="<%= request.getContextPath() %>/AnnouncementServlet?action=list" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-300 hover:text-red-500 transition-colors" title="清除搜尋">
                            <i class="ph-fill ph-x-circle text-xl"></i>
                        </a>
                    <% } %>
                </form>
            </div>
        </header>

        <!-- 內容區 -->
        <div class="flex-1 overflow-y-auto px-10 pb-10">
            
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 flex flex-col h-full min-h-[600px]">
                
                <div class="flex justify-between items-end mb-8">
                    <div>
                        <h3 class="text-xl font-bold text-gray-900">公告列表</h3>
                    </div>
                    
                    <div class="flex items-center space-x-3">
                        <button id="btn-add-announcement" class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2 rounded-lg text-sm font-medium transition-colors shadow-md shadow-blue-200 flex items-center">
                            新增公告
                        </button>
                    </div>
                </div>

                <!-- 列表 -->
                <div class="overflow-x-auto rounded-xl border border-gray-100">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 border-b border-gray-100">
                                <th class="py-4 px-6 text-[12px] font-bold text-gray-500 uppercase tracking-wider w-20">分類</th>
                                <th class="py-4 px-6 text-[12px] font-bold text-gray-500 uppercase tracking-wider w-16 text-center">置頂</th>
                                <th class="py-4 px-6 text-[12px] font-bold text-gray-500 uppercase tracking-wider w-56">標題</th>
                                <th class="py-4 px-6 text-[12px] font-bold text-gray-500 uppercase tracking-wider max-w-xs">內容</th>
                                <th class="py-4 px-6 text-[12px] font-bold text-gray-500 uppercase tracking-wider w-40">排程狀態</th>
                                <th class="py-4 px-6 text-[12px] font-bold text-gray-500 uppercase tracking-wider w-24 text-center">操作</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 text-sm relative">
                            <%
                                if(totalItems > 0) {
                                    for(int i = startIndex; i < endIndex; i++) {
                                        AnnouncementBean bean = list.get(i);
                                        boolean isDraft = "draft".equals(bean.getStatus());
                                        String pinColorClass = bean.getIsPinned() ? "text-amber-500 bg-amber-50" : "text-gray-300 bg-transparent";
                                        
                                        // 處理時間格式，轉換成 Flatpickr 認得的格式 YYYY-MM-DDTHH:mm
                                        String pubStr = "";
                                        if (bean.getPublishAt() != null) pubStr = String.valueOf(bean.getPublishAt()).substring(0, 16).replace(" ", "T");
                                        String expStr = "";
                                        if (bean.getExpireAt() != null) expStr = String.valueOf(bean.getExpireAt()).substring(0, 16).replace(" ", "T");
                            %>
                            <tr class="hover:bg-slate-50/80 transition-colors group cursor-default"
                                data-id="<%= bean.getAnnouncementId() %>" 
                                data-category="<%= bean.getCategory() %>" 
                                data-ispinned="<%= bean.getIsPinned() %>" 
                                data-publishat="<%= pubStr %>" 
                                data-expireat="<%= expStr %>" 
                                data-status="<%= bean.getStatus() %>">
                                
                                <td class="py-4 px-6">
                                    <!-- 隱藏的文字內容放在這裡，並使用 textarea，完美保留換行與空格 -->
                                    <div class="hidden">
                                        <textarea class="data-title-store"><%= bean.getTitle() %></textarea>
                                        <textarea class="data-content-store"><%= bean.getContent() %></textarea>
                                    </div>
                                    <div class="flex items-center">
                                        <div class="w-2 h-2 rounded-full bg-blue-500 mr-2"></div>
                                        <span class="font-medium text-gray-700"><%= bean.getCategory() %></span>
                                    </div>
                                </td>
                                <td class="py-4 px-6 text-center">
                                    <div class="inline-flex p-1.5 rounded-lg <%= pinColorClass %> transition-colors">
                                        <i class="<%= bean.getIsPinned() ? "ph-fill" : "ph" %> ph-push-pin text-lg"></i>
                                    </div>
                                </td>
                                <td class="py-4 px-6">
                                    <div class="font-bold text-gray-900 text-base mb-1 group-hover:text-blue-600 transition-colors line-clamp-2" title="<%= bean.getTitle() %>"><%= bean.getTitle() %></div>
                                    <div class="text-[11px] text-gray-400">建立於：<%= String.valueOf(bean.getCreatedAt()).substring(0, 16) %></div>
                                </td>
                                
                                <!-- 內容預覽 -->
                                <td class="py-4 px-6">
                                    <p class="text-sm text-gray-500 line-clamp-2 leading-relaxed" title="<%= bean.getContent() %>">
                                        <%= bean.getContent() %>
                                    </p>
                                </td>

                                <td class="py-4 px-6">
								    <%
								        Timestamp now = new Timestamp(System.currentTimeMillis());
								        Timestamp pubAt = bean.getPublishAt();
								        Timestamp expAt = bean.getExpireAt();
								
								        if (expAt != null && now.after(expAt)) {
								            out.print("<span class='px-2 py-0.5 rounded-full text-xs font-bold bg-rose-50 text-rose-500'>已下架</span>");
								            out.print("<div class='text-[10px] text-gray-400 mt-1'>結束於：<br>" + String.valueOf(expAt).substring(0, 16) + "</div>");
								        } else if (pubAt != null && now.before(pubAt)) {
								            out.print("<span class='px-2 py-0.5 rounded-full text-xs font-bold bg-amber-50 text-amber-500'>排程中</span>");
								            out.print("<div class='text-[10px] text-gray-400 mt-1'>預定於：" + String.valueOf(pubAt).substring(0, 16) + "發布</div>");
								        } else {
								            out.print("<span class='px-2 py-0.5 rounded-full text-xs font-bold bg-emerald-50 text-emerald-500'>已發布</span>");
								            if(expAt != null) {
								                out.print("<div class='text-[10px] text-gray-400 mt-1'>下架時間：<br>" + String.valueOf(expAt).substring(0, 16) + "</div>");
								            } else {
								                out.print("<div class='text-[10px] text-emerald-600 font-bold mt-1'>永久有效</div>");
								            }
								        }
								    %>
								</td>
                                <td class="py-4 px-6 text-center">
                                    <div class="flex justify-center space-x-2">
                                        <!-- 彈窗按鈕 -->
                                        <button type="button" class="btn-edit-announcement w-8 h-8 rounded-lg flex items-center justify-center text-gray-400 hover:text-blue-600 hover:bg-blue-50 transition-all" title="編輯">
                                            <i class="ph ph-pencil-simple text-lg"></i>
                                        </button>
                                        <a href="<%= request.getContextPath() %>/AnnouncementServlet?action=delete&id=<%= bean.getAnnouncementId() %>" class="btn-delete w-8 h-8 rounded-lg flex items-center justify-center text-gray-400 hover:text-rose-600 hover:bg-rose-50 transition-all" title="刪除">
                                            <i class="ph ph-trash text-lg"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="6" class="py-16 text-center">
                                        <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gray-50 mb-4">
                                            <i class="ph ph-file-dashed text-3xl text-gray-400"></i>
                                        </div>
                                        <h4 class="text-gray-900 font-medium text-base mb-1">找不到公告資料！</h4>
                                        <p class="text-gray-400 text-sm">請調整搜尋條件或新增一筆資料</p>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <!-- 分頁 -->
                <div class="mt-auto pt-6 flex items-center justify-between text-sm">
                    <div class="text-gray-500 font-medium">
                        顯示第 <%= totalItems == 0 ? 0 : startIndex + 1 %> 到 <%= endIndex %> 筆，共 <%= totalItems %> 筆資料
                    </div>
                    <% if (totalPages > 1) { %>
                    <div class="flex space-x-2">
                        <% if (currentPage > 1) { %>
                            <a href="?action=list&page=<%= currentPage - 1 %><%= queryString %>" class="px-3 py-1.5 border border-gray-200 text-gray-600 rounded-lg hover:bg-gray-50 transition-colors font-medium">上一頁</a>
                        <% } %>
                        
                        <% 
                            int startPage = Math.max(1, currentPage - 2);
                            int endPage = Math.min(totalPages, currentPage + 2);
                        %>
                        <% for (int p = startPage; p <= endPage; p++) { %>
                            <% if (p == currentPage) { %>
                                <button class="px-3 py-1.5 bg-blue-600 text-white border border-blue-600 rounded-lg shadow-sm font-medium"><%= p %></button>
                            <% } else { %>
                                <a href="?action=list&page=<%= p %><%= queryString %>" class="px-3 py-1.5 border border-gray-200 text-gray-600 rounded-lg hover:bg-gray-50 transition-colors font-medium"><%= p %></a>
                            <% } %>
                        <% } %>

                        <% if (currentPage < totalPages) { %>
                            <a href="?action=list&page=<%= currentPage + 1 %><%= queryString %>" class="px-3 py-1.5 border border-gray-200 text-gray-600 rounded-lg hover:bg-gray-50 transition-colors font-medium">下一頁</a>
                        <% } %>
                    </div>
                    <% } %>
                </div>

            </div>
        </div>
    </main>

    <!-- 新增視窗 -->
    <div id="addModal" class="fixed inset-0 z-50 hidden bg-gray-900/40 backdrop-blur-sm flex items-center justify-center p-4 transition-opacity">
        <div class="bg-white rounded-2xl shadow-xl w-full max-w-2xl overflow-visible transform transition-all">
            
            <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-slate-50 rounded-t-2xl">
                <h3 class="text-lg font-bold text-gray-900 flex items-center">
                    新增公告
                </h3>
                <button type="button" class="btn-close-add-modal text-gray-400 hover:text-rose-500 transition-colors p-1 rounded-lg hover:bg-rose-50">
                    <i class="ph ph-x text-xl"></i>
                </button>
            </div>
            
            <form action="<%= request.getContextPath() %>/AnnouncementServlet" method="POST" class="p-6">
                <input type="hidden" name="action" value="insert">
                
                <div class="space-y-5">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1.5">公告標題 <span class="text-rose-500">*</span></label>
                        <input type="text" name="title" required placeholder="請輸入標題..." class="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all">
                    </div>
                    
                    <div class="flex gap-5">
                        <div class="relative">
						    <select name="category" id="add-real-category" class="hidden">
						        <option value="一般公告">一般公告</option>
						        <option value="緊急公告">緊急公告</option>
						        <option value="系統公告">系統公告</option>
						    </select>
						    <button type="button" id="add-custom-select-btn" class="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl flex items-center justify-between hover:bg-white transition-all">
						        <div class="flex items-center text-gray-700 font-medium" id="add-custom-select-display">一般公告</div>
						        <i class="ph ph-caret-down text-gray-400 transition-transform duration-200" id="add-custom-select-arrow"></i>
						    </button>
						    <div id="add-custom-select-panel" class="absolute z-50 w-full mt-2 bg-white border border-gray-100 rounded-xl shadow-xl hidden opacity-0 scale-95 transition-all duration-200">
						        <ul class="p-1.5">
						            <li class="add-custom-option px-4 py-2.5 rounded-lg hover:bg-blue-50 cursor-pointer text-sm text-gray-700" data-value="一般公告">一般公告</li>
						            <li class="add-custom-option px-4 py-2.5 rounded-lg hover:bg-blue-50 cursor-pointer text-sm text-gray-700" data-value="緊急公告">緊急公告</li>
						            <li class="add-custom-option px-4 py-2.5 rounded-lg hover:bg-blue-50 cursor-pointer text-sm text-gray-700" data-value="系統公告">系統公告</li>
						        </ul>
						    </div>
						</div>
                        <div class="flex items-end pb-3">
                            <label class="flex items-center space-x-2 cursor-pointer group">
                                <input type="checkbox" name="isPinned" value="true" class="w-5 h-5 border-gray-300 rounded text-blue-600 focus:ring-blue-500 transition-all cursor-pointer">
                                <span class="text-sm font-bold text-gray-600 group-hover:text-blue-600 transition-colors">設為置頂公告</span>
                            </label>
                        </div>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1.5">公告內容 <span class="text-rose-500">*</span></label>
                        <textarea name="content" rows="4" required placeholder="請寫下公告內容..." class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all resize-none"></textarea>
                    </div>
                    
                    <div class="flex gap-5">
                        <div class="flex-1">
                            <label class="block text-sm font-bold text-gray-700 mb-1.5">發布時間 <span class="text-rose-500">*</span></label>
                            <div class="relative">
                                <i class="ph ph-calendar-blank absolute left-3.5 top-1/2 transform -translate-y-1/2 text-gray-400 text-lg z-10"></i>
                                <input type="text" name="publishAt" placeholder="選擇日期與時間" class="datetime-picker w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all text-sm text-gray-600 cursor-pointer">
                            </div>
                        </div>
                        <div class="flex-1">
                            <label class="block text-sm font-bold text-gray-700 mb-1.5">下架時間 <span class="text-xs font-normal text-gray-400 ml-1">(選填)</span></label>
                            <div class="relative">
                                <i class="ph ph-calendar-x absolute left-3.5 top-1/2 transform -translate-y-1/2 text-gray-400 text-lg z-10"></i>
                                <input type="text" name="expireAt" placeholder="選擇日期與時間" class="datetime-picker w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all text-sm text-gray-600 cursor-pointer">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-8 flex justify-end space-x-3 pt-4 border-t border-gray-50">
                    <button type="submit" name="status" value="draft" class="px-5 py-2.5 text-sm font-bold text-gray-700 bg-white border border-gray-200 hover:bg-gray-50 hover:border-gray-300 rounded-xl transition-all shadow-sm">儲存草稿</button>
                    <button type="submit" name="status" value="published" class="px-6 py-2.5 text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl transition-all shadow-md shadow-blue-200 flex items-center">發布</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 編輯視窗 -->
    <div id="editModal" class="fixed inset-0 z-50 hidden bg-gray-900/40 backdrop-blur-sm flex items-center justify-center p-4 transition-opacity">
        <div class="bg-white rounded-2xl shadow-xl w-full max-w-2xl overflow-visible transform transition-all">
            
            <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-slate-50 rounded-t-2xl">
                <h3 class="text-lg font-bold text-gray-900 flex items-center">
                    編輯公告
                </h3>
                <button type="button" class="btn-close-edit-modal text-gray-400 hover:text-rose-500 transition-colors p-1 rounded-lg hover:bg-rose-50">
                    <i class="ph ph-x text-xl"></i>
                </button>
            </div>
            
            <form action="<%= request.getContextPath() %>/AnnouncementServlet" method="POST" class="p-6">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="announcementId" id="edit-announcementId" value="">
                
                <div class="space-y-5">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1.5">公告標題 <span class="text-rose-500">*</span></label>
                        <input type="text" name="title" id="edit-title" required class="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all">
                    </div>
                    
                    <div class="flex gap-5">
                        <div class="relative">
						    <select name="category" id="edit-real-category" class="hidden">
						        <option value="一般公告">一般公告</option>
						        <option value="緊急公告">緊急公告</option>
						        <option value="系統公告">系統公告</option>
						    </select>
						    <button type="button" id="edit-custom-select-btn" class="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl flex items-center justify-between hover:bg-white transition-all">
						        <div class="flex items-center text-gray-700 font-medium" id="edit-custom-select-display">一般公告</div>
						        <i class="ph ph-caret-down text-gray-400 transition-transform duration-200" id="edit-custom-select-arrow"></i>
						    </button>
						    <div id="edit-custom-select-panel" class="absolute z-50 w-full mt-2 bg-white border border-gray-100 rounded-xl shadow-xl hidden opacity-0 scale-95 transition-all duration-200">
						        <ul class="p-1.5">
						            <li class="edit-custom-option px-4 py-2.5 rounded-lg hover:bg-blue-50 cursor-pointer text-sm text-gray-700" data-value="一般公告">一般公告</li>
						            <li class="edit-custom-option px-4 py-2.5 rounded-lg hover:bg-blue-50 cursor-pointer text-sm text-gray-700" data-value="緊急公告">緊急公告</li>
						            <li class="edit-custom-option px-4 py-2.5 rounded-lg hover:bg-blue-50 cursor-pointer text-sm text-gray-700" data-value="系統公告">系統公告</li>
						        </ul>
						    </div>
						</div>
                        <div class="flex items-end pb-3">
                            <label class="flex items-center space-x-2 cursor-pointer group">
                                <input type="checkbox" name="isPinned" id="edit-isPinned" value="true" class="w-5 h-5 border-gray-300 rounded text-blue-600 focus:ring-blue-500 transition-all cursor-pointer">
                                <span class="text-sm font-bold text-gray-600 group-hover:text-blue-600 transition-colors">設為置頂公告</span>
                            </label>
                        </div>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1.5">公告內容 <span class="text-rose-500">*</span></label>
                        <textarea name="content" id="edit-content" rows="4" required class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all resize-none"></textarea>
                    </div>
                    
                    <div class="flex gap-5">
                        <div class="flex-1">
                            <label class="block text-sm font-bold text-gray-700 mb-1.5">發布時間 <span class="text-rose-500">*</span></label>
                            <div class="relative">
                                <i class="ph ph-calendar-blank absolute left-3.5 top-1/2 transform -translate-y-1/2 text-gray-400 text-lg z-10"></i>
                                <input type="text" name="publishAt" id="edit-publishAt" class="edit-datetime-picker w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all text-sm text-gray-600 cursor-pointer">
                            </div>
                        </div>
                        <div class="flex-1">
                            <label class="block text-sm font-bold text-gray-700 mb-1.5">下架時間 <span class="text-xs font-normal text-gray-400 ml-1">(選填)</span></label>
                            <div class="relative">
                                <i class="ph ph-calendar-x absolute left-3.5 top-1/2 transform -translate-y-1/2 text-gray-400 text-lg z-10"></i>
                                <input type="text" name="expireAt" id="edit-expireAt" class="edit-datetime-picker w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all text-sm text-gray-600 cursor-pointer">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-8 flex justify-end space-x-3 pt-4 border-t border-gray-50">
                    <button type="submit" name="status" value="published" class="px-6 py-2.5 text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl transition-all shadow-md shadow-blue-200 flex items-center">更新</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            
            // 刪除視窗
            $('.btn-delete').on('click', function(e) {
                if (!confirm('確定要刪除這筆公告嗎？資料刪除後將無法復原喔ヾ(;ﾟ;Д;ﾟ;)ﾉﾞ')) {
                    e.preventDefault();
                }
            });

            // 新增視窗邏輯
            $('#btn-add-announcement').on('click', function() {
                $('#addModal').removeClass('hidden');
                $('body').css('overflow', 'hidden'); 
            });

            $('.btn-close-add-modal').on('click', function() {
                $('#addModal').addClass('hidden');
                $('body').css('overflow', ''); 
                $('#addModal form')[0].reset();
                $('#add-custom-select-display').html('<i class="ph ph-gear text-lg mr-2 text-gray-500"></i> 系統設定');
                // 清除 Flatpickr 時間
                document.querySelector('#addModal [name="publishAt"]')._flatpickr.clear();
                document.querySelector('#addModal [name="expireAt"]')._flatpickr.clear();
            });

            // 編輯視窗邏輯
            $('.btn-edit-announcement').on('click', function() {
                // 從整列 (tr) 去抓取 data 屬性和裡面隱藏的 textarea
                const $row = $(this).closest('tr');
                
                const id = $row.data('id');
                const category = $row.data('category');
                const isPinned = $row.data('ispinned');
                const publishAt = $row.data('publishat'); // 格式 YYYY-MM-DDTHH:mm
                const expireAt = $row.data('expireat');
                
                // 抓hidden textarea 的 .val()，完美保留所有換行及特殊符號
                const title = $row.find('.data-title-store').val();
                const content = $row.find('.data-content-store').val();

                // 資料放入表單
                $('#edit-announcementId').val(id);
                $('#edit-title').val(title);
                $('#edit-content').val(content);
                $('#edit-isPinned').prop('checked', isPinned === true || isPinned === 'true');

                // 處理時間設定
                const fpPub = document.getElementById('edit-publishAt')._flatpickr;
                const fpExp = document.getElementById('edit-expireAt')._flatpickr;
                fpPub.setDate(publishAt ? publishAt : null);
                fpExp.setDate(expireAt ? expireAt : null);

                // 顯示視窗
                $('#editModal').removeClass('hidden');
                $('body').css('overflow', 'hidden');
            });

            $('.btn-close-edit-modal').on('click', function() {
                $('#editModal').addClass('hidden');
                $('body').css('overflow', ''); 
            });

            // 點擊空白處關閉視窗
            $('#addModal, #editModal').on('click', function(e) {
                if (e.target === this) {
                    $(this).addClass('hidden');
                    $('body').css('overflow', '');
                }
            });


            // 初始化Flatpickr
            const fpConfig = {
            	enableTime: true,
                time_24hr: false,
           	    locale: "zh_tw",
           	    dateFormat: "Y-m-d H:i",
           	    altInput: true,
           	    altFormat: "Y-m-d K h:i",
           	    allowInput: true
			};
            
         	// 新增視窗：發布時間(預設NOW)、下架時間
            flatpickr("#addModal [name='publishAt']", Object.assign({}, fpConfig, { 
                minDate: "today", 
                defaultDate: "<%= nowTime %>" 
            }));
            flatpickr("#addModal [name='expireAt']", Object.assign({}, fpConfig, { 
            }));

            // 編輯視窗：不設 minDate 與預設值 (由 JS setDate 填入)
            flatpickr(".edit-datetime-picker", fpConfig);

            // 下拉選單邏輯
            function setupCustomSelect(btnId, panelId, arrowId, displayId, realId, optionClass) {
                const $btn = $('#' + btnId);
                const $panel = $('#' + panelId);
                const $arrow = $('#' + arrowId);
                const $display = $('#' + displayId);
                const $real = $('#' + realId);

                $btn.on('click', function(e) {
                    e.stopPropagation();
                    if ($panel.hasClass('hidden')) {
                        // 隱藏其他打開的 panel
                        $('.custom-select-panel').addClass('hidden opacity-0 scale-95').removeClass('opacity-100 scale-100');
                        $('.custom-select-arrow').removeClass('rotate-180');
                        
                        $panel.removeClass('hidden');
                        setTimeout(() => {
                            $panel.removeClass('opacity-0 scale-95').addClass('opacity-100 scale-100');
                            $arrow.addClass('rotate-180');
                        }, 10);
                    } else {
                        closePanel();
                    }
                });

                $('.' + optionClass).on('click', function(e) {
                    e.stopPropagation();
                    $display.html($(this).html());
                    $real.val($(this).data('value'));
                    closePanel();
                });

                function closePanel() {
                    $panel.removeClass('opacity-100 scale-100').addClass('opacity-0 scale-95');
                    $arrow.removeClass('rotate-180');
                    setTimeout(() => $panel.addClass('hidden'), 200);
                }

                $(document).on('click', function() {
                    if (!$panel.hasClass('hidden')) closePanel();
                });
                $panel.on('click', function(e) { e.stopPropagation(); });
                
                // 加上共用 Class 方便統一管理關閉
                $panel.addClass('custom-select-panel');
                $arrow.addClass('custom-select-arrow');
            }

            // 綁定新增與編輯的下拉選單
            setupCustomSelect('add-custom-select-btn', 'add-custom-select-panel', 'add-custom-select-arrow', 'add-custom-select-display', 'add-real-category', 'add-custom-option');
            setupCustomSelect('edit-custom-select-btn', 'edit-custom-select-panel', 'edit-custom-select-arrow', 'edit-custom-select-display', 'edit-real-category', 'edit-custom-option');
            
        });
    </script>
</body>
</html>