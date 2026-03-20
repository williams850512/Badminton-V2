package com.badminton.dao;

import java.sql.Date;
import java.util.List;

import com.badminton.model.BookingsBean;

public interface BookingsDAO {
	
	//1.新增預約
	int insert(BookingsBean booking);
	
	//2.更新預約狀態
	int updateStatus(int bookingId, String status);
	
	//3.依會員ID查詢預約
	List<BookingsBean> findByMemberId(int memberId);
	
	//4.依場地ID查詢哪天被誰預約
	List<BookingsBean> findByCourtIdAndDate(int courtId , Date bookingDate);
	

}
