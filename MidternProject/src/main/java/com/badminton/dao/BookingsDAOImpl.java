package com.badminton.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.badminton.model.BookingsBean;

public class BookingsDAOImpl implements BookingsDAO {

	@Override
	public int insert(BookingsBean booking) {
		int result = 0;// 用來記錄成功新增了幾筆資料
		String sql = "INSERT INTO Bookings(member_id, court_id, booking_date, start_time, end_time, total_amount, note) "
				+ "VALUES(?,?,?,?,?,?,?)";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1, booking.getMemberId());
			stmt.setInt(2, booking.getCourtId());
			stmt.setDate(3, booking.getBookingDate());
			stmt.setTime(4, booking.getStartTime());
			stmt.setTime(5, booking.getEndTime());
			stmt.setBigDecimal(6, booking.getTotalAmount());
			stmt.setString(7, booking.getNote());
			
			result = stmt.executeUpdate();
			
			
			
		} catch (NamingException | SQLException e) {
			
			e.printStackTrace();
		}finally {
			if(stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {					
					e.printStackTrace();
				}
			}
		}if(conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {				
				e.printStackTrace();
			}
		}		
		return result;
	}

	@Override
	public int updateStatus(int bookingId, String status) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<BookingsBean> findByMemberId(int memberId) {
		List<BookingsBean> list = new ArrayList<>();
		String sql = "SELECT * FROM Bookings WHERE member_id = ?";
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			Context context = new InitialContext();
			DataSource ds =(DataSource)context.lookup("java:/comp/env/jdbc/BadmintonDB");
			conn = ds.getConnection();
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1, memberId);
			
			rs = stmt.executeQuery();
			
			if(rs.next()) {
				BookingsBean booking = new BookingsBean();
				
				
			}
			
		} catch (NamingException | SQLException e) {
			
			e.printStackTrace();
		}
		
		return null;
	}

	@Override
	public List<BookingsBean> findByCourtIdAndDate(int courtId, Date bookingDate) {
		// TODO Auto-generated method stub
		return null;
	}
	

}
