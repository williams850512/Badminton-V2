package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.badminton.dao.CourtsDAO;
import com.badminton.dao.CourtsDAOImpl;


import com.badminton.model.CourtsBean;



@WebServlet("/CourtsServlet")
public class CourtsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
    public CourtsServlet() {
        super();
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// === 步驟 1：處理中文亂碼問題 ===
				request.setCharacterEncoding("UTF-8");
				response.setContentType("text/html; charset=UTF-8");
				
				String action = request.getParameter("action");
				
				// 判斷是否要前往「新增球場表單」
				if ("addForm".equals(action)) {
					 // 把 venueId 帶過去給新增表單
					String venueId = request.getParameter("venueId");
					request.setAttribute("venueId",venueId);
					request.getRequestDispatcher("/WEB-INF/views/courts_insert.jsp").forward(request, response);
					return; // 提早結束，不往下跑撈全部資料的程式
					
				// 判斷是否要前往「修改球場資料表單」
				}else if("editForm".equals(action)){
					String courtIdStr = request.getParameter("courtId");
					int courtId = Integer.parseInt(courtIdStr);
					CourtsDAO dao = new CourtsDAOImpl();
					CourtsBean court = dao.findById(courtId);
					request.setAttribute("court", court);
					request.getRequestDispatcher("/WEB-INF/views/courts_update.jsp").forward(request, response);
					return;
					
				}
				try  {// === 步驟 2：呼叫 DAO 幫忙做事 ===
					 // 先抓到使用者是按了哪個場館
					String venueIdStr = request.getParameter("venueId");
					int venueId = Integer.parseInt(venueIdStr);
					CourtsDAO dao = new CourtsDAOImpl();
					List<CourtsBean> courtsList = dao.findByVenueId(venueId);  // 只撈這間球館的場地
					// === 步驟 3：把資料存起來，準備帶去給 JSP 看 ===
			        // 前面是取名字 (JSP 要用這個名字找東西)，後面是你要傳過去的資料 (那個 List 箱子)
					request.setAttribute("venueId", venueId);
					request.setAttribute("AllCourts", courtsList);
					// === 步驟 4：轉交 (Forward) 畫面給 JSP ===
			        // 告訴 Servlet：「請你把這些資料打包好，送到下面這個 JSP 網頁去負責顯示」
					request.getRequestDispatcher("/WEB-INF/views/courts_list.jsp").forward(request, response);
					
					} catch (Exception e) {
						e.printStackTrace();}
					
				}
	

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		            // === 步驟 1：處理中文亂碼問題 ===
				request.setCharacterEncoding("UTF-8");
				response.setContentType("text/html; charset=UTF-8");
				
				String action = request.getParameter("action");
				
				if("insert".equals(action)) {
					try {
						// 1. 抓取表單傳過來的資料 (參數名稱必須跟 jsp 表單的 name 一樣)
						String venueIdStr = request.getParameter("venueId");//放進資料庫需要抓venueId
						String courtName = request.getParameter("courtName"); 
						
						int venueId = Integer.parseInt(venueIdStr);
						
						// 2. 裝進 Bean 裡面
						CourtsBean court = new CourtsBean();
						
						court.setVenueId(venueId);
						court.setCourtName(courtName);
						
						// 3. 呼叫 DAO 幫忙存進資料庫
						CourtsDAO dao = new CourtsDAOImpl();
						//用result接住insert方法回傳的0或1，用來判斷新增是否成功
						int result = dao.insert(court);
						
						// 4.判斷成功或失敗後，重新導向回 Servlet 的 Get 請求，讓它重新查出所有資料並顯示列表+
						if(result>0) {
							response.sendRedirect(request.getContextPath() + "/CourtsServlet?venueId=" + venueId + "&message=insertSuccess"); 
						}else {
							response.sendRedirect(request.getContextPath() + "/CourtsServlet?venueId=" + venueId + "&message=insertfail");
						}
					} catch (NumberFormatException e) {
						
						e.printStackTrace();
					}
					
					
					
				}else if("delete".equals(action)){
					int result;
					try {
						String courtIdStr = request.getParameter("courtId");
						int courtId = Integer.parseInt(courtIdStr);
						CourtsDAO dao = new CourtsDAOImpl();
						CourtsBean court = dao.findById(courtId);
						court.setIsActive(false);
						int venueId = court.getVenueId();
						result = dao.update(court);
						if(result > 0) {
							response.sendRedirect(request.getContextPath() + "/CourtsServlet?venueId=" + venueId + "&message=deleteSuccess");	
						}else {
							response.sendRedirect(request.getContextPath() + "/CourtsServlet?venueId=" + venueId + "&message=deletefail");
						}
					} catch (NumberFormatException e) {
						
						e.printStackTrace();
					}
					
				}else if("update".equals(action)) {
					try {
						// 1. 抓取表單傳過來的資料 (參數名稱必須跟 jsp 表單的 name 一樣)
						String courtIdStr = request.getParameter("courtId");
						String venueIdStr = request.getParameter("venueId");
						String courtName = request.getParameter("courtName");
						String isActiveStr = request.getParameter("isActive");
						
						//把不是String的轉型
						int venueId = Integer.parseInt(venueIdStr);
						int courtId = Integer.parseInt(courtIdStr);
						Boolean isActive = Boolean.parseBoolean(isActiveStr);
						
						//裝進Bean裡面
						CourtsBean court = new CourtsBean();
						court.setCourtId(courtId);
						court.setVenueId(venueId);
						court.setCourtName(courtName);
						court.setIsActive(isActive);
						
						// 3. 呼叫 DAO 幫忙存進資料庫
						CourtsDAO dao = new CourtsDAOImpl();
						int result = dao.update(court);
						
						if(result > 0) {
							response.sendRedirect(request.getContextPath() + "/CourtsServlet?venueId=" + venueId + "&message=updateSuccess");	
						}else {
							response.sendRedirect(request.getContextPath() + "/CourtsServlet?venueId=" + venueId + "&message=updateSuccess");
						}
						
						
					} catch (NumberFormatException e) {
						
						e.printStackTrace();
					}
					
					
				}else {
					
					doGet(request, response);
				}
		
	}

}
