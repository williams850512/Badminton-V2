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
		
		if ("addForm".equals(action)) {
			try {
				com.badminton.dao.VenuesDAO vDao = new com.badminton.dao.VenuesDAOImpl();
				com.badminton.dao.CourtsDAO cDao = new com.badminton.dao.CourtsDAOImpl();
				request.setAttribute("AllVenues", vDao.getAll());
				request.setAttribute("AllCourts", cDao.getAll());
			} catch (Exception e) {
				e.printStackTrace();
			}
			// 前往新增表單
			request.getRequestDispatcher("/WEB-INF/views/bookings_insert.jsp").forward(request, response);
			return;
		}
		
		try {
			BookingsDAO dao = new BookingsDAOImpl();
			
			// 預設列出所有預約
			List<BookingsBean> bookingsList = dao.getAll();
			
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
				String memberPhone = request.getParameter("memberPhone");
				String courtIdStr = request.getParameter("courtId");
				String bookingDateStr = request.getParameter("bookingDate");
				String startTimeStr = request.getParameter("startTime");
				String endTimeStr = request.getParameter("endTime");
				String totalAmountStr = request.getParameter("totalAmount");
				String note = request.getParameter("note");

				// 2. 準備資料 (目前先寫死 memberId = 1，未來組員合併分支後可改用查手機查詢)
				int memberId = 1;
				int courtId = Integer.parseInt(courtIdStr);
				java.sql.Date bookingDate = java.sql.Date.valueOf(bookingDateStr);
				
				// HTML5 的 type="time" 若沒有秒，回傳 HH:mm，但 SQL 的 Time.valueOf 需要 HH:mm:ss
				java.sql.Time startTime = java.sql.Time.valueOf(startTimeStr + (startTimeStr.length() == 5 ? ":00" : ""));
				java.sql.Time endTime = java.sql.Time.valueOf(endTimeStr + (endTimeStr.length() == 5 ? ":00" : ""));
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
