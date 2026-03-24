package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.badminton.dao.BookingsDAO;
import com.badminton.dao.BookingsDAOImpl;
import com.badminton.model.BookingsBean;

@WebServlet("/BookingsServlet")
public class BookingsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public BookingsServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String action = request.getParameter("action");
		
		// ===== AJAX：根據球館ID回傳該球館的場地 JSON =====
		if ("getCourtsByVenue".equals(action)) {
			response.setContentType("application/json; charset=UTF-8");
			String venueIdStr = request.getParameter("venueId");
			try {
				int venueId = Integer.parseInt(venueIdStr);
				com.badminton.dao.CourtsDAO cDao = new com.badminton.dao.CourtsDAOImpl();
				List<com.badminton.model.CourtsBean> courts = cDao.findByVenueId(venueId);
				
				// 手動拼 JSON 陣列
				StringBuilder json = new StringBuilder("[");
				for (int i = 0; i < courts.size(); i++) {
					com.badminton.model.CourtsBean c = courts.get(i);
					json.append("{\"courtId\":").append(c.getCourtId())
						.append(",\"courtName\":\"").append(c.getCourtName().replace("\"", "\\\"")).append("\"}");
					if (i < courts.size() - 1) {
						json.append(",");
					}
				}
				json.append("]");
				
				response.getWriter().write(json.toString());
			} catch (Exception e) {
				e.printStackTrace();
				response.getWriter().write("[]");
			}
			return;
		}
		// ================================================
		
		if ("addForm".equals(action)) {
			try {
				com.badminton.dao.VenuesDAO vDao = new com.badminton.dao.VenuesDAOImpl();
				com.badminton.dao.CourtsDAO cDao = new com.badminton.dao.CourtsDAOImpl();
				com.badminton.dao.TimeSlotsDAO tDao = new com.badminton.dao.TimeSlotsDAOImpl();
				
				request.setAttribute("AllVenues", vDao.getAll());
				request.setAttribute("AllCourts", cDao.getAll());
				request.setAttribute("AllTimeSlots", tDao.getAll());
				
				// ===== 關鍵字模糊查詢會員功能 =====
				String searchKeyword = request.getParameter("searchKeyword");
				if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
					com.badminton.service.MembersService memberService = new com.badminton.service.MembersService();
					List<com.badminton.model.MembersBean> foundMembers = memberService.searchMembers(searchKeyword.trim());
					
					if (foundMembers != null && !foundMembers.isEmpty()) {
						request.setAttribute("foundMembers", foundMembers);
						request.setAttribute("msg", "搜尋成功：找到 " + foundMembers.size() + " 位符合的會員，請在下方確認並選取。");
					} else {
						request.setAttribute("msg", "找不到符合該關鍵字的會員！");
					}
				}
				// ==================================

			} catch (Exception e) {
				e.printStackTrace();
			}
			// 前往新增表單
			request.getRequestDispatcher("/WEB-INF/views/bookings_insert.jsp").forward(request, response);
			return;
		}
		
		try {
			BookingsDAO dao = new BookingsDAOImpl();
			
			// 檢查是否有搜尋關鍵字
			String searchKeyword = request.getParameter("searchKeyword");
			List<BookingsBean> bookingsList;
			
			if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
				// 模糊搜尋
				bookingsList = dao.searchByKeyword(searchKeyword.trim());
				request.setAttribute("searchKeyword", searchKeyword.trim());
				request.setAttribute("searchMsg", "搜尋「" + searchKeyword.trim() + "」，共找到 " + bookingsList.size() + " 筆結果");
			} else {
				// 預設列出所有預約
				bookingsList = dao.getAll();
			}
			
			request.setAttribute("AllBookings", bookingsList);
			request.getRequestDispatcher("/WEB-INF/views/bookings_list.jsp").forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String action = request.getParameter("action");
		
		if ("insert".equals(action)) {
			try {
				// 1. 取得表單參數
				String memberIdStr = request.getParameter("memberId");
				String courtIdStr = request.getParameter("courtId");
				String bookingDateStr = request.getParameter("bookingDate");
				String startTimeStr = request.getParameter("startTime");
				String endTimeStr = request.getParameter("endTime");
				String totalAmountStr = request.getParameter("totalAmount");
				String note = request.getParameter("note");

				if (memberIdStr == null || memberIdStr.trim().isEmpty()) {
					response.sendRedirect(request.getContextPath() + "/BookingsServlet?action=addForm&message=missingMember");
					return;
				}

				// 2. 準備資料 
				int memberId = Integer.parseInt(memberIdStr.trim());
				int courtId = Integer.parseInt(courtIdStr);
				java.sql.Date bookingDate = java.sql.Date.valueOf(bookingDateStr);
				
				// 直接轉換前台傳來的 "HH:MM:SS" 字串
				java.sql.Time startTime = java.sql.Time.valueOf(startTimeStr);
				java.sql.Time endTime = java.sql.Time.valueOf(endTimeStr);
				
				java.math.BigDecimal totalAmount = new java.math.BigDecimal(totalAmountStr);

				// 3. 裝進 Bean
				BookingsBean booking = new BookingsBean();
				booking.setMemberId(memberId);
				booking.setCourtId(courtId);
				booking.setBookingDate(bookingDate);
				booking.setStartTime(startTime);
				booking.setEndTime(endTime);
				booking.setTotalAmount(totalAmount);
				booking.setNote(note);

				// 4. 呼叫 DAO
				BookingsDAO dao = new BookingsDAOImpl();
				int result = dao.insert(booking);

				if (result > 0) {
					response.sendRedirect(request.getContextPath() + "/BookingsServlet?action=list&message=insertSuccess");
				} else {
					response.sendRedirect(request.getContextPath() + "/BookingsServlet?action=list&message=insertFail");
				}
			} catch (Exception e) {
				e.printStackTrace();
				response.sendRedirect(request.getContextPath() + "/BookingsServlet?action=list&message=insertFail");
			}
			
		} else if ("updateStatus".equals(action)) {
			String bookingIdStr = request.getParameter("bookingId");
			String status = request.getParameter("status");
			
			int bookingId = Integer.parseInt(bookingIdStr);
			
			BookingsDAO dao = new BookingsDAOImpl();
			
			int result = dao.updateStatus(bookingId, status);
			
			if (result > 0) {
				response.sendRedirect(request.getContextPath() + "/BookingsServlet?message=updateSuccess");
			} else {
				response.sendRedirect(request.getContextPath() + "/BookingsServlet?message=updateFail");
			}
			
		} else {
			doGet(request, response);
		}
	}
}
