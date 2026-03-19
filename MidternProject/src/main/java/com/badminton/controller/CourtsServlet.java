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
import com.badminton.dao.VenuesDAO;
import com.badminton.dao.VenuesDAOImpl;
import com.badminton.model.CourtsBean;
import com.badminton.model.VenuesBean;


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
					request.getRequestDispatcher("/WEB-INF/views/Courts_insert.jsp").forward(request, response);
					return; // 提早結束，不往下跑撈全部資料的程式
					
				// 判斷是否要前往「修改球場資料表單」
				}else if("editForm".equals(action)){
					String courtIdStr = request.getParameter("courtId");
					int courtId = Integer.parseInt(courtIdStr);
					CourtsDAO dao = new CourtsDAOImpl();
					CourtsBean court = dao.findById(courtId);
					request.setAttribute("court", court);
					request.getRequestDispatcher("/WEB-INF/views/court_update.jsp").forward(request, response);
					return;
					
				}
				try  {// === 步驟 2：呼叫 DAO 幫忙做事 ===
					// 建立 DAO 物件（這裡體現了 Interface 的好處，我們用介面型態去接實作類別）
					
					
					 // 拜託 DAO 去資料庫把所有球館撈出來，裝進 List 裡
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
			        // 假設你照我之前建議的，把 JSP 放在 /WEB-INF/views/ 裡
					request.getRequestDispatcher("/WEB-INF/views/courts_list.jsp").forward(request, response);
					
					} catch (Exception e) {
						e.printStackTrace();}
					
				}
	

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
