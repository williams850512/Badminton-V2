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
        
        // 如果沒有指定，預設就是查詢全部
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        // 根據 action 值呼叫方法
        switch (action) {
	        case "showAddForm": // 去新增
	            showAddForm(request, response);
	            break;
            case "insert":
                insertAnnouncement(request, response);
                break;
            case "delete":
                deleteAnnouncement(request, response);
                break;
            case "edit":    // 去編輯
                showEditForm(request, response);
                break;
            case "update":  // 去修改
                updateAnnouncement(request, response);
                break;
            case "list":
            default:
                listAnnouncements(request, response);
                break;
        }
	}
	
	// 前往新增公告頁
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/admin/announcement/add.jsp").forward(request, response);
    }
	
    // 1.查詢所有公告，並給 JSP 顯示
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

    // 2.新增一筆公告
    private void insertAnnouncement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // (1) 接欄位資料
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String category = request.getParameter("category");
            String status = request.getParameter("status");
            // 抓傳的字串
            String publishAtStr = request.getParameter("publishAt");
            String expireAtStr = request.getParameter("expireAt");
            // checkbox 如果有勾選會傳on/true，沒勾是 null
            String isPinnedStr = request.getParameter("isPinned"); 
            boolean isPinned = "on".equals(isPinnedStr) || "true".equals(isPinnedStr);

            // (2) 把散資料包裝成 AnnouncementBean 物件
            AnnouncementBean bean = new AnnouncementBean();
            bean.setTitle(title);
            bean.setContent(content);
            bean.setCategory(category);
            bean.setStatus(status != null ? status : "draft");
            bean.setIsPinned(isPinned);
            bean.setPublishAt(parseHtmlDateTime(publishAtStr));
            bean.setExpireAt(parseHtmlDateTime(expireAtStr));
            
            // 時間欄位處理
            bean.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            // (3) 呼叫 Service 執行新增
            boolean isSuccess = service.addAnnouncement(bean);

            // (4) 新增完畢決定畫面去哪裡
            if (isSuccess) {
                // 成功：Redirect 回列表頁
                response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
            } else {
                // 失敗：Forward 回新增頁面
                request.getRequestDispatcher("/WEB-INF/admin/announcement/add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 用 Forward 回到新增頁面
            request.getRequestDispatcher("/WEB-INF/admin/announcement/add.jsp").forward(request, response);
        }
    }
    
    // 3.接傳的 ID 刪除一筆公告
    private void deleteAnnouncement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 網址上的 ?id=xxx
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr);
                
                // 呼叫 Service 刪除
                service.deleteAnnouncement(id);
            }
            
            // 刪除完導回列表頁(畫面自動更新)
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
        }
    }
    
    // 4.看ID 撈舊資料、去編輯網頁
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            int id = Integer.parseInt(idStr);
            // Service 去找出公告
            AnnouncementBean existingBean = service.getAnnouncementById(id);
            
            // 把舊資料打包傳給編輯頁面
            request.setAttribute("announcement", existingBean);
            request.getRequestDispatcher("/WEB-INF/admin/announcement/edit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
        }
    }

    // 5.接編輯頁傳的新資料，存回資料庫
    private void updateAnnouncement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("announcementId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String category = request.getParameter("category");
            String status = request.getParameter("status");
            String isPinnedStr = request.getParameter("isPinned"); 
            String publishAtStr = request.getParameter("publishAt");
            String expireAtStr = request.getParameter("expireAt");
            boolean isPinned = "on".equals(isPinnedStr) || "true".equals(isPinnedStr);

            AnnouncementBean bean = new AnnouncementBean();
            bean.setAnnouncementId(id);
            bean.setTitle(title);
            bean.setContent(content);
            bean.setCategory(category);
            bean.setStatus(status != null ? status : "draft");
            bean.setIsPinned(isPinned);
            bean.setPublishAt(parseHtmlDateTime(publishAtStr));
            bean.setExpireAt(parseHtmlDateTime(expireAtStr));
            
            service.updateAnnouncement(bean);

            // 回列表頁
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AnnouncementServlet?action=list");
        }
    }
    
    // 把傳來的 "yyyy-MM-ddThh:mm" 轉成 Timestamp
    private Timestamp parseHtmlDateTime(String datetimeStr) {
        if (datetimeStr == null || datetimeStr.trim().isEmpty()) {
            return null;
        }
        try {
            return Timestamp.valueOf(datetimeStr.replace("T", " ") + ":00");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}