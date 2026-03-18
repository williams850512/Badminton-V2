package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.badminton.dao.VenuesDAO;
import com.badminton.dao.VenuesDAOImpl;
import com.badminton.model.VenuesBean;


@WebServlet("/VenuesServlet")
public class VenuesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public VenuesServlet() {
        super();
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// === 步驟 1：處理中文亂碼問題 ===
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String action = request.getParameter("action");
		
		// 判斷是否要前往「新增場館表單」
		if ("addForm".equals(action)) {
			request.getRequestDispatcher("/WEB-INF/views/venues_insert.jsp").forward(request, response);
			return; // 提早結束，不往下跑撈全部資料的程式
		}
		
		try  {// === 步驟 2：呼叫 DAO 幫忙做事 ===
		// 建立 DAO 物件（這裡體現了 Interface 的好處，我們用介面型態去接實作類別）
		VenuesDAO dao = new VenuesDAOImpl();
		
		 // 拜託 DAO 去資料庫把所有球館撈出來，裝進 List 裡
		List<VenuesBean> venuesList = dao.getAll();
		
		// === 步驟 3：把資料存起來，準備帶去給 JSP 看 ===
        // 前面是取名字 (JSP 要用這個名字找東西)，後面是你要傳過去的資料 (那個 List 箱子)
		request.setAttribute("AllVenues", venuesList);
		
		// === 步驟 4：轉交 (Forward) 畫面給 JSP ===
        // 告訴 Servlet：「請你把這些資料打包好，送到下面這個 JSP 網頁去負責顯示」
        // 假設你照我之前建議的，把 JSP 放在 /WEB-INF/views/ 裡
		request.getRequestDispatcher("/WEB-INF/views/venues_list.jsp").forward(request, response);
		
		} catch (Exception e) {
			e.printStackTrace();}
		
		}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// === 步驟 1：處理中文亂碼問題 ===
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String action = request.getParameter("action");
		
		if ("insert".equals(action)) {
			try {
				// 1. 抓取表單傳過來的資料 (參數名稱必須跟 jsp 表單的 name 一樣)
				String venueName = request.getParameter("venueName");
				String address = request.getParameter("address");
				String phone = request.getParameter("phone");
				
				// 2. 裝進 Bean 裡面
				VenuesBean venue = new VenuesBean();
				venue.setVenueName(venueName);
				venue.setAddress(address);
				venue.setPhone(phone);
				
				// 3. 呼叫 DAO 幫忙存進資料庫
				VenuesDAO dao = new VenuesDAOImpl();
				dao.insert(venue);
				
				// 4. 新增成功後，重新導向回 Servlet 的 Get 請求，讓它重新查出所有資料並顯示列表
				response.sendRedirect(request.getContextPath() + "/VenuesServlet");
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			doGet(request, response);
		}
	}

}
