package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

import com.badminton.model.AnnouncementBean;
import com.badminton.service.AnnouncementService;

@WebServlet("/AnnouncementServlet")
public class AnnouncementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	// 宣告 Service，讓 Controller 可以指揮大腦做事
    private AnnouncementService service;
    
    @Override
    public void init() throws ServletException {
        service = new AnnouncementService();
    }
       
    public AnnouncementServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response); // 把 GET 請求也交給 doPost 統一處理
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 防止中文變成亂碼
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 取得網頁傳來的 action 參數，決定現在要做什麼動作
        String action = request.getParameter("action");
        
        // 如果沒有指定 action，預設就當作是「查詢全部列表」
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        // 根據 action 的值，呼叫對應的方法
        switch (action) {
	        case "showAddForm": // 【新增這一行】準備新增畫面
	            showAddForm(request, response);
	            break;
            case "insert":
                insertAnnouncement(request, response);
                break;
            case "delete":  // 新增這三行！
                deleteAnnouncement(request, response);
                break;
            case "edit":    // 新增：準備編輯畫面
                showEditForm(request, response);
                break;
            case "update":  // 新增：執行修改存檔
                updateAnnouncement(request, response);
                break;
            case "list":
            default:
                listAnnouncements(request, response);
                break;
            // 未來繼續補上 "update", "delete"
        }
	}
	
	// 新增：帶領使用者前往「新增公告」的網頁
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/admin/announcement/add.jsp").forward(request, response);
    }
	
    // 1：查詢所有公告，並把資料傳給 JSP 顯示
	private void listAnnouncements(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword"); // 抓取搜尋框的字
        List<AnnouncementBean> list;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = service.searchAnnouncements(keyword); // 有字就去模糊搜尋
            request.setAttribute("keyword", keyword); // 把搜尋字存起來，讓畫面維持著剛剛打的字
        } else {
            list = service.getAllAnnouncements(); // 沒字就查全部
        }
        
        request.setAttribute("announcementList", list);
        request.getRequestDispatcher("/WEB-INF/admin/announcement/list.jsp").forward(request, response);
    }

    // 2：接收網頁表單，新增一筆公告
    private void insertAnnouncement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // (1)接收表單傳來的欄位資料 (getParameter 裡面的字要跟 jsp 表單的 name 一樣)
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String category = request.getParameter("category");
            String status = request.getParameter("status");
            // 抓取網頁傳來的字串
            String publishAtStr = request.getParameter("publishAt");
            String expireAtStr = request.getParameter("expireAt");
            // checkbox 如果有勾選會傳來 "on" 或 "true"，沒勾就是 null
            String isPinnedStr = request.getParameter("isPinned"); 
            boolean isPinned = "on".equals(isPinnedStr) || "true".equals(isPinnedStr);

            // (2) 把這些散落的資料，包裝成一個 AnnouncementBean 物件
            AnnouncementBean bean = new AnnouncementBean();
            bean.setTitle(title);
            bean.setContent(content);
            bean.setCategory(category);
            bean.setStatus(status != null ? status : "draft");
            bean.setIsPinned(isPinned);
            // 包裝 Bean 的地方補上這兩行轉換
            bean.setPublishAt(parseHtmlDateTime(publishAtStr));
            bean.setExpireAt(parseHtmlDateTime(expireAtStr));
            
            // 時間欄位處理 (這裡先簡單塞入當下時間，之後可以依需求改成接表單的日期)
            bean.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            // (3) 呼叫 Service 執行新增資料庫
            boolean isSuccess = service.addAnnouncement(bean);

            // (4) 新增完畢後，決定畫面要去哪裡
            if (isSuccess) {
                // 新增成功：叫瀏覽器「重新導向 (Redirect)」回列表頁
                response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
            } else {
                // 【修改這裡】新增失敗：用 Forward 回到新增頁面
                request.getRequestDispatcher("/WEB-INF/admin/announcement/add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 【修改這裡】發生例外錯誤時：用 Forward 回到新增頁面
            request.getRequestDispatcher("/WEB-INF/admin/announcement/add.jsp").forward(request, response);
        }
    }
    
 // 3：接收網頁傳來的 ID，刪除一筆公告
    private void deleteAnnouncement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 抓取網址上的 ?id=xxx
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr);
                
                // 呼叫 Service 執行刪除 (假設你的 Service 裡有寫 deleteAnnouncement 這個方法)
                service.deleteAnnouncement(id);
            }
            
            // 刪除完畢後，重新導向回列表頁，讓畫面自動更新
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
            
        } catch (Exception e) {
            e.printStackTrace();
            // 如果發生錯誤，一樣先導回列表頁
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
        }
    }
    
 // 4：根據 ID 撈出舊資料，並帶往編輯網頁 (edit.jsp)
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            int id = Integer.parseInt(idStr);
            // 請 Service 去撈出這筆公告 (假設你有寫 getAnnouncementById)
            AnnouncementBean existingBean = service.getAnnouncementById(id);
            
            // 把這筆舊資料打包，貼上標籤 "announcement"，傳給編輯頁面
            request.setAttribute("announcement", existingBean);
            request.getRequestDispatcher("/WEB-INF/admin/announcement/edit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
        }
    }

    // 5：接收編輯網頁傳來的新資料，存回資料庫
    private void updateAnnouncement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 注意！修改資料必須要知道是改哪一筆，所以一定要抓 ID
            int id = Integer.parseInt(request.getParameter("announcementId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String category = request.getParameter("category");
            String status = request.getParameter("status");
            String isPinnedStr = request.getParameter("isPinned"); 
            String publishAtStr = request.getParameter("publishAt");
            String expireAtStr = request.getParameter("expireAt");
            boolean isPinned = "on".equals(isPinnedStr) || "true".equals(isPinnedStr);

            // 包裝成 Bean
            AnnouncementBean bean = new AnnouncementBean();
            bean.setAnnouncementId(id); // 更新必須要有 ID
            bean.setTitle(title);
            bean.setContent(content);
            bean.setCategory(category);
            bean.setStatus(status != null ? status : "draft");
            bean.setIsPinned(isPinned);
            bean.setPublishAt(parseHtmlDateTime(publishAtStr));
            bean.setExpireAt(parseHtmlDateTime(expireAtStr));
            
            // 這裡更新時間可以根據需求決定要不要覆蓋，我們通常會保留原本建立時間或加一個 update_at 欄位
            // 這裡先簡化，單純更新內容

            // 呼叫 Service 執行更新 (假設你有寫 updateAnnouncement)
            service.updateAnnouncement(bean);

            // 更新完畢，回列表頁
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
        }
    }
    
    // 實用工具：把網頁傳來的 "yyyy-MM-ddThh:mm" 轉換成資料庫看得懂的 Timestamp
    private Timestamp parseHtmlDateTime(String datetimeStr) {
        if (datetimeStr == null || datetimeStr.trim().isEmpty()) {
            return null; // 如果使用者沒填時間，就回傳 null
        }
        try {
            // 把網頁格式的 'T' 換成空白，並在後面補上秒數 ':00'
            return Timestamp.valueOf(datetimeStr.replace("T", " ") + ":00");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
